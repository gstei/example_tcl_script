#==================================================================
# Vivado Project Generation
#===================================================================

#------------------- Project specific definitions ------------------

#### project name
set prj_name mcu

#### VHDL source files
set vhdl_src_files {}
lappend vhdl_src_files mcu.vhd
lappend vhdl_src_files mcu_pkg.vhd

#### VHDL tstbench files
set vhdl_tb_files {}
lappend vhdl_tb_files tb_mcu.vhd

#### Constraints files
set const_files {}
lappend const_files Zybo-Z7-Master.xdc

#### Waveform files
set wave_files {}
#lappend wave_files mcu.wcfg

#------------------- Default definitions and actions --------------

#### define environment ####################
# project directory
set prj_dir ./vivado
# source directory
set vhdl_dir ./vhdl
# control directory
set ctr_dir ./ctrl
# Zynq device
set zynq_dev xc7z010clg400-1

#### build the project #####################
# move to script directory
set script_dir [file dirname [file normalize [info script]]]
cd $script_dir
# create project

#set_property board_part digilentinc.com:zybo:part0:1.0 [current_project]
# set_property target_language VHDL [current_project]
# set_property simulator_language VHDL [current_project]
# set_property default_lib work [current_project]

#### add VHDL source files ################
if {[llength $vhdl_src_files] > 0} {
  set l_vhdl_src_files ""
  foreach file $vhdl_src_files {
    set l_vhdl_src_files [concat $l_vhdl_src_files $vhdl_dir/$file]
  }
  add_files -norecurse $l_vhdl_src_files
##set default library to work
  set_property library work [get_files $l_vhdl_src_files]
##add specific files to other library
  set_property library mcu_lib  [get_files $vhdl_dir/mcu.vhd]
  set_property library mcu_pkg_lib [get_files $vhdl_dir/mcu_pkg.vhd]
  update_compile_order
}

#### add VHDL testbench files #############
if {[llength $vhdl_tb_files] > 0} {
  set_property SOURCE_SET sources_1 [get_filesets sim_1]
  set l_vhdl_tb_files ""
  foreach file $vhdl_tb_files {
    set l_vhdl_tb_files [concat $l_vhdl_tb_files $vhdl_dir/$file]
  }
  add_files -fileset sim_1 -norecurse $l_vhdl_tb_files
  set_property library work [get_files $l_vhdl_tb_files]
  update_compile_order -fileset sim_1
}

#### add constraints files #################
if {[llength $const_files] > 0} {
  set l_const_files ""
  foreach file $const_files {
    set l_const_files [concat $l_const_files $ctr_dir/$file]
  }
    add_files -fileset constrs_1 -norecurse $l_const_files
}

#### add waveform files ####################
if {[llength $wave_files] > 0} {
  set_property SOURCE_SET sources_1 [get_filesets sim_1]
  set l_wave_files ""
  foreach file $wave_files {
    set l_wave_files [concat $l_wave_files $ctr_dir/$file]
  }
  add_files -fileset sim_1 -norecurse $l_wave_files
}

synth_design -top mcu -part $zynq_dev
write_checkpoint -force $prj_dir/post_synth
report_utilization -force -file $prj_dir/post_synth_util.rpt
report_timing -sort_by group -max_paths 5 -path_type summary -file $prj_dir/post_synth_timing.rpt
opt_design
place_design 
route_design
write_bitstream -force -file $prj_dir/design.bit

open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
current_hw_device [get_hw_devices xc7z010_1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7z010_1] 0]
set_property PROBES.FILE {} [get_hw_devices xc7z010_1]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7z010_1]
set_property PROGRAM.FILE $prj_dir/design.bit [get_hw_devices xc7z010_1]
program_hw_devices [get_hw_devices xc7z010_1]
# project settings
