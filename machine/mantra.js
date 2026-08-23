// मन्त्रकोश — the spell-treasury.  Utter a term-name (a spell) and the
// machine returns its invoked structure: type, module, locus, address.
// This is the READ direction of the agent↔kernel channel at corpus scale —
// Pratyaksa without a per-module cold load: every top-level checked name in
// formal/cubical indexed in one pass, content-addressed (Nama-style: the
// hash is the base, the name is carried).
//
//   node machine/mantra.js <spell>       resolve one spell (exact name)
//   node machine/mantra.js ~ <substr>    every spell whose name contains substr
//   node machine/mantra.js : <substr>    every spell whose TYPE contains substr
//   node machine/mantra.js --json        dump the whole treasury
//   node machine/mantra.js --stat        counts
//
// The spell IS the name; the machine holds the body.  Say greek/sanskrit;
// drop the prose.  (For the elaborated type rather than the written one,
// pipe the module through नाडी: ./nadi load <module>; ./nadi infer <name>.)

const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

const ROOT = path.join(__dirname, "..", "formal", "cubical");
const KW = new Set(["module","open","import","private","variable","infix",
  "infixl","infixr","syntax","pattern","where","field","constructor",
  "postulate","mutual","abstract","instance","primitive","using","renaming","hiding"]);

function walk(dir) {
  let out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) out = out.concat(walk(p));
    else if (e.name.endsWith(".agda")) out.push(p);
  }
  return out;
}

// a top-level signature: NAME : TYPE  (NAME at column 0, not a keyword),
// or  data NAME : ... / record NAME ... : ...
// TYPE continues on indented non-empty lines until a blank or column-0 line.
function harvest(file) {
  const mod = path.basename(file, ".agda");
  const lines = fs.readFileSync(file, "utf8").split("\n");
  const spells = [];
  for (let i = 0; i < lines.length; i++) {
    const L = lines[i];
    if (/^\s/.test(L) || L.trim() === "" || L.startsWith("--") || L.startsWith("{-")) continue;
    let m = L.match(/^(data|record)\s+(\S+)/);
    let name = null, typeStart = null;
    if (m) { name = m[2]; const c = L.indexOf(":"); typeStart = c >= 0 ? L.slice(c + 1) : ""; }
    else {
      m = L.match(/^(\S+)\s*:(?![:=])\s?(.*)$/);   // NAME : TYPE  (not := or ::)
      if (!m || KW.has(m[1])) continue;
      name = m[1]; typeStart = m[2];
    }
    let type = typeStart.trim();
    for (let j = i + 1; j < lines.length; j++) {
      const N = lines[j];
      if (N.trim() === "" || /^\S/.test(N)) break;      // blank or col-0 ends the type
      type += " " + N.trim();
    }
    type = type.replace(/\s+/g, " ").trim();
    if (type === "") continue;
    const addr = crypto.createHash("sha256").update(name + "\0" + type).digest("hex").slice(0, 12);
    spells.push({ name, type, mod, line: i + 1, addr });
  }
  return spells;
}

function treasury() {
  let all = [];
  for (const f of walk(ROOT)) all = all.concat(harvest(f));
  return all;
}

function show(s) {
  return `${s.name}\n  : ${s.type}\n  · ${s.mod}:${s.line}  #${s.addr}`;
}

const [, , cmd, arg] = process.argv;
const T = treasury();
if (cmd === "--json") { process.stdout.write(JSON.stringify(T)); }
else if (cmd === "--stat") {
  const names = new Set(T.map(s => s.name));
  const addrs = new Set(T.map(s => s.addr));
  const coll = T.length - names.size;
  console.log(`spells ${T.length} · distinct names ${names.size} · distinct addrs ${addrs.size} · name-collisions ${coll} · modules ${new Set(T.map(s=>s.mod)).size}`);
}
else if (cmd === "~") { T.filter(s => s.name.includes(arg)).forEach(s => console.log(show(s))); }
else if (cmd === ":") { T.filter(s => s.type.includes(arg)).slice(0, 60).forEach(s => console.log(show(s))); }
else if (cmd) {
  const hits = T.filter(s => s.name === cmd);
  if (hits.length === 0) { console.log(`no spell «${cmd}» — try: node machine/mantra.js ~ ${cmd}`); process.exit(0); }
  hits.forEach(s => console.log(show(s)));
  if (hits.length > 1) console.log(`(${hits.length} seats hold this spell — anekānta: the name is one, the loci many)`);
}
else console.log("मन्त्रकोश: node machine/mantra.js <spell> | ~ <substr> | : <substr> | --json | --stat");
