(name,Measure Outside Corner)

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgname,Measure Outside Corner)
(dlg,Select corner, typ=label, x=20, w=455, color=0xffa500)
(dlg,data::MeasureCornerOutside, typ=image, x=0)
(dlg,|X+Y+|X+Y-|X-Y-|X-Y+, typ=checkbox, x=50, w=110, def=1, store, param=corner)
(dlg,Distance from X edge, typ=label, x=20, w=455, color=0xffa500)
(dlg,Edge, x=0, dec=2, def='setunit(10, 0.5);', min=0.1, max=10000, setunits, store, param=edge)
(dlgshow)

M73
G17 G90 G91.1 G90.2 G08 G15 G94
M50P0
M55P0
M56P0
M57P0
M10P1
M11P1

o<st> if [#<corner> EQ 1]
  #<axis> = 0
  #<dir> = +1
o<st> elseif [#<corner> EQ 2]
  #<axis> = 1
  #<dir> = -1
o<st> elseif [#<corner> EQ 3]
  #<axis> = 0
  #<dir> = -1
o<st> elseif [#<corner> EQ 4]
  #<axis> = 1
  #<dir> = +1
o<st> else
  (msg,Error)
  M2
o<st> endif

G65 P145 H#<axis> E#<dir> D#<edge>
M2
