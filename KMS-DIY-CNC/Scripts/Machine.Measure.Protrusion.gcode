(name,Measure Protrusion)
o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgname,Measure Protrusion)
(dlg,Select start postition, typ=label, x=20, color=0xffa500)
(dlg,data::MeasureProtrusion, typ=image, x=60)
(dlg,Protrusion size, typ=label, x=20, color=0xffa500)
(dlg,Size X, x=0, dec=2, def='setunit(30, 1);', min=0.1, max=10000, setunits, store, param=sizex)
(dlg,Size Y, x=0, dec=2, def='setunit(30, 1);', min=0.1, max=10000, setunits, store, param=sizey)
(dlg,Z_Drop, x=0, dec=2, def='setunit(0, 0.5);', min=0.0, max=10000, setunits, def=#<_kms_z_drop>, store, param=_kms_z_drop)
(dlg,Set X/Y to 0, typ=checkbox, x=50, w=110, def=#<_probeing_center_set_origin>,  param=_probeing_center_set_origin)
(dlg,Set Z-Hight to 0, typ=checkbox, x=50, w=110, def=#<_probeing_center_set_z_hight>,  param=_probeing_center_set_z_hight)
(dlgshow)

M73
G17 G90 G91.1 G90.2 G08 G15 G94
M50P0
M55P0
M56P0
M57P0
M10P1
M11P1

G65 P155 I#<sizex> J#<sizey> Z#<_kms_z_drop>

o<xy_origin>if[#<_probeing_center_set_origin> EQ 1]
  ;$<cmd_setworkoffset> (uncomment this line to set work offset automatically)
  $<cmd_setcsoffset> (uncomment this line to set coordinate system automatically)
o<xy_origin>endif

o<setzhight> if[#<_probeing_center_set_z_hight> EQ 1]
  #<off> = #<_measure_Z>
  o<chk> if[#<_tooloff> NE 0]
    #<off> = [#<off> - #<_tooloff_z>]
  o<chk> endif
  #<off> = [#<off> - #<_workoff_z>]
  #<off> = [#<off> - #<_warp_offset>]
  #<cs> = DEF[#<qvalue>,#<_coordsys>]
  G10 L2 P#<cs> Z#<off>
  (print,|!  Setting Coordinate System Z Hight to #<_measure_Z>)
o<setzhight> endif

M2
