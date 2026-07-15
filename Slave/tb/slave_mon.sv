package slave_mon_pkg;

    
    import uvm_pkg::*;
    `include "uvm_macros.svh"


    import slave_txn_pkg::*;


    class slave_mon extends uvm_monitor;
        `uvm_component_utils(slave_mon)

        slave_txn mon_txn;

        uvm_analysis_port #(slave_txn) ap;

        virtual slave_if slv_vif;




        function new (string name = "slave_mon", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            ap = new ("ap", this);

            if (!uvm_config_db#(virtual slave_if):: get (this,"", "slv_vif", slv_vif))
                `uvm_fatal(get_full_name(), "Monitor Cannot retrieve VIF")

        endfunction


        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                @(slv_vif.cb);
                if (~slv_vif.PRESETn) begin
                    mon_txn = slave_txn::type_id::create("mon_txn");
                    mon_txn.PRESETn  <= slv_vif.PRESETn;
                    #1step ap.write(mon_txn);
                end
                else if (slv_vif.PSEL && slv_vif.PENABLE && slv_vif.PREADY || !slv_vif.PRESETn) begin
                    mon_txn = slave_txn::type_id::create("mon_txn");

                    mon_txn.PADDR    <= slv_vif.PADDR;
                    mon_txn.PWRITE   <= slv_vif.PWRITE;
                    mon_txn.PSTRB    <= slv_vif.PSTRB;
                    mon_txn.PSLVERR  <= slv_vif.PSLVERR;

                    if (slv_vif.PWRITE)
                        mon_txn.PWDATA <= slv_vif.PWDATA;
                    else
                        mon_txn.PRDATA <= slv_vif.PRDATA;

                    #1step ap.write(mon_txn);
                end
            end
        endtask


    endclass
endpackage : slave_mon_pkg