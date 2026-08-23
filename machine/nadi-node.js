// नाडी (node conduit) — a warm, dependency-free channel between minds and the
// kernel.  machine/Nadi.hs is the Haskell port; it needs vector+aeson+the Sabda/
// Yantra module chain, which is not built in every environment.  This node
// version needs only `agda` on PATH and holds one `agda --interaction-json`
// process WARM, answering typed questions in milliseconds — so a mind can
// converse with the machine instead of cold-running the kernel per question.
//
//   node machine/nadi-node.js <sock>                     # start (cwd = formal/cubical)
//   node machine/nadi-ask-node.js <sock> '{"cmd":"load","file":"/abs/M.agda"}'
//   cmds: load <file> | infer <expr> | norm <expr> | goals | goal <id>
//         auto <id> | refine <id> <expr> | give <id> <expr> | case <id> <expr>
//         raw <IOTCM line>
// One JSON line in, the kernel's JSON lines out, terminated by a blank line.
// Completion is SEMANTIC (the response's own terminal message), not a timeout.

const net = require("net");
const { spawn } = require("child_process");
const fs = require("fs");

const sock = process.argv[2] || "/tmp/nadi.sock";
try { fs.unlinkSync(sock); } catch (e) {}

const agda = spawn("agda", ["--interaction-json"], {
  cwd: process.cwd(),
  env: { ...process.env, LC_ALL: "C.UTF-8" },
});

let buffer = "", sink = null, idleTimer = null;

function isDone(kind, j) {
  if (!j || !j.kind) return false;
  if (j.kind === "DisplayInfo") {
    if (kind === "load") return j.info && (j.info.kind === "Error" || j.info.kind === "CompilationOk");
    return true;
  }
  if (kind === "load" && j.kind === "InteractionPoints") return true;
  if (kind !== "load" && (j.kind === "GiveAction" || j.kind === "MakeCase")) return true;
  return false;
}

agda.stdout.on("data", (d) => {
  buffer += d.toString("utf8");
  let idx;
  while ((idx = buffer.indexOf("\n")) >= 0) {
    const line = buffer.slice(0, idx); buffer = buffer.slice(idx + 1);
    if (!sink) continue;
    const clean = line.replace(/^JSON> /, "").trim();
    if (clean.length > 0) {
      sink.lines.push(clean);
      let j = null; try { j = JSON.parse(clean); } catch (e) {}
      if (isDone(sink.kind, j)) { flush(); continue; }
    }
    if (idleTimer) clearTimeout(idleTimer);
    idleTimer = setTimeout(flush, 60 * 1000);
  }
});
agda.stderr.on("data", (d) => { if (sink) sink.lines.push(JSON.stringify({ stderr: d.toString("utf8") })); });
agda.on("exit", (c) => { console.error("agda exited", c); process.exit(1); });

function flush() {
  if (!sink) return;
  try { sink.conn.write(sink.lines.join("\n") + "\n\n"); sink.conn.end(); } catch (e) {}
  sink = null;
}

const iotcm = (file, cmd) => `IOTCM "${file}" None Indirect (${cmd})\n`;
let context = null;
const esc = (s) => s.replace(/\\/g, "\\\\").replace(/"/g, '\\"');

function toCommand(q) {
  switch (q.cmd) {
    case "load":   context = q.file; return iotcm(q.file, `Cmd_load "${esc(q.file)}" []`);
    case "infer":  return iotcm(context, `Cmd_infer_toplevel Simplified "${esc(q.expr)}"`);
    case "norm":   return iotcm(context, `Cmd_compute_toplevel DefaultCompute "${esc(q.expr)}"`);
    case "goal":   return iotcm(context, `Cmd_goal_type Simplified ${q.id} noRange ""`);
    case "goals":  return iotcm(context, `Cmd_metas Simplified`);
    case "auto":   return iotcm(context, `Cmd_autoOne ${q.id} noRange "${esc(q.hints || "")}"`);
    case "refine": return iotcm(context, `Cmd_refine_or_intro False ${q.id} noRange "${esc(q.expr || "")}"`);
    case "give":   return iotcm(context, `Cmd_give WithoutForce ${q.id} noRange "${esc(q.expr || "")}"`);
    case "case":   return iotcm(context, `Cmd_make_case ${q.id} noRange "${esc(q.expr || "")}"`);
    case "raw":    return q.line.endsWith("\n") ? q.line : q.line + "\n";
    default:       return null;
  }
}

net.createServer((conn) => {
  let inbuf = "";
  conn.on("data", (d) => {
    inbuf += d.toString("utf8");
    const nl = inbuf.indexOf("\n"); if (nl < 0) return;
    let q; try { q = JSON.parse(inbuf.slice(0, nl)); }
    catch (e) { conn.write(JSON.stringify({ error: "bad json" }) + "\n\n"); conn.end(); return; }
    if (sink) { conn.write(JSON.stringify({ error: "busy" }) + "\n\n"); conn.end(); return; }
    const cmd = toCommand(q);
    if (!cmd) { conn.write(JSON.stringify({ error: "unknown cmd" }) + "\n\n"); conn.end(); return; }
    if (q.cmd !== "load" && q.cmd !== "raw" && !context) {
      conn.write(JSON.stringify({ error: "no module loaded; load first" }) + "\n\n"); conn.end(); return;
    }
    sink = { conn, lines: [], kind: q.cmd === "load" ? "load" : "query" };
    agda.stdin.write(cmd);
    if (idleTimer) clearTimeout(idleTimer);
    idleTimer = setTimeout(flush, 30 * 60 * 1000);
  });
}).listen(sock, () => console.error("नाडी (node) listening on", sock));
