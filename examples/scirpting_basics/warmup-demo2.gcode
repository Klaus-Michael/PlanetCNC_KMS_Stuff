(name,Warmup Demo)

G53 G1 Z#<_tc_safeheight> F1000

#<_warmup_number_steps> = 5
#<_warmup_number_iterations> = 2

#<XMIN> = [#<_motorlimit_xn> + 10]
#<XMAX> = [[#<_motorlimit_xp>-#<_motorlimit_xn>] * 0.1]
#<YMIN> = [#<_motorlimit_yn> + 10]
#<YMAX> = [[#<_motorlimit_yp>-#<_motorlimit_yn>] * 0.1]
#<rpm_increase> = 2000
#<feed_increase> = 1000

#<loop_steps_count> = 0
#<feedrate> = 1000
#<rpm> = 4000
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