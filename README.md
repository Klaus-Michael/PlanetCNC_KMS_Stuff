# PlanetCNC_KMS_Stuff
This is a collection of my personal PlanetCNC Settings and Scripts.
Most scripts are based on the original PlanetCNC scripts that can be accessed through the Settings menu from PlanetCNC.
The copyright of the original parts belongs to PlanetCNC.
Custom Icons were created by Daniel aka Bambusbjoern (Thanks a lot)


Feel free to use whatever script you like, but please test everything beforehand. All Scripts should be threated as experimental and a work in progress. 
## Use everything at your own risk!!!!!!!
I take no responsibility of any damage done to you or your machine from using anything from this repository.

Some of the changes I made include:
* extension of most of the measurement scripts with a slow speed for the last few mm of the Z travel
* possibility to reduce the accelerations during movements from the measurement scripts (acceleration settings are not correctly restored when stopping the measurements manually)
* measurement of outside corner and Z height in one step
* measurement of center and Z height in one step
* measurement of center without any Z movement (will move around the outside of the stock)
* measurement of center including a workpiece rotation. This will set the rotation in currently selected work coordinate system!!!! You need to manually reset this if you no longer need the rotation!!! (very experimental but seems to be working ok)
* a short warmup routine, hardcoded to my machine limits, if you want to use this use extreme caution as it included a running spindle and movement on all axes!!!
* prevents startup of spindle if tool 255 is selected (This is my 3D Probe and I do not want to accidentally start the spindle with the probe)
* tool runtime recording. Spindle on time will be recorded into custom variable 1 in the tool library for every tool. The recording is started during M3 and M4 commands and measured with M5. If one of those is not executed no recording will happen (Stopping with E-Stop for example, if the Menu button should be reflected the settings need to be set to M Code instead of Native for the Spindle Command) This requires at last SW Version 2021.02.12 (Thanks to PlanetCNC for making the Custom Variables of the tool table writeable)
* M6 changed to not disable speed override
