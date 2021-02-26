(name,Measure Surface)

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

(dlgname,Measure Surface,w=250)
(dlg,data::MeasureSurface, typ=image, x=0)
(dlg,Size, typ=label, x=20, w=230, color=0xffa500)
(dlg,X, x=0, dec=2, def=40, min=0.1, max=10000, param=sizeX)
(dlg,Y, x=0, dec=2, def=30, min=0.1, max=10000, param=sizeY)
(dlg,Step, typ=label, x=20, w=230, color=0xffa500)
(dlg,X, x=0, dec=2, def=5, min=0.1, max=10000, param=stepX)
(dlg,Y, x=0, dec=2, def=5, min=0.1, max=10000, param=stepY)
(dlg,Return distance, typ=label, x=20, w=230, color=0xffa500)
(dlg,, x=80, dec=2, def=3, min=0.1, max=200, param=return)
(dlgshow)

M73 ;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
;  M50P0 ;disable speed override
M55P0 ;disable trans
M56P0 ;disable warp
M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable

#<startx> = #<_machine_x>
#<starty> = #<_machine_y>

#<endx> = [#<startx> + #<sizeX>]
#<endy> = [#<starty> + #<sizeY>]
#<posx> = #<startx>
#<posy> = #<starty>
#<dir>  = 1

(pointsclear)
o<loopy> while[1]
  o<loopx> while[1]
    #<posz> = #<_machine_z>
    O<probe> call [2] [-1]
    #<measure> = #<_return>
    G91 G53 G00 Z#<return>
    G90

    (point,X#<posx> Y#<posy> Z#<measure>)

    o<chk> if[[#<dir> GT 0] AND [#<posx> GE #<endx>]]
      o<loopx> break
    o<chk> endif

    o<chk> if[[#<dir> LT 0] AND [#<posx> LE #<startx>]]
      o<loopx> break
    o<chk> endif

    #<posx> = [#<posx> + #<dir>*#<stepX>]
    G53 G00 X#<posx>

  o<loopx> endwhile

  #<posy> = [#<posy> + #<stepY>]

  o<chk> if[#<posy> GT #<endy>]
    o<loopy> break
  o<chk> endif

  G53 G00 Y#<posy>
  #<dir> = [-1*#<dir>]

o<loopy> endwhile

(print,Number of points: #<_pointcnt,0>)


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
