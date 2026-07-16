package slave_env_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import slave_agt_pkg::*;
    import slave_scrbrd_pkg::*;
    import slave_sub_pkg::*;
    import slave_txn_pkg::*;


    class slave_env extends uvm_env;
        `uvm_component_utils(slave_env)

        slave_agt agt;
        slave_scrbrd scrbrd;
        slave_sub sub;

        virtual slave_if slv_vif;

        uvm_active_passive_enum env_e;

        function new (string name = "slave_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            agt = slave_agt::type_id::create("agt", this);
            scrbrd = slave_scrbrd::type_id::create("scrbrd", this);
            sub = slave_sub::type_id::create("sub", this);

            if (!uvm_config_db#(virtual slave_if):: get (this,"", "slv_vif", slv_vif))
                `uvm_fatal(get_full_name(), "ENV Cannot retrieve VIF")

            if (!uvm_config_db#(uvm_active_passive_enum):: get (this, "", "slv_e", env_e))
                `uvm_fatal(get_full_name(), "ENV Cannot retrieve ACTIVE/PASSIVE Enum")

            uvm_config_db#(virtual slave_if) :: set (this, "agt", "slv_vif", slv_vif);
            uvm_config_db#(uvm_active_passive_enum) :: set (this, "agt", "slv_e", env_e);

        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            agt.ap.connect(scrbrd.imp);
            agt.ap.connect(sub.analysis_export);
        endfunction

    endclass


endpackage : slave_env_pkg