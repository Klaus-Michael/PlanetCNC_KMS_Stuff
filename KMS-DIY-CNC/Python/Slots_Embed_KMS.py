#! /usr/bin/env python 

# This script provides a dialog for organizing tool slots in Planet CNC.
# It allows users to view and modify the tool assignments in each slot,
# and it checks which tools are used in the current program. The script also
# includes options to clear or auto-fill the tool slots, and it updates the
# color coding of the tool names based on their presence in the program.
#
# Based on the original Slots_Embed.py script by PlanetCNC provided in the DEMO_2025-05-26.zip
#
# Author: KMS
# Date: 2025-06-02
# Version: 1.0
#
#
#	Version | Date       | Description
#	1.0     | 2025-06-02 | Initial version based on Slots_Embed, added Color Highligting for Tools used in the Current Program and listing of tools used in the program at the bottom of the dialog.

import sys
import time
import math
import planetcnc

def SlotsNew():
	global dlg_handle
	global slot_count
	global comp_tool
	global comp_toolname
	global comp_tool_programm
	global programm_tools
	global slot_tool_numbers
	
	dlg_handle = planetcnc.dlg_new("Organize tool slots") 
	planetcnc.dlg_callback(dlg_handle, SlotsGen)
	
	planetcnc.dlg_keep_open(dlg_handle, False)
	planetcnc.dlg_set_modal(dlg_handle, True)
	planetcnc.dlg_set_size(dlg_handle, 0, 0)
	planetcnc.dlg_set_resizable(dlg_handle, False)
	planetcnc.dlg_set_btn(dlg_handle, False, True, True)

	planetcnc.dlg_add_option(dlg_handle, "Clear", ClearOpt, 0)
	planetcnc.dlg_add_option(dlg_handle, "Auto", AutoOpt, 0)
	
	comp = planetcnc.dlg_add_label(dlg_handle, "", "Slot Name")
	planetcnc.dlg_comp_color(comp, 0xffa500)
	planetcnc.dlg_comp_font(comp, 15, False)
	planetcnc.dlg_comp_pos(comp, 80, -1)
	
	comp = planetcnc.dlg_add_label(dlg_handle, "", "Tool Number")
	planetcnc.dlg_comp_color(comp, 0xffa500)
	planetcnc.dlg_comp_font(comp, 15, False)
	planetcnc.dlg_comp_pos(comp, 200, -1)
	
	programm_tools_count = planetcnc.param_get("_prog_tools")
	#initialise an empty array called programm_tools
	programm_tools = []
	programm_tools_in_slots = []  # Initialize an empty list to store tools not in slots
	slot_tool_numbers = []

	
	for programm_tools_idx in range(programm_tools_count):
		programm_tools.append(planetcnc.param_get("_prog_tools",programm_tools_idx))


	# print(f"Number of Tools used in program {programm_tools_count} ")
	# print(f"Tools used in program {programm_tools} ")

	slot_count = planetcnc.param_get("_slot_count")
	comp_tool = {} 
	comp_toolname = {} 
	for slot_idx in range(slot_count):
		slot_num = planetcnc.param_get("_slot_get", slot_idx)
		tool_num = planetcnc.param_get("_slot_tool", slot_num)
		slot_tool_numbers.append(tool_num) # Append the tool number to the list
		#print(f"Slot {slot_num} has number{slot_num} and assigned tool {tool_num}.")
		
		# Slot Name
		comp_slot = planetcnc.dlg_add_label(dlg_handle, str(slot_num), planetcnc.param_get("_slot_name", slot_num))
		planetcnc.dlg_comp_size(comp_slot, 200, 24)
		
		# Tool Number
		comp_tool[slot_idx] = planetcnc.dlg_add_num_input(dlg_handle, "", tool_num, 0, 1000, 0)
		planetcnc.dlg_comp_pos(comp_tool[slot_idx], 200, -1)
		planetcnc.dlg_comp_size(comp_tool[slot_idx], 90, 0)
		planetcnc.dlg_comp_callback(comp_tool[slot_idx], ToolNumChange, slot_idx)
			
		# Tool Name
		comp_toolname[slot_idx] = planetcnc.dlg_add_label(dlg_handle, "", planetcnc.param_get("_tool_name", tool_num))
		planetcnc.dlg_comp_pos(comp_toolname[slot_idx], 300, -1)
		planetcnc.dlg_comp_size(comp_toolname[slot_idx], 300, 24)

		#check if the tool in tool_num is in programm_tools

		if tool_num in programm_tools:
			# print(f"Tool {tool_num} is in programm_tools")
			programm_tools_in_slots.append(tool_num)
			planetcnc.dlg_comp_color(comp_toolname[slot_idx], 0x00ff00)
		else:
			# print(f"Tool {tool_num} is not in programm_tools")
			planetcnc.dlg_comp_color(comp_toolname[slot_idx], 0xffa500)
				
	#get all the tools that are in  programm_tools lots but not in programm_tools_in_slots
	programm_tools_not_in_slots = [tool for tool in programm_tools if tool not in programm_tools_in_slots]
	# print(f"Tools not in slots: {programm_tools_not_in_slots}")

	comp_kms_label = planetcnc.dlg_add_label(dlg_handle, "", "Tools Used in Programm")
	planetcnc.dlg_comp_color(comp_kms_label, 0xffa500)
	planetcnc.dlg_comp_font(comp_kms_label, 15, False)
	#planetcnc.dlg_comp_pos(comp, 200, -1)
	comp_tool_programm = {}
	for tool in programm_tools:
		comp_tool_list_item = planetcnc.dlg_add_label(dlg_handle, str(tool), planetcnc.param_get("_tool_name", tool))
		#add comp_tool to comp_tool_programm with tool as the key
		comp_tool_programm[tool] = comp_tool_list_item


		if tool in programm_tools_in_slots:
			planetcnc.dlg_comp_color(comp_tool_list_item, 0x00ff00)
		else:
			planetcnc.dlg_comp_color(comp_tool_list_item, 0xffa500)

	planetcnc.dlg_show(dlg_handle)
	return None
	

