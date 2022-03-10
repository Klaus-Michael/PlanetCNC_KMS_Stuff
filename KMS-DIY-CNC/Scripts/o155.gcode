o155 ;Measure Protrusion
G65 P109 Q1
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Protrusion)
  M2
o<chk> endif

#<_return> = NAN[]
#<distx> = #<ivalue>
#<disty> = #<jvalue>
o<chk> if[NOTEXISTS[#<distx>] OR [#<distx> LE 0]]
  (msg,Size value incorrect)
  M2
o<chk> endif
o<chk> if[NOTEXISTS[#<disty>] OR [#<disty> LE 0]]
  (msg,Size value incorrect)
  M2
o<chk> endif
M73
G08 G15 G94
M50P0
M55P0
M56P0
M57P0
M10P1

(check if a alternative z drop was configured in the dialog)
o<z_drop> if[EXISTS[#<Zvalue>]]
 (print, additional Z Drop configured with #<Zvalue>)
  #<z_drop> = #<Zvalue>
 o<z_drop> else
 #<z_drop> = 0
o<z_drop> endif

#<posX> = #<_machine_x>
#<posY> = #<_machine_y>
G65 P131 H0 E1 D[#<distx>/2] Z#<z_drop>
#<measureZ> = #<_measure_z>
#<travelZ> = [#<measureZ> + #<_probe_trav> + #<_probe_sizez>]
G65 P110 H0 E-1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Protrusion)
  M2
o<chk> endif

#<measure01> = #<_measure_x>

G53 G00 Z#<travelZ>
G53 G00 X#<posX>
G65 P131 H0 E-1 D[#<distx>/2] K#<measureZ>
G65 P110 H0 E1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Protrusion)
  M2
o<chk> endif

#<measure02> = #<_measure_x>

G53 G00 Z#<travelZ>
#<posX> = [[#<measure01> + #<measure02>] / 2]
G53 G00 X#<posX>
G65 P131 H1 E1 D[#<disty>/2] K#<measureZ>
G65 P110 H1 E-1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Protrusion)
  M2
o<chk> endif

#<measure11> = #<_measure_y>

G53 G00 Z#<travelZ>
G53 G00 Y#<posY>
G65 P131 H1 E-1 D[#<disty>/2] K#<measureZ>
G65 P110 H1 E1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Protrusion)
  M2
o<chk> endif

#<measure12> = #<_measure_y>

G53 G00 Z#<travelZ>
#<posY> = [[#<measure11> + #<measure12>] / 2]
G53 G00 Y#<posY>
G65 P131 H0 E1 D[#<distx>/2] K#<measureZ>
G65 P110 H0 E-1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Protrusion)
  M2
o<chk> endif

#<measure01> = #<_measure_x>

G53 G00 Z#<travelZ>
G53 G00 X#<posX>
G65 P131 H0 E-1 D[#<distx>/2] K#<measureZ>
G65 P110 H0 E1 R0
o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure error: Measure Protrusion)
  M2
o<chk> endif

#<measure02> = #<_measure_x>

G53 G00 Z#<travelZ>
#<posX> = [[#<measure01> + #<measure02>] / 2]
G53 G00 X#<posX>
#<_measure_x> = [[#<measure01> + #<measure02>] / 2]
#<_measure_sizex> = [ABS[#<measure01> - #<measure02>]]
#<_measure_y> = [[#<measure11> + #<measure12>] / 2]
#<_measure_sizey> = [ABS[#<measure11> - #<measure12>]]

(print,|!Measure Protrusion)
G65 P103
(print,|!  Protrusion size:)
(print,  X#<_measure_sizex> Y#<_measure_sizey>)

#<_measure_z> = #<measureZ>

#<_return> = 0
M99
