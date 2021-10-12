(dlgname,Set Tool Z Offset)
(dlg,This Sets the ZX Offset for the Current Tool, typ=label, x=10, w=600, color=0xffa500)
(dlg,Perform a Face Calibration Cut first at Z=0 with your master Tool, typ=label, x=10, w=455, color=0xffa500)
(dlg,use a shim gauge to move the new tool to a known distance , typ=label, x=10, w=455, color=0xffa500)
(dlg,shim gauge size, x=100, dec=3, def=#<_SET_TOOL_Z_OFFSET_size>, min=0,  param=_SET_TOOL_Z_OFFSET_size)
(dlgshow)

(print, current tool: #<_current_tool> selected tool: #<_selected_tool>)
G07
G18
G90
G21

G10 L10 P#<_current_tool> Z[#<_SET_TOOL_Z_OFFSET_size>]
