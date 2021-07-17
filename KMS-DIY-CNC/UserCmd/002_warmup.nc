(dlgname,Warmup)
(dlg,This will slowly warm up your machine, typ=label, x=20, w=455, color=0xffa500)
(dlg,Number of Steps, x=100, dec=0, def=#<_warmup_number_steps>, min=1, max=100, param=_warmup_number_steps)
(dlg,Number of Iterations per Step, x=100, dec=0, def=#<_warmup_number_iterations>, min=1, max=100, param=_warmup_number_iterations)
(dlg,Min Feedrate, x=100, dec=0, def=#<_warmup_min_feedrate>, min=500, max=#<_speed_traverse>, param=_warmup_min_feedrate)
(dlg,Max Feedrate, x=100, dec=0, def=#<_warmup_max_feedrate>, min=500, max=#<_speed_traverse>, param=_warmup_max_feedrate)
(dlg,Min Z Position below safeheight, x=100, dec=0, def=#<_warmup_min_z>, param=_warmup_min_z)
(dlg,Min Spindle RPM, x=100, dec=0, def=#<_warmup_min_rpm>, min=#<_spindle_speed_min>, max=#<_spindle_speed_max>, param=_warmup_min_rpm)
(dlg,Max Spindle RPM, x=100, dec=0, def=#<_warmup_max_rpm>, min=#<_spindle_speed_min>, max=#<_spindle_speed_max>, param=_warmup_max_rpm)
(dlgshow)

#<XMIN> = [#<_motorlimit_xn> + 10]
#<XMAX> = [#<_motorlimit_xp> - 10]
#<YMIN> = [#<_motorlimit_yn> + 10]
#<YMAX> = [#<_motorlimit_yp> - 10]
#<ZMIN> = [#<_tc_safeheight> + #<_warmup_min_z>]


#<feed_increase> = [[#<_warmup_max_feedrate> - #<_warmup_min_feedrate>]/ [#<_warmup_number_steps>-1]]
#<rpm_increase> = [[#<_warmup_max_rpm> - #<_warmup_min_rpm>]/ [#<_warmup_number_steps>-1]]
(print, moving from X#<XMIN> Y#<YMIN> to X#<XMAX> Y#<YMAX> )
(print, moving from Z#<_tc_safeheight> to Z#<ZMIN> )
(print, start feedrate #<_warmup_min_feedrate> increase per step #<feed_increase> )
(print, start RPM #<_warmup_min_rpm> increase per step #<rpm_increase> )

G53 G1 Z#<_tc_safeheight> F#<_warmup_min_feedrate>
#<loop_steps_count> = 0
#<feedrate> = #<_warmup_min_feedrate>
#<rpm> = #<_warmup_min_rpm>
S#<_warmup_min_rpm> M3
o<loop_steps> while[#<loop_steps_count> lt #<_warmup_number_steps>]
  (print, feedrate: #<feedrate>, RPM: #<rpm>)
  S#<rpm>
  #<loop_iterations_count>= 0
  o<loop_iterations> while[#<loop_iterations_count> lt #<_warmup_number_iterations>]
    (print, iteration:#<loop_iterations_count> in step:#<loop_steps_count>)
    G53 G1 x#<XMIN> y#<YMIN> F#<feedrate>
    G53 G1 x#<XMAX> y#<YMAX> F#<feedrate>
    #<loop_iterations_count> = [#<loop_iterations_count>+1]
  o<loop_iterations> endwhile

  #<feedrate> = [#<feedrate> + #<feed_increase>]
  #<rpm> = [#<rpm> + #<rpm_increase>]
  #<loop_steps_count> = [#<loop_steps_count>+1]
o<loop_steps> endwhile
M5
G53 G1 X#<_tooloff_sensorX> Y#<_tooloff_sensorY>

#<loop_steps_count> = 0
#<feedrate> = #<_warmup_min_feedrate>
o<loop_steps> while[#<loop_steps_count> lt #<_warmup_number_steps>]
  #<loop_iterations_count>= 0
    (print, feedrate: #<feedrate>)
  o<loop_iterations> while[#<loop_iterations_count> lt #<_warmup_number_iterations>]
    (print, iteration:#<loop_iterations_count> in step:#<loop_steps_count>)
    G53 G1 Z#<ZMIN>  F#<feedrate> 
    G53 G1 Z#<_tc_safeheight> F#<feedrate> 
    #<loop_iterations_count> = [#<loop_iterations_count>+1]
  o<loop_iterations> endwhile
  #<feedrate> = [#<feedrate> + #<feed_increase>]
  #<loop_steps_count> = [#<loop_steps_count>+1]
o<loop_steps> endwhile

