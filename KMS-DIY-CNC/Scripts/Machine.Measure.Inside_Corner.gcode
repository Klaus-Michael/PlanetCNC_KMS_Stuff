(name,Measure Inside Corner)

#<_slow_maxacc> = 750
#<_slow_maxdec> = 750

#<_orig_maxacc>=#<_motion_maxacc> ;save original acceleration settings
#<_orig_maxdec>=#<_motion_maxdec> ;save original decelaration settings
#<_motion_maxacc>=#<_slow_maxacc> 
#<_motion_maxdec>=#<_slow_maxdec>


O<PlanetCNC> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Sensor is not configured)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
O<PlanetCNC> endif

(dlgname,Measure Inside Corner)
(dlg,Select corner, typ=label, x=20, w=455, color=0xffa500)
(dlg,data::MeasureCornerInside, typ=image, x=0)
(dlg,|X+Y+|X+Y-|X-Y-|X-Y+, typ=checkbox, x=50, w=425, def=1, param=corner)
(dlgshow)

M73 ;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
; M50P0 ;disable speed override
M55P0 ;disable trans
M56P0 ;disable warp
M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable

o<cor> if [#<corner> EQ 1]
  #<axis> = 0
  #<dir> = +1
o<cor> elseif [#<corner> EQ 2]
  #<axis> = 0
  #<dir> = +1
o<cor> elseif [#<corner> EQ 3]
  #<axis> = 0
  #<dir> = -1
o<cor> elseif [#<corner> EQ 4]
  #<axis> = 0
  #<dir> = -1
o<cor> else
  (msg,Error)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
o<cor> endif

#<pos> = #<_machine_axis|#<axis>>
O<probe> call [#<axis>] [#<dir>]

#<_measureX> = #<_return>
G53 G00 H#<axis> E#<pos>

o<cor> if [#<corner> EQ 1]
  #<axis> = 1
  #<dir> = +1
o<cor> elseif [#<corner> EQ 2]
  #<axis> = 1
  #<dir> = -1
o<cor> elseif [#<corner> EQ 3]
  #<axis> = 1
  #<dir> = -1
o<cor> elseif [#<corner> EQ 4]
  #<axis> = 1
  #<dir> = +1
o<cor> else
  (msg,Error)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
o<cor> endif

#<pos> = #<_machine_axis|#<axis>>
O<probe> call [#<axis>] [#<dir>]
  
#<_measureY> = #<_return>
G53 G00 H#<axis> E#<pos>

G53 G00 Z#<_probe_safeheigh>
G53 G00 X#<_measureX> Y#<_measureY>
(print,Measure result: X=#<_measureX> Y=#<_measureY>)


#<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
#<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
M2

O<probe> sub
  M73
  #<axis> = #1
  #<dir> = #2

  M11P0 G38.2 H#<axis> E[#<dir> * 100000] F#<_probe_speed>
  G91 G01 H#<axis> E[-#<dir> * #<_probe_swdist>]
  o<low> if [#<_probe_speed_low> GT 0]
    G90 G38.2 H#<axis> E[#<dir> * 100000] F#<_probe_speed_low>
    G91 G01 H#<axis> E[-#<dir> * #<_probe_swdist>] F#<_probe_speed>
  o<low> endif
  M11P1 G90

  #<_measure> = [#<_probe_axis|#<axis>> + #<dir> * #<_probe_size_axis|#<axis>>]
O<probe> endsub [#<_measure>] 

