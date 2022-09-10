#<target_diameter> = 20
o<ck_p_value> if[EXISTS[#<Pvalue>]]
    #<target_diameter> = #<Pvalue>
o<ck_p_value> endif
#<SET_TOOL_X_OFFSET_Dia> =  #<target_diameter>

(dlgname,Set Tool X Offset)
(dlg,This Sets the X Offset for the Current Tool, typ=label, x=10, w=600, color=0xffa500)
(dlg,Target Diameter, x=100, dec=3, def=#<target_diameter>, min=0,  param=target_diameter)
(dlg,Measured Diameter, x=100, dec=3, def=#<SET_TOOL_X_OFFSET_Dia>, min=0,  param=SET_TOOL_X_OFFSET_Dia)
(dlgshow)

;get current tool offset from tooltable
#<current_x_offset> = #<_tool_off_x_num|#<_current_tool>>
(print, current tool offset = #<current_x_offset>)

#<delta_target_real>= [#<target_diameter> - #<SET_TOOL_X_OFFSET_Dia>]
(print, Difference real vs Target = #<delta_target_real>)

o<ck_diff>if[#<delta_target_real> NE 0]
   
    #<new_x_offset>=[#<current_x_offset> + [#<delta_target_real>/2]]
     (print, new offset: #<new_x_offset>)
     G10 L1 P#<_current_tool> X[#<new_x_offset>]
o<ck_diff>endif
