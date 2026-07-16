package mstr_sub_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;

    import mstr_txn_pkg::*;


    class mstr_sub extends uvm_subscriber #(mstr_txn);
        `uvm_component_utils(mstr_sub)

        mstr_txn sub_txn;

            covergroup master_cg;
                en_cp: coverpoint sub_txn.EN {
                    bins zero_bin = {1'b0};
                    bins one_bin = {1'b1};
                }

                penable_cp: coverpoint sub_txn.PENABLE {
                    bins zero_bin = {1'b0};
                    bins one_bin = {1'b1};
                }

                en_cross: cross en_cp, penable_cp {
                    ignore_bins zero = binsof(en_cp.one_bin) && binsof(penable_cp.zero_bin);
                }


                sel_cp: coverpoint sub_txn.SEL{
                    bins comb_bins [] = {[2'b00:$]};
                }

                psel1_cp: coverpoint sub_txn.PSEL1 {
                    bins zero_bin = {1'b0};
                    bins one_bin = {1'b1};
                }

                psel2_cp: coverpoint sub_txn.PSEL2 {
                    bins zero_bin = {1'b0};
                    bins one_bin = {1'b1};
                }

                cross psel1_cp, psel2_cp;
                cross psel1_cp, psel2_cp, penable_cp;
                
                pwrite_cp: coverpoint sub_txn.PWRITE {
                    bins read_bin           = {1'b0};
                    bins write_bin          = {1'b1};
                }

                paddr_cp: coverpoint sub_txn.PADDR {
                    bins status_addr_bin    = {STATUS_REGISTER};
                    bins data_addr_bin      = {DATA_REGISTER};
                    bins ctrl_addr_bin      = {CONTROL_REGISTER};
                    bins cfg_addr_bin       = {CONFIG_REGISTER};

                    bins other_bin = {[32'hF:$]};
                }

                pwdata_cp: coverpoint sub_txn.PWDATA {
                    bins zero_bin           = {32'h0000_0000};
                    bins max_bin            = {32'hFFFF_FFFF};
                    bins pattern_bins[]     = {32'h0000_0000, 32'hFFFF_FFFF, 32'hAAAA_AAAA, 32'h5555_5555, 32'h0000_FFFF, 32'hFFFF_0000};

                    bins other = default;
                }

                wdata_cp: coverpoint sub_txn.WDATA {
                    bins zero_bin           = {32'h0000_0000};
                    bins max_bin            = {32'hFFFF_FFFF};
                    bins pattern_bins[]     = {32'h0000_0000, 32'hFFFF_FFFF, 32'hAAAA_AAAA, 32'h5555_5555, 32'h0000_FFFF, 32'hFFFF_0000};

                    bins other = default;
                }

                prdata_cp: coverpoint sub_txn.PRDATA {
                    bins zero_bin           = {32'h0000_0000};
                    bins max_bin            = {32'hFFFF_FFFF};
                    bins pattern_bins[]     = {32'h0000_0000, 32'hFFFF_FFFF, 32'hAAAA_AAAA, 32'h5555_5555, 32'h0000_FFFF, 32'hFFFF_0000};
                    bins rest_value         = {32'h0000_0000};
                    bins rest_value_status  = {32'h0000_0012};
                    bins other = default;
                }

                dataout_cp: coverpoint sub_txn.DATA_OUT {
                    bins zero_bin           = {32'h0000_0000};
                    bins max_bin            = {32'hFFFF_FFFF};
                    bins pattern_bins[]     = {32'h0000_0000, 32'hFFFF_FFFF, 32'hAAAA_AAAA, 32'h5555_5555, 32'h0000_FFFF, 32'hFFFF_0000};
                    bins rest_value         = {32'h0000_0000};
                    bins rest_value_status  = {32'h0000_0012};
                    bins other = default;
                }

                pstrb_cp: coverpoint sub_txn.PSTRB{
                    bins zeroByte_bin       = {4'b0000};
                    bins oneByte_bins[]     = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
                    bins twoByte_bins[]     = {4'b0011, 4'b0110, 4'b1100};
                    bins threeByte_bins[]   = {4'b0111, 4'b1110};
                    bins fourBytes_bin      = {4'b1111};
                }

                pslverr_cp: coverpoint sub_txn.PSLVERR {
                    bins zero_bin           = {1'b0};
                    bins one_bin            = {1'b1};

                    bins trans_bins         = (1'b0,1'b1 => 1'b0, 1'b1);
                }

                cross pwrite_cp, paddr_cp;
                cross paddr_cp, pwdata_cp;
                cross paddr_cp, prdata_cp {
                    ignore_bins ig_bin1 = binsof (paddr_cp.other_bin) && (!binsof (prdata_cp.rest_value));
                    ignore_bins ig_bin2 = binsof (paddr_cp.status_addr_bin) && (!binsof(prdata_cp.rest_value_status));
                    ignore_bins ig_bin3 = binsof (prdata_cp.rest_value_status) && (!binsof(paddr_cp.status_addr_bin));
                }
                
                cross paddr_cp, pstrb_cp;

                cross paddr_cp, pslverr_cp{
                    bins zero_err = binsof(pslverr_cp.zero_bin) && (!binsof(paddr_cp.other_bin));
                    bins err = binsof(pslverr_cp.one_bin) && (binsof(paddr_cp.other_bin));
                    ignore_bins ig_bin1 = binsof(pslverr_cp.zero_bin) && (binsof(paddr_cp.other_bin));
                    ignore_bins ig_bin2 = binsof(pslverr_cp.one_bin) && (!binsof(paddr_cp.other_bin));
                }

            endgroup


        function new (string name = "mstr_sub", uvm_component parent = null);
            super.new(name, parent);
            master_cg = new;
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            sub_txn = mstr_txn::type_id::create("sub_txn");
        endfunction

        function void write (mstr_txn t);
            sub_txn = t;
            master_cg.sample();
        endfunction
    endclass


endpackage : mstr_sub_pkg
