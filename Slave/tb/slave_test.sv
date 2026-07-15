package slave_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"


    import slave_env_pkg::*;
    import slave_seq_pkg::*;


    class slave_test extends uvm_test;
        `uvm_component_utils(slave_test)
        // Env
        slave_env env;
        
        // Sequences
        slave_reset_seq rst_seq;
        slave_write_seq write_seq;
        slave_read_seq read_seq;
        slave_write_read_seq w_r_seq;

        // Virtual Interface
        virtual slave_if slv_vif;

        function new (string name = "slave_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
        
            env = slave_env::type_id::create("env", this);
            rst_seq = slave_reset_seq::type_id::create("rst_seq");
            write_seq = slave_write_seq::type_id::create("write_seq");
            read_seq = slave_read_seq::type_id::create("read_seq");
            w_r_seq = slave_write_read_seq::type_id::create("w_r_seq");

            if (!uvm_config_db#(virtual slave_if) :: get (this, "", "slv_vif", slv_vif))
                `uvm_fatal(get_full_name(), "Test Cannot retrieve VIF")

            uvm_config_db #(virtual slave_if) :: set (this, "env" /*find by name ig*/, "slv_vif", slv_vif);

        endfunction


        task run_phase (uvm_phase phase);
            super.run_phase(phase);

            phase.raise_objection(this);

            rst_seq.start(env.agt.sqr);
            write_seq.start(env.agt.sqr);
            read_seq.start(env.agt.sqr);
            w_r_seq.start(env.agt.sqr);

            phase.drop_objection(this);
        endtask


    endclass

endpackage : slave_test_pkg