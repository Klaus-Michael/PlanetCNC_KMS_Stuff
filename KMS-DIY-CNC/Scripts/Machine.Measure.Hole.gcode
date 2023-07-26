(name,Measure Hole)
o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif
(dlgname,Measure Hole)
(dlg,data::MeasureHole, typ=image, x=80)
(dlg,X/Y Retract distance, x=50,  dec=2, def='setunit(0, 0.5);', min=0.0, max=10000, setunits, def=#<_probe_swdist>, store, param=_K_return)
(dlg,Set X/Y to 0, typ=checkbox, x=50, w=110, def=#<_probeing_center_set_origin>,  param=_probeing_center_set_origin)

(dlgshow)

M73
G17 G90 G91.1 G90.2 G08 G15 G94
M50P0
M55P0
M56P0
M57P0
M10P1
M11P1

G65 P150 K#<_K_return>

o<xy_origin>if[#<_probeing_center_set_origin> EQ 1]
  ;$<cmd_setworkoffset> (uncomment this line to set work offset automatically)
  $<cmd_setcsoffset> (uncomment this line to set coordinate system automatically)
o<xy_origin>endif
M2
