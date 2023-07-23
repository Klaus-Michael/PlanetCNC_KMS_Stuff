o110 ;Probe

#<_return> = NAN[]
#<_measure> = 0
#<_measure_x> = NAN[]
#<_measure_y> = NAN[]
#<_measure_z> = NAN[]
#<_measure_sizex> = NAN[]
#<_measure_sizey> = NAN[]
#<_measure_sizez> = NAN[]
#<_measure_rot> = NAN[]

o<chk> if[LNOT[ACTIVE[]]]
  M99
o<chk> endif

G65 P109 Q[DEF[#<qvalue>, 1]]
o<chk> if[NOTEXISTS[#<_return>]]
  (msg,Probe error: Probe)
  M2
o<chk> endif

#<axis> = #<hvalue>
#<dir> = #<evalue>
o<chk> if[NOTEXISTS[#<axis>]]
  (msg,Axis value missing)
  M2
o<chk> endif
o<chk> if[[#<axis> LT 0] OR [#<axis> GT 2]]
  (msg,Axis value incorrect)
  M2
o<chk> endif
o<chk> if[NOTEXISTS[#<dir>]]
  (msg,Direction value missing)
  M2
o<chk> endif
o<chk> if[[#<dir> EQ -1] XNOR [#<dir> EQ 1]]
  (msg,Direction value incorrect)
  M2
o<chk> endif

#<dist> = DEFNZ[#<dvalue>,10000]
o<chk> if[NOTEXISTS[#<dvalue>] AND [#<axis> EQ 2] AND [#<dir> EQ -1]]
  #<dist> = DEFNZ[#<_probe_length>, #<dist>]
o<chk> endif
#<back> = DEF[#<kvalue>,#<_probe_swdist>]
o<chk> if[EXISTS[#<jvalue>]]
  #<size> = #<jvalue>
  #<off> = 0
o<chk> else
  #<size> = #<_probe_size_axis|#<axis>>
  #<off> = #<_probe_off_axis|#<axis>>
o<chk> endif
#<speed> = DEF[#<fvalue>,#<_probe_speed>]
#<speedlow> = DEF[#<ivalue>,#<_probe_speed_low>]

M73
G08 G15 G94
M50P0
M55P0
M56P0
M57P0
M10P1

#<start> = #<_machine_axis|#<axis>>
M11P0 G91 G91.2
G53 G38.2 H#<axis> E[#<dir> * #<dist>] F#<speed>
G53 G01 H#<axis> E[-#<dir> * #<back>]
o<low> if[#<speedlow> GT 0]
  G38.2 H#<axis> E[#<dir> * #<dist>] F#<speedlow>
  G53 G01 H#<axis> E[-#<dir> * #<back>] F#<speed>
o<low> endif
M11P1 G90 G90.2
o<ret> if [EXISTS[#<rvalue>] AND [#<rvalue> GT 0]]
  G53 G00 H#<axis> E#<start>
o<ret> endif

#<_measure> = 1
#<i> = 0
o<loop> while [#<i> LE 2]
  o<chk> if[#<i> EQ #<axis>]
    #<_measure_axis|#<axis>> = [#<_probe_axis|#<axis>> + #<dir>*#<size> + #<off>]
  o<chk> else
    #<_measure_axis|#<i>> = #<_probe_axis|#<i>>
  o<chk> endif
  #<i> = [#<i>+1]
o<loop> endwhile

#<_return> = #<_measure_axis|#<axis>>
M99
