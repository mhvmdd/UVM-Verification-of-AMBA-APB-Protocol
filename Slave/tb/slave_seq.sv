package slave_seq_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;

    import slave_txn_pkg::*;


    class slave_reset_seq extends uvm_sequence;
        `uvm_object_utils(slave_reset_seq)

        slave_txn slv_txn;


        function new (string name = "slave_reset_seq");
            super.new(name);
        endfunction

        task pre_body();
            slv_txn = slave_txn::type_id::create("slv_txn");
        endtask

        task body ();
            start_item(slv_txn);
                slv_txn.PRESETn = 1'b0;
                slv_txn.PADDR = {ADDR_WIDTH{1'b0}};
                slv_txn.PWRITE = 1'b0;
                slv_txn.PWDATA = {DATA_WIDTH{1'b0}};
                slv_txn.PSTRB = {(DATA_WIDTH/8){1'b0}};
            finish_item(slv_txn);
        endtask
    endclass





    class slave_write_seq extends uvm_sequence;
        `uvm_object_utils(slave_write_seq)

        slave_txn slv_txn;


        function new (string name = "slave_write_seq");
            super.new(name);
        endfunction

        task pre_body();
            slv_txn = slave_txn::type_id::create("slv_txn");
        endtask

        task body ();
            slv_txn.pwrite_const_normal.constraint_mode(0);
            slv_txn.pwrite_const_read.constraint_mode(0);
                repeat (10000) begin
                    start_item(slv_txn);
                    slv_txn.randomize();
                    finish_item(slv_txn);
                end
            slv_txn.pwrite_const_normal.constraint_mode(1);
            slv_txn.pwrite_const_read.constraint_mode(1);
        endtask
    endclass




    class slave_read_seq extends uvm_sequence;
        `uvm_object_utils(slave_read_seq)

        slave_txn slv_txn;


        function new (string name = "slave_read_seq");
            super.new(name);
        endfunction

        task pre_body();
            slv_txn = slave_txn::type_id::create("slv_txn");
        endtask

        task body ();
            slv_txn.pwrite_const_normal.constraint_mode(0);
            slv_txn.pwrite_const_write.constraint_mode(0);
                repeat (10000) begin
                    start_item(slv_txn);
                    slv_txn.randomize();
                    finish_item(slv_txn);
                end
            slv_txn.pwrite_const_normal.constraint_mode(1);
            slv_txn.pwrite_const_write.constraint_mode(1);
        endtask
    endclass


    class slave_write_read_seq extends uvm_sequence;
        `uvm_object_utils(slave_write_read_seq)

        slave_txn slv_txn;


        function new (string name = "slave_write_read_seq");
            super.new(name);
        endfunction

        task pre_body();
            slv_txn = slave_txn::type_id::create("slv_txn");
        endtask

        task body ();
            slv_txn.pwrite_const_read.constraint_mode(0);
            slv_txn.pwrite_const_write.constraint_mode(0);
                repeat (10000) begin
                    start_item(slv_txn);
                    slv_txn.randomize();
                    finish_item(slv_txn);
                end
                repeat (1000) begin
                    start_item(slv_txn);
                    slv_txn.randomize() with {
                        !(PADDR inside {[DATA_REGISTER:CONFIG_REGISTER]});
                        PWDATA inside {
                            32'h0000_0000,
                            32'hFFFF_FFFF,
                            32'hAAAA_AAAA,
                            32'h5555_5555,
                            32'h0000_FFFF,
                            32'hFFFF_0000
                        };

                    };
                    finish_item(slv_txn);
                end
                repeat (1000) begin
                    start_item(slv_txn);
                    slv_txn.randomize() with {
                        PADDR ==  STATUS_REGISTER;
                        PWDATA inside {
                            32'h0000_0000,
                            32'hFFFF_FFFF,
                            32'hAAAA_AAAA,
                            32'h5555_5555,
                            32'h0000_FFFF,
                            32'hFFFF_0000
                        };
                    };
                    finish_item(slv_txn);
                end
            slv_txn.pwrite_const_read.constraint_mode(1);
            slv_txn.pwrite_const_write.constraint_mode(1);
        endtask
    endclass


endpackage : slave_seq_pkg