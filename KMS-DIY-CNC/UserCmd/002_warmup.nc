(dlgname,Warmup)
(dlg,This will slowly warm up your machine, typ=label, x=20, w=455, color=0xffa500)
(dlg,Number of Steps, x=100, dec=0, def=#<_warmup_number_steps>, min=1, max=100, param=_warmup_number_steps)
(dlg,Min Spindle RPM, x=100, dec=0, def=#<_warmup_min_rpm>, min=#<_spindle_speed_min>, max=#<_spindle_speed_max>, param=_warmup_min_rpm)
(dlg,Max Spindle RPM, x=100, dec=0, def=#<_warmup_max_rpm>, min=#<_spindle_speed_min>, max=#<_spindle_speed_max>, param=_warmup_max_rpm)
(dlg,Runtime per step, x=100, dec=0, def=#<_warmup_step_runtime>, min=1, max=10, param=_warmup_step_runtime)
(dlg,extra Runtime on max RPM, x=100, dec=0, def=#<_warmup_max_rpm_runtime>, min=1, max=100, param=_warmup_max_rpm_runtime)
(dlgshow)


#<unposy_start_offset> = 65
#<unposz_start_offset> = 20

#<ldposy_end_offset> = 65
#<ldposz_start_offset> = 20

#<tc_clamp_open_pin> = 8
#<tc_tool_in_spindle_pin> = 7
#<warmup_auto_tool> = 0

#<warmup_tool> = #<_atc_tool_pocket_0>
o<checktool> if [#<_input_num|7> EQ 0]
  #<warmup_auto_tool> = 1
  (print, No Tool in Spindle, will get the tool from pocket 0)
  (msg, No Tool in Spindle, will get the tool from pocket 0)
  (print, will use tool #<warmup_tool>)
  O<chmagcl>if [#<_input_num|4> EQ 1]
    (msg,Magazin seems to be open, is this correct?)
  O<chmagcl>endif  
  ;Open Magazin
  M62 P3 Q1
  G04 P1.5
  G9
  O<chmagco>if [#<_input_num|4> EQ 0]
    (msg,Magazin did not open correctly)
  O<chmagco>endif  
  #<ldposx> = #<_tool_tc_x_num|#<warmup_tool>>
  #<ldposy> = #<_tool_tc_y_num|#<warmup_tool>>
  #<ldposz> = #<_tool_tc_z_num|#<warmup_tool>>
  #<ldposx_start> = [	#<ldposx>]
  #<ldposy_end> = [#<ldposy> + #<ldposy_end_offset>]
  #<ldposz_start> = [#<ldposz> + #<ldposz_start_offset>]
  #<unposz_end> = [#<unposz>+30]

  G53 G0 Z#<_tc_safeheight>
  G53 G0 X#<ldposx> Y#<ldposy>
  G9
  G53 G0 Z#<ldposz_start> 
  ;arrived at clamp open position, open clamp and lower to tool Z
  M62 P2 Q1
  G04 P1
  ;check if clamp is open
  G9
  o<chk_for_tool> if [#<_input_num|#<tc_clamp_open_pin>> EQ 0]
    M62 P2 Q0
    (msg, Clamp did not open for loading, aborting!!!)
    M2
  o<chk_for_tool> endif    
  G53 G1 Z#<ldposz> F2000
  ;close clamp
  G9
  M62 P2 Q0
  G04 P1
  G9
  ;check if clamp is closed
  o<chk_for_tool> if [#<_input_num|#<tc_clamp_open_pin>> EQ 1]
    M62 P2 Q0
    (msg, Clamp did not close correctly, aborting!!!)
    M2
  o<chk_for_tool> endif  
  ;check if we grabbed the tool correctly
  G9 
  o<chk_for_tool> if [#<_input_num|#<tc_tool_in_spindle_pin>> EQ 0]
    M62 P2 Q0
    (msg, Tool not correctl loaded, aborting!!!)
    M2
  o<chk_for_tool> endif 
  G53 G1 Y #<ldposy_end> F2000
  G53 G0 Z#<_tc_safeheight>   
  G53 G00 X[#<_motorlimit_xn>+20] Y[#<_motorlimit_yp>-20] 
o<checktool> endif

#<rpm_increase> = 0
o<ckrmincrease> if[#<_warmup_number_steps> GT 1]
  #<rpm_increase> = [[#<_warmup_max_rpm> - #<_warmup_min_rpm>]/ [#<_warmup_number_steps>-1]]
o<ckrmincrease> endif

(print, start RPM #<_warmup_min_rpm> increase per step #<rpm_increase> )

#<loop_steps_count> = 0
#<rpm> = #<_warmup_min_rpm>
S#<_warmup_min_rpm> M3
o<loop_steps> while[#<loop_steps_count> lt #<_warmup_number_steps>]
  (print, RPM: #<rpm> in loop #<loop_steps_count>)
  S#<rpm>
  G04 P[#<_warmup_step_runtime>*60]
  #<rpm> = [#<rpm> + #<rpm_increase>]
  #<loop_steps_count>  = [#<loop_steps_count> +1]
o<loop_steps> endwhile

#<loop_steps_count> = 0
o<loop_steps2> while[#<loop_steps_count> lt #<_warmup_max_rpm_runtime>]
  #<runtime_left> =[#<_warmup_max_rpm_runtime> - #<loop_steps_count> ]
  (print, running on max rpm for another #<runtime_left> minutes)
  G04 P60
  #<loop_steps_count> = [#<loop_steps_count>+1]
o<loop_steps2> endwhile
M5


o<checktool2> if [#<warmup_auto_tool> EQ 1]
  ;calcualte the start unload position
  (msg, Auto Tool in Spindle, will move the tool to pocket 0)
  ;Open Magazin
  M62 P3 Q1
  G04 P1.5
  G9
  O<chmagco>if [#<_input_num|4> EQ 0]
    (msg,Magazin did not open correctly)
  O<chmagco>endif 
  #<unposx> = #<_tool_tc_x_num|#<warmup_tool>>
  #<unposy> = #<_tool_tc_y_num|#<warmup_tool>>
  #<unposz> = #<_tool_tc_z_num|#<warmup_tool>>
  #<unposx_start> = [	#<unposx>]
  #<unposy_start> = [#<unposy> + #<unposy_start_offset>]
  #<unposz_start> = [#<unposz> + #<unposz_start_offset>]
  #<unposz_end> = [#<unposz>+30]
  ;move to Z Safe
  G53 G00 Z#<_tc_safeheight>
  ;move to XY Unload start position, start with Y then move X
  G53 G00 Y#<unposy_start>
  G53 G00 X#<unposx_start> 
  G9
  ;check if we have a tool clamped, if not error out
  o<chk_for_tool> if [#<_input_num|#<tc_tool_in_spindle_pin>> EQ 0]
    (msg, no tool in spindle)
    M2
  o<chk_for_tool> endif
  ;move into unload position
  G53 G0 Z#<unposz>
  G53 G1 Y#<unposy> F2000
  ;(print, arrived at position, opening clamp)
  M62 P2 Q1
  G04 P1
  G9
  ;check if clamp is open
  o<chk_for_tool> if [#<_input_num|#<tc_clamp_open_pin>> EQ 0]
    M62 P2 Q0
    (msg, Clamp did not open during unload, aborting!!!)
    M2
  o<chk_for_tool> endif
  ;move up to unload the tool
  G53 G1 Z#<unposz_end> F2000 
  G9
  ;close the clamp
  M62 P2 Q0
  G04 P1
  G53 G0 Z#<_tc_safeheight>
  G9
  G53 G00 X[#<_motorlimit_xn>+20] Y[#<_motorlimit_yp>-20] 
  ;Close Magazin
  M62 P3 Q0
o<checktool2> endif