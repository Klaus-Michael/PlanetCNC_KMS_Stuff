(name,Find Center of Rectangle)

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgname,Measure Center + Z)
(dlg,Probe should be placed roughly in the center of the Workpiece, typ=label, x=20, w=455, color=0xffa500)
(dlg,Dimensions, typ=label, x=20, w=455, color=0xffa500)
(dlg,X-Size, x=0, dec=2, def=#<_probeing_center_stock_size_x>, min=0.1, max=10000, param=x_size)
(dlg,Y-Size, x=0, dec=2, def=#<_probeing_center_stock_size_y>, min=0.1, max=10000, param=y_size)
(dlg,XY Overtravel, x=0, dec=2, def=10, min=0.1, max=10000, param=overtravel)
(dlg,Z_Drop, x=0, dec=2, def='setunit(0, 0.5);', min=0.0, max=10000, setunits, def=#<_kms_z_drop>, store, param=_kms_z_drop)
(dlg,Set X/Y Origin, typ=checkbox, x=50, w=110, def=#<_probeing_center_set_origin>,  param=set_origin)
(dlg,Set Z-Hight, typ=checkbox, x=50, w=110, def=#<_probeing_center_set_z_hight>,  param=set_z_hight)
(dlgshow)

#<_probeing_center_stock_size_x> = #<x_size>
#<_probeing_center_stock_size_y> = #<y_size>
#<_probeing_overtravel> = #<overtravel>
#<_probeing_center_set_origin> = #<set_origin>
#<_probeing_center_set_z_hight> = #<set_z_hight>

M73;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
;M50P0;disable speed override
M55P0;disable trans
M56P0;disable warp
M57P0;disable swap
M10P1;motor enable
M11P1;limits/probe enable

;store start position
#<startz> = #<_machine_z>
#<startx> = #<_machine_x>
#<starty> = #<_machine_y>

(print, startx: #<startz> starty: #<startx> startz: #<starty>)

G65 P109 Q1 ;check if Probe is enabled
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Measure Tab)
  M2
o<chk> endif

#<_return> = NAN[]

; start with X Axis
  #<axis> = 0
  G65 P131 H#<axis> E1 D[#<x_size>/2+#<overtravel>] Z#<_kms_z_drop>;Probe Z Hight and move to right side
  #<measureZ> = #<_measure_z>
  (print, measureZ: #<measureZ>)
  #<travelZ> = [#<measureZ> + #<_probe_trav>] 
  (print, travelZ: #<travelZ>)
  G65 P110 H#<axis> E-1 R0 ;probe right side
  o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
    (msg,Measure error: Measure Tab)
    M2
  o<chk> endif

  #<measure_x_1> = #<_measure_axis|#<axis>>
  (print, measure_x_1: #<measure_x_1>)

  G53 G00 Z#<travelZ>
  G53 G00 H#<axis> E#<startx>
  G65 P131 H#<axis> E-1 D[#<x_size>/2+#<overtravel>] K#<measureZ>  Z#<_kms_z_drop>; move to left side 
  G65 P110 H#<axis> E1 R0 ;probe left side
  o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
    (msg,Measure error: Measure Tab)
    M2
  o<chk> endif

  #<measure_x_2> = #<_measure_axis|#<axis>>
  (print, measure_x_2: #<measure_x_2>)

  G53 G00 Z#<travelZ>
  #<_measure_axis|#<axis>> = [[#<measure_x_1> + #<measure_x_2>] / 2]
  #<_measure_size_axis|#<axis>> = [ABS[#<measure_x_1> - #<measure_x_2>]]
  #<measureX> = #<_measure_axis|#<axis>> 
  G53 G00 H#<axis> E#<_measure_axis|#<axis>>

; Continue with Y Axis
  #<axis> = 1
  G65 P131 H#<axis> E1 D[#<y_size>/2+#<overtravel>]  K#<measureZ> Z#<_kms_z_drop>; move to top side 
  (print, travelZ: #<travelZ>) 
  G65 P110 H#<axis> E-1 R0 ;probe top side
  o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
    (msg,Measure error: Measure Tab)
    M2
  o<chk> endif

  #<measure_y_1> = #<_measure_axis|#<axis>>
  (print, measure_y_1: #<measure_y_1>)

  G53 G00 Z#<travelZ>
  G53 G00 H#<axis> E#<starty>
  G65 P131 H#<axis> E-1 D[#<y_size>/2+#<overtravel>] K#<measureZ> Z#<_kms_z_drop>; move to lower side 
  G65 P110 H#<axis> E1 R0 ;probe lower side
  o<chk> if[NOTEXISTS[#<_return>] OR [#<_measure> EQ 0]]
    (msg,Measure error: Measure Tab)
    M2
  o<chk> endif

  #<measure_y_2> = #<_measure_axis|#<axis>>
  (print, measure_y_2: #<measure_y_2>)

  G53 G00 Z#<travelZ>
  #<_measure_axis|#<axis>> = [[#<measure_y_1> + #<measure_y_2>] / 2]
  #<_measure_size_axis|#<axis>> = [ABS[#<measure_y_1> - #<measure_y_2>]]
  #<measureY> = #<_measure_axis|#<axis>> 
  G53 G00 H#<axis> E#<_measure_axis|#<axis>>





;(print,|!Measure Center)
G65 P103

;(print,|!  Tab width:)
;(print,  $<axis|#<axis>>#<_measure_size_axis|#<axis>>)

(print,set_origin set to #<set_origin>)
o<setorigin> if[#<set_origin> EQ 1]
  #<posx> = #<_measure_x>
  #<posy> = #<_measure_y>
  #<poswx> = TOWORK[#<posx>,0]
  #<poswy> = TOWORK[#<posy>,1]
  #<deltax> = [#<posx> + #<_operator_x>]
  #<deltay> = [#<posy> + #<_operator_y>]
  #<_operator_x> = -#<posx>
  #<_operator_y> = -#<posy>
  #<offx> = #<posx>
  #<offy> = #<posy>
  o<chk> if[#<_tooloff> NE 0]
    #<offx> = [#<offx> - #<_tooloff_x>]
    #<offy> = [#<offy> - #<_tooloff_y>]
  o<chk> endif
  #<offwx> = [#<offx> - #<_coordsys_x>]
  #<offwy> = [#<offy> - #<_coordsys_y>]
  #<offcx> = [#<offx> - #<_workoff_x>]
  #<offcy> = [#<offy> - #<_workoff_y>]
  (print,|!  Setting Coordinate System)
  G10 L2 P#<_coordsys> X#<offcx> Y#<offcy>
o<setorigin> endif

(print,set_z_hight set to #<set_z_hight>)
o<setzhight> if[#<set_z_hight> EQ 1]
  #<off> = #<measureZ>
  o<chk> if[#<_tooloff> NE 0]
    #<off> = [#<off> - #<_tooloff_z>]
  o<chk> endif
  #<off> = [#<off> - #<_workoff_z>]
  #<off> = [#<off> - #<_warp_offset>]
  #<cs> = DEF[#<qvalue>,#<_coordsys>]
  G10 L2 P#<cs> Z#<off>
  (print,|!  Setting Coordinate System Z Hight)
o<setzhight> endif

#<_return> = 0
M2
