package mstr_mon_pkg;

    
    import uvm_pkg::*;
    `include "uvm_macros.svh"


    import mstr_txn_pkg::*;

    import shared_pkg::*;

    class mstr_mon extends uvm_monitor;
        `uvm_component_utils(mstr_mon)

        mstr_txn mon_txn;

        uvm_analysis_port #(mstr_txn) ap;

        virtual mstr_if mstr_vif;




        function new (string name = "mstr_mon", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            ap = new ("ap", this);

            if (!uvm_config_db#(virtual mstr_if):: get (this,"", "mstr_vif", mstr_vif))
                `uvm_fatal(get_full_name(), "Monitor Cannot retrieve VIF")

        endfunction


        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                    repeat(2) @(mstr_vif.cb);


                if (~mstr_vif.PRESETn) begin
                    mon_txn = mstr_txn::type_id::create("mon_txn");
                    mon_txn.PRESETn  <= mstr_vif.PRESETn;
                    #1step ap.write(mon_txn);
                end
                else if (mstr_vif.PREADY) begin
                    mon_txn = mstr_txn::type_id::create("mon_txn");

                    mon_txn.PADDR    <= mstr_vif.PADDR;
                    mon_txn.PSEL1    <= mstr_vif.PSEL1;
                    mon_txn.PSEL2    <= mstr_vif.PSEL2;
                    mon_txn.PENABLE  <= mstr_vif.PENABLE;
                    mon_txn.PWRITE   <= mstr_vif.PWRITE;
                    mon_txn.PWDATA   <= mstr_vif.PWDATA;
                    mon_txn.PSTRB    <= mstr_vif.PSTRB;
                    mon_txn.DATA_OUT <= mstr_vif.DATA_OUT;

                    mon_txn.ADDR     <= mstr_vif.ADDR;
                    mon_txn.SEL      <= mstr_vif.SEL;
                    mon_txn.WRn      <= mstr_vif.WRn;
                    mon_txn.EN       <= mstr_vif.EN;
                    mon_txn.WDATA    <= mstr_vif.WDATA;
                    mon_txn.WSTRB    <= mstr_vif.WSTRB;

                    mon_txn.PREADY   <= mstr_vif.PREADY;
                    mon_txn.PRDATA   <= mstr_vif.PRDATA;
                    mon_txn.PSLVERR  <= mstr_vif.PSLVERR;

                    #1step ap.write(mon_txn);
                end
                if (backToBack == 1'b0)
                    @(mstr_vif.cb);
            end
        endtask


    endclass
endpackage : mstr_mon_pkg
