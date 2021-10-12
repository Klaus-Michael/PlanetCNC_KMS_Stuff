
#<current_x_value> = [#<_x> * 2]
#<_SET_TOOL_X_OFFSET_Dia> = #<current_x_value>
(print, current optimal value: #<current_x_value>)
(dlgname,Set Tool X Offset)
(dlg,This Sets the X Offset for the Current Tool, typ=label, x=10, w=600, color=0xffa500)
(dlg,Perform a OD or ID Calibration Cut first and do not move X Position after cut, typ=label, x=10, w=455, color=0xffa500)
(dlg,Calibration Cut Measured Diameter, x=100, dec=3, def=20, min=0,  param=_SET_TOOL_X_OFFSET_Dia)
(dlgshow)

G07
G18
G90
G21

G10 L10 P#<_current_tool> X[#<_SET_TOOL_X_OFFSET_Dia>/2]
