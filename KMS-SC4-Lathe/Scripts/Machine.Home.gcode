(name,Home)

M73
G17 G90 G91.1 G90.2 G08 G15 G94
M50P0
M55P0
M56P0
M57P0
M10P1
M11P1

(test if Z axis sensor is triggered)
o<zaxis> if[#<_hw_limit_num|2> GT 0]
(print,Z Axis Sensor is triggered!! freeing z-axis first!)
  o<zfreeloop> while [ #<_hw_limit_num|2> GT 0]
    G91 G1 Z-1 F 500
    G90
  o<zfreeloop> endwhile
o<zaxis> endif

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
      o<probehome> call [#<axis>] [#<dir>]
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

  M11P0
  G53 G38.1 H#<axis> E#<dir> F#<_home_speed>
  G10 L9 H#<axis> E[#<_home_swpos_axis|#<axis>>]
  G91 G53 G01 H#<axis> E[-#<dir> * #<_home_swdist>]

  o<low> if [#<_home_speed_low> GT 0]
    G90 G53 G38.1 H#<axis> E#<dir> F#<_home_speed_low>
    G10 L9 H#<axis> E[#<_home_swpos_axis|#<axis>>]
    G91 G53 G01 H#<axis> E[-#<dir> * #<_home_swdist>] F#<_home_speed>
  o<low> endif

  M11P1 G90
  G53 G00 H#<axis> E[#<_home_moveto_axis|#<axis>>]

o<probehome> endsub

