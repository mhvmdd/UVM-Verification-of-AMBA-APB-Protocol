package mstr_env_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import mstr_agt_pkg::*;
    import mstr_scrbrd_pkg::*;
    import mstr_sub_pkg::*;
    import mstr_txn_pkg::*;


    class mstr_env extends uvm_env;
        `uvm_component_utils(mstr_env)

        mstr_agt agt;
        mstr_scrbrd scrbrd;
        mstr_sub sub;

        virtual mstr_if mstr_vif;


        function new (string name = "mstr_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            agt = mstr_agt::type_id::create("agt", this);
            scrbrd = mstr_scrbrd::type_id::create("scrbrd", this);
            sub = mstr_sub::type_id::create("sub", this);

            if (!uvm_config_db#(virtual mstr_if):: get (this,"", "mstr_vif", mstr_vif))
                `uvm_fatal(get_full_name(), "ENV Cannot retrieve VIF")

            uvm_config_db#(virtual mstr_if) :: set (this, "agt", "mstr_vif", mstr_vif);

        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            agt.ap.connect(scrbrd.imp);
            agt.ap.connect(sub.analysis_export);
        endfunction

    endclass


endpackage : mstr_env_pkg
