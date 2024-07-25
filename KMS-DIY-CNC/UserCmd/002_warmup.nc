(dlgname,Warmup)
(dlg,This will slowly warm up your machine, typ=label, x=20, w=455, color=0xffa500)
(dlg,Number of Steps, x=100, dec=0, def=#<_warmup_number_steps>, min=1, max=100, param=_warmup_number_steps)
(dlg,Min Spindle RPM, x=100, dec=0, def=#<_warmup_min_rpm>, min=#<_spindle_speed_min>, max=#<_spindle_speed_max>, param=_warmup_min_rpm)
(dlg,Max Spindle RPM, x=100, dec=0, def=#<_warmup_max_rpm>, min=#<_spindle_speed_min>, max=#<_spindle_speed_max>, param=_warmup_max_rpm)
(dlg,Runtime per step, x=100, dec=0, def=#<_warmup_step_runtime>, min=1, max=10, param=_warmup_step_runtime)
(dlg,extra Runtime on max RPM, x=100, dec=0, def=#<_warmup_max_rpm_runtime>, min=1, max=100, param=_warmup_max_rpm_runtime)
(dlgshow)


#<rpm_increase> = [[#<_warmup_max_rpm> - #<_warmup_min_rpm>]/ [#<_warmup_number_steps>-1]]
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
(print, running on max rpm for another [#<_warmup_max_rpm_runtime> - #<loop_steps_count> ] minutes)
  G04 P60
o<loop_steps2> endwhile
M5

