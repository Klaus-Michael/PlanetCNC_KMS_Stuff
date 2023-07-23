o150 ;Measure Hole
o<chk> if[LNOT[ACTIVE[]]]
  M99
o<chk> endif
G65 P109 Q1
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Hole)
  M2
o<chk> endif

#<_return> = NAN[]
M73
G08 G15 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M58P0
M10P1


#<vert_retract> = DEF[#<Kvalue>,#<_probe_swdist>]


G65 P110 H0 E1 R1 K#<vert_retract>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  M2
o<chk> endif

#<measure01> = #<_measure_x>

G65 P110 H0 E-1 R0 K#<vert_retract>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  M2
o<chk> endif

#<measure02> = #<_measure_x>

G53 G00 X[[#<measure01> + #<measure02>] / 2]

G65 P110 H1 E1 R1  K#<vert_retract>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  M2
o<chk> endif

#<measure11> = #<_measure_y>

G65 P110 H1 E-1 R0  K#<vert_retract>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  M2
o<chk> endif

#<measure12> = #<_measure_y>

G53 G00 Y[[#<measure11> + #<measure12>] / 2]

G65 P110 H0 E1 R1  K#<vert_retract>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  M2
o<chk> endif

#<measure01> = #<_measure_x>

G65 P110 H0 E-1 R0  K#<vert_retract>
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Hole)
  M2
o<chk> endif

#<measure02> = #<_measure_x>

G53 G00 X[[#<measure01> + #<measure02>] / 2]

#<_measure_x> = [[#<measure01> + #<measure02>] / 2]
#<_measure_sizex> = [ABS[#<measure01> - #<measure02>]]
#<_measure_y> = [[#<measure11> + #<measure12>] / 2]
#<_measure_sizey> = [ABS[#<measure11> - #<measure12>]]

(print,|!Measure Hole)
G65 P103
(print,|!  Hole size:)
(print,  X#<_measure_sizex> Y#<_measure_sizey>)

#<_return> = 0
M99
