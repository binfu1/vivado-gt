# set directory
set launchDir [file dirname [file normalize [info script]]]
# set launchDir /home/dengzw/dengzw/hw_test/nx2000/hw_test_2ddr
set srcDir ${launchDir}/src
set xdcDir ${launchDir}/xdc
set projName "proj"
set projDir "./$projName"
set projPart "xcvu37p-fsvh2892-2L-e"
create_project $projName $projDir -part $projPart

# add source files
# rtl
add_files -norecurse ${srcDir}/hdl/top.v
add_files -norecurse ${srcDir}/hdl/aurora_exdes.v
add_files -norecurse ${srcDir}/hdl/data_send.v
add_files -norecurse ${srcDir}/hdl/frequency_counter.v
add_files -norecurse ${srcDir}/hdl/aurora_64b66b_0_cdc_sync_exdes.v
# tcl
source ${srcDir}/tcl/aurora.tcl
source ${srcDir}/tcl/vio.tcl
source ${srcDir}/tcl/ila.tcl

# sim
add_files -fileset sim_1 -norecurse ${srcDir}/sim/top_tb.v

# add constrains
add_files -fileset constrs_1 -norecurse ${xdcDir}/top.xdc

## synth
#launch_runs synth_1 -jobs 20
#wait_on_run synth_1
## impl
#launch_runs impl_1 -jobs 20
#wait_on_run impl_1
## generate bitstream
#launch_runs impl_1 -to_step write_bitstream -jobs 20