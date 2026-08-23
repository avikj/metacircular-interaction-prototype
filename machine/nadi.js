// नाडी — the conduit: a warm, persistent channel between agents and the
// kernel.  The batch interface is a one-bit cut (exit code + first error,
// minutes of cold re-elaboration per question); this holds one agda
// process in --interaction-json mode with the library loaded and WARM,
// and answers typed questions in milliseconds:
//
//   load <file>          elaborate a module incrementally (imports cached)
//   goals                every open hole with its id
//   goal <id>            the goal type at one hole
//   infer <expr>         the kernel's type for any expression
//   norm <expr>          the normal form of any expression
//   raw <IOTCM...>       escape hatch: any interaction command verbatim
//
// नाडी is the yogic term for a channel/conduit; used literally.  Server
// listens on a unix socket; one JSON line in, the kernel's JSON lines
// out (terminated by a blank line).  No queueing beyond one client at a
// time — agents are patient, and the point is the warm state, not
// concurrency.  Built 2026-08-23 at the owner's direction to take the
// agent↔kernel boundary to the limit; the sensory organs (colour, sound,
// geometry) are output transforms of what this carries.
//
// Run:   node machine/nadi.js /tmp/nadi.sock  (cwd must see the library)
// Ask:   node machine/nadi-ask.js /tmp/nadi.sock '{"cmd":"infer","expr":"..."}'

const net = require("net");
const { spawn } = require("child_process");
const fs = require("fs");

const sock = process.argv[2] || "/tmp/nadi.sock";
try { fs.unlinkSync(sock); } catch (e) {}

const agda = spawn("agda", ["--interaction-json"], {
  cwd: process.cwd(),
  env: { ...process.env, LC_ALL: "C.UTF-8" },
});

let buffer = "";
let sink = null;          // current client's collector
let idleTimer = null;

// completion is SEMANTIC, never temporal: a load ends at its
// InteractionPoints line (or an error DisplayInfo); a query ends at its
// DisplayInfo.  The idle timer is only a distant fallback.
function isDone(sinkKind, j) {
  if (!j || !j.kind) return false;
  if (j.kind === "DisplayInfo") {
    if (sinkKind === "load")
      return j.info && (j.info.kind === "Error" || j.info.kind === "CompilationOk");
    return true;
  }
  if (sinkKind === "load" && j.kind === "InteractionPoints") return true;
  // the machine WRITING a term: give/case/refine emit these, not DisplayInfo
  if (sinkKind !== "load" && (j.kind === "GiveAction" || j.kind === "MakeCase")) return true;
  return false;
}

agda.stdout.on("data", (d) => {
  buffer += d.toString("utf8");
  let idx;
  while ((idx = buffer.indexOf("\n")) >= 0) {
    const line = buffer.slice(0, idx);
    buffer = buffer.slice(idx + 1);
    if (sink) {
      // strip the JSON> prompt prefix agda emits
      const clean = line.replace(/^JSON> /, "").trim();
      if (clean.length > 0) {
        sink.lines.push(clean);
        let j = null;
        try { j = JSON.parse(clean); } catch (e) {}
        if (isDone(sink.kind, j)) { flush(); continue; }
      }
      if (idleTimer) clearTimeout(idleTimer);
      idleTimer = setTimeout(flush, 60 * 1000);
    }
  }
});
agda.stderr.on("data", (d) => {
  if (sink) sink.lines.push(JSON.stringify({ stderr: d.toString("utf8") }));
});
agda.on("exit", (c) => { console.error("agda exited", c); process.exit(1); });

function flush() {
  if (!sink) return;
  const out = sink.lines.join("\n") + "\n\n";
  try { sink.conn.write(out); sink.conn.end(); } catch (e) {}
  sink = null;
}

function iotcm(file, cmd) {
  return `IOTCM "${file}" None Indirect (${cmd})\n`;
}

// one interaction file must be named even for toplevel queries; keep the
// last loaded file as the context.
let context = null;

function toCommand(q) {
  const esc = (s) => s.replace(/\\/g, "\\\\").replace(/"/g, '\\"');
  switch (q.cmd) {
    case "load":
      context = q.file;
      return iotcm(q.file, `Cmd_load "${esc(q.file)}" []`);
    case "infer":
      return iotcm(context, `Cmd_infer_toplevel Simplified "${esc(q.expr)}"`);
    case "norm":
      return iotcm(context, `Cmd_compute_toplevel DefaultCompute "${esc(q.expr)}"`);
    case "goal":
      return iotcm(context, `Cmd_goal_type Simplified ${q.id} noRange ""`);
    case "goals":
      return iotcm(context, `Cmd_metas Simplified`);
    // ── the machine writes the proof: hole in, term out ──────────────
    case "auto":   // Mimer proof search on one hole
      return iotcm(context, `Cmd_autoOne ${q.id} noRange "${esc(q.hints || "")}"`);
    case "refine": // apply q.expr (or "") to the hole, leaving arg-holes
      return iotcm(context, `Cmd_refine_or_intro False ${q.id} noRange "${esc(q.expr || "")}"`);
    case "give":   // fill the hole with an exact term
      return iotcm(context, `Cmd_give WithoutForce ${q.id} noRange "${esc(q.expr || "")}"`);
    case "case":   // case-split the hole on q.expr
      return iotcm(context, `Cmd_make_case ${q.id} noRange "${esc(q.expr || "")}"`);
    case "raw":
      return q.line.endsWith("\n") ? q.line : q.line + "\n";
    default:
      return null;
  }
}

const server = net.createServer((conn) => {
  let inbuf = "";
  conn.on("data", (d) => {
    inbuf += d.toString("utf8");
    const nl = inbuf.indexOf("\n");
    if (nl < 0) return;
    const line = inbuf.slice(0, nl);
    let q;
    try { q = JSON.parse(line); }
    catch (e) { conn.write(JSON.stringify({ error: "bad json" }) + "\n\n"); conn.end(); return; }
    if (sink) { conn.write(JSON.stringify({ error: "busy" }) + "\n\n"); conn.end(); return; }
    const cmd = toCommand(q);
    if (!cmd) { conn.write(JSON.stringify({ error: "unknown cmd" }) + "\n\n"); conn.end(); return; }
    if (q.cmd !== "load" && q.cmd !== "raw" && !context) {
      conn.write(JSON.stringify({ error: "no module loaded; load first" }) + "\n\n");
      conn.end(); return;
    }
    sink = { conn, lines: [], kind: q.cmd === "load" ? "load" : "query" };
    agda.stdin.write(cmd);
    if (idleTimer) clearTimeout(idleTimer);
    idleTimer = setTimeout(flush, 30 * 60 * 1000); // distant fallback only
  });
});

server.listen(sock, () => console.error("नाडी listening on", sock));
