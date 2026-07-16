package mstr_txn_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;


    class mstr_txn extends uvm_sequence_item;
        `uvm_object_utils(mstr_txn)

        // IN to DUT
        rand logic PRESETn;
        rand logic [DATA_WIDTH-1:0] WDATA;
        rand logic [(DATA_WIDTH/8)-1:0] WSTRB;
        rand logic [ADDR_WIDTH-1:0] ADDR;
        rand logic [1:0] SEL;
        rand logic WRn;
        logic EN;

        // OUT from DUT to TB
        logic [DATA_WIDTH-1:0] DATA_OUT;

        // OUT from DUT to Slave
        logic [ADDR_WIDTH-1:0] PADDR;
        logic PSEL1;
        logic PSEL2;
        logic PENABLE;
        logic PWRITE;
        logic [DATA_WIDTH-1:0] PWDATA;
        logic [(DATA_WIDTH/8)-1:0] PSTRB;

        // IN from Slave
        rand logic PREADY;
        rand logic [DATA_WIDTH-1:0] PRDATA;
        rand logic PSLVERR;

        rand bit backToBack_r;
        static int reg_file [int] = '{
            CONTROL_REGISTER: 32'h0000_0000,
            STATUS_REGISTER: 32'h0000_0012,
            DATA_REGISTER: 32'h0000_0000,
            CONFIG_REGISTER: 32'h0000_0000
        };

        rand bit special;
        rand bit [2:0] prob;
        int prev_data;


        function new(string name = "mstr_txn");
            super.new(name);
        endfunction


        function void post_randomize();
                prev_data = PRDATA;
                if (!PSLVERR && PRESETn) begin
                    if (WRn) begin
                        for (int i = 0 ; i < (DATA_WIDTH/8) ; i++) begin
                            if (WSTRB[i])
                                reg_file[ADDR] [(i*8)+:8] = WDATA [(i*8)+:8];
                        end
                    end
                end
        endfunction

        constraint prestn_const {
            PRESETn dist {1'b1:/95, 1'b0:/5};
        }

        constraint sel_const {
            SEL dist {2'b00:/5, [2'b01:2'b11]:/95};
        }

        constraint wdata_const {
            special dist {1 := 95, 0 := 5};

            if (special)
                WDATA inside {
                    32'h0000_0000,
                    32'hFFFF_FFFF,
                    32'hAAAA_AAAA,
                    32'h5555_5555,
                    32'h0000_FFFF,
                    32'hFFFF_0000
                };
            else
                !(WDATA inside {
                    32'h0000_0000,
                    32'hFFFF_FFFF,
                    32'hAAAA_AAAA,
                    32'h5555_5555,
                    32'h0000_FFFF,
                    32'hFFFF_0000
                });
        } 

        constraint addr_const {
            ADDR dist {[DATA_REGISTER:CONFIG_REGISTER]:/95, [32'hF:$]:/5};
            ADDR[1:0] dist {2'b00:/95, [2'b01:$]:/5};
        }

        constraint strb_const {

            prob inside {[1:5]};

            if (prob == 1){
                $countones(WSTRB) == 0;
            }

            if (prob == 2){
                $countones(WSTRB) == 1;
            }

            if (prob == 3){
                $countones(WSTRB) == 2;
            }

            if (prob == 4){
                $countones(WSTRB) == 3;
            }

            if (prob == 5){
                $countones(WSTRB) == 4;
            }
        }   

        constraint wrn_const_normal {
            WRn dist {1'b1:/60, 1'b0:/40};
        }
        constraint wrn_const_read {
            WRn dist {1'b0:/95, 1'b1:/5};
        }
        constraint wrn_const_write {
            WRn dist {1'b0:/5, 1'b1:/95};
        }

        constraint pready_const {
            // PREADY dist {1'b1:/95, 1'b0:/5};
            PREADY == 1'b1;
        }

        constraint pslverr_const {
            if (PRESETn) {
                if (ADDR[1:0] != 0 || ADDR >= 32'hF ||
                    (ADDR == STATUS_REGISTER && WRn))
                    PSLVERR == 1'b1;
                else 
                    PSLVERR == 1'b0;
            }
        }

        constraint prdata_const {
            if (PRESETn && !PSLVERR){
                if (~WRn)
                    PRDATA == reg_file[ADDR];
                else 
                    PRDATA == 32'h0000_0000;
            }
            else 
                PRDATA == 32'h0000_0000;
        }

        constraint backToBack_normal_const {
            backToBack_r dist {1'b0:/99, 1'b1:/1};
        }
        constraint backToBack_btbseq_const {
            backToBack_r dist {1'b1:/80, 1'b0:/20};
        }

    endclass


endpackage : mstr_txn_pkg
