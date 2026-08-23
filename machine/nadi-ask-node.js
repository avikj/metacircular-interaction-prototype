// नाडी ask client (node): send one JSON command to the warm conduit, print the reply.
//   node machine/nadi-ask-node.js <sock> '{"cmd":"infer","expr":"..."}'
const net = require("net");
const [, , sock, payload] = process.argv;
const c = net.createConnection(sock, () => c.write(payload.trim() + "\n"));
let out = "";
c.on("data", (d) => { out += d.toString("utf8"); });
c.on("end", () => { process.stdout.write(out); });
c.on("error", (e) => { console.error("no conduit at " + sock + " — " + e.message); process.exit(1); });
