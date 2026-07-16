package mstr_seq_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;

    import mstr_txn_pkg::*;


    class mstr_reset_seq extends uvm_sequence;
        `uvm_object_utils(mstr_reset_seq)

        mstr_txn mstr_txn_item;


        function new (string name = "mstr_reset_seq");
            super.new(name);
        endfunction

        task pre_body();
            mstr_txn_item = mstr_txn::type_id::create("mstr_txn_item");
        endtask

        task body ();
            start_item(mstr_txn_item);
                mstr_txn_item.PRESETn = 1'b0;
                mstr_txn_item.WDATA = {DATA_WIDTH{1'b0}};
                mstr_txn_item.WSTRB = {(DATA_WIDTH/8){1'b0}};
                mstr_txn_item.ADDR = {ADDR_WIDTH{1'b0}};
                mstr_txn_item.SEL = 1'b0;
                mstr_txn_item.WRn = 1'b0;
                mstr_txn_item.EN = 1'b0;
                mstr_txn_item.PREADY = 1'b0;
                mstr_txn_item.PRDATA = {DATA_WIDTH{1'b0}};
                mstr_txn_item.PSLVERR = 1'b0;
            finish_item(mstr_txn_item);
        endtask
    endclass



    class mstr_write_seq extends uvm_sequence;
        `uvm_object_utils(mstr_write_seq)

        mstr_txn mstr_txn_item;


        function new (string name = "mstr_write_seq");
            super.new(name);
        endfunction

        task pre_body();
            mstr_txn_item = mstr_txn::type_id::create("mstr_txn_item");
        endtask

        task body ();
            mstr_txn_item.wrn_const_normal.constraint_mode(0);
            mstr_txn_item.wrn_const_read.constraint_mode(0);
            mstr_txn_item.backToBack_btbseq_const.constraint_mode(0);
                repeat (1000) begin
                    start_item(mstr_txn_item);
                    mstr_txn_item.randomize();
                    finish_item(mstr_txn_item);
                end
            mstr_txn_item.wrn_const_normal.constraint_mode(1);
            mstr_txn_item.wrn_const_read.constraint_mode(1);
        endtask
    endclass



    class mstr_read_seq extends uvm_sequence;
        `uvm_object_utils(mstr_read_seq)

        mstr_txn mstr_txn_item;


        function new (string name = "mstr_read_seq");
            super.new(name);
        endfunction

        task pre_body();
            mstr_txn_item = mstr_txn::type_id::create("mstr_txn_item");
        endtask

        task body;
            mstr_txn_item.wrn_const_normal.constraint_mode(0);
            mstr_txn_item.wrn_const_write.constraint_mode(0);
            mstr_txn_item.backToBack_btbseq_const.constraint_mode(0);
                repeat (1000) begin
                    start_item(mstr_txn_item);
                    mstr_txn_item.randomize();
                    finish_item(mstr_txn_item);
                end
            mstr_txn_item.wrn_const_normal.constraint_mode(1);
            mstr_txn_item.wrn_const_write.constraint_mode(1);
        endtask
    endclass


    class mstr_write_read_seq extends uvm_sequence;
        `uvm_object_utils(mstr_write_read_seq)

        mstr_txn mstr_txn_item;


        function new (string name = "mstr_write_read_seq");
            super.new(name);
        endfunction

        task pre_body();
            mstr_txn_item = mstr_txn::type_id::create("mstr_txn_item");
        endtask

        task body ();
            mstr_txn_item.wrn_const_write.constraint_mode(0);
            mstr_txn_item.wrn_const_read.constraint_mode(0);
            mstr_txn_item.backToBack_btbseq_const.constraint_mode(0);
                repeat (1000) begin
                    start_item(mstr_txn_item);
                    mstr_txn_item.randomize();
                    backToBack = mstr_txn_item.backToBack_r;
                    finish_item(mstr_txn_item);
                end
            mstr_txn_item.wrn_const_write.constraint_mode(1);
            mstr_txn_item.wrn_const_read.constraint_mode(1);
        endtask
    endclass
    
    class mstr_write_read_btb_seq extends uvm_sequence;
        `uvm_object_utils(mstr_write_read_btb_seq)

        mstr_txn mstr_txn_item;


        function new (string name = "mstr_write_read_btb_seq");
            super.new(name);
        endfunction

        task pre_body();
            mstr_txn_item = mstr_txn::type_id::create("mstr_txn_item");
        endtask

        task body ();
            mstr_txn_item.wrn_const_write.constraint_mode(0);
            mstr_txn_item.wrn_const_read.constraint_mode(0);
            mstr_txn_item.backToBack_normal_const.constraint_mode(0);
                repeat (1000) begin
                    start_item(mstr_txn_item);
                    mstr_txn_item.randomize();
                    backToBack = mstr_txn_item.backToBack_r;
                    finish_item(mstr_txn_item);
                end
                repeat (1000) begin
                    start_item(mstr_txn_item);
                    mstr_txn_item.randomize() with {
                        ADDR inside {[DATA_REGISTER:CONFIG_REGISTER]};
                        WDATA inside {
                            32'h0000_0000,
                            32'hFFFF_FFFF,
                            32'hAAAA_AAAA,
                            32'h5555_5555,
                            32'h0000_FFFF,
                            32'hFFFF_0000
                        };
                        ADDR [1:0] == 2'b00;
                        WSTRB == 4'b1111;
                    };
                    backToBack = mstr_txn_item.backToBack_r;
                    finish_item(mstr_txn_item);
                end

            mstr_txn_item.wrn_const_write.constraint_mode(1);
            mstr_txn_item.wrn_const_read.constraint_mode(1);

                repeat (1000) begin
                    start_item(mstr_txn_item);
                    mstr_txn_item.randomize() with {
                        ADDR inside {CONTROL_REGISTER};
                        WDATA inside {
                            32'h0000_0000,
                            32'hFFFF_FFFF,
                            32'hAAAA_AAAA,
                            32'h5555_5555,
                            32'h0000_FFFF,
                            32'hFFFF_0000
                        };
                        ADDR [1:0] == 2'b00;
                        WSTRB == 4'b1111;
                    };
                    backToBack = mstr_txn_item.backToBack_r;
                    finish_item(mstr_txn_item);
                end
            mstr_txn_item.wrn_const_write.constraint_mode(1);
            mstr_txn_item.wrn_const_read.constraint_mode(1);


            mstr_txn_item.wrn_const_write.constraint_mode(1);
            mstr_txn_item.wrn_const_read.constraint_mode(1);

                repeat (1000) begin
                    start_item(mstr_txn_item);
                    mstr_txn_item.randomize() with {
                        ADDR inside {CONFIG_REGISTER};
                        WDATA inside {
                            32'h0000_0000,
                            32'hFFFF_FFFF,
                            32'hAAAA_AAAA,
                            32'h5555_5555,
                            32'h0000_FFFF,
                            32'hFFFF_0000
                        };
                        ADDR [1:0] == 2'b00;
                        WSTRB == 4'b1111;
                    };
                    backToBack = mstr_txn_item.backToBack_r;
                    finish_item(mstr_txn_item);
                end
            mstr_txn_item.wrn_const_write.constraint_mode(1);
            mstr_txn_item.wrn_const_read.constraint_mode(1);


        endtask
    endclass


endpackage : mstr_seq_pkg
