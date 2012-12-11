# make          <- runs simv (after compiling simv if needed)
# make simv     <- compile simv if needed (but do not run)
# make int      <- runs int_simv interactively (after compiling it if needed)
# make syn      <- runs syn_simv (after synthesizing if needed then 
#                                 compiling synsimv if needed)
# make syn_int  <- runs syn_int_simv interactively (much like make syn)
# make clean    <- remove files created during compilations (but not synthesis)
# make nuke     <- remove all files created during compilation and synthesis
#
# To compile additional files, add them to the TESTBENCH or SIMFILES as needed
# Every .vg file will need its own rule and one or more synthesis scripts
# The information contained here (in the rules for those vg files) will be 
# similar to the information in those scripts but that seems hard to avoid.
#

VCS = SW_VCS=2011.03 vcs +v2k +vc -Mupdate -line -full64 -sverilog
INTFLAGS = -I +memcbk 
VISFLAGS = -lncurses

all:    simv
	./simv | tee program.out

##### 
# Modify starting here
#####

TESTBENCH =	sys_defs.vh	\
		testbench/mem.v	\
		testbench/pipeline_test.v
SIMFILES =	verilog/BTB.v	\
		verilog/if_stage.v	\
                verilog/id_stage.v      \
		verilog/if_id.v   	\
		verilog/archtable.v	\
		verilog/rob.v   	\
                verilog/pr.v           \
                verilog/rs2.v           \
                verilog/ex_stage/alu.v \
                verilog/ex_stage/ex_pipeline.v\
                verilog/ex_stage/mult_stage.v \
                verilog/ex_stage/pipe_mult.v \
                verilog/ex_stage/mult_decoder.v	\
		verilog/maptable.v	\
		verilog/freelist.v	\
		verilog/Icache.v	\
		verilog/cachecontroller.v	\
                verilog/Dcache.v	\
                verilog/cache.v		\
		verilog/rob_connect.v	\
		verilog/bs.v	\
		verilog/pipeline.v	\
		verilog/prefetch.v	\
		verilog/ldq.v		\
		verilog/stq.v

SIMFILES_SYN =	verilog/BTB.v	\
		verilog/if_stage.v	\
                verilog/id_stage.v      \
		verilog/if_id.v   	\
		verilog/archtable.v	\
		verilog/rob.v   	\
                verilog/pr.v           \
                verilog/rs2.v           \
                verilog/ex_stage/alu.v \
                verilog/ex_stage/ex_pipeline.v\
                verilog/ex_stage/mult_decoder.v	\
		verilog/cachecontroller.v	\
                verilog/cache.v		\
		verilog/maptable.v	\
		verilog/freelist.v	\
                verilog/rob_connect.v	\
		verilog/bs.v	\
		verilog/pipeline.v	\
		verilog/prefetch.v	\
		verilog/ldq.v		\
		verilog/stq.v

SYNFILES = synth/pipeline.vg  /afs/engin.umich.edu/caen/generic/mentor_lib-D.1/public/eecs470/verilog/lec25dscc25.v
#######################################  if_id  ################################
#synth/if_id.vg: verilog/if_id.v verilog/if_stage.v verilog/BTB.v verilog/id_stage.v verilog/prefetch.v synth/if_id.tcl
#	cd synth && dc_shell-t -f ./if_id.tcl | tee if_id.out

#synth/if_stage.vg:    verilog/if_stage.v synth/BTB.vg synth/if_stage.tcl
#	cd synth && dc_shell-t -f ./if_stage.tcl | tee if_stage.out

#synth/BTB.vg:        verilog/BTB.v synth/BTB.tcl
#	cd synth && dc_shell-t -f ./BTB.tcl | tee BTB.out

#synth/id_stage.vg:        verilog/id_stage.v synth/id_stage.tcl
#	cd synth && dc_shell-t -f ./id_stage.tcl | tee id_stage.out

#synth/prefetch.vg:        verilog/prefetch.v synth/prefetch.tcl
#	cd synth && dc_shell-t -f ./prefetch.tcl | tee prefetch.out

#######################################  ex_pipeline  ################################
#synth/ex_pipeline.vg:        verilog/ex_stage/ex_pipeline.v verilog/ex_stage/alu.v verilog/ex_stage/mult_decoder.v synth/pipe_mult.vg synth/mult_stage.vg synth/ex_pipeline.tcl
#	cd synth && dc_shell-t -f ./ex_pipeline.tcl | tee ex_pipeline.out

#synth/mult_decoder.vg:        verilog/ex_stage/mult_decoder.v synth/pipe_mult.vg synth/mult_decoder.tcl
#	cd synth && dc_shell-t -f ./mult_decoder.tcl | tee mult_decoder.out

synth/pipe_mult.vg:        verilog/ex_stage/pipe_mult.v synth/mult_stage.vg synth/pipe_mult.tcl
	cd synth && dc_shell-t -f ./pipe_mult.tcl | tee pipe_mult.out

synth/mult_stage.vg:        verilog/ex_stage/mult_stage.v synth/mult_stage.tcl
	cd synth && dc_shell-t -f ./mult_stage.tcl | tee mult_stage.out

