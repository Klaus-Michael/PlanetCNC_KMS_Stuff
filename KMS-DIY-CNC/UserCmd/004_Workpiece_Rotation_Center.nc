(name,Workpiece Rotation - Center + Z)

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

(dlgname,Measure Rotation + Center)
(dlg,Always starts with Probe moving X+, typ=label, x=20, w=455, color=0xffa500)
(dlg,Dimensions, typ=label, x=20, w=455, color=0xffa500)
(dlg,X-Size, x=200, dec=2, def=#<_probeing_center_stock_size_x> , min=0.1, max=10000, param=x_size)
(dlg,Y-Size, x=200, dec=2, def=#<_probeing_center_stock_size_y>, min=0.1, max=10000, param=y_size)
(dlg,Roation Measure Distance Y+ move from current position, x=200, dec=2, def=30, min=0.1, max=10000, param=rotation_dist)
(dlg,XY Overtravel, x=200, dec=2, def=10, min=0.1, max=10000, param=overtravel)
(dlgshow)

#<_probeing_center_stock_size_x> = #<x_size>
#<_probeing_center_stock_size_y> = #<y_size>

M73 ;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
; M50P0 ;disable speed override
;M55P0 ;disable trans
; M56P0 ;disable warp
; M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable
#<startz> = #<_machine_z>
#<startx> = #<_machine_x>
#<starty> = #<_machine_y>

;measure rotation 
G10 L2 P#<_coordsys> R 0 ;set rotation to 0
#<axis> = 0
#<axis2> = 1
#<dir> = +1
#<pos21> = #<_machine_axis|#<axis2>>
O<probe> call [#<axis>] [#<dir>]
#<measure1> = #<_return>
#<measure_rot_1> = #<_return>
G90 G53 G00 Z#<_probe_safeheigh>
G90 G53 G00 X#<startx>
G91 G53 G00 Y#<rotation_dist>
(print, start z: #<startz> zoffset: #<_slow_z_hight_offset>)
G90 G53 G00 Z[#<startz> + #<_slow_z_hight_offset>] ; go to slow hight start above Z0
G90 G53 G01 Z#<startz> F#<_slow_z_hight_speed>  ;go to Z0 - z_drop at slow speed
#<pos22> = #<_machine_axis|#<axis2>>
O<probe> call [#<axis>] [#<dir>]
#<measure2> = #<_return>
#<measure_rot_2> = #<_return>
G90 G53 G00 Z#<_probe_safeheigh>

#<_angle> = [ATAN2[[#<measure2>-#<measure1>],[#<pos22>-#<pos21>]]]
(print,Measure result: Angle=#<_angle>)
G10 L2 P#<_coordsys> R[360-#<_angle>] ;set rotation to measurement
; go to X Start Position
(print,Start Center Point Measurement)
G90 G53 G00 X#<startx> Y#<starty>
G90 G53 G00 Z[#<startz> + #<_slow_z_hight_offset>] ; go to slow hight start above Z0
G90 G53 G01 Z#<startz> F#<_slow_z_hight_speed>  ;go to Z0 - z_drop at slow speed

#<axis> = 0
#<dir> = +1

O<probe> call [#<axis>] [#<dir>] ;get first X Value
#<measure_x_1> = #<_return>
#<measure_xb_1> = #<_measure_B> 
(print, X1 X:#<measure_x_1> Y:#<measure_xb_1>)
; got to right side of X
G90 G53 G00 Z#<_probe_safeheigh>
G91 G00 X[ #<x_size> + #<overtravel>]
G90 G53 G00 Z[#<startz> + #<_slow_z_hight_offset>] ; go to slow hight start above Z0
G90 G53 G01 Z#<startz> F#<_slow_z_hight_speed>  ;go to Z0 - z_drop at slow speed
#<axis> = 0
#<dir> = -1
O<probe> call [#<axis>] [#<dir>] ;get second X Value
#<measure_x_2> = #<_return>
#<measure_xb_2> = #<_measure_B> 
(print, X2 X:#<measure_x_2> Y:#<measure_xb_2>)
#<X_measure> = [[#<measure_x_1> + #<measure_x_2>] / 2]
#<X_measure_b> = [[#<measure_xb_1> + #<measure_xb_2>] / 2]
#<X_width> = [ABS[#<measure_x_1> - #<measure_x_2>]]
(print,Measure X result: X=#<X_measure>, Xb=#<X_measure_b> , X Width=#<X_width>)

;go to center between the two x measure points
G90 G53 G00 Z#<_probe_safeheigh>
G90 G53 G00 X#<X_measure> Y#<X_measure_b>

#<y_travel> = [#<y_size> / 2 ]
G91 G00 Y[- #<y_travel> - #<overtravel>]
G90 G53 G00 Z[#<startz> + #<_slow_z_hight_offset>] ; go to slow hight start above Z0
G90 G53 G01 Z#<startz> F#<_slow_z_hight_speed>  ;go to Z0 - z_drop at slow speed
#<axis> = 1
#<dir> = +1
O<probe> call [#<axis>] [#<dir>] ;get first Y Value
#<measure_y_1> = #<_return>
#<measure_yb_1> = #<_measure_B> 
(print, Y1 X:#<measure_yb_1> Y:#<measure_y_1>)
; got to upper side of Y
G90 G53 G00 Z#<_probe_safeheigh>
G91 G00 Y[#<y_size> + #<overtravel>]
G90 G53 G00 Z[#<startz> + #<_slow_z_hight_offset>] ; go to slow hight start above Z0
G90 G53 G01 Z#<startz> F#<_slow_z_hight_speed>  ;go to Z0 - z_drop at slow speed
#<axis> = 1
#<dir> = -1
O<probe> call [#<axis>] [#<dir>] ;get second X Value
#<measure_y_2> = #<_return>
#<measure_yb_2> = #<_measure_B> 
(print, Y2 X:#<measure_yb_2> Y:#<measure_y_2>)
#<Y_measure> = [[#<measure_y_1> + #<measure_y_2>] / 2]
#<Y_measure_b> = [[#<measure_yb_1> + #<measure_yb_2>] / 2]

(print,Measure Y result: Y=#<Y_measure>, )

; go to new center
G53 G00 Z#<_probe_safeheigh>
G53 G00 X#<Y_measure_b>  Y#<Y_measure>


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
  #<_measure> = [#<_probe_axis|#<axis>> ]
  #<other_axis> = 0
  O<other_axis_check> if [#<axis> EQ 0]
  #<other_axis> = 1
	O<other_axis_check> endif 
	#<_measure_B> = [#<_probe_axis|#<other_axis>>]
O<probe> endsub [#<_measure>] 