package slave_sqr_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"


    import slave_txn_pkg::*;


    class slave_sqr extends uvm_sequencer #(slave_txn);
        `uvm_component_utils(slave_sqr)


        function new (string name = "slave_sqr", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);

        
        
        endfunction


        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            
        
        endtask 
    endclass




endpackage : slave_sqr_pkg