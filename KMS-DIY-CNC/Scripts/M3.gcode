O<ProbeCheck> if [[#<_tool_isprobe|#<_current_tool>>] EQ 1]
  (msg,Current tool is a probe. Spindle NOT Started)
  M2
O<ProbeCheck> else
	#<spindle_try>=0
	O<checkfortool> while [[#<_input|7> EQ 0] AND [#<spindle_try> LT 5]]
		#<spindle_try> = [#<spindle_try> +1]
		(msg,No Tool in Spindle, cannot start)
	O<checkfortool> endwhile

	(print,Start spindle CW)
	M3
	o<chk> if[LNOT[ACTIVE[]]]
		M99
	o<chk> endif
	O<PlanetCNC> if [#<_spindle_delay_start> GT 0]
		G04 P#<_spindle_delay_start>
	O<PlanetCNC> endif
	O<checkforspindlerun> if [#<_input|5> EQ 0]
		(print,No run signal from VFD)
		(msg,No run signal from VFD)
	O<checkforspindlerun> endif
	#<_tool_life_toolnumber> = #<_current_tool> 
	#<_tool_life_starttime> = DateTime[]
	(print, Tool Number: #<_tool_life_toolnumber> Starttime: #<_tool_life_starttime> )
O<ProbeCheck> endif
