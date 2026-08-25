#!/usr/bin/env wolframscript

(* Discovery-only Wolfram Language probe.
   Usage: wolframscript -file code/wolfram_probe.wls request.json output-dir
   The request must contain Expression (held WL source), Assumptions (WL source),
   and Operation.  Outputs are WXF plus a JSON provenance envelope. *)

args = Rest[$ScriptCommandLine];
If[Length[args] =!= 2,
  WriteString[$Output, "usage: wolfram_probe.wls request.json output-dir\n"];
  Exit[2]
];

requestPath = ExpandFileName[args[[1]]];
outputDir = ExpandFileName[args[[2]]];
If[! DirectoryQ[outputDir], CreateDirectory[outputDir, CreateIntermediateDirectories -> True]];

request = Import[requestPath, "RawJSON"];
required = {"Expression", "Assumptions", "Operation", "StatementHash"};
If[! And @@ (KeyExistsQ[request, #] & /@ required),
  WriteString[$Output, "request missing required keys\n"];
  Exit[2]
];

heldExpression = ToExpression[request["Expression"], InputForm, HoldComplete];
heldAssumptions = ToExpression[request["Assumptions"], InputForm, HoldComplete];
operation = request["Operation"];
timeout = Lookup[request, "TimeConstraintSeconds", 60];

evaluate["FullSimplify", expression_, assumptions_] :=
  FullSimplify[expression, Assumptions -> assumptions, TimeConstraint -> timeout];
evaluate["FunctionExpand", expression_, assumptions_] :=
  FullSimplify[FunctionExpand[expression], Assumptions -> assumptions, TimeConstraint -> timeout];
evaluate["Reduce", expression_, assumptions_] :=
  TimeConstrained[Reduce[expression && assumptions], timeout, $Aborted];
evaluate["Resolve", expression_, assumptions_] :=
  TimeConstrained[Resolve[Implies[assumptions, expression]], timeout, $Aborted];
evaluate["FindInstance", expression_, assumptions_] :=
  TimeConstrained[FindInstance[Not[Implies[assumptions, expression]]], timeout, $Aborted];
evaluate[_, _, _] := $Failed;

expression = ReleaseHold[heldExpression];
assumptions = ReleaseHold[heldAssumptions];
started = AbsoluteTime[];
result = Block[{$MessageList = {}}, evaluate[operation, expression, assumptions]];
elapsed = AbsoluteTime[] - started;

wxfPath = FileNameJoin[{outputDir, "result.wxf"}];
Export[wxfPath, result, "WXF"];
manifest = <|
  "statement_hash" -> request["StatementHash"],
  "operation" -> operation,
  "wolfram_version" -> $Version,
  "system_id" -> $SystemID,
  "machine_precision" -> $MachinePrecision,
  "elapsed_seconds" -> N[elapsed],
  "result_wxf" -> wxfPath,
  "input_contains_inexact_numbers" -> (! FreeQ[expression, _Real] || ! FreeQ[assumptions, _Real]),
  "contains_inexact_numbers" -> ! FreeQ[result, _Real],
  "status" -> Which[result === $Aborted, "timeout", result === $Failed, "failed", True, "candidate-only"]
|>;
Export[FileNameJoin[{outputDir, "manifest.json"}], manifest, "RawJSON"];
WriteString[$Output, ExportString[manifest, "RawJSON"] <> "\n"];
Exit[Which[result === $Aborted, 124, result === $Failed, 1, True, 0]];
