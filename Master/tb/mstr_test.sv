package mstr_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"


    import mstr_env_pkg::*;
    import mstr_seq_pkg::*;


    class mstr_test extends uvm_test;
        `uvm_component_utils(mstr_test)
        // Env
        mstr_env env;
        
        // Sequences
        mstr_reset_seq rst_seq;
        mstr_write_seq write_seq;
        mstr_read_seq read_seq;
        mstr_write_read_seq w_r_seq;
        mstr_write_read_btb_seq btb_seq;
        // Virtual Interface
        virtual mstr_if mstr_vif;

        uvm_active_passive_enum mstr_e;

        function new (string name = "mstr_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
        
            env = mstr_env::type_id::create("env", this);
            rst_seq = mstr_reset_seq::type_id::create("rst_seq");
            write_seq = mstr_write_seq::type_id::create("write_seq");
            read_seq = mstr_read_seq::type_id::create("read_seq");
            w_r_seq = mstr_write_read_seq::type_id::create("w_r_seq");
            btb_seq = mstr_write_read_btb_seq::type_id::create("btb_seq");

            mstr_e = UVM_ACTIVE;

            if (!uvm_config_db#(virtual mstr_if) :: get (this, "", "mstr_vif", mstr_vif))
                `uvm_fatal(get_full_name(), "Test Cannot retrieve VIF")

            uvm_config_db #(virtual mstr_if) :: set (this, "env", "mstr_vif", mstr_vif);
            uvm_config_db #(uvm_active_passive_enum) :: set (this, "env", "mstr_e", mstr_e);

        endfunction


        task run_phase (uvm_phase phase);
            super.run_phase(phase);

            phase.raise_objection(this);

            rst_seq.start(env.agt.sqr);
            write_seq.start(env.agt.sqr);
            read_seq.start(env.agt.sqr);
            w_r_seq.start(env.agt.sqr);
            btb_seq.start(env.agt.sqr);
            rst_seq.start(env.agt.sqr);
            btb_seq.start(env.agt.sqr);

            phase.drop_objection(this);
        endtask


    endclass

endpackage : mstr_test_pkg
