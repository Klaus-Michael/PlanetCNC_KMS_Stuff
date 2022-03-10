(print,OnStart script)
(print,  Line: #<line,0>)
(print,  PosState: X#<posstate_x,3>, Y#<posstate_y,3>, Z#<posstate_z,3>)

o<chk_ovrd_speedfeed> if[#<_ovrd_speedfeed> NE 1 OR #<_ovrd_speedtraverse> NE 1 OR #<_ovrd_spindle> NE 1]
  (msg, Check your feed, rapid and spindle Overwrites, one of them is not at 100%!)
o<chk_ovrd_speedfeed> endif

O<chk> if [#<line>]
  (print,  MistState: #<miststate,0>)
  (print,  FloodState: #<floodstate,0>)
  (print,  SpindleState: #<spindlestate,0>)
  (print,  MotorsState: #<motorsstate,0>)
  (print,  LimitsState: #<limitsstate,0>)


  G53 G00 Z#<_tooloff_safeheight>
  G53 G00 X#<posstate_x> Y#<posstate_y> 
  
  G09
  (dlgname,Start From Selected Line, opt=1)
  (dlg,Click OK to continue from line #<line,0>, typ=label, x=20, w=250, color=0xffa500)
  (dlgshow)
  
  G53 G00 Z#<posstate_z>
  
O<chk> endif