: words latest
  begin
    @ dup
  if
    dup cell + count [ f-immediate 1- ] literal and type space
  repeat
  drop ;

: forget word find dup if dup here ! @ latest ! else drop then ;

: prompt begin ." # " write refill interpret again [ reveal prompt