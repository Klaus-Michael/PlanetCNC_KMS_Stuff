O<ProbeCheck> if [[#<_tool_isprobe_num|#<_current_tool>>] EQ 1]
  (msg,Current tool is a probe. Spindle NOT Started)
  M2
O<ProbeCheck> else

	O<checkfortool> while [#<_input_num|7> EQ 0]
		(msg,No Tool in Spindle, cannot start)
	O<checkfortool> endwhile

		(print,Start spindle CW)
		M3
		O<PlanetCNC> if [#<_spindle_delay_start> GT 0]
			G04 P#<_spindle_delay_start>
		O<PlanetCNC> endif
		O<checkforspindlerun> if [#<_input_num|5> EQ 0]
			(print,No run signal from VFD)
			(msg,No run signal from VFD)
		O<checkforspindlerun> endif
		#<_tool_life_toolnumber> = #<_current_tool> 
		#<_tool_life_starttime> = DateTime[]
		(print, Tool Number: #<_tool_life_toolnumber> Starttime: #<_tool_life_starttime> )

 
		


O<ProbeCheck> endif
