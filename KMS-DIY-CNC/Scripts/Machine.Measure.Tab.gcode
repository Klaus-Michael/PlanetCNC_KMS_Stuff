(name,Measure Tab)
#<_slow_z_hight_offset>=5
#<_slow_z_hight_speed> = 100
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

(dlgname,Measure Tab)
(dlg,Select start postition, typ=label, x=20, w=455, color=0xffa500)
(dlg,data::MeasureTab, typ=image, x=0)
(dlg,|X+|X-|Y+|Y-, typ=checkbox, x=50, w=425, def=1, param=strt)
(dlg,Tab size, typ=label, x=20, w=455, color=0xffa500)
(dlg,Size, x=0, dec=2, def=30, min=0.1, max=10000, param=size)
(dlgshow)

M73 ;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
; M50P0 ;disable speed override
M55P0 ;disable trans
M56P0 ;disable warp
M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable

#<startz> = #<_machine_z>
#<slow_z> = [#<_machine_z> + #<_slow_z_hight_offset>]
o<st> if [#<slow_z> GE #<_probe_safeheigh>]
  (print,Warning: Slow Z hight #<slow_z> above Probe Safehight #<_probe_safeheigh> using Probe Safehight as Slow Z Hight! )
  #<slow_z>  = #<_probe_safeheigh>  
o<st> endif

o<st> if [#<strt> EQ 1]
  #<axis> = 0
  #<dir> = +1
o<st> elseif [#<strt> EQ 2]
  #<axis> = 0
  #<dir> = -1
o<st> elseif [#<strt> EQ 3]
  #<axis> = 1
  #<dir> = +1
o<st> elseif [#<strt> EQ 4]
  #<axis> = 1
  #<dir> = -1
o<st> else
  (msg,Error)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
o<st> endif

#<pos> = #<_machine_axis|#<axis>>
O<probe> call [#<axis>] [#<dir>]
#<measure1> = #<_return>
G53 G00 H#<axis> E#<pos>

#<dist> = [ABS[#<_return> - #<pos>]]

G53 G00 Z#<_probe_safeheigh>
G91 G53 G00 H#<axis> E[#<dir> * [2*#<dist> + #<size>]]
G90
G53 G00 Z#<slow_z>
G53 G01 Z#<startz>  F#<_slow_z_hight_speed>
#<pos> = #<_machine_axis|#<axis>>
O<probe> call [#<axis>] [-#<dir>]
#<measure2> = #<_return>
G53 G00 H#<axis> E#<pos>

G53 G00 Z#<_probe_safeheigh>

#<_measure> = [[#<measure1> + #<measure2>] / 2]
#<width> = [ABS[#<measure1> - #<measure2>]]
G53 G00 H#<axis> E#<_measure>

o<st> if [#<strt> EQ 1]
  (print,Measure result: X=#<_measure>, Width=#<width>)
o<st> elseif [#<strt> EQ 2]
  (print,Measure result: X=#<_measure>, Width=#<width>)
o<st> elseif [#<strt> EQ 3]
  (print,Measure result: Y=#<_measure>, Width=#<width>)
o<st> elseif [#<strt> EQ 4]
  (print,Measure result: Y=#<_measure>, Width=#<width>)
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