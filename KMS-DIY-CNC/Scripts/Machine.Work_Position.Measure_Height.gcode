(name,Measure Work Height)


O<PlanetCNC> if[[#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Sensor is not configured)
  M2
O<PlanetCNC> endif

M73 ;store state, auto restore
G17 G90 G91.1 G90.2 G08 G15 G94
;M50P0 ;disable speed override
M55P0 ;disable trans
M57P0 ;disable swap
M10P1 ;motor enable
M11P1 ;limits/probe enable

#<startz> = #<_machine_z>

M11P0 G38.2 Z-100000 F#<_workoff_speed>
G91 G01 Z[+#<_workoff_swdist>]
o<low> if [#<_workoff_speed_low> GT 0]
  G90 G38.2 Z-100000 F#<_workoff_speed_low>
  G91 G01 Z[+#<_workoff_swdist>] F#<_workoff_speed>
o<low> endif
M11P1 G90

o<chk> if[NOTEXISTS[#<_probe_z>]]
  (msg,Measuring failed)
  M2
o<chk> endif

o<chk> if[#<_probe> EQ 0]
  (msg,Measuring failed)
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
M2
