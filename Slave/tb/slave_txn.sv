package slave_txn_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;


    class slave_txn extends uvm_sequence_item;
        `uvm_object_utils(slave_txn)

        // IN to DUT
        rand logic PRESETn;
        rand logic [ADDR_WIDTH-1:0] PADDR;
        logic PSEL;
        logic PENABLE;
        rand logic PWRITE;
        rand logic [DATA_WIDTH-1:0] PWDATA;
        rand logic [(DATA_WIDTH/8)-1:0] PSTRB;

        // OUT from DUT
        logic PREADY;
        logic [DATA_WIDTH-1:0] PRDATA;
        logic PSLVERR;
       
        rand bit special;
        rand bit[2:0] prob;

        function new(string name = "slave_txn");
            super.new(name);
        endfunction


        constraint prestn_const {
            PRESETn dist {1'b1:/95, 1'b0:/5};
        }


        constraint paddr_const {
            PADDR dist {[DATA_REGISTER:CONFIG_REGISTER]:/95, [32'hF:$]:/5};
            PADDR[1:0] dist {2'b00:/95, [2'b01:$]:/5};
        }

        constraint pwrite_const_normal {
            PWRITE dist {1'b1:/75, 1'b0:/25};
        }
        constraint pwrite_const_read {
            PWRITE dist {1'b0:/95, 1'b1:/5};
        }
        constraint pwrite_const_write {
            PWRITE dist {1'b0:/5, 1'b1:/95};
        }


        constraint pwdata_const {
            special dist {1 := 95, 0 := 5};

            if (special)
                PWDATA inside {
                    32'h0000_0000,
                    32'hFFFF_FFFF,
                    32'hAAAA_AAAA,
                    32'h5555_5555,
                    32'h0000_FFFF,
                    32'hFFFF_0000
                };
            else
                !(PWDATA inside {
                    32'h0000_0000,
                    32'hFFFF_FFFF,
                    32'hAAAA_AAAA,
                    32'h5555_5555,
                    32'h0000_FFFF,
                    32'hFFFF_0000
                });
        }
        constraint pstrb_const {

            prob inside {[1:5]};

            if (prob == 1){
                $countones(PSTRB) == 0;
            }

            if (prob == 2){
                $countones(PSTRB) == 1;
            }

            if (prob == 3){
                $countones(PSTRB) == 2;
            }

            if (prob == 4){
                $countones(PSTRB) == 3;
            }

            if (prob == 5){
                $countones(PSTRB) == 4;
            }
        }



    endclass


endpackage : slave_txn_pkg