#synth/alu_all.vg:        verilog/ex_stage/alu.v synth/alu_all.tcl
#	cd synth && dc_shell-t -f ./alu_all.tcl | tee alu_all.out

#######################################  rob_connection  ################################
#synth/rob_connect.vg:        verilog/rob_connect.v verilog/rob.v verilog/archtable.v verilog/maptable.v verilog/freelist.v verilog/bs.v synth/rob_connect.tcl
#	cd synth && dc_shell-t -f ./rob_connect.tcl | tee rob_connect.out

#synth/rob.vg:        verilog/rob.v synth/rob.tcl
#	cd synth && dc_shell-t -f ./rob.tcl | tee rob.out

#synth/archtable.vg:        verilog/archtable.v synth/archtable.tcl
#	cd synth && dc_shell-t -f ./archtable.tcl | tee archtable.out

#synth/maptable.vg:        verilog/maptable.v synth/maptable.tcl
#	cd synth && dc_shell-t -f ./maptable.tcl | tee maptable.out

#synth/freelist.vg:        verilog/freelist.v synth/freelist.tcl
#	cd synth && dc_shell-t -f ./freelist.tcl | tee freelist.out

#synth/bs.vg:        verilog/bs.v synth/bs.tcl
#	cd synth && dc_shell-t -f ./bs.tcl | tee bs.out

#######################################  Cache  ################################
#synth/cache.vg:        verilog/cache.v verilog/cachecontroller.v synth/Icache.vg synth/Dcache.vg synth/cache.tcl
#	cd synth && dc_shell-t -f ./cache.tcl | tee cache.out

synth/Icache.vg:        verilog/Icache.v synth/Icache.tcl
	cd synth && dc_shell-t -f ./Icache.tcl | tee Icache.out

synth/Dcache.vg:        verilog/Dcache.v synth/Dcache.tcl
	cd synth && dc_shell-t -f ./Dcache.tcl | tee Dcache.out

#synth/cachecontroller.vg:        verilog/cachecontroller.v synth/cachecontroller.tcl
#	cd synth && dc_shell-t -f ./cachecontroller.tcl | tee cachecontroller.out

################################# pipeline  ################################
synth/pipeline.vg:        $(SIMFILES_SYN) synth/mult_stage.vg synth/pipe_mult.vg synth/Icache.vg synth/Dcache.vg synth/pipeline.tcl
	cd synth && dc_shell-t -f ./pipeline.tcl | tee pipeline.out

#synth/rs.vg:        verilog/rs2.v synth/rs.tcl
#	cd synth && dc_shell-t -f ./rs.tcl | tee rs.out

#synth/pr.vg:        verilog/pr.v synth/pr.tcl
#	cd synth && dc_shell-t -f ./pr.tcl | tee pr.out

#synth/ldq.vg:        verilog/ldq.v synth/ldq.tcl
#	cd synth && dc_shell-t -f ./ldq.tcl | tee ldq.out

#synth/stq.vg:        verilog/stq.v synth/stq.tcl
#	cd synth && dc_shell-t -f ./stq.tcl | tee stq.out

#####
# Should be no need to modify after here
#####

VISTESTBENCH = $(TESTBENCH:pipeline_test.v=visual/visual_testbench.v) \
		testbench/visual/visual_c_hooks.c

#visual debug
vis:	$(VISTESTBENCH) $(SIMFILES)
	$(VCS) $(VISFLAGS) $^ -o vis_simv 
	./vis_simv

simv:	$(SIMFILES) $(TESTBENCH)
	$(VCS) $(TESTBENCH) $(SIMFILES)	-o simv 

int:	$(SIMFILES) $(TESTBENCH) 
	$(VCS) $(INTFLAGS) $(TESTBENCH) $(SIMFILES) -o int_simv -RI

dve:	$(SIMFILES) $(TESTBENCH)
	$(VCS) +memcbk $(TESTBENCH) $(SIMFILES) -o dve -R -gui
.PHONY:	dve

syn_simv:	$(SYNFILES) $(TESTBENCH)
	$(VCS) $(TESTBENCH) $(SYNFILES) -o syn_simv 

syn:	syn_simv
	./syn_simv | tee syn_program.out

syn_int:	$(SYNFILES) $(TESTBENCH)
	$(VCS) $(INTFLAGS) $(TESTBENCH) $(SYNFILES) -o syn_int_simv -RI

clean:
	rm -rf simv simv.daidir csrc vcs.key program.out
	rm -rf syn_simv syn_simv.daidir syn_program.out
	rm -rf int_simv int_simv.daidir syn_int_simv syn_int_simv.daidir
	rm -rf dve dve.daidir *.vpd *.vcd
	rm -rf simv.vdb

nuke:	clean
	rm -rvf *.out synth/*.rep synth/*.vg synth/*.ddc synth/*.chk synth/command.log synth/*.out synth/*.svf DVEfiles/ simv.vdb/ dve.vdb/ vis_simv.daidir/ vis_simv.vdb/

.PHONY: clean nuke


