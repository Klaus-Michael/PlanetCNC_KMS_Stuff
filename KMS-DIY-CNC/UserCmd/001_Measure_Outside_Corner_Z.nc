(name,Measure Outside Corner + Z)

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

(dlgname,Measure Outside Corner)
(dlg,Select corner, typ=label, x=20, w=455, color=0xffa500)
(dlg,data::MeasureCornerOutside, typ=image, x=0)
(dlg,|X+Y+|X+Y-|X-Y-|X-Y+, typ=checkbox, x=50, w=425, def=1, param=corner)
(dlg,Distance from X edge, typ=label, x=20, w=455, color=0xffa500)
(dlg,Edge, x=0, dec=2, def=#<_probeing_edge>, min=0.1, max=10000, param=edge)
(dlg,Z-Drop, x=0, dec=2, def=2*#<_probe_sizeXY>, min=0.1, max=10000, param=z_drop)
(dlgshow)

#<_probeing_edge> = #<edge>


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

G53 G00 Z#<startz>


;go to starting position for Corner Measurement
(print,start Corner: Z=#<_machine_z> X=#<_machine_x> Y=#<_machine_y>) 
G53 G00 H#<axis> E[#<_machine_axis|#<axis>>-#<edge>]
;Drop Z below Z0
G1 Z[-1 * #<z_drop>] 

#<startz> = #<_machine_z>
#<slow_z> = [#<_machine_z> + #<_slow_z_hight_offset>]
o<st> if [#<slow_z> GE #<_probe_safeheigh>]
  (print,Warning: Slow Z hight #<slow_z> above Probe Safehight #<_probe_safeheigh> using Probe Safehight as Slow Z Hight! )
  #<slow_z>  = #<_probe_safeheigh>  
o<st> endif

  #<pos> = #<_machine_axis|#<axis>>
  (print,start Position: Z=#<pos>>)
O<probe> call [#<axis>] [#<dir>]
  #<_measureX> = #<_return>
  G53 G00 H#<axis> E#<pos>

  #<dist> = [ABS[#<_return> - #<pos>]]

  G53 G00 Z#<_probe_safeheigh>
  ;G91 G53 G00 H#<axis> E[+#<dir> * [#<dist> + #<edge>]]
  G53 G00 X#<startx> Y#<starty>  
  (print,start Corner 2: Z=#<_machine_z> X=#<_machine_x> Y=#<_machine_y>)
  G90
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

  G91 G53 G00 H#<axis> E[-#<dir> * [#<dist> + #<edge>]]
  G90
  G53 G00 Z#<slow_z>
  G53 G01 Z#<startz>  F#<_slow_z_hight_speed>

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
