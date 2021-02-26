(print,Stop spindle)
M5

O<ToolCheck> if [ #<_current_tool> EQ #<_tool_life_toolnumber> and #<_tool_life_starttime> gt 0]
	#<_tool_life_endtime> = DateTime[]
	#<_tool_life_runtime> = [[#<_tool_life_endtime> - #<_tool_life_starttime>] / 60]
	O<ToolCheckRecord> if [Exists[#<_tool_par1_num|#<_current_tool>>]]
		#<tool_life_old_runtime> = #<_tool_par1_num|#<_current_tool>>
	O<ToolCheckRecord> else
		#<tool_life_old_runtime> = 0
		(print, Tool runtime set to 0 for Tool #<_current_tool> )
	O<ToolCheckRecord>  endif
	#<tool_life_new_runtime> = [#<tool_life_old_runtime> + #<_tool_life_runtime>]
	#<_tool_par1_num|#<_selected_tool>>= #<tool_life_new_runtime> 
	(print, Tool Number: #<_current_tool>, Starttime: #<_tool_life_starttime>, Endtime: #<_tool_life_endtime>, Runtime: #<_tool_life_runtime>, old runtime  #<tool_life_old_runtime>. New Total Tool Runtime: #<tool_life_new_runtime>  )
	#<_tool_life_starttime> = 0
O<ToolCheck> endif

O<PlanetCNC> if [#<_spindle_delay_stop> GT 0]
	G04 P#<_spindle_delay_stop>
O<PlanetCNC> endif

