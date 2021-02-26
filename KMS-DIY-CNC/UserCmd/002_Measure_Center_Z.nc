(name,Center + Z)

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

(dlgname,Measure Center + Z)
(dlg,Probe should be placed roughly in the center of the Workpiece, typ=label, x=20, w=455, color=0xffa500)
(dlg,Dimensions, typ=label, x=20, w=455, color=0xffa500)
(dlg,X-Size, x=0, dec=2, def=50, min=0.1, max=10000, param=x_size)
(dlg,Y-Size, x=0, dec=2, def=50, min=0.1, max=10000, param=y_size)
(dlg,Z-Drop, x=0, dec=2, def=2*#<_probe_sizeXY>, min=0.1, max=10000, param=z_drop)
(dlg,XY Overtravel, x=0, dec=2, def=10, min=0.1, max=10000, param=overtravel)
(dlgshow)

M73 ;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
; M50P0 ;disable speed override
M55P0 ;disable trans
M56P0 ;disable warp
M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable


;first measure Z Hight at current position
#<startz> = #<_machine_z>
#<startx> = #<_machine_x>
#<starty> = #<_machine_y>
(print,start: Z=#<_machine_z> X=#<_machine_x> Y=#<_machine_y>)
  M11P0 G38.2 Z-100000 F#<_workoff_speed>
  G91 G01 Z[+#<_workoff_swdist>]
  o<low> if [#<_workoff_speed_low> GT 0]
    G90 G38.2 Z-100000 F#<_workoff_speed_low>
    G91 G01 Z[+#<_workoff_swdist>] F#<_workoff_speed>
  o<low> endif
  M11P1 G90


o<chk> if[NOTEXISTS[#<_probe_z>]]
  (msg,Measuring failed)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
o<chk> endif

o<chk> if[#<_probe> EQ 0]
  (msg,Measuring failed)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
o<chk> endif

#<off> = #<_probe_z>
o<chk> if[#<_tooloff> NE 0]
#<off> = [#<off> - #<_tooloff_z>]
o<chk> endif
#<off> = [#<off> - #<_coordsys_z>]
#<off> = [#<off> - #<_warp_offset>]
G92.1 Z[#<off> - #<_workoff_size>]

#<z_zero> = [#<off> - #<_workoff_size>]
(print, Z-Zero: #<z_zero>)
;Z Measurment done, Continue with X Measurement
; go to X Start Position
G53 G00 Z#<_probe_safeheigh>
#<x_travel> = [#<x_size> / 2 ]
G53 G00 X[#<startx> - #<x_travel> - #<overtravel>]
G00 Z[0 + #<_slow_z_hight_offset>] ; go to slow hight start above Z0
G01 Z-#<z_drop> F#<_slow_z_hight_speed>  ;go to Z0 - z_drop at slow speed
#<axis> = 0
#<dir> = +1
O<probe> call [#<axis>] [#<dir>] ;get first X Value
#<measure_x_1> = #<_return>
; got to right side of X
G53 G00 Z#<_probe_safeheigh>
G53 G00 X[#<startx> + #<x_travel> + #<overtravel>]
G00 Z[0 + #<_slow_z_hight_offset>] ; go to slow hight start above Z0
G01 Z-#<z_drop> F#<_slow_z_hight_speed>  ;go to Z0 - z_drop at slow speed
#<axis> = 0
#<dir> = -1
O<probe> call [#<axis>] [#<dir>] ;get second X Value
#<measure_x_2> = #<_return>
#<X_measure> = [[#<measure_x_1> + #<measure_x_2>] / 2]
#<X_width> = [ABS[#<measure_x_1> - #<measure_x_2>]]
(print,Measure X result: X=#<X_measure>, X Width=#<X_width>)

; go back to ogirinal X Value and start with Y
G53 G00 Z#<_probe_safeheigh>
G53 G00 X#<startx>

G53 G00 Z#<_probe_safeheigh>
#<y_travel> = [#<y_size> / 2 ]
G53 G00 Y[#<starty> - #<y_travel> - #<overtravel>]
G00 Z[0 + #<_slow_z_hight_offset>] ; go to slow hight start above Z0
G01 Z-#<z_drop> F#<_slow_z_hight_speed>  ;go to Z0 - z_drop at slow speed
#<axis> = 1
#<dir> = +1
O<probe> call [#<axis>] [#<dir>] ;get first X Value
#<measure_y_1> = #<_return>
; got to upper side of Y
G53 G00 Z#<_probe_safeheigh>
G53 G00 Y[#<starty> + #<y_travel> + #<overtravel>]
G00 Z[0 + #<_slow_z_hight_offset>] ; go to slow hight start above Z0
G01 Z-#<z_drop> F#<_slow_z_hight_speed>  ;go to Z0 - z_drop at slow speed
#<axis> = 1
#<dir> = -1
O<probe> call [#<axis>] [#<dir>] ;get second X Value
#<measure_y_2> = #<_return>
#<Y_measure> = [[#<measure_y_1> + #<measure_y_2>] / 2]
#<Y_width> = [ABS[#<measure_y_1> - #<measure_y_2>]]
(print,Measure Y result: Y=#<Y_measure>, Y Width=#<Y_width>)

; go to new center
G53 G00 Z#<_probe_safeheigh>
G53 G00 X#<X_measure> Y#<Y_measure>
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