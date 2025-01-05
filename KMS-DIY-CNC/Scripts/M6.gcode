;M63 P1 R05
#<unposy_start_offset> = 65
#<unposz_start_offset> = 20

#<ldposy_end_offset> = 65
#<ldposz_start_offset> = 20




#<kms_3d_probe_pin>=1
#<kms_atc_door_pin>=4
#<kms_atc_umbrealla_front_pin>=3
#<kms_atc_umbrealla_back_pin>=2
#<kms_atc_pocket_empty_pin> = 1

#<kms_tool_in_spindle_pin> = 7
#<kms_clamp_open_pin> = 8



#<kms_atc_umbrealla_pout>=3
#<kms_atc_clamp_pout>=2
#<kms_atc_door_pout>=1
#<kms_wls_clean_pout> = 5

O<PlanetCNC> if[[#<_tc_toolmeasure>] AND [#<_probe_pin_1> EQ 0] AND [#<_probe_pin_2> EQ 0]]
  (msg,Sensor is not configured)
;  M2
o<PlanetCNC> endif

(Skip Same Tool)
o<sametool> if [#<_tc_skipsame> AND [#<_current_tool> EQ #<_selected_tool>]]
  (print,Tool Change: Skip Same Tool)
  M99
o<sametool> endif

(print,Tool Change)
(Store And Set Modal State)
M73
G17 G90 G91.1 G90.2 G08 G15 G94
;M50P0
M55P0
M56P0
M57P0
M10P1
M11P1

;check if magazin is closed (work around due to normaly closed sensor)
O<chmagcl>if [#<_extin1|#<kms_atc_door_pin>> EQ 1]
 (msg,Magazin seems to be open, is this correct?)
O<chmagcl>endif


O<en> if [ACTIVE[] AND #<_tc_enable>]
  (print,Toolchange from #<_current_tool> to #<_selected_tool>)
  #<toisset>=0
  #<wstartx> = #<_x>
  #<wstarty> = #<_y>
  #<wstartz> = #<_z>

  #<spindle> = #<_spindle>
  O<sp> if [#<_tc_spindlecheck> AND [#<spindle> NE 5]]
    (print,  Spindle is ON)
    M5
  O<sp> endif
  O<st> if [#<_tc_skipsame> AND [#<_current_tool> EQ #<_selected_tool>]]
    (print,  Skip same tool)
  O<st> else

    O<sh> if [#<_tc_safeheight_en>]
;    (print,  Move to safe height)
      G53 G00 Z#<_tc_safeheight>
    O<sh> endif


    #<sox> = [DEF[#<_tool_so_x|#<_current_tool>>,0]]
    #<soy> = [DEF[#<_tool_so_y|#<_current_tool>>,0]]
    #<soz> = [DEF[#<_tool_so_z|#<_current_tool>>,0]]
  O<toolbreakdetect> if [[#<_kms_tool_break_detect> EQ 1] AND [#<_tool_skipmeasure|#<_current_tool>> EQ 0] AND [#<_current_tool> GT 0] AND [#<_input|#<kms_tool_in_spindle_pin>> EQ 1] AND [#<_current_slot> NE 0] AND [#<sox> EQ 0] AND [#<soy> EQ 0]]
 ;   (print,  Tool Break detect active)

    G53 G00 Z#<_tooloff_safeheight>
    G53 G00 X[#<_tooloff_sensorx> - #<sox>] 
    G53 G00 Y[#<_tooloff_sensory> - #<soy>]
    o<fastmove>if[#<_tool_off_z|#<_current_tool>> gt 0]
        #<fast_z_target> = [#<_tooloff_sensorz> + #<_tool_off_z|#<_current_tool>> + 10]        
        o<fastmove3>if[#<fast_z_target> lt 0]
 ;         (print,  old tool lentgh greater 0, move down fast to G53 Z #<fast_z_target>)
          G90 G53 G38.3 Z#<fast_z_target>  F5000
        o<fastmove3>endif     
    o<fastmove>endif
    M11P0
    ;clean WLS with air from out 7
    M62 P#<kms_wls_clean_pout> Q1
    G04 P1 
    G9
    M62 P#<kms_wls_clean_pout> Q0
    G53 G38.2 Z-100000 F#<_tooloff_speed>
    G91 G53 G01 Z[+#<_tooloff_swdist>]
    o<low> if [#<_tooloff_speed_low> GT 0]
      M62 P#<kms_wls_clean_pout> Q1
      G04 P0.5
      G9
      M62 P#<kms_wls_clean_pout> Q0
      G90 G53 G38.2 Z-100000 F#<_tooloff_speed_low>
      G91 G53 G01 Z[+#<_tooloff_swdist>] F#<_tooloff_speed>      
    o<low> endif
    M11P1 G90
    G53 G00 Z#<_tooloff_safeheight>
    o<chk> if[ACTIVE[] AND NOTEXISTS[#<_probe_z>]]
      (msg,Measuring failed)
    ;  M2
    o<chk> endif
    #<off_check> = [#<_probe_z> - #<_tooloff_sensorz> - #<soz>]
    #<off_diff_check>= [ #<off_check>-#<_tool_off_z|#<_current_tool>>] 
    (print,T#<_current_tool> diff #<off_diff_check>, new Z#<off_check> , old #<_tool_off_z|#<_current_tool>> during break detect)
      
    O<toolbreakdetect2> if [[#<off_diff_check> LT -0.5] OR [#<off_diff_check> GT 0.5]]
      (msg, Tool Length deviation too big! Check tool!)
    O<toolbreakdetect2> endif
  O<toolbreakdetect> endif






O<noatcen> if [#<_tc_atc_en> EQ 0]
  (print,  ATC disabled)
  (Move To Position)
  o<po> if [#<_tc_pos_en>]
    (print,  Move to position)
    o<safeheight> if [#<_tc_safeheight_en>]
      G53 G00 X#<_tc_pos_x> Y#<_tc_pos_y>
      G53 G00 Z#<_tc_pos_z>
    o<safeheight> else
      G53 G00 X#<_tc_pos_x> Y#<_tc_pos_y> Z#<_tc_pos_z>
    o<safeheight> endif
  o<po> endif
  G09
      O<ac> if [AND[#<_tc_action>, 1]]
        O<tn> if [#<_toolchangename>]
          (msg,Change tool to\  $<_toolchangename>)
        O<tn> else
          (msg,Change tool:\  #<_current_tool,0>: $<tool_name|#<_current_tool>> \to\  #<_selected_tool,0>: $<tool_name|#<_selected_tool>>)
        O<tn> endif
      O<ac> else
        O<tn> if [#<_toolchangename>]
          (print,  Change tool to $<_toolchangename>)
        O<tn> else
          (print,  Change tool #<_current_tool,0> to #<_selected_tool,0>)
        O<tn> endif
      O<ac> endif
      O<ac> if [AND[#<_tc_action>, 2]]
        M0
      O<ac> endif
      O<PROBE_CK> if [#<_tool_isprobe|#<_selected_tool>> EQ 1]
        (print, Probe selected enable Probe E-STOP!!!)
        #<_probe_estop>=1
      O<PROBE_CK> else
        (print, normale tool selected Probe E-STOP disabled)
        #<_probe_estop>=0
      O<PROBE_CK> endif		
      G09
O<noatcen> endif


  O<atcen> if [#<_tc_atc_en>]
; (print,  ATC enabled)
    O<ubload> if [#<_current_tool> GT 0]
      ;check if current tool is in magazine, if not manual change
      O<un_manual> if [#<_current_slot> EQ 0]
        G53 G00 Z#<_tc_safeheight>
        G53 G00 X#<_tc_pos_x> Y#<_tc_pos_y>
        O<un_next_manual> if [#<_selected_slot> GT 0]          
          (msg, remove current tool #<_current_tool,0> $<tool_name|#<_current_tool>>)
        O<un_next_manual> else
          (msg, remove current tool #<_current_tool,0> $<tool_name|#<_current_tool>> new tool #<_selected_tool,0>  $<tool_name|#<_selected_tool>> is manual as well)          
        o<un_next_manual> endif
      O<un_manual> else
        ;(print,  Move tool #<_current_tool,0> to magazine)
        ;get the unload position for the current tool
        #<unposx> = #<_slot_tc_x|#<_current_slot>>
        #<unposy> = #<_slot_tc_y|#<_current_slot>>
        #<unposz> = #<_slot_tc_z|#<_current_slot>>
        #<unposc> = #<_slot_tc_c|#<_current_slot>>
        #<unposz_end> = [#<unposz>+30]
        O<chk_umb_front>if [#<_extin1|#<kms_atc_umbrealla_back_pin>> EQ 0]  
          ;move umbrella back
          M62 P#<kms_atc_umbrealla_pout> Q0
          G04P2.5
          O<chk_umb_back>if [#<_extin1|#<kms_atc_umbrealla_back_pin>> EQ 0]  
            (msg,Umbrealla front sensor not active, check position)
          O<chk_umb_back>endif
        O<chk_umb_front>endif

        G53 G00 Z#<_tc_safeheight>
        ;move umbrella to slot position & move xy
        G53 G00 X#<unposx>  Y#<unposy>
        G53 G00 C#<unposc>
        G9

        
        ;Open Door
        M62 P#<kms_atc_door_pout> Q1
        G04 P2
        G9
        O<chmagco>if [#<_extin1|#<kms_atc_door_pin>> EQ 0]
          (msg,Door did not open correctly)
        O<chmagco>endif
        ;check if tool pocket is empty
        O<ckemptypocket> if [#<_extin1|#<kms_atc_pocket_empty_pin>> GT 0]
          (msg,Pocket seems to hold a tool, please check)
        O<ckemptypocket>endif
        G53 G00 Z#<unposz>
        ;move umbrella forward
        M62 P#<kms_atc_umbrealla_pout> Q1
        G04P1
        G9
        O<chk_umb_front> while [#<_extin1|#<kms_atc_umbrealla_front_pin>> EQ 0]
         ; (print,umbrealla still not front, waiting)
          G04 P0.1
        O<chk_umb_front> endwhile
        ;check if move was successfull
        O<chk_umb_front>if [#<_extin1|#<kms_atc_umbrealla_front_pin>> EQ 0]  
          (msg,Umbrealla front sensor not active, check position)
        O<chk_umb_front>endif 
 ;      (print, arrived at position, opening clamp)
        M62 P#<kms_atc_clamp_pout> Q1
        G04 P1
        G9
        ;check if clamp is open
        o<chk_for_tool> if [#<_input|#<kms_clamp_open_pin>> EQ 0]
          M62 P#<kms_atc_clamp_pout> Q0
          (msg, Clamp did not open during unload, aborting!!!)
          M2
        o<chk_for_tool> endif
        ;move up to unload the tool
        G53 G1 Z#<unposz_end> F2000 
        G9
        ;close the clamp
        M62 P#<kms_atc_clamp_pout> Q0
        G04 P1
        G53 G0 Z#<_tc_safeheight>
        G9
        ;check if we have no longer a tool clamped, if yes error out
        o<chk_for_tool> if [#<_input|#<kms_tool_in_spindle_pin>> EQ 1]
          (print, Tool still in spindle -> Aborting!)
          (msg, Tool still in spindle -> Aborting!)
          M2
        o<chk_for_tool> endif
        ;(print, Tool successfully unloaded)
      O<un_manual> endif
    O<ubload>else
      (print, Tool 0 was current tool, nothing todo)
    O<ubload> endif


    ;loading new tool
    O<ld> if [#<_selected_tool> GT 0]
      ;(print,  Load tool #<_selected_tool,0>)
      O<ex> if [#<_tool_exists|#<_selected_tool>> EQ 0]
        (msg,Selected tool #<_selected_tool,0> does not exist in tool table)
        M2
      O<ex> endif
      O<skp> if [#<_tool_skipchange|#<_selected_tool>> EQ 0]
        ;check if selected tool is in magazine, if not manual change
        O<ld_manual> if [#<_selected_slot> EQ 0 ]
          G53 G00 Z#<_tc_safeheight>
          ;move the umbrealla back as we no longer need it
          M62 P#<kms_atc_umbrealla_pout> Q0
          G53 G00 X#<_tc_pos_x> Y#<_tc_pos_y>
          (msg, insert new tool #<_selected_tool,0> $<tool_name|#<_selected_tool>>)
          #<spindle_try>=0
          O<checkfortool> while [[#<_input|#<kms_tool_in_spindle_pin>> EQ 0] AND [#<spindle_try> LT 5]]
            #<spindle_try> = [#<spindle_try> +1]
            (msg, no tool in spindle insert new tool #<_selected_tool,0> $<tool_name|#<_selected_tool>>)
          O<checkfortool> endwhile
          o<chk_for_tool_tl> if [#<_input|#<kms_tool_in_spindle_pin>> EQ 0]
            (msg, no tool in spindle ABORTING!)
            #<_current_tool>=0
            #<_selected_tool>=0
            m6
;           M2
          o<chk_for_tool_tl> endif
        O<ld_manual> else
;          (print,  Load tool #<_selected_tool,0> from magazine)
          #<ldposx> = #<_slot_tc_x|#<_selected_slot>>
          #<ldposy> = #<_slot_tc_y|#<_selected_slot>>
          #<ldposz> = #<_slot_tc_z|#<_selected_slot>>
          #<ldposc> = #<_slot_tc_c|#<_selected_slot>>
          #<ldposz_start> = [#<ldposz>+30]
          G53 G0 Z#<_tc_safeheight>

          ;calculate shortest path to C value
          #<direct_c_move> = ABS[#<ldposc>-#<_machine_c>]
          #<positive_c_move> = ABS[#<ldposc>+360-#<_machine_c>]
          #<negative_c_move> = ABS[#<ldposc>-360-#<_machine_c>]

          O<shortest_path>if[ #<direct_c_move> GT #<positive_c_move>]
            (print, using positive path)
            #<ldposc> = [#<ldposc>+360]
          O<shortest_path>elseif [#<direct_c_move> GT #<negative_c_move>]
             (print, using negative path)
            #<ldposc> = [#<ldposc>-360]
          O<shortest_path> endif

          (print, c load position target #<ldposc>)

          G53 G0 X#<ldposx> Y#<ldposy> C#<ldposc>
          ;unwind C in case we used lager C value for shorter path
          G10 L9 C[#<_machine_c> MOD 360]
          G9
          ;check if door is open and if umbrealla is moved forward
          O<chk_door>if [[#<_output|#<kms_atc_door_pout>> EQ 0]]
            M62 P#<kms_atc_door_pout> Q1
            G04 P2
            G9
            O<ch_door2>if [#<_extin1|#<kms_atc_door_pin>> EQ 0]
              (msg,Door did not open correctly)
            O<ch_door2>endif
          O<chk_door>endif
          O<chk_umbrealla>if [#<_output|#<kms_atc_umbrealla_pout>>EQ 0]
            M62 P#<kms_atc_umbrealla_pout> Q1
            G04 P2 
            G09
            O<chk_umb_front>if [#<_extin1|#<kms_atc_umbrealla_front_pin>> EQ 0]  
              (msg,Umbrealla front sensor not active, check position)
            O<chk_umb_front>endif
          O<chk_umbrealla>endif       

          G53 G0 Z#<ldposz_start> 
          ;arrived at clamp open position, open clamp and lower to tool Z
          M62 P#<kms_atc_clamp_pout> Q1
          G04 P1
          ;check if clamp is open
          G9
          o<chk_for_tool> if [#<_input|#<kms_clamp_open_pin>> EQ 0]
            M62 P#<kms_atc_clamp_pout> Q0
            (msg, Clamp did not open for loading, aborting!!!)
;            M2
          o<chk_for_tool> endif    
          G53 G1 Z#<ldposz> F2000
          ;close clamp
          G9
          M62 P#<kms_atc_clamp_pout> Q0
          G04 P1
          G9
          ;check if clamp is closed
          o<chk_for_tool> if [#<_input|#<kms_clamp_open_pin>> EQ 1]
            M62 P#<kms_atc_clamp_pout> Q0
            (msg, Clamp did not close correctly, aborting!!!)
;            M2
          o<chk_for_tool> endif  
          ;check if we grabbed the tool correctly
          G9 
          o<chk_for_tool> if [#<_input|#<kms_tool_in_spindle_pin>> EQ 0]
            M62 P#<kms_atc_clamp_pout> Q0
            (msg, Tool not correctl loaded, aborting!!!)
;            M2
          o<chk_for_tool> endif 
          ;move the umbrealla back
          M62 P#<kms_atc_umbrealla_pout> Q0
          G04P1
          ;wait till umbrealla moved back
          O<chk_umb_back> while [#<_extin1|#<kms_atc_umbrealla_back_pin>> EQ 0]
           ; (print,umbrealla still not back, waiting)
            G04 P0.1
          O<chk_umb_back> endwhile
          ;check if move was successfull
          O<chk_umb_back>if [#<_extin1|#<kms_atc_umbrealla_back_pin>> EQ 0]  
            (msg,Umbrealla back sensor not active, check position)
          O<chk_umb_back>endif       
          G53 G0 Z#<_tc_safeheight>
;         (print, tool successfully loaded)
        O<ld_manual> endif 
      O<skp> endif
     O<ld>else
      (print, Tool 0 is selected as new tool, nothing todo)
    O<ld> endif
      M6
    O<atcen> endif

    O<check_umbrealla> if [[#<_extin1|#<kms_atc_umbrealla_back_pin>> EQ 0]]
      ;move the umbrealla back just in case this was somehow missed above
      M62 P#<kms_atc_umbrealla_pout> Q0
      G9
      ;wait till umbrealla moved back
      O<chk_umb_back> while [#<_extin1|#<kms_atc_umbrealla_back_pin>> EQ 0]
        (print,umbrealla still not back, waiting)
        G04 P0.1
      O<chk_umb_back> endwhile
      G04 P1
      G9
      ;check if move was successfull
      O<chk_umb_back>if [#<_extin1|#<kms_atc_umbrealla_back_pin>> EQ 0]  
        (msg,Umbrealla back sensor not active, check position)
      O<chk_umb_back>endif    
      G9         
    O<check_umbrealla> endif 
    ;close the door
    M62 P#<kms_atc_door_pout> Q0

    (check is the current tool is a probe, if yes enable probe pin, otherwhise disable probe)

    O<ProbeCheck> if [[#<_tool_isprobe|#<_current_tool>>] EQ 1]
      #<_probe_pin_1> = #<kms_3d_probe_pin>
      #<_probe_estop>=1
    o<ProbeCheck> else
      #<_probe_pin_1>=0
      #<_probe_estop>=0
    o<ProbeCheck> endif
    #<kms_sk_tlm> = [DEF[#<_kms_sk_tlm>,0]]
    (tool length measurement)
    O<tm> if [[#<_tc_toolmeasure> GT 0] AND [#<_tool_skipmeasure|#<_current_tool>> EQ 0] AND [#<kms_sk_tlm> EQ 0]]
      G09
      ;(print,  Measure tool)
      #<sox> = [DEF[#<_tool_so_x|#<_current_tool>>,0]]
      #<soy> = [DEF[#<_tool_so_y|#<_current_tool>>,0]]
      #<soz> = [DEF[#<_tool_so_z|#<_current_tool>>,0]]

      G53 G00 Z#<_tooloff_safeheight>
      G53 G00 X[#<_tooloff_sensorx> - #<sox>] 
      G53 G00 Y[#<_tooloff_sensory> - #<soy>]
      G53 G00 Z#<_tooloff_rapidheight>

      O<xyoffset2> if [[#<soy> NE 0]]
        (msg, Rotate Tool into correct position)
      O<xyoffset2> endif

      o<fastmove>if[#<_tool_off_z|#<_current_tool>> gt 0]
        #<fast_z_target> = [#<_tooloff_sensorz> + #<_tool_off_z|#<_current_tool>> + 20]        
        o<fastmove3>if[#<fast_z_target> lt 0]
          ;(print,  old tool lentgh greater 0, move down fast to G53 Z #<fast_z_target>)
          G90 G53 G38.3 Z#<fast_z_target>  F5000
        o<fastmove3>endif     
      o<fastmove>endif

      M11P0
      ;clean WLS wit air from out 7
      M62 P#<kms_wls_clean_pout> Q1
      G04 P1 
      G9
      M62 P#<kms_wls_clean_pout> Q0
      G53 G38.2 Z-100000 F#<_tooloff_speed>
      G91 G53 G01 Z[+#<_tooloff_swdist>]
      o<low> if [#<_tooloff_speed_low> GT 0]
        M62 P#<kms_wls_clean_pout> Q1
        G04 P0.5
        G9
        M62 P#<kms_wls_clean_pout> Q0
        G90 G53 G38.2 Z-100000 F#<_tooloff_speed_low>
        G91 G53 G01 Z[+#<_tooloff_swdist>] F#<_tooloff_speed>
      o<low> endif
      M11P1 G90
      G53 G00 Z#<_tooloff_safeheight>
      o<chk> if[ACTIVE[] AND NOTEXISTS[#<_probe_z>]]
        (msg,Measuring failed)
        M2
      o<chk> endif
      #<off> = [#<_probe_z> - #<_tooloff_sensorz> - #<soz>]
      #<tool_off_diff>=[#<off> - #<_tool_off_z|#<_current_tool>>]
      O<tmset> if [#<_tc_toolmeasure> EQ 2]
        (print, T#<_current_tool> Set tooltable Z#<off> , old offset #<_tool_off_z|#<_current_tool>>, diff #<tool_off_diff>)
        G10 L1 P#<_current_tool> Z#<off>
        #<toisset>=2
      O<tmset> elseif [#<_tc_toolmeasure> EQ 1]
        (print, T#<_current_tool> Set tool offset Z#<off>, old offset #<_tool_off_z|#<_current_tool>>,diff #<tool_off_diff>)
        G43.1 Z#<off>
        #<toisset>=1
      O<tmset> endif
    O<tm> endif
  O<st> endif
  O<toen> if [#<_tc_tooloff_en>]
    M72
    M71
  ;    (print,  Enable tool offset)
    O<tois> if [#<_tc_tooloff_en> EQ 2]
    G43
    O<tois> elseif [#<_tc_tooloff_en> EQ 1]
    G43.1
    O<tois> endif
  O<toen> endif																		  
  o<ar> if [#<_tc_autoreturn>]
    G00 X#<wstartx> Y#<wstarty>
  O<ar> endif
  O<sp> if [#<_tc_spindlecheck> AND [#<spindle> EQ 3]]
    (print,  Turn spindle CW)
    M3
  O<sp> elseif [#<_tc_spindlecheck> AND [#<spindle> EQ 4]]
    (print,  Turn spindle CCW)
    M4
  O<sp> endif
O<en> else
  M6
O<en> endif

