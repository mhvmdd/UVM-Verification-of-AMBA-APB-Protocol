package slave_agt_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import slave_sqr_pkg  ::*;
    import slave_mon_pkg    ::*;
    import slave_dvr_pkg    ::*;
    import slave_txn_pkg    ::*;


    class slave_agt extends uvm_agent;
        `uvm_component_utils(slave_agt)

        slave_dvr dvr;
        slave_mon mon;
        slave_sqr sqr;

        virtual slave_if slv_vif;

        uvm_analysis_port #(slave_txn) ap;


        function new (string name = "slave_agt", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            dvr = slave_dvr::type_id::create("dvr", this);
            mon = slave_mon::type_id::create("mon", this);
            sqr = slave_sqr::type_id::create("sqr", this);

            ap = new ("ap", this);
            
            if (!uvm_config_db#(virtual slave_if):: get (this,"", "slv_vif", slv_vif))
                `uvm_fatal(get_full_name(), "Agent Cannot retrieve VIF")

            uvm_config_db#(virtual slave_if) :: set (this, "dvr", "slv_vif", slv_vif);
            uvm_config_db#(virtual slave_if) :: set (this, "mon", "slv_vif", slv_vif);
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            dvr.seq_item_port.connect(sqr.seq_item_export);
            mon.ap.connect (ap);
        endfunction

    endclass



endpackage : slave_agt_pkg