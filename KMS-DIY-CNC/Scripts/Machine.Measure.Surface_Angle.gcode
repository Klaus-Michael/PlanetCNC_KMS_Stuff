(name,Measure Surface Angle)

O<PlanetCNC> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Sensor is not configured)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
O<PlanetCNC> endif

(dlgname,Measure Surface Angle,w=250)
(dlg,data::MeasureSurfaceAngle, typ=image, x=55)
(dlg,Distance, typ=label, x=20, w=230, color=0xffa500)
(dlg,, x=50, dec=2, def=25, min=0.1, max=10000, param=dist)
(dlgshow)

#<startx> = #<_machine_x>
#<starty> = #<_machine_y>

#<axis> = 2
#<dir> = -1
G91 G00 Y-#<dist>
G90
#<pos> = #<_machine_axis|#<axis>>
O<probe> call [#<axis>] [#<dir>]
#<measure1> = #<_return>
G53 G00 H#<axis> E#<pos>

#<dx> = [#<dist> * COS[30]]
#<dy> = [#<dist> * SIN[30]]
G91 G00 X[#<dx>] Y[#<dist> + #<dy>]
G90
#<pos> = #<_machine_axis|#<axis>>
O<probe> call [#<axis>] [#<dir>]
#<measure2> = #<_return>
G53 G00 H#<axis> E#<pos>

G91 G00 X[-2*#<dx>]
G90
#<pos> = #<_machine_axis|#<axis>>
O<probe> call [#<axis>] [#<dir>]
#<measure3> = #<_return>
G53 G00 H#<axis> E#<pos>

G53 G00 X#<startx> Y#<starty>
#<_measure> = [[#<measure1> + #<measure2> + #<measure3>] / 3]
(print,|!Measure Surface Angle)
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

O<Probe_check> endif	


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