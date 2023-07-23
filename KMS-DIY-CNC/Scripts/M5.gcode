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
	#<_tool_par1_num|#<_current_tool>>= #<tool_life_new_runtime> 
	(print, Tool Number: #<_current_tool>, Runtime: #<_tool_life_runtime>, Total Tool Runtime: #<tool_life_new_runtime>, Starttime: #<_tool_life_starttime>, Endtime: #<_tool_life_endtime>, old runtime  #<tool_life_old_runtime>.  )
	O<CheckToolTableChange> if [ #<_tool_par1_num|#<_current_tool>> NE #<tool_life_new_runtime>  ]
		(print, Tool Table update NOT successfull. Trying again! tool table value #<_tool_par1_num|#<_current_tool>> should be value #<tool_life_new_runtime>)
		#<_tool_par1_num|#<_current_tool>>= #<tool_life_new_runtime> 
		(print, Tool Table value after second try: #<_tool_par1_num|#<_current_tool>>)
	O<CheckToolTableChange> endif
	#<_tool_life_starttime> = 0
	#<_spindle_total_ontime> = [#<_spindle_total_ontime> + #<_tool_life_runtime> ]
	(print, Total Spindle ontime: #<_spindle_total_ontime>)
O<ToolCheck> else
	(print current tool number #<_current_tool> does not match expected tool number #<_tool_life_toolnumber>. Runtime was NOT recorded!!!!!!)
O<ToolCheck> endif

;turn of mms 
M09

	O<checkforspindlerun> while [#<_input_num|5> EQ 1]
	;	(print,spindle still running, waiting)
		G04 P0.1
	O<checkforspindlerun> endwhile

O<PlanetCNC> if [#<_spindle_delay_stop> GT 0]
;	G04 P#<_spindle_delay_stop>
O<PlanetCNC> endif

