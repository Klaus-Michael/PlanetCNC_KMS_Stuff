O<ProbeCheck> if [ #<_current_tool> EQ 255]
    (msg,Probe selected, Spindle not started!!!!!)
    M2
O<ProbeCheck> else
	(print,Start spindle CW)
	M3
	O<PlanetCNC> if [#<_spindle_delay_start> GT 0]
		G04 P#<_spindle_delay_start>
	O<PlanetCNC> endif
	#<_tool_life_toolnumber> = #<_current_tool> 
	#<_tool_life_starttime> = DateTime[]
	(print, Tool Number: #<_tool_life_toolnumber> Starttime: #<_tool_life_starttime> )
O<ProbeCheck> endif
