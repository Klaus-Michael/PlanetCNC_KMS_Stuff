(name,Measure Angle)

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

(dlgname,Measure Angle)
(dlg,Select start postition, typ=label, x=20, w=455, color=0xffa500)
(dlg,data::MeasureAngle, typ=image, x=0)
(dlg,|X+|X-|Y+|Y-, typ=checkbox, x=50, w=425, def=1, param=strt)
(dlg,Distance to next probe, typ=label, x=20, w=455, color=0xffa500)
(dlg,Distance, x=0, dec=2, def=30, min=0.1, max=10000, param=dist)
(dlgshow)

M73 ;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
; M50P0 ;disable speed override
M55P0 ;disable trans
M56P0 ;disable warp
M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable

o<st> if [#<strt> EQ 1]
  #<axis> = 0
  #<dir> = +1
  #<axis2> = 1
  #<dir2> = +1
o<st> elseif [#<strt> EQ 2]
  #<axis> = 0
  #<dir> = -1
  #<axis2> = 1
  #<dir2> = -1
o<st> elseif [#<strt> EQ 3]
  #<axis> = 1
  #<dir> = +1
  #<axis2> = 0
  #<dir2> = +1
o<st> elseif [#<strt> EQ 4]
  #<axis> = 1
  #<dir> = -1
  #<axis2> = 0
  #<dir2> = -1
o<st> else
  (msg,Error)
  M2
o<st> endif

#<pos> = #<_machine_axis|#<axis>>
#<pos21> = #<_machine_axis|#<axis2>>
O<probe> call [#<axis>] [#<dir>]
#<measure1> = #<_return>
G53 G00 H#<axis> E#<pos>

G91 G53 G00 H#<axis2> E[#<dir2> * #<dist>]
G90

#<pos> = #<_machine_axis|#<axis>>
#<pos22> = #<_machine_axis|#<axis2>>
O<probe> call [#<axis>] [#<dir>]
#<measure2> = #<_return>
G53 G00 H#<axis> E#<pos>

G53 G00 Z#<_probe_safeheigh>

G53 G00 H#<axis2> E[[#<pos21> + #<pos22>] / 2]
#<_measure> = [[#<measure1> + #<measure2>] / 2]
G53 G00 H#<axis> E#<_measure>

#<_angle> = [ATAN2[[#<measure2>-#<measure1>],[#<pos22>-#<pos21>]]]

o<st> if [#<strt> EQ 1]
  (print,Measure result: X=#<_measure>, Angle=#<_angle>)
o<st> elseif [#<strt> EQ 2]
  (print,Measure result: X=#<_measure>, Angle=#<_angle>)
o<st> elseif [#<strt> EQ 3]
  (print,Measure result: Y=#<_measure>, Angle=#<_angle>)
o<st> elseif [#<strt> EQ 4]
  (print,Measure result: Y=#<_measure>, Angle=#<_angle>)
o<st> else
  (msg,Error)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
o<st> endif

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
