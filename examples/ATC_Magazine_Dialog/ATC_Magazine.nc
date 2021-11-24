(name,ATC Magazine)

;	10 slots ATC Magazine GUI, designed to set the xyz coordinates for up to 10 tools in the Tool Table to a configured value. 
;	all Tools that are not configured for ATC in this dialog will be set to X=0 Y=0 Z=0 for Tool Change
;	ensure that you add the parameters from parameters_ACT_add.txt to your Parameters.txt 
;	by KMS 
;	https://github.com/Klaus-Michael/PlanetCNC_KMS_Stuff
;	https://www.youtube.com/c/KlausMichaelKMS
;	History:
;	2021-11-24 - Initial Version
;
;
;	The following section needs to be manually adjusted to your machine, set each XYZ triplet for each slot according to you machine


#<ATC_Pocket_X_0> = 10
#<ATC_Pocket_Y_0> = 10
#<ATC_Pocket_Z_0> = -10

#<ATC_Pocket_X_1> = 20
#<ATC_Pocket_Y_1> = 10
#<ATC_Pocket_Z_1> = -10

#<ATC_Pocket_X_2> = 30
#<ATC_Pocket_Y_2> = 10
#<ATC_Pocket_Z_2> = -10

#<ATC_Pocket_X_3> = 40
#<ATC_Pocket_Y_3> = 10
#<ATC_Pocket_Z_3> = -10

#<ATC_Pocket_X_4> = 50
#<ATC_Pocket_Y_4> = 10
#<ATC_Pocket_Z_4> = -10

#<ATC_Pocket_X_5> = 60
#<ATC_Pocket_Y_5> = 10
#<ATC_Pocket_Z_5> = -10

#<ATC_Pocket_X_6> = 70
#<ATC_Pocket_Y_6> = 10
#<ATC_Pocket_Z_6> = -10

#<ATC_Pocket_X_7> = 80
#<ATC_Pocket_Y_7> = 10
#<ATC_Pocket_Z_7> = -10

#<ATC_Pocket_X_8> = 90
#<ATC_Pocket_Y_8> = 10
#<ATC_Pocket_Z_8> = -10

#<ATC_Pocket_X_9> = 100
#<ATC_Pocket_Y_9> = 10
#<ATC_Pocket_Z_9> = -10

(dlgname,ATC Magazine)
(dlg,This Dialog will change the ATC XYZ Values of your tooltable, typ=label, x=20, w=455, color=0xffa500)
(dlg,Make sure the Pockets of you Magazine are configured correctly in the Script!, typ=label, x=20, w=455, color=0xffa500)
(dlg,Enter 0 if no Tool is in the pocket or the pocket does not exist, typ=label, x=20, w=455, color=0xffa500)

