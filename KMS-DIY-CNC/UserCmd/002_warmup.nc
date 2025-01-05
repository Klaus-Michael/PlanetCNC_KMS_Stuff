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
o<checktool> if [#<_input|7> EQ 0]
  #<warmup_auto_tool> = 1
  (print, No Tool in Spindle, will get tool 999)
  (msg, No Tool in Spindle, will get tool 999)
  (print, will use tool #<warmup_tool>)
  T999 M6
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
  (msg, Auto Tool in Spindle, need to remove tool 999)
  T0 M6
o<checktool2> endif