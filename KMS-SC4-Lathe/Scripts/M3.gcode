(print,Start spindle CW)
(print, current speed: #<_hw_ctrlspindle_rpm>, target speed: #<_spindlespeed_rpm> )

M3
;M62 P7 Q1
;G04 P1
;M62 P7 Q0

O<RPM> if[ #<_hw_ctrlspindle_rpm> LT #<_spindlespeed_rpm> *0.95 OR #<_hw_ctrlspindle_rpm> GT #<_spindlespeed_rpm> *1.05 ]
  (msg,Set Spindle to #<_spindlespeed_rpm> RPM CW)
O<RPM> endif


O<PlanetCNC> if [#<_spindle_delay_start> GT 0]
  G04 P#<_spindle_delay_start>
O<PlanetCNC> endif

  #<_tool_life_toolnumber> = #<_current_tool> 
	#<_tool_life_starttime> = DateTime[]
	(print, Tool Number: #<_tool_life_toolnumber> Starttime: #<_tool_life_starttime> )

