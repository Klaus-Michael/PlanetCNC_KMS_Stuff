
(print,Start spindle CCW)
(msg,Set Spindle to #<_spindlespeed_rpm> RPM CCW)
M4
O<PlanetCNC> if [#<_spindle_delay_start> GT 0]
	G04 P#<_spindle_delay_start>
O<PlanetCNC> endif	  
#<_tool_life_toolnumber> = #<_current_tool> 
#<_tool_life_starttime> = DateTime[]
(print, Tool Number: #<_tool_life_toolnumber>, Starttime: #<_tool_life_starttime> )

