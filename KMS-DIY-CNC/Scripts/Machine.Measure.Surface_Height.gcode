(name,Measure Surface Height)


O<PlanetCNC> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Sensor is not configured)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
O<PlanetCNC> endif

(dlgname,Measure Surface Height,w=340)
(dlg,data::MeasureSurfaceHeight, typ=image, x=100)
(dlgshow)

M73 ;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
; M50P0 ;disable speed override
M55P0 ;disable trans
M56P0 ;disable warp
M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable

#<axis> = 2
#<dir> = -1
#<pos> = #<_machine_axis|#<axis>>
O<probe> call [#<axis>] [#<dir>]
#<_measure> = #<_return>
G53 G00 H#<axis> E#<pos>

(print,|!Measure Surface Height)
(print,Result: Z=#<_measure>)
#<off> = #<_measure>
o<chk> if[#<_tooloff> NE 0]
  #<off> = [#<off> - #<_tooloff_axis|#<axis>>]
o<chk> endif

#<offw> = [#<off> - #<_coordsys_axis|#<axis>>]
#<offc> = [#<off> - #<_workoff_axis|#<axis>>]

(print,|!Set work position:)
(print,G92.1 Z#<offw>)
(print,|!Set coordinate system #<_coordsys,0>:)
(print,G10 L2 P#<_coordsys,0> Z#<offc>)
(print,|!------------------------------)

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
