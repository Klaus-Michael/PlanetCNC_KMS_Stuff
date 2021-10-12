(dlgname,Face Calibration Cut)
(dlg,This performs a Face calibration cut for the Z Axis, typ=label, x=20, w=455, color=0xffa500)
(dlg,RPM, x=100, dec=0, def=#<_FACE_CAL_CUT_Z_RPM>, min=1, max=#<_spindle_speed_max>, param=_FACE_CAL_CUT_Z_RPM)
(dlg,Feedrate, x=100, dec=0, def=#<_FACE_CAL_CUT_Z_FEED>, min=1, max=2000, param=_FACE_CAL_CUT_Z_FEED)
(dlg,X Over Travel Distance, x=100, dec=1, def=#<_FACE_CAL_CUT_Z_X_TRAVEL>, param=_FACE_CAL_CUT_Z_X_TRAVEL)
(dlg,Retrac, x=100, dec=0, def=#<_FACE_CAL_CUT_Z_RETRAC>, min=1, max=#<_speed_traverse>, param=_FACE_CAL_CUT_Z_RETRAC)
(dlgshow)

#<StartX> = #<_x>
#<StartZ> = #<_z>
G07
G18
G90
G21

M3 S#<_FACE_CAL_CUT_Z_RPM>
G90 G1 X[0-[#<_FACE_CAL_CUT_Z_X_TRAVEL>*2]] F#<_FACE_CAL_CUT_Z_FEED>
G91 G1 Z#<_FACE_CAL_CUT_Z_RETRAC> F#<_FACE_CAL_CUT_Z_FEED>
G90 G0 X[#<StartX>*2]
G91 G0 Z[-#<_FACE_CAL_CUT_Z_RETRAC>]
G90
M5
M2
