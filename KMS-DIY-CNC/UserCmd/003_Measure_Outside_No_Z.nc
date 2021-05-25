(name,Measure Outside without any Z Moves)

#<_slow_z_hight_offset>=5
#<_slow_z_hight_speed> = 100
#<_Probe_error_pin>=1
#<_slow_maxacc> = 750
#<_slow_maxdec> = 750

#<_orig_maxacc>=#<_motion_maxacc> ;save original acceleration settings
#<_orig_maxdec>=#<_motion_maxdec> ;save original decelaration settings
#<_motion_maxacc>=#<_slow_maxacc> 
#<_motion_maxdec>=#<_slow_maxdec>
#<_original_probe_estop> = #<_probe_estop>
#<_probe_estop> = 1


O<PlanetCNC> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Sensor is not configured)
  #<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
  #<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
  M2
O<PlanetCNC> endif

(dlgname,Measure Outside without any Z Moves)
(dlg,Always starts with Probe moving Y+, continues CLockwhise around Workpiece, typ=label, x=20, w=455, color=0xffa500)
(dlg,X-Size, x=0, dec=2, def=#<_probeing_center_stock_size_x>, min=0.1, max=10000, param=x_size)
(dlg,Y-Size, x=0, dec=2, def=#<_probeing_center_stock_size_y>, min=0.1, max=10000, param=y_size)
(dlg,XY Overtravel, x=0, dec=2, def=10, min=0.1, max=10000, param=overtravel)
(dlg,Backoff Distance, x=0, dec=2, def=5, min=0.1, max=10000, param=backoff_distance)
(dlg,Feed Speed, x=0, dec=2, def=1000, min=0.1, max=10000, param=f_speed)
(dlgshow)

#<_probeing_center_stock_size_x> = #<x_size>
#<_probeing_center_stock_size_y> = #<y_size>

M73 ;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
;  M50P0 ;disable speed override
M55P0 ;disable trans
M56P0 ;disable warp
M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable

(print,Start Outside Measurement without Z Move)
#<startx> = #<_machine_x>
#<starty> = #<_machine_y>
;perform first measurement
#<axis> = 1
#<dir> = +1
O<probe> call [#<axis>] [#<dir>]
#<measure_y1> = #<_return>
#<x_measurepoint> = #<_machine_x> 
G91 G00 Y[- #<backoff_distance>] ;backoff from workpiece
;move clockwise to the next measurement point
(print, measure_y1: #<measure_y1>)
G91 G01 X[- #<x_size> / 2 - #<overtravel>] F#<f_speed>
G91 G01 Y[ #<y_size> / 2 + #<backoff_distance>] F#<f_speed> ;should now be in the middel of Y on left side
#<axis> = 0
#<dir> = +1
O<probe> call [#<axis>] [#<dir>] ; first measurement for x
#<measure_x1> = #<_return>
G91 G00 X[- #<backoff_distance>] ;backoff from workpiece  
#<y_measurepoint> = #<_machine_y>
(print, measure_x1: #<measure_x1>)

G90 G53 G01 Y[#<measure_y1> + #<y_size> + #<overtravel>] 
;G91 G01 Y[ #<y_size> / 2 + #<backoff_distance>] F#<f_speed> 
G90 G53 G01 X#<x_measurepoint> F#<f_speed> 
#<axis> = 1
#<dir> = -1
O<probe> call [#<axis>] [#<dir>]
#<measure_y2> = #<_return>
G91 G00 Y[+ #<backoff_distance>] ;backoff from workpiece
(print, measure_y2: #<measure_y2>)

G90 G53 G01 X[#<measure_x1> + #<x_size> + #<overtravel>] 
;G91 G01 X[ #<x_size> / 2 + #<overtravel>] F#<f_speed>
G90 G53 G01 Y#<y_measurepoint> F#<f_speed> ;should now be in the middel of Y on right side
#<axis> = 0
#<dir> = -1
O<probe> call [#<axis>] [#<dir>]
#<measure_x2> = #<_return>

G91 G00 X[+ #<backoff_distance>] ;backoff from workpiece  
(print, measure_x2: #<measure_x2>)
;go back to start position
G90 G53 G01 Y#<starty> F#<f_speed>
G90 G53 G01 X#<startx> F#<f_speed>

#<X_width> = [ABS[#<measure_x1> - #<measure_x2>]]
#<Y_width> = [ABS[#<measure_y1> - #<measure_y2>]]
#<X_measure> = [[#<measure_x1> + #<measure_x2>] / 2]
#<Y_measure> = [[#<measure_y1> + #<measure_y2>] / 2]
(print,Measure X result: X=#<X_measure>, X Width=#<X_width>)
(print,Measure Y result: Y=#<Y_measure>, Y Width=#<Y_width>)

G09
  (print,Set new G92 to: X=#<X_measure>, Y=#<Y_measure>)
G92 X[#<_machine_x>-#<X_measure>] Y[ #<_machine_y> - #<Y_measure>]


#<_motion_maxacc>=#<_orig_maxacc> ;restore original acceleration settings
#<_motion_maxdec>=#<_orig_maxdec> ;restore original deceleration settings
#<_probe_estop>=#<_original_probe_estop> 
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