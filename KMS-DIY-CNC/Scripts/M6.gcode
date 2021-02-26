M63 P1 R05

O<PlanetCNC> if[[#<_tc_toolmeasure>] AND [#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Sensor is not configured)
  M2
O<PlanetCNC> endif

M73
G17 G90 G91.1 G90.2 G08 G15 G94
;M50P0 ;disable speed override
M55P0 ;disable trans
M56P0 ;disable warp
M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable

O<en> if [ACTIVE[] AND #<_tc_enable>]
  (print,Toolchange)
  #<toisset>=0
  #<wstartx> = #<_x>
  #<wstarty> = #<_y>
  #<wstartz> = #<_z>

  #<spindle> = #<_spindle>
  O<sp> if [#<_tc_spindlecheck> AND [#<spindle> NE 5]]
    (print,  Spindle is ON)
    M5
  O<sp> endif
  O<st> if [#<_tc_skipsame> AND [#<_current_tool> EQ #<_selected_tool>]]
    (print,  Skip same tool)
  O<st> else
    O<sh> if [#<_tc_safeheight_en>]
    (print,  Move to safe height)
      G53 G00 Z#<_tc_safeheight>
    O<sh> endif

    O<po> if [#<_tc_pos_en>]
      (print,  Move to position)
      O<sh> if [#<_tc_safeheight_en>]
        G53 G00 X#<_tc_pos_x> Y#<_tc_pos_y>
        G53 G00 Z#<_tc_pos_z>
      O<sh> else
        G53 G00 X#<_tc_pos_x> Y#<_tc_pos_y> Z#<_tc_pos_z>
      O<sh> endif
    O<po> endif
    G09

    O<ac> if [AND[#<_tc_action>, 1]]
      (msg,Change tool:\      #<_current_tool,0> : #<_tool_dia_num|#<_current_tool>,2>mm $<_current_tool>\to\      #<_selected_tool,0> : #<_tool_dia_num|#<_selected_tool,0>,2>mm $<_selected_tool>)
    O<ac> else
      (print,  Change tool #<_current_tool,0> to #<_selected_tool,0>)
    O<ac> endif
    O<ac> if [AND[#<_tc_action>, 2]]
      M0
    O<ac> endif
    O<atcen> if [#<_tc_atc_en>]
      (print,  ATC enabled)
      O<un> if [#<_current_tool> GT 0]
        (print,  Unload tool #<_current_tool,0>)
        O<ex> if [#<_tool_exists|#<_current_tool>> EQ 0]
          (msg,Current tool #<_current_tool,0> does not exist in tool table)
          M2
        O<ex> endif
        O<skp> if [#<_tool_skipchange_num|#<_current_tool>> EQ 0]
        #<unposx> = #<_tool_tc_x_num|#<_current_tool>>
        #<unposy> = #<_tool_tc_y_num|#<_current_tool>>
        #<unposz> = #<_tool_tc_z_num|#<_current_tool>>
        #<unposx_in1> = [#<unposx> - #<_tc_unload_in1_x>]
        #<unposy_in1> = [#<unposy> - #<_tc_unload_in1_y>]
        #<unposz_in1> = [#<unposz> - #<_tc_unload_in1_z>]
        #<unposx_in2> = [#<unposx_in1> - #<_tc_unload_in2_x>]
        #<unposy_in2> = [#<unposy_in1> - #<_tc_unload_in2_y>]
        #<unposz_in2> = [#<unposz_in1> - #<_tc_unload_in2_z>]
        (print,  Unload in2 position X#<unposx_in2> Y#<unposy_in2> Z#<unposz_in2>)
        (print,  Unload in1 position X#<unposx_in1> Y#<unposy_in1> Z#<unposz_in1>)
        (print,  Unload position X#<unposx> Y#<unposy> Z#<unposz>)
        O<unpos> if [#<_tc_safeheight_en>]
          G53 G00 X#<unposx_in2> Y#<unposy_in2>
          G53 G00 Z#<unposz_in2>
        O<unpos> else
          G53 G00 X#<unposx_in2> Y#<unposy_in2> Z#<unposz_in2>
        O<unpos> endif
        G53 G01 X#<unposx_in1> Y#<unposy_in1> Z#<unposz_in1> F#<_tc_atc_speed2>
        G53 G01 X#<unposx> Y#<unposy> Z#<unposz> F#<_tc_atc_speed>
      O<unp11> if [[#<_tc_unload_pin1> GT 0] AND [#<_tc_unload_pin1set1> GT 0]]
        M62 P#<_tc_unload_pin1> Q[#<_tc_unload_pin1set1>-1]
      O<unp11> endif
      O<und11> if [#<_tc_unload_pin1delay1> GT 0]
        G04 P#<_tc_unload_pin1delay1>
      O<und11> endif
      O<unp12> if [[#<_tc_unload_pin1> GT 0] AND [#<_tc_unload_pin1set2> GT 0]]
        M62 P#<_tc_unload_pin1> Q[#<_tc_unload_pin1set2>-1]
      O<unp12> endif
      O<und12> if [#<_tc_unload_pin1delay2> GT 0]
        G04 P#<_tc_unload_pin1delay2>
      O<und12> endif
      O<unp21> if [[#<_tc_unload_pin2> GT 0] AND [#<_tc_unload_pin2set1> GT 0]]
        M62 P#<_tc_unload_pin2> Q[#<_tc_unload_pin2set1>-1]
      O<unp21> endif
      O<und21> if [#<_tc_unload_pin2delay1> GT 0]
        G04 P#<_tc_unload_pin2delay1>
      O<und21> endif
      O<unp22> if [[#<_tc_unload_pin2> GT 0] AND [#<_tc_unload_pin2set2> GT 0]]
        M62 P#<_tc_unload_pin2> Q[#<_tc_unload_pin2set2>-1]
      O<unp22> endif
      O<und22> if [#<_tc_unload_pin2delay2> GT 0]
        G04 P#<_tc_unload_pin2delay2>
      O<und22> endif
        #<unposx_out1> = [#<unposx> + #<_tc_unload_out1_x>]
        #<unposy_out1> = [#<unposy> + #<_tc_unload_out1_y>]
        #<unposz_out1> = [#<unposz> + #<_tc_unload_out1_z>]
        #<unposx_out2> = [#<unposx_out1> + #<_tc_unload_out2_x>]
        #<unposy_out2> = [#<unposy_out1> + #<_tc_unload_out2_y>]
        #<unposz_out2> = [#<unposz_out1> + #<_tc_unload_out2_z>]
        (print,  Unload out1 position X#<unposx_out1> Y#<unposy_out1> Z#<unposz_out1>)
        (print,  Unload out2 position X#<unposx_out2> Y#<unposy_out2> Z#<unposz_out2>)
        G53 G01 X#<unposx_out1> Y#<unposy_out1> Z#<unposz_out1> F#<_tc_atc_speed>
        G53 G01 X#<unposx_out2> Y#<unposy_out2> Z#<unposz_out2> F#<_tc_atc_speed2>
        O<sh> if [#<_tc_safeheight_en>]
          G53 G00 Z#<_tc_safeheight>
        O<sh> endif
        O<skp> endif
      O<un> endif
      O<ld> if [#<_selected_tool> GT 0]
        (print,  Load tool #<_selected_tool,0>)
        O<ex> if [#<_tool_exists|#<_selected_tool>> EQ 0]
          (msg,Selected tool #<_selected_tool,0> does not exist in tool table)
          M2
        O<ex> endif
        O<skp> if [#<_tool_skipchange_num|#<_selected_tool>> EQ 0]
        #<ldposx> = #<_tool_tc_x_num|#<_selected_tool>>
        #<ldposy> = #<_tool_tc_y_num|#<_selected_tool>>
        #<ldposz> = #<_tool_tc_z_num|#<_selected_tool>>
        #<ldposx_in1> = [#<ldposx> - #<_tc_load_in1_x>]
        #<ldposy_in1> = [#<ldposy> - #<_tc_load_in1_y>]
        #<ldposz_in1> = [#<ldposz> - #<_tc_load_in1_z>]
        #<ldposx_in2> = [#<ldposx_in1> - #<_tc_load_in2_x>]
        #<ldposy_in2> = [#<ldposy_in1> - #<_tc_load_in2_y>]
        #<ldposz_in2> = [#<ldposz_in1> - #<_tc_load_in2_z>]
        (print,  Load in2 position X#<ldposx_in2> Y#<ldposy_in2> Z#<ldposz_in2>)
        (print,  Load in1 position X#<ldposx_in1> Y#<ldposy_in1> Z#<ldposz_in1>)
        (print,  Load position X#<ldposx> Y#<ldposy> Z#<ldposz>)
        O<ldpos> if [#<_tc_safeheight_en>]
          G53 G00 X#<ldposx_in2> Y#<ldposy_in2>
          G53 G00 Z#<ldposz_in2>
        O<ldpos> else
          G53 G00 X#<ldposx_in2> Y#<ldposy_in2> Z#<ldposz_in2>
        O<ldpos> endif
        G53 G01 X#<ldposx_in1> Y#<ldposy_in1> Z#<ldposz_in1> F#<_tc_atc_speed2>
        G53 G01 X#<ldposx> Y#<ldposy> Z#<ldposz> F#<_tc_atc_speed>
      O<ldp11> if [[#<_tc_load_pin1> GT 0] AND [#<_tc_load_pin1set1> GT 0]]
        M62 P#<_tc_load_pin1> Q[#<_tc_load_pin1set1>-1]
      O<ldp11> endif
      O<ldd11> if [#<_tc_load_pin1delay1> GT 0]
        G04 P#<_tc_load_pin1delay1>
      O<ldd11> endif
      O<ldp12> if [[#<_tc_load_pin1> GT 0] AND [#<_tc_load_pin1set2> GT 0]]
        M62 P#<_tc_load_pin1> Q[#<_tc_load_pin1set2>-1]
      O<ldp12> endif
      O<ldd12> if [#<_tc_load_pin1delay2> GT 0]
        G04 P#<_tc_load_pin1delay2>
      O<ldd12> endif
      O<ldp21> if [[#<_tc_load_pin2> GT 0] AND [#<_tc_load_pin2set1> GT 0]]
        M62 P#<_tc_load_pin2> Q[#<_tc_load_pin2set1>-1]
      O<ldp21> endif
      O<ldd21> if [#<_tc_load_pin2delay1> GT 0]
        G04 P#<_tc_load_pin2delay1>
      O<ldd21> endif
      O<ldp22> if [[#<_tc_load_pin2> GT 0] AND [#<_tc_load_pin2set2> GT 0]]
        M62 P#<_tc_load_pin2> Q[#<_tc_load_pin2set2>-1]
      O<ldp22> endif
      O<ldd22> if [#<_tc_load_pin2delay2> GT 0]
        G04 P#<_tc_load_pin2delay2>
      O<ldd22> endif
        #<ldposx_out1> = [#<ldposx> + #<_tc_load_out1_x>]
        #<ldposy_out1> = [#<ldposy> + #<_tc_load_out1_y>]
        #<ldposz_out1> = [#<ldposz> + #<_tc_load_out1_z>]
        #<ldposx_out2> = [#<ldposx_out1> + #<_tc_load_out2_x>]
        #<ldposy_out2> = [#<ldposy_out1> + #<_tc_load_out2_y>]
        #<ldposz_out2> = [#<ldposz_out1> + #<_tc_load_out2_z>]
        (print,  Unload out1 position X#<ldposx_out1> Y#<ldposy_out1> Z#<ldposz_out1>)
        (print,  Unload out2 position X#<ldposx_out2> Y#<ldposy_out2> Z#<ldposz_out2>)
        G53 G01 X#<ldposx_out1> Y#<ldposy_out1> Z#<ldposz_out1> F#<_tc_atc_speed>
        G53 G01 X#<ldposx_out2> Y#<ldposy_out2> Z#<ldposz_out2> F#<_tc_atc_speed2>
        O<sh> if [#<_tc_safeheight_en>]
          G53 G00 Z#<_tc_safeheight>
        O<sh> endif
        O<skp> endif
      O<ld> endif
      M6
    O<atcen> else
      M6
    O<atcen> endif

    O<tm> if [[#<_tc_toolmeasure> GT 0] AND [#<_tool_skipmeasure_num|#<_current_tool>> EQ 0]]
      G09
      (print,  Measure tool)
      #<sox> = [DEF[#<_tool_so_x_num|#<_current_tool>>,0]]
      #<soy> = [DEF[#<_tool_so_y_num|#<_current_tool>>,0]]
      #<soz> = [DEF[#<_tool_so_z_num|#<_current_tool>>,0]]

      G53 G00 Z#<_tooloff_safeheight>
      G53 G00 X[#<_tooloff_sensorX> - #<sox>] Y[#<_tooloff_sensorY> - #<soy>]
      G53 G00 Z#<_tooloff_rapidheight>

      M11P0 G38.2 Z-100000 F#<_tooloff_speed>
      G91 G01 Z[+#<_tooloff_swdist>]
      o<low> if [#<_tooloff_speed_low> GT 0]
        G90 G38.2 Z-100000 F#<_tooloff_speed_low>
        G91 G01 Z[+#<_tooloff_swdist>] F#<_tooloff_speed>
      o<low> endif
      M11P1 G90

      G53 G00 Z#<_tooloff_safeheight>
      o<chk> if[ACTIVE[] AND NOTEXISTS[#<_probe_z>]]
        (msg,Measuring failed)
        M2
      o<chk> endif

      #<off> = [#<_probe_z> - #<_tooloff_sensorZ> - #<soz>]

      O<tmset> if [#<_tc_toolmeasure> EQ 2]
        (print,  Set tooltable Z#<off>)
        G10 L1 P#<_current_tool> Z#<off>
        #<toisset>=2
      O<tmset> elseif [#<_tc_toolmeasure> EQ 1]
        (print,  Set tool offset Z#<off>)
        G43.1 Z#<off>
        #<toisset>=1
      O<tmset> endif
    O<tm> endif
  O<st> endif
  O<toen> if [#<_tc_tooloff_en>]
    M72
    M71
    (print,  Enable tool offset)
    O<tois> if [#<toisset> EQ 2]
      G43
    O<tois> elseif [#<toisset> EQ 1]
      G43.1
    O<tois> endif
  O<toen> endif
  o<ar> if [#<_tc_autoreturn>]
    G00 X#<wstartx> Y#<wstarty>
    G00 Z#<wstartz>
  O<ar> endif
  O<sp> if [#<_tc_spindlecheck> AND [#<spindle> EQ 3]]
    (print,  Turn spindle CW)
    M3
  O<sp> elseif [#<_tc_spindlecheck> AND [#<spindle> EQ 4]]
    (print,  Turn spindle CCW)
    M4
  O<sp> endif
O<en> else
  M6
O<en> endif

M63 P1 R88
G04 P0.1
M63 P1 R85