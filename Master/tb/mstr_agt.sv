package mstr_agt_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import mstr_sqr_pkg  ::*;
    import mstr_mon_pkg    ::*;
    import mstr_dvr_pkg    ::*;
    import mstr_txn_pkg    ::*;


    class mstr_agt extends uvm_agent;
        `uvm_component_utils(mstr_agt)

        mstr_dvr dvr;
        mstr_mon mon;
        mstr_sqr sqr;

        virtual mstr_if mstr_vif;

        uvm_analysis_port #(mstr_txn) ap;


        function new (string name = "mstr_agt", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            dvr = mstr_dvr::type_id::create("dvr", this);
            mon = mstr_mon::type_id::create("mon", this);
            sqr = mstr_sqr::type_id::create("sqr", this);

            ap = new ("ap", this);
            
            if (!uvm_config_db#(virtual mstr_if):: get (this,"", "mstr_vif", mstr_vif))
                `uvm_fatal(get_full_name(), "Agent Cannot retrieve VIF")

            uvm_config_db#(virtual mstr_if) :: set (this, "dvr", "mstr_vif", mstr_vif);
            uvm_config_db#(virtual mstr_if) :: set (this, "mon", "mstr_vif", mstr_vif);
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            dvr.seq_item_port.connect(sqr.seq_item_export);
            mon.ap.connect (ap);
        endfunction

    endclass



endpackage : mstr_agt_pkg
