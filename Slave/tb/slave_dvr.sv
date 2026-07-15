package slave_dvr_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import slave_txn_pkg::*;


    class slave_dvr extends uvm_driver #(slave_txn);
        `uvm_component_utils(slave_dvr)

        slave_txn dvr_txn;
        
        virtual slave_if slv_vif;


        function new (string name = "slave_dvr", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            dvr_txn = slave_txn::type_id::create("dvr_txn");

            if (!uvm_config_db#(virtual slave_if):: get (this,"", "slv_vif", slv_vif))
                `uvm_fatal(get_full_name(), "Driver Cannot retrieve VIF")

        endfunction


        task run_phase (uvm_phase phase);
            super.run_phase(phase);

            forever begin
                seq_item_port.get_next_item(dvr_txn);
                
                // if (!dvr_txn.PRESETn) begin
                //     PRESETn
                // end


                slv_vif.cb.PRESETn <= dvr_txn.PRESETn;
                slv_vif.cb.PADDR <= dvr_txn.PADDR;
                slv_vif.cb.PWRITE <= dvr_txn.PWRITE;
                slv_vif.cb.PWDATA <= dvr_txn.PWDATA;
                slv_vif.cb.PSTRB <= dvr_txn.PSTRB;
                slv_vif.cb.PSEL <= 1'b1;
                slv_vif.cb.PENABLE <= 1'b0;

                @(slv_vif.cb)

                slv_vif.cb.PENABLE <= 1'b1;

                @(slv_vif.cb)

                slv_vif.cb.PSEL <= 1'b0;
                slv_vif.cb.PENABLE <= 1'b0;


                @(slv_vif.cb)
                seq_item_port.item_done();
            end
        endtask 


    endclass

endpackage