;M63 P1 R05
#<unposy_start_offset> = 65
#<unposz_start_offset> = 20

#<ldposy_end_offset> = 65
#<ldposz_start_offset> = 20

#<tc_clamp_open_pin> = 1
#<tc_tool_in_spindle_pin> = 2

O<PlanetCNC> if[[#<_tc_toolmeasure>] AND [#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Sensor is not configured)
  M2
O<PlanetCNC> endif

M73
G17 G90 G91.1 G90.2 G08 G15 G94
;M50P0
M55P0
M56P0
M57P0
M10P1
M11P1

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

O<noatcen> if [#<_tc_atc_en> EQ 0]
(print,  ATC disabled)

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
        O<tn> if [#<_toolchangename>]
          (msg,Change tool to\  $<_toolchangename>)
        O<tn> else
          (msg,Change tool:\  #<_current_tool,0>: $<tool_name|#<_current_tool>> \to\  #<_selected_tool,0>: $<tool_name|#<_selected_tool>>)
        O<tn> endif
      O<ac> else
        O<tn> if [#<_toolchangename>]
          (print,  Change tool to $<_toolchangename>)
        O<tn> else
          (print,  Change tool #<_current_tool,0> to #<_selected_tool,0>)
        O<tn> endif
      O<ac> endif
      O<ac> if [AND[#<_tc_action>, 2]]
        M0
      O<ac> endif
      O<PROBE_CK> if [#<_tool_isprobe_num|#<_selected_tool>> EQ 1]
        (print, Probe selected enable Probe E-STOP!!!)
        #<_probe_estop>=1
      O<PROBE_CK> else
        (print, normale tool selected Probe E-STOP disabled)
        #<_probe_estop>=0
      O<PROBE_CK> endif		
      G09
O<noatcen> endif
    O<atcen> if [#<_tc_atc_en>]
      (print,  ATC enabled)
     O<ubload> if [#<_current_tool> GT 0]
        ;check if current tool is in magazine, if not manual change
      O<un_manual> if [#<_tool_tc_x_num|#<_current_tool>> EQ 0 AND #<_tool_tc_y_num|#<_current_tool>> EQ 0 ]
          G53 G00 Z#<_tc_safeheight>
          G53 G00 X#<_tc_pos_x> Y#<_tc_pos_y>
          (msg, remove current tool #<_current_tool,0> check if new tool #<_selected_tool,0> is manual as well)
      O<un_manual> else
        (print,  Move tool #<_selected_tool,0> to magazine)
        #<unposx> = #<_tool_tc_x_num|#<_current_tool>>
        #<unposy> = #<_tool_tc_y_num|#<_current_tool>>
        #<unposz> = #<_tool_tc_z_num|#<_current_tool>>
        #<unposx_start> = [	#<unposx>]
        #<unposy_start> = [#<unposy> + #<unposy_start_offset>]
        #<unposz_start> = [#<unposz> + #<unposz_start_offset>]
        #<unposz_end> = [#<unposz>+30]
        ;move to Z Safe
        G53 G00 Z#<_tc_safeheight>
        ;move to XY Unload start position
        G9
        G53 G00 Y#<unposy_start>
        G53 G00 X#<unposx_start> 
        G9
        ;check if we have a tool clamped, if not error out
        o<chk_for_tool> if [#<_hw_limit_num|#<tc_tool_in_spindle_pin>> EQ 0]
          (msg, no tool in spindle)
          M2
        o<chk_for_tool> endif

        G53 G1 Y#<unposy> F3000
        G53 G0 Z#<unposz_start>
        G53 G1 Z#<unposz> F1000
        (print, arrived at position, opening clamp)
        M62 P7 Q1
        G04 P1
        G9
        ;check if clamp is open
        o<chk_for_tool> if [#<_hw_limit_num|#<tc_clamp_open_pin>> EQ 0]
          M62 P7 Q0
          (msg, Clamp did not open during unload, aborting!!!)
          M2
        o<chk_for_tool> endif
        G53 G1 Z#<unposz_end> F1000 
        G9
        M62 P7 Q0
        G04 P1
        G53 G0 Z#<_tc_safeheight>
        G9
      ;check if we have no longer a tool clamped, if yes error out
        o<chk_for_tool> if [#<_hw_limit_num|#<tc_tool_in_spindle_pin>> EQ 1]
          (print, Tool still in spindle -> Aborting!)
          (msg, Tool still in spindle -> Aborting!)
          M2
        o<chk_for_tool> endif
        (print, Tool successfully unloaded)

      O<un_manual> endif
    O<ubload>else
      (print, Tool 0 was current tool, nothing todo)
    O<ubload> endif
    ;loading new tool
    O<ld> if [#<_selected_tool> GT 0]
      (print,  Load tool #<_selected_tool,0>)
      O<ex> if [#<_tool_exists|#<_selected_tool>> EQ 0]
        (msg,Selected tool #<_selected_tool,0> does not exist in tool table)
        M2
      O<ex> endif
      O<skp> if [#<_tool_skipchange_num|#<_selected_tool>> EQ 0]
        ;check if selected tool is in magazine, if not manual change
        O<ld_manual> if [#<_tool_tc_x_num|#<_selected_tool>> EQ 0 AND #<_tool_tc_y_num|#<_selected_tool>> EQ 0 ]
          G53 G00 Z#<_tc_safeheight>
          G53 G00 X#<_tc_pos_x> Y#<_tc_pos_y>
        (msg, insert new tool #<_selected_tool,0>)
        O<ld_manual> else
          (print,  Load tool #<_selected_tool,0> from magazine)
          #<ldposx> = #<_tool_tc_x_num|#<_selected_tool>>
          #<ldposy> = #<_tool_tc_y_num|#<_selected_tool>>
          #<ldposz> = #<_tool_tc_z_num|#<_selected_tool>>
          #<ldposx_start> = [	#<ldposx>]
          #<ldposy_end> = [#<ldposy> + #<ldposy_end_offset>]
          #<ldposz_start> = [#<ldposz> + #<ldposz_start_offset>]
          #<unposz_end> = [#<unposz>+30]

          G53 G0 Z#<_tc_safeheight>
          G53 G0 X#<ldposx> Y#<ldposy>
          G9
          G53 G0 Z#<ldposz_start> 
          ;arrived at clamp open position, open clamp and lower to tool Z
          M62 P7 Q1
          G04 P1
          ;check if clamp is open
          G9
          o<chk_for_tool> if [#<_hw_limit_num|#<tc_clamp_open_pin>> EQ 0]
            M62 P7 Q0
            (msg, Clamp did not open for loading, aborting!!!)
            M2
          o<chk_for_tool> endif    
          G53 G1 Z#<ldposz> F1000
          ;close clamp
          G9
          M62 P7 Q0
          G04 P1
          G9
          ;check if clamp is closed
          o<chk_for_tool> if [#<_hw_limit_num|#<tc_clamp_open_pin>> EQ 1]
            M62 P7 Q0
            (msg, Clamp did not close correctly, aborting!!!)
            M2
          o<chk_for_tool> endif  
          ;check if we grabbed the tool correctly
          G9 
          o<chk_for_tool> if [#<_hw_limit_num|#<tc_tool_in_spindle_pin>> EQ 0]
            M62 P7 Q0
            (msg, Tool not correctl loaded, aborting!!!)
            M2
          o<chk_for_tool> endif 
          G53 G0 Z#<_tc_safeheight>
          G53 G0 Y #<ldposy_end>

          (print, tool successfully loaded)
          

        O<ld_manual> endif 
      O<skp> endif
     O<ld>else
      (print, Tool 0 is selected as new tool, nothing todo)
    O<ld> endif
      M6
    O<atcen> endif

    O<tm> if [[#<_tc_toolmeasure> GT 0] AND [#<_tool_skipmeasure_num|#<_current_tool>> EQ 0]]
      G09
      (print,  Measure tool)
      #<sox> = [DEF[#<_tool_so_x_num|#<_current_tool>>,0]]
      #<soy> = [DEF[#<_tool_so_y_num|#<_current_tool>>,0]]
      #<soz> = [DEF[#<_tool_so_z_num|#<_current_tool>>,0]]

      G53 G00 Z#<_tooloff_safeheight>
      G53 G00 X[#<_tooloff_sensorx> - #<sox>] 
      G53 G00 Y[#<_tooloff_sensory> - #<soy>]
      G53 G00 Z#<_tooloff_rapidheight>

      M11P0
      G53 G38.2 Z-100000 F#<_tooloff_speed>
      G91 G53 G01 Z[+#<_tooloff_swdist>]
      o<low> if [#<_tooloff_speed_low> GT 0]
        G90 G53 G38.2 Z-100000 F#<_tooloff_speed_low>
        G91 G53 G01 Z[+#<_tooloff_swdist>] F#<_tooloff_speed>
      o<low> endif
      M11P1 G90

      G53 G00 Z#<_tooloff_safeheight>
      o<chk> if[ACTIVE[] AND NOTEXISTS[#<_probe_z>]]
        (msg,Measuring failed)
        M2
      o<chk> endif

      #<off> = [#<_probe_z> - #<_tooloff_sensorz> - #<soz>]

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
    O<tois> if [#<_tc_tooloff_en> EQ 2]
      G43
    O<tois> elseif [#<_tc_tooloff_en> EQ 1]
      G43.1
    O<tois> endif
  O<toen> endif																		  
  o<ar> if [#<_tc_autoreturn>]
    G00 X#<wstartx> Y#<wstarty>
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

;M63 P1 R88
;G04 P0.1
;M63 P1 R85