if {[catch {

# define run engine funtion
source [file join {/home/es4user/tools/radiant/2.2} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "/home/es4user/Documents/radiant-designs/cpu_project"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- cpu_project_impl_1.vm cpu_project_impl_1.ldc
run_engine_newmsg synthesis -f "cpu_project_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o cpu_project_impl_1_syn.udb cpu_project_impl_1.vm] "/home/es4user/Documents/radiant-designs/cpu_project/impl_1/cpu_project_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
