(name,Measure Edge Find)
o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgnew,Measure Edge Find)
(dlg,Select start postition, typ=label, x=20, color=0xffa500)
(dlg,data::MeasureAxis, typ=image, x=0)
(dlg,|X+|X-|Y+|Y-, typ=checkbox, x=50, w=110, def=1, store, param=orient)
(dlg,Distance, x=0, dec=2, def='setunit(10, 0.5);', min=0.1, max=10000, setunits, store, param=dist)
(dlg, name='Z_Drop', typ=numinput, min=0.0, max=10000, dec=2, setunits, def=#<_kms_z_drop>, store, param=_kms_z_drop)
(dlg,Move to Position, typ=checkbox, x=50, w=110, def=#<_probeing_move_to_pos>,  param=_probeing_move_to_pos)
(dlg,Set Axis to 0, typ=checkbox, x=50, w=110, def=#<_probeing_center_set_origin>,  param=_probeing_center_set_origin)
(dlg,Set Z-Hight to 0, typ=checkbox, x=50, w=110, def=#<_probeing_center_set_z_hight>,  param=_probeing_center_set_z_hight)
(dlgshow)

M73
G17 G08 G15 G40 G90 G91.1 G90.2 G94
M50P0
M55P0
M56P0
M57P0
M10P1
M11P1

o<st> if [#<orient> EQ 1]
  #<axis> = 0
  #<dir> = +1
o<st> elseif [#<orient> EQ 2]
  #<axis> = 0
  #<dir> = -1
o<st> elseif [#<orient> EQ 3]
  #<axis> = 1
  #<dir> = +1
o<st> elseif [#<orient> EQ 4]
  #<axis> = 1
  #<dir> = -1
o<st> else
  (msg,Error)
  M2
o<st> endif

G65 P131 H#<axis> E-#<dir> D#<dist> Z#<z_drop>
#<first_measure_Z> = #<_measure_Z>
G65 P130 H#<axis> E#<dir> 
(print,|!Measure Edge Find)
G65 P102 H#<axis>

o<chk> if[#<_probeing_move_to_pos> EQ 1]
  G53 G00 Z#<_tc_safeheight>
  G53 G00 H#<axis> E#<_measure_axis|#<axis>>  
o<chk> endif

o<xy_origin>if[#<_probeing_center_set_origin> EQ 1]
  ;$<cmd_setworkoffset> (uncomment this line to set work offset automatically)
  $<cmd_setcsoffset> (uncomment this line to set coordinate system automatically)
o<xy_origin>endif

o<setzhight> if[#<_probeing_center_set_z_hight> EQ 1]
  #<off> = #<first_measure_Z>
  o<chk> if[#<_tooloff> NE 0]
    #<off> = [#<off> - #<_tooloff_z>]
  o<chk> endif
  #<off> = [#<off> - #<_workoff_z>]
  #<off> = [#<off> - #<_warp_offset>]
  #<cs> = DEF[#<qvalue>,#<_coordsys>]
  G10 L2 P#<cs> Z#<off>
  (print,|!  Setting Coordinate System Z Hight)
o<setzhight> endif
M2
