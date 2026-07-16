package mstr_sqr_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"


    import mstr_txn_pkg::*;


    class mstr_sqr extends uvm_sequencer #(mstr_txn);
        `uvm_component_utils(mstr_sqr)


        function new (string name = "mstr_sqr", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass




endpackage : mstr_sqr_pkg
