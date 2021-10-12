(dlgname,OD Calibration Cut)
(dlg,This performs a OD calibration cut for the X Axis, typ=label, x=20, w=455, color=0xffa500)
(dlg,RPM, x=100, dec=0, def=#<_OD_CAL_CUT_X_RPM>, min=1, max=#<_spindle_speed_max>, param=_OD_CAL_CUT_X_RPM)
(dlg,Feedrate, x=100, dec=0, def=#<_OD_CAL_CUT_X_FEED>, min=1, max=2000, param=_OD_CAL_CUT_X_FEED)
(dlg,Z Travel Distance, x=100, dec=0, def=#<_OD_CAL_CUT_X_Z_TRAVEL>, min=1, max=#<_speed_traverse>, param=_OD_CAL_CUT_X_Z_TRAVEL)
(dlg,Retrac, x=100, dec=0, def=#<_OD_CAL_CUT_X_RETRAC>, min=1, max=#<_speed_traverse>, param=_OD_CAL_CUT_X_RETRAC)
(dlg,Z Park Travel, x=100, dec=0, def=#<_OD_CAL_CUT_X_Z_PARK_TRAVEL>, param=_OD_CAL_CUT_X_Z_PARK_TRAVEL)
(dlgshow)

#<StartX> = #<_x>
#<StartZ> = #<_z>
G07
G18
G90
G21

M3 S#<_OD_CAL_CUT_X_RPM>
G91 G1 Z[-#<_OD_CAL_CUT_X_Z_TRAVEL>] F#<_OD_CAL_CUT_X_FEED>
G91 G1 X#<_OD_CAL_CUT_X_RETRAC> F#<_OD_CAL_CUT_X_FEED>
G91 G0 Z[#<_OD_CAL_CUT_X_Z_TRAVEL>+#<_OD_CAL_CUT_X_Z_PARK_TRAVEL>]
G91 G0 X[-#<_OD_CAL_CUT_X_RETRAC>]
G90
M5
M2
