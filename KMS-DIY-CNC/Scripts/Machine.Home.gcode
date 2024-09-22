(name,Home)
;move C axis to position where its most likely not triggering the sensor and where it has a short way to home

o<chk> if[#<_hw_limit> EQ 16]
G0C20
g9
o<chk> endif

o<chk> if[#<_hw_limit> NE 0]

  (msg,Limit switches are active)
  M2
o<chk> endif

o<chk> if[[#<_probe_pin_1> NE 0] AND [#<_input|#<_probe_pin_1>> NE 0] ]
  (msg,Probe pin 1 active)
  M2
o<chk> endif

o<chk> if[[#<_probe_pin_2> NE 0] AND [#<_input|#<_probe_pin_2>> NE 0] ]
  (msg,Probe pin 2 active)
  M2
o<chk> endif

M73
G17 G08 G15 G40 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M10P1
M11P1

#<main>=0
o<mainloop> while [#<main> LT 9]
  #<axis>=0
  o<axisloop> while [#<axis> LT 9]
    #<order> = [#<_home_order_axis|#<axis>> - 1]
    o<ord> if [#<order> EQ #<main>]

      #<dir> = 0
      #<pin> = 0
      o<dir> if [#<_home_dir_axis|#<axis>> GT +0.5]
        #<dir> = +1
        #<pin> = #<_limitpin_p_axis|#<axis>>
      o<dir> elseif [#<_home_dir_axis|#<axis>> LT -0.5]
        #<dir> = -1
        #<pin> = #<_limitpin_n_axis|#<axis>>
      o<dir> endif

      o<checkdir> if [#<dir> EQ 0]
        (msg,Direction is not configured)
        M2
      o<checkdir> endif

      o<checkpin> if [#<pin> EQ 0]
        (msg,Limit switch is not configured)
        M2
      o<checkpin> endif

      ;--------------------------------------------
      G65 P115 H#<axis> E#<dir>
      ;--------------------------------------------

    o<ord> endif
    #<axis> = [#<axis> + 1]
  o<axisloop> endwhile
  #<main> = [#<main> + 1]
o<mainloop> endwhile

M11P1
M2


o<probehome> sub
  M73
  #<axis> = #1
  #<dir> = #2
  o<spd> if[[#<axis> GE 3] AND [#<axis> LE 5]]
    #<speed>=#<_home_speedabc>
    #<speedlow>=#<_home_speedabc_low>
  o<spd> else
    #<speed>=#<_home_speed>
    #<speedlow>=#<_home_speed_low>
  o<spd> endif

  M11P0
  G53 G38.1 H#<axis> E#<dir> F#<speed>
  G10 L9 H#<axis> E[#<_home_swpos_axis|#<axis>>]
  G91 G91.2 G53 G01 H#<axis> E[-#<dir> * #<_home_swdist>]

  o<low> if [#<speedlow> GT 0]
    G90 G90.2 G53 G38.1 H#<axis> E#<dir> F#<speedlow>
    G10 L9 H#<axis> E[#<_home_swpos_axis|#<axis>>]
    G91 G91.2 G53 G01 H#<axis> E[-#<dir> * #<_home_swdist>] F#<speed>
  o<low> endif

  M11P1 G90 G90.2
  G53 G00 H#<axis> E[#<_home_moveto_axis|#<axis>>]

o<probehome> endsub