(dlg,Tool Number Pocket 0, x=100, dec=0, def=#<_ATC_Tool_Pocket_0>, min=0, max=999, param=_ATC_Tool_Pocket_0)
(dlg,Tool Number Pocket 1, x=100, dec=0, def=#<_ATC_Tool_Pocket_1>, min=0, max=999, param=_ATC_Tool_Pocket_1)
(dlg,Tool Number Pocket 2, x=100, dec=0, def=#<_ATC_Tool_Pocket_2>, min=0, max=999, param=_ATC_Tool_Pocket_2)
(dlg,Tool Number Pocket 3, x=100, dec=0, def=#<_ATC_Tool_Pocket_3>, min=0, max=999, param=_ATC_Tool_Pocket_3)
(dlg,Tool Number Pocket 4, x=100, dec=0, def=#<_ATC_Tool_Pocket_4>, min=0, max=999, param=_ATC_Tool_Pocket_4)
(dlg,Tool Number Pocket 5, x=100, dec=0, def=#<_ATC_Tool_Pocket_5>, min=0, max=999, param=_ATC_Tool_Pocket_5)
(dlg,Tool Number Pocket 6, x=100, dec=0, def=#<_ATC_Tool_Pocket_6>, min=0, max=999, param=_ATC_Tool_Pocket_6)
(dlg,Tool Number Pocket 7, x=100, dec=0, def=#<_ATC_Tool_Pocket_7>, min=0, max=999, param=_ATC_Tool_Pocket_7)
(dlg,Tool Number Pocket 8, x=100, dec=0, def=#<_ATC_Tool_Pocket_8>, min=0, max=999, param=_ATC_Tool_Pocket_8)
(dlg,Tool Number Pocket 9, x=100, dec=0, def=#<_ATC_Tool_Pocket_9>, min=0, max=999, param=_ATC_Tool_Pocket_9)

(dlgshow)

;first we set the ATC XYZ coordinates of ALL tools to 0, in a second step we will set the correct xyz values for the tools that are configured in the gui
#<loop_tool_number> = 0
o<cleanuploop> while [#<loop_tool_number> lt 1000]
	;first check if tool exists
	o<toolexists> if[#<_tool_exists|#<loop_tool_number>> GT 0]
		#<_tool_tc_x_num|#<loop_tool_number>> = 0
		#<_tool_tc_y_num|#<loop_tool_number>> = 0
		#<_tool_tc_z_num|#<loop_tool_number>> = 0
	o<toolexists> endif
	#<loop_tool_number>  = [#<loop_tool_number> +1]
o<cleanuploop> endwhile


;now we can set the coordinates for each slot for the correct tool

o<chk_pocket>if[#<_ATC_Tool_Pocket_0> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_0>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_0> for Pocket 0 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_0>> = #<ATC_Pocket_X_0>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_0>> = #<ATC_Pocket_Y_0>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_0>> = #<ATC_Pocket_Z_0>
	o<toolexists> endif
o<chk_pocket>endif

o<chk_pocket>if[#<_ATC_Tool_Pocket_1> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_1>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_1> for Pocket 1 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_1>> = #<ATC_Pocket_X_1>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_1>> = #<ATC_Pocket_Y_1>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_1>> = #<ATC_Pocket_Z_1>
	o<toolexists> endif
o<chk_pocket>endif

o<chk_pocket>if[#<_ATC_Tool_Pocket_2> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_2>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_2> for Pocket 2 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_2>> = #<ATC_Pocket_X_2>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_2>> = #<ATC_Pocket_Y_2>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_2>> = #<ATC_Pocket_Z_2>
	o<toolexists> endif
o<chk_pocket>endif

o<chk_pocket>if[#<_ATC_Tool_Pocket_3> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_3>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_3> for Pocket 3 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_3>> = #<ATC_Pocket_X_3>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_3>> = #<ATC_Pocket_Y_3>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_3>> = #<ATC_Pocket_Z_3>
	o<toolexists> endif
o<chk_pocket>endif

o<chk_pocket>if[#<_ATC_Tool_Pocket_4> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_4>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_4> for Pocket 4 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_4>> = #<ATC_Pocket_X_4>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_4>> = #<ATC_Pocket_Y_4>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_4>> = #<ATC_Pocket_Z_4>
	o<toolexists> endif
o<chk_pocket>endif

o<chk_pocket>if[#<_ATC_Tool_Pocket_5> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_5>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_5> for Pocket 5 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_5>> = #<ATC_Pocket_X_5>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_5>> = #<ATC_Pocket_Y_5>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_5>> = #<ATC_Pocket_Z_5>
	o<toolexists> endif
o<chk_pocket>endif

o<chk_pocket>if[#<_ATC_Tool_Pocket_6> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_6>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_6> for Pocket 6 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_6>> = #<ATC_Pocket_X_6>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_6>> = #<ATC_Pocket_Y_6>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_6>> = #<ATC_Pocket_Z_6>
	o<toolexists> endif
o<chk_pocket>endif

o<chk_pocket>if[#<_ATC_Tool_Pocket_7> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_7>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_7> for Pocket 7 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_7>> = #<ATC_Pocket_X_7>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_7>> = #<ATC_Pocket_Y_7>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_7>> = #<ATC_Pocket_Z_7>
	o<toolexists> endif
o<chk_pocket>endif

o<chk_pocket>if[#<_ATC_Tool_Pocket_8> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_8>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_0> for Pocket 8 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_8>> = #<ATC_Pocket_X_8>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_8>> = #<ATC_Pocket_Y_8>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_8>> = #<ATC_Pocket_Z_8>
	o<toolexists> endif
o<chk_pocket>endif

o<chk_pocket>if[#<_ATC_Tool_Pocket_9> GT 0]
	o<toolexists> if[#<_tool_exists|#<_ATC_Tool_Pocket_9>> EQ 0]
		(msg,Tool #<_ATC_Tool_Pocket_9> for Pocket 9 does not exist in Tooltable!)
	o<toolexists> else
		#<_tool_tc_x_num|#<_ATC_Tool_Pocket_9>> = #<ATC_Pocket_X_9>
		#<_tool_tc_y_num|#<_ATC_Tool_Pocket_9>> = #<ATC_Pocket_Y_9>
		#<_tool_tc_z_num|#<_ATC_Tool_Pocket_9>> = #<ATC_Pocket_Z_9>
	o<toolexists> endif
o<chk_pocket>endif