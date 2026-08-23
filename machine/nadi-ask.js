// नाडी-प्रश्नः — one question down the conduit, the kernel's answer back.
// Usage: node machine/nadi-ask.js /tmp/nadi.sock '{"cmd":"infer","expr":"..."}'
// Prints the kernel's JSON lines; exits when the response completes.

const net = require("net");
const sock = process.argv[2];
const query = process.argv[3];
const conn = net.createConnection(sock);
let out = "";
conn.on("connect", () => conn.write(query + "\n"));
conn.on("data", (d) => { out += d.toString("utf8"); });
conn.on("end", () => {
  // condense: show DisplayInfo payloads and errors, one per line
  for (const line of out.split("\n")) {
    if (!line.trim()) continue;
    try {
      const j = JSON.parse(line);
      if (j.kind === "DisplayInfo" && j.info) {
        const i = j.info;
        if (i.kind === "InferredType" && i.expr) console.log("TYPE:", i.expr);
        else if (i.kind === "NormalForm" && i.expr) console.log("NORM:", i.expr);
        else if (i.kind === "AllGoalsWarnings") {
          const gs = (i.visibleGoals || []).map(g =>
            `?${g.constraintObj && g.constraintObj.id !== undefined ? g.constraintObj.id : "?"} : ${g.type || ""}`);
          console.log(gs.length ? "GOALS:\n  " + gs.join("\n  ") : "GOALS: none");
        }
        else if (i.kind === "GoalSpecific" && i.goalInfo && i.goalInfo.type)
          console.log("GOAL:", i.goalInfo.type);
        else if (i.kind === "Error") {
          const msg = (i.error && i.error.message) || JSON.stringify(i).slice(0, 400);
          console.log("ERROR:", msg);
        }
        else console.log(j.kind + "/" + i.kind + ":", JSON.stringify(i).slice(0, 300));
      } else if (j.kind === "Status" || j.kind === "ClearHighlighting"
                 || j.kind === "HighlightingInfo" || j.kind === "ClearRunningInfo"
                 || j.kind === "RunningInfo" || j.kind === "InteractionPoints") {
        // quiet kinds; InteractionPoints printed compactly
        if (j.kind === "InteractionPoints" && j.interactionPoints && j.interactionPoints.length)
          console.log("HOLES:", j.interactionPoints.map(p => p.id).join(" "));
      } else if (j.error) console.log("NADI-ERROR:", j.error);
      else console.log(JSON.stringify(j).slice(0, 300));
    } catch (e) { console.log(line.slice(0, 300)); }
  }
});
conn.on("error", (e) => { console.error("no conduit at", sock, "-", e.message); process.exit(1); });
