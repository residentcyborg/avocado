: immediate last @ nfa + dup b@ f-immediate xor over b! drop ; immediate
: hidden    last @ nfa + dup b@ f-hidden    xor over b! drop ; immediate

: [ commit 0 state ! ; immediate
: ] apply -1 state ! ; immediate

: begin top @ ; immediate

: if lit ?jump postpone , top @ 0 postpone , ; immediate
: then push top @ pop ! ; immediate

: repeat push lit jump postpone , postpone , top @ pop ! ; immediate
: until lit ?jump postpone , postpone , ; immediate

: variable postpone : lit var postpone , 0 postpone , postpone ; ; immediate
: constant postpone : postpone literal lit call postpone ,
  ' literal literal postpone , postpone ; postpone immediate ; immediate

: char word [ 'buffer 1+ ] literal b@ postpone literal ; immediate

: ( begin word? 'buffer b@ 1 =
  [ 'buffer 1+ ] literal b@ char ) = and until ; immediate

: " ( -- addr ) begin skip key? until 0 'buffer b!
  begin
    key advance dup char " xor
  if
    accumulate key? not [ over ] until accept
  repeat
  drop save head @ ; immediate

: hold ( char -- ) 'buffer @ 1- dup 'buffer ! b! ;

: digit ( u -- char ) dup 10 u<
  if char 0 + tail then [ char A 10 - ] literal + ;

: u. ( u -- ) [ 'buffer 256 + ] literal 'buffer !
  begin 0 base @ um/mod push digit hold pop dup 0= until drop
  'buffer @ [ 'buffer 256 + ] literal over - type ;

: . ( n -- ) dup 0< if char - emit negate then u. ;

: bina  2 base ! ; immediate
: deci 10 base ! ; immediate
: hexa 16 base ! ; immediate

: lshift ( x1 u -- x2 ) begin dup if push 2* pop 1- repeat drop ;
: rshift ( x1 u -- x2 ) begin dup if push 2/ pop 1- repeat drop ;

: space 32 emit ;

: cells ( n1 -- n2 ) cell * ;
