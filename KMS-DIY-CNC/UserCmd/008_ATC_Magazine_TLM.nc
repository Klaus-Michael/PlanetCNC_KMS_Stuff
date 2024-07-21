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


#<ATC_Pocket_X_0> = 0
#<ATC_Pocket_Y_0> = 7
#<ATC_Pocket_Z_0> = -78.5
#<ATC_Pocket_Type_0> = 2

#<ATC_Pocket_X_1> = 75
#<ATC_Pocket_Y_1> = 8
#<ATC_Pocket_Z_1> = -78.5
#<ATC_Pocket_Type_1> = 2

#<ATC_Pocket_X_2> = 150
#<ATC_Pocket_Y_2> = 7.9
#<ATC_Pocket_Z_2> = -78.5
#<ATC_Pocket_Type_2> = 2

#<ATC_Pocket_X_3> = 225
#<ATC_Pocket_Y_3> = 8
#<ATC_Pocket_Z_3> = -78.5
#<ATC_Pocket_Type_3> = 2

#<ATC_Pocket_X_4> = 300
#<ATC_Pocket_Y_4> = 5
#<ATC_Pocket_Z_4> = -78.5
#<ATC_Pocket_Type_4> = 2

#<ATC_Pocket_X_5> = 375
#<ATC_Pocket_Y_5> = 5.5
#<ATC_Pocket_Z_5> = -79
#<ATC_Pocket_Type_5> = 2

#<ATC_Pocket_X_6> = 450
#<ATC_Pocket_Y_6> = 6
#<ATC_Pocket_Z_6> = -78.5
#<ATC_Pocket_Type_6> = 2

#<ATC_Pocket_X_7> = 0
#<ATC_Pocket_Y_7> = 0
#<ATC_Pocket_Z_7> = 0
#<ATC_Pocket_Type_7> = 1

#<ATC_Pocket_X_8> = 0
#<ATC_Pocket_Y_8> = 0
#<ATC_Pocket_Z_8> = 0
#<ATC_Pocket_Type_8> = 1

#<ATC_Pocket_X_9> = 0
#<ATC_Pocket_Y_9> = 0
#<ATC_Pocket_Z_9> = 0
#<ATC_Pocket_Type_9> = 1

(dlgname,ATC Skip Tool Length Measurement)
(dlg,This Dialog will change the Skip Tool Measurement values for the listet tools, typ=label, x=20, w=455, color=0xffa500)
(dlg, Skip TLM for tool #<_ATC_Tool_Pocket_0>, x=100, typ=checkbox,def=#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_0>>,param=ATC_Tool_Pocket_0_TLM)
(dlg, Skip TLM for tool #<_ATC_Tool_Pocket_1>, typ=checkbox,def=#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_1>>,param=ATC_Tool_Pocket_1_TLM)
(dlg, Skip TLM for tool #<_ATC_Tool_Pocket_2>, typ=checkbox,def=#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_2>>,param=ATC_Tool_Pocket_2_TLM)
(dlg, Skip TLM for tool #<_ATC_Tool_Pocket_3>, typ=checkbox,def=#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_3>>,param=ATC_Tool_Pocket_3_TLM)
(dlg, Skip TLM for tool #<_ATC_Tool_Pocket_4>, typ=checkbox,def=#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_4>>,param=ATC_Tool_Pocket_4_TLM)
(dlg, Skip TLM for tool #<_ATC_Tool_Pocket_5>, typ=checkbox,def=#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_5>>,param=ATC_Tool_Pocket_5_TLM)
(dlg, Skip TLM for tool #<_ATC_Tool_Pocket_6>, typ=checkbox,def=#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_6>>,param=ATC_Tool_Pocket_6_TLM)
(dlgshow)

#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_0>> = #<ATC_Tool_Pocket_0_TLM>
#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_1>> = #<ATC_Tool_Pocket_1_TLM>
#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_2>> = #<ATC_Tool_Pocket_2_TLM>
#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_3>> = #<ATC_Tool_Pocket_3_TLM>
#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_4>> = #<ATC_Tool_Pocket_4_TLM>
#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_5>> = #<ATC_Tool_Pocket_5_TLM>
#<_tool_skipmeasure_num|#<_ATC_Tool_Pocket_6>> = #<ATC_Tool_Pocket_6_TLM>