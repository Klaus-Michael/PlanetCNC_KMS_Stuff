(name,Measure Edge Position)

o<chk> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Probe pin is not configured)
  M2
o<chk> endif

o<chk> if [[#<_probe_use_tooltable> GT 0] AND [#<_tool_isprobe_num|#<_current_tool>>] EQ 0]
  (msg,Current tool is not probe)
  M2
o<chk> endif


(dlgname,Measure Edge Position)
(dlg,Select start postition, typ=label, x=20, color=0xffa500)
(dlg,data::MeasureAxis, typ=image, x=0)
(dlg,|X+|X-|Y+|Y-, typ=checkbox, x=50, w=110, def=1, store, param=orient)
(dlg,Move to Position, typ=checkbox, x=50, w=110, def=#<_probeing_move_to_pos>,  param=_probeing_move_to_pos)
(dlgshow)

M73
G17 G90 G91.1 G90.2 G08 G15 G94
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

G65 P130 H#<axis> E#<dir>
(print,|!Measure Edge Position)

G65 P102 H#<axis>
o<chk> if[#<_probeing_move_to_pos> EQ 1]
  G53 G00 Z#<_tc_safeheight>
  G53 G00 H#<axis> E#<_measure_axis|#<axis>>  
o<chk> endif


M2
