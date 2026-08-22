# strip Lean block comments /- ... -/ (incl. doc /-- ... -/) and line comments --
{ line=$0; out=""; i=1; n=length(line)
  while (i<=n) {
    c=substr(line,i,2)
    if (blk==0 && c=="/-") { blk++; i+=2; continue }
    if (blk>0  && c=="/-") { blk++; i+=2; continue }
    if (blk>0  && c=="-/") { blk--; i+=2; continue }
    if (blk>0) { i++; continue }
    if (c=="--") { break }
    out = out substr(line,i,1); i++
  }
  print out }