def Update_Used_Tool_List():
	#update all comp in comp_tool_programm with the ccorrect color
	for tool_number, comp_tool_list_item in comp_tool_programm.items():
		if tool_number in slot_tool_numbers:
			planetcnc.dlg_comp_color(comp_tool_list_item, 0x00ff00)
		else:
			planetcnc.dlg_comp_color(comp_tool_list_item, 0xffa500)

	
def ToolNumChange(comp, slot_idx):
	tool_num = planetcnc.dlg_comp_value(comp)
	slot_tool_numbers[slot_idx] = tool_num
	planetcnc.dlg_comp_value(comp_toolname[slot_idx], planetcnc.param_get("_tool_name", tool_num))

	if tool_num in programm_tools:
		# print(f"Tool {tool_num} is in programm_tools")
		planetcnc.dlg_comp_color(comp_toolname[slot_idx], 0x00ff00)
	else:
		# print(f"Tool {tool_num} is not in programm_tools")
		planetcnc.dlg_comp_color(comp_toolname[slot_idx], 0xffa500)

	Update_Used_Tool_List()
	
	
def ClearOpt(num):
	for slot_idx in range(slot_count):
		planetcnc.dlg_comp_value(comp_tool[slot_idx], 0)
		planetcnc.dlg_comp_value(comp_toolname[slot_idx], "")
		slot_tool_numbers[slot_idx] = 0
	Update_Used_Tool_List()
	
def AutoOpt(num):
	for slot_idx in range(slot_count):
		tool_idx = slot_idx
		tool_num = planetcnc.param_get("_prog_tools", tool_idx)
		planetcnc.dlg_comp_value(comp_tool[slot_idx], tool_num)
		planetcnc.dlg_comp_value(comp_toolname[slot_idx], planetcnc.param_get("_tool_name", tool_num))
		if tool_num > 0:
			planetcnc.dlg_comp_color(comp_toolname[slot_idx], 0x00ff00)
		else:
			planetcnc.dlg_comp_color(comp_toolname[slot_idx], 0xffa500)

		slot_tool_numbers[slot_idx] = tool_num

	Update_Used_Tool_List()
			
		
def SlotsGen(dlg_handle, dlg_result, params):
	print("Received", len(params), "params:")
	for key, value in params.items():
		print(f"Param {key}: {value}")	
	
	if (dlg_result != -2):
		print("  CLOSE")
		return None

	for slot_idx in range(slot_count):
		slot_num = planetcnc.param_get("_slot_get", slot_idx)
		tool_num = planetcnc.dlg_comp_value(comp_tool[slot_idx])
		# print(f"Tool {tool_num} to slot {slot_num}")
		
		planetcnc.param_set("_slot_tool", slot_num, tool_num)
		
	return None

	
if __name__ == '__main__':
	global dlg_handle
		
	SlotsNew()
	planetcnc.ready()
	
	if (planetcnc.dlg_is_valid(dlg_handle)):
		while (planetcnc.dlg_run(dlg_handle)):
			pass


