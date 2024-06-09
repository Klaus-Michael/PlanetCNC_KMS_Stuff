O<PlanetCNC> if[[#<_tc_toolmeasure>] AND [#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Sensor is not configured)
  M2
O<PlanetCNC> endif

M73
G17 G90 G91.1 G90.2 G08 G15 G94
M50P0
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
  O<st> elseif [#<_tool_skipchange_num|#<_selected_tool>> EQ 1]
	M6
  O<st> else 
    O<sh> if [#<_tc_safeheight_en>]
    (print,  Move to safe height)
      G53 G00 X#<_tc_safeheight>
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
    ;check if new tool is longer, if yes move to z to new tools zero point to enable safe tool change

    ;(print, old tool Z offset: #<_tool_off_z_num|#<_current_tool>>  new tool: #<_tool_off_z_num|#<_selected_tool>>)
    o<z_offset> if[#<_tool_off_z_num|#<_selected_tool>> GT #<_tool_off_z_num|#<_current_tool>>]
     ;(print, move Z to safe pos for new tool)
      #<new_z>= [#<_machine_z> + #<_tool_off_z_num|#<_selected_tool>> -  #<_tool_off_z_num|#<_current_tool>>]
      ;(print, new G53 Z #<new_z>)
      G53 G0 Z#<new_z>
      G9
    o<z_offset> endif
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
    G09
	
   M6
  O<st> endif
  (print,  enable tool offset set to #<_tc_tooloff_en>)
  O<toen> if [#<_tc_tooloff_en>]
    M72
    M71
    O<tois> if [#<toisset> EQ 2]
      G43
    O<tois> elseif [#<toisset> EQ 1]
      G43.1
    O<tois> elseif [#<toisset> EQ 0]
      G43
    O<tois> endif
  O<toen> endif
  o<ar> if [#<_tc_autoreturn>]
   ; G00 X#<wstartx> Y#<wstarty>
    o<skip>if [#<_tool_skipchange_num|#<_selected_tool>> EQ 0]
      G90 G00 Z#<wstartz>
    o<skip>endif
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

