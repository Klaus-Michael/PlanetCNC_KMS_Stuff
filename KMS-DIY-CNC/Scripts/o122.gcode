o122 ;Measure Tool Offset
#<wls_clean_pin> = 5
G65 P109 Q0
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Tool Offset)
  M2
o<chk> endif
;check if magazin is cloded (work around due to normaly closed sensor)
O<chmagcl>if [#<_input_num|4> EQ 1]
  (msg,Magazin seems to be open, is this correct?)
O<chmagcl>endif

#<mist_on>= #<_mist_on>
O<ckmist> if [[#<mist_on> NE 0]]
  (print,  MMS is ON)
  M9
O<ckmist> endif

#<spindle> = #<_spindle>
O<sp> if [[#<spindle> NE 5]]
  (print,  Spindle is ON)
  M5
O<sp> endif

;Open Magazin
M62 P3 Q1
G04 P1.5
G9
O<chmagco>if [#<_input_num|4> EQ 0]
  (msg,Magazin did not open correctly)
O<chmagco>endif

#<_return> = NAN[]
#<num> = DEF[#<qvalue>,#<_current_tool>]
o<skp> if [#<_tool_skipmeasure_num|#<num>> GT 0]
 ; (print,Measuring skipped)
 ; M99
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
O<xyoffset> if [ [#<soy> NE 0]]
  (msg, Rotate Tool into correct position)
O<xyoffset> endif

o<chk_fast> if[#<fvalue> EQ 1]
  o<fastmove>if[#<_tool_off_z_num|#<_current_tool>> gt 0]
      #<fast_z_target> = [#<_tooloff_sensorz> + #<_tool_off_z_num|#<_current_tool>> + 10]        
      o<fastmove3>if[#<fast_z_target> lt 0]
;            (print,  old tool lentgh greater 0, move down fast to G53 Z #<fast_z_target>)
        G90 G53 G38.3 Z#<fast_z_target>  F5000
      o<fastmove3>endif     
  o<fastmove>endif
o<chk_fast> endif



M62 P#<wls_clean_pin> Q1
G04 P1 
G9
M62 P#<wls_clean_pin> Q0

G65 P110 H2 E-1 Q0 R1 D10000 K#<_tooloff_swdist> J[#<_tooloff_sensorz> + #<soz>] F#<_tooloff_speed> I#<_tooloff_speed_low>
G53 G00 Z#<_tooloff_safeheight>
G53 G00 X#<startX> Y#<startY>

o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
  (msg,Measure Tool Offset Measure error)
  M2
o<chk> endif

#<off> = #<_measure_z>
#<tool_off_diff>=[#<off> - #<_tool_off_z_num|#<_current_tool>>]
#<timesampkms>= DateTime[]
o<chk> if[#<rvalue> EQ 1]
  (print,  Set tool offset Z#<off>, old offset #<_tool_off_z_num|#<_current_tool>>, diff #<tool_off_diff>, Time #<timesampkms>) 
  M72
  M71
  G43.1 Z#<off>
o<chk> elseif[#<rvalue> EQ 2]
 (print,  Set tooltable Z#<off> , old offset #<_tool_off_z_num|#<_current_tool>>, diff #<tool_off_diff>, Time #<timesampkms>)
  G10 L1 P#<num> Z#<off>
  G43.1 Z#<off>
o<chk> endif
#<_return> = #<off>

;Close Magazin
M62 P3 Q0
G9

O<sp> if [ [#<spindle> EQ 3]]
  (print,  Turn spindle CW)
  M3
O<sp> elseif [[#<spindle> EQ 4]]
  (print,  Turn spindle CCW)
  M4
O<sp> endif

O<ckmist> if [[#<mist_on> NE 0]]
  (print,  MMS is ON)
  M7
O<ckmist> endif

M99
