o122 ;Measure Tool Offset
G65 P109 Q0
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Tool Offset)
  M2
o<chk> endif

#<_return> = NAN[]
#<num> = DEF[#<qvalue>,#<_current_tool>]
o<skp> if [#<_tool_skipmeasure_num|#<num>> GT 0]
  (print,Measuring skipped)
  M99
o<skp> endif

M73
G08 G15 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M10P1

#<startX> = #<_machine_x>
#<startY> = #<_machine_y>

#<sox> = [DEF[#<_tool_so_x_num|#<_current_tool>>,0]]
#<soy> = [DEF[#<_tool_so_y_num|#<_current_tool>>,0]]
#<soz> = [DEF[#<_tool_so_z_num|#<_current_tool>>,0]]

G53 G00 Z#<_tooloff_safeheight>
G53 G00 X[#<_tooloff_sensorx> - #<sox>] Y[#<_tooloff_sensory> - #<soy>]
G53 G00 Z#<_tooloff_rapidheight>

G65 P110 H2 E-1 Q0 R1 D10000 K#<_tooloff_swdist> J[#<_tooloff_sensorz> + #<soz>] F#<_tooloff_speed> I#<_tooloff_speed_low>
G53 G00 Z#<_tooloff_safeheight>
G53 G00 X#<startX> Y#<startY>

o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure Tool Offset Measure error)
  M2
o<chk> endif

#<off> = #<_measure_z>
o<chk> if[#<rvalue> EQ 1]
  M72
  M71
  G43.1 Z#<off>
o<chk> elseif[#<rvalue> EQ 2]
  G10 L1 P#<num> Z#<off>
  
o<chk> endif
(print,  Set tool offset Z#<off>)
#<_return> = #<off>
M99
