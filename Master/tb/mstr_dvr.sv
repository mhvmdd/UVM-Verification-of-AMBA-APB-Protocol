package mstr_dvr_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import mstr_txn_pkg::*;

    import shared_pkg::*;

    class mstr_dvr extends uvm_driver #(mstr_txn);
        `uvm_component_utils(mstr_dvr)

        mstr_txn dvr_txn;
        
        virtual mstr_if mstr_vif;


        function new (string name = "mstr_dvr", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            dvr_txn = mstr_txn::type_id::create("dvr_txn");

            if (!uvm_config_db#(virtual mstr_if):: get (this,"", "mstr_vif", mstr_vif))
                `uvm_fatal(get_full_name(), "Driver Cannot retrieve VIF")

        endfunction


        task run_phase (uvm_phase phase);
            super.run_phase(phase);

            forever begin
                seq_item_port.get_next_item(dvr_txn);
                
                mstr_vif.cb.PRESETn <= dvr_txn.PRESETn;
                mstr_vif.cb.WDATA <= dvr_txn.WDATA;
                mstr_vif.cb.WSTRB <= dvr_txn.WSTRB;
                mstr_vif.cb.ADDR <= dvr_txn.ADDR;
                mstr_vif.cb.SEL <= dvr_txn.SEL;
                mstr_vif.cb.WRn <= dvr_txn.WRn;
                mstr_vif.cb.EN <= 1'b1;

                mstr_vif.cb.PREADY <= dvr_txn.PREADY;
                mstr_vif.cb.PRDATA <= dvr_txn.PRDATA;
                mstr_vif.cb.PSLVERR <= dvr_txn.PSLVERR;

                @(mstr_vif.cb);

                if (backToBack == 1'b0) begin
                    mstr_vif.cb.EN <= 1'b0;
                    @(mstr_vif.cb);
                end

                @(mstr_vif.cb);
                
                seq_item_port.item_done();
            end
        endtask 


    endclass

endpackage
