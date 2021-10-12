(dlgname,OD Turn)
(dlg,This performs a OD Turn Operation, typ=label, x=20, w=455, color=0xffa500)
(dlg,Stock Diameter, x=100, dec=2, def=#<_OD_TURN_STOCK_DIAMETER>, min=0, param=_OD_TURN_STOCK_DIAMETER)
(dlg,Target Diameter, x=100, dec=2, def=#<_OD_TURN_TARGET_DIAMETER>, min=0, param=_OD_TURN_TARGET_DIAMETER)
(dlg,Target Z Length, x=100, dec=2, def=#<_OD_TURN_Z_LENGTH>, min=0, param=_OD_TURN_Z_LENGTH)
(dlg,RPM, x=100, dec=0, def=#<_OD_TURN_RPM>, min=100, max=#<_spindle_speed_max>, param=_OD_TURN_RPM)
(dlg,roughing Feedrate, x=100, dec=0, def=#<_OD_TURN_ROUGH_FEED>, min=1, max=2000, param=_OD_TURN_ROUGH_FEED)
(dlg,roughing Stepdown, x=100, dec=2, def=#<_OD_TURN_ROUGH_STEPDOWN>, min=0, max=2000, param=_OD_TURN_ROUGH_STEPDOWN)
(dlg,finish Feedrate, x=100, dec=0, def=#<_OD_TURN_FINISH_FEED>, min=1, max=2000, param=_OD_TURN_FINISH_FEED)
(dlg,finish Stepdown, x=100, dec=2, def=#<_OD_TURN_FINISH_STEPDOWN>, min=0, max=2000, param=_OD_TURN_FINISH_STEPDOWN)
(dlg,finish Steps, x=100, dec=0, def=#<_OD_TURN_FINISH_STEPS>, min=1, max=2000, param=_OD_TURN_FINISH_STEPS)
(dlg,Retrac, x=100, dec=1, def=#<_OD_TURN_RETRAC>, min=1, max=#<_speed_traverse>, param=_OD_TURN_RETRAC)
(dlg,Extra Z start, x=100, dec=1, def=#<_OD_TURN_Z_START>, min=1, max=#<_speed_traverse>, param=_OD_TURN_Z_START)
(dlg,|None|MMS|Flood, typ=checkbox, x=50, w=110, def=#<_OD_TURN_cooling>, param=_OD_TURN_cooling)
(dlgshow)

G07
G18
G90
G21
G94

M3 S#<_OD_TURN_RPM>
O<cooling>if [#<_OD_TURN_cooling> EQ 2]
 (print, MMS)
 M7
o<cooling> elseif [#<_OD_TURN_cooling> EQ 3]
 (print, Flood)
 M8
o<cooling> endif


#<finish_total_distance> = [#<_OD_TURN_FINISH_STEPDOWN> * #<_OD_TURN_FINISH_STEPS>]
(print,Distance for finishing Cuts: #<finish_total_distance> )
#<roughing_Total_distance> = [#<_OD_TURN_STOCK_DIAMETER>- #<_OD_TURN_TARGET_DIAMETER> - #<finish_total_distance> ]
(print,Distance for roughing Cuts: #<roughing_Total_distance> )
#<roughing_Total_steps> = floor[#<roughing_Total_distance> / #<_OD_TURN_ROUGH_STEPDOWN>]
#<roughing_Total_steps_text>=[#<roughing_Total_steps>+1]
(print,required roughing steps: #<roughing_Total_steps_text>)

#<start_roughing> = [#<_OD_TURN_TARGET_DIAMETER> + #<finish_total_distance> + #<roughing_Total_steps> * #<_OD_TURN_ROUGH_STEPDOWN> ]
(print,roughing start step: #<start_roughing> )

G0 Z#<_OD_TURN_Z_START> X[#<start_roughing> +#<_OD_TURN_RETRAC>]

#<current_roughing_step> = #<roughing_Total_steps>
O<roughing> while [#<current_roughing_step> GE 0]
    #<current_roughing_x> = [#<_OD_TURN_TARGET_DIAMETER> + #<finish_total_distance> + #<current_roughing_step> * #<_OD_TURN_ROUGH_STEPDOWN> ]
    (print,Roughing step #<current_roughing_step> at diameter #<current_roughing_x>)
    G1 X#<current_roughing_x>
    G1 Z[-#<_OD_TURN_Z_LENGTH>] F#<_OD_TURN_ROUGH_FEED>
    G91 G1 Z#<_OD_TURN_RETRAC> X#<_OD_TURN_RETRAC>
    G90 G0 Z#<_OD_TURN_Z_START>
    #<current_roughing_step> = [#<current_roughing_step> - 1]
O<roughing> endwhile

#<current_finish_step> = #<_OD_TURN_FINISH_STEPS>
O<finishing> while [#<current_finish_step> GE 1]
    #<current_finish_step> = [#<current_finish_step> - 1]
    #<current_finish_x> = [#<_OD_TURN_TARGET_DIAMETER> + #<current_finish_step> * #<_OD_TURN_FINISH_STEPDOWN> ]
    (print,Finish step #<current_finish_step> at diameter #<current_finish_x>)
    G1 X#<current_finish_x>
    G1 Z[-#<_OD_TURN_Z_LENGTH>] F#<_OD_TURN_FINISH_FEED>
    G91 G1 Z#<_OD_TURN_RETRAC> X#<_OD_TURN_RETRAC>
    G90 G0 Z#<_OD_TURN_Z_START>
O<finishing> endwhile

M9
M5
M2