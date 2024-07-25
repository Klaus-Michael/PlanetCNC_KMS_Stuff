
#<minspindletime> = [DEF[#<pvalue>,0]]
(print, min spindle time: #<minspindletime>)
O<ToolCheckLength> if [[[DateTime[] - #<_tool_life_starttime>] / 60] GT #<minspindletime>]
	G65 P122 R2 F1
O<ToolCheckLength> endif