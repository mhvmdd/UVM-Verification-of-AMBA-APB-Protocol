package slave_scrbrd_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;

    import slave_txn_pkg::*;


    class slave_scrbrd extends uvm_scoreboard;
        `uvm_component_utils(slave_scrbrd)

        slave_txn scrbrd_txn;

        uvm_analysis_imp #(slave_txn, slave_scrbrd) imp;


        int reg_file [int] = '{
            CONTROL_REGISTER: 32'h0000_0000,
            STATUS_REGISTER: 32'h0000_0012,
            DATA_REGISTER: 32'h0000_0000,
            CONFIG_REGISTER: 32'h0000_0000
            };

        function new (string name = "slave_scrbrd", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            imp = new("imp", this);

            scrbrd_txn = slave_txn::type_id::create("scrbrd_txn");

        endfunction

        function void write (slave_txn t);
            if (~t.PRESETn) begin
                reg_file[CONTROL_REGISTER]   = 32'h0000_0000;
                reg_file[STATUS_REGISTER]    = 32'h0000_0012;
                reg_file[DATA_REGISTER]      = 32'h0000_0000;
                reg_file[CONFIG_REGISTER]    = 32'h0000_0000;
            end
            else if (t.PWRITE) begin
                    if (t.PADDR <= CONFIG_REGISTER && t.PADDR[1:0] == 2'b00 && t.PADDR != STATUS_REGISTER) begin
                        for (int i = 0 ; i < (DATA_WIDTH/8) ; i++) begin
                            if (t.PSTRB[i])
                                reg_file[t.PADDR] [(i*8)+:8] = t.PWDATA [(i*8)+:8];
                        end
                    end 
                    else begin
                        if (!t.PSLVERR)
                            `uvm_error("SLAVE_scoreboard", $sformatf("SLVERR is not asserted Correctly , PSLVERR Data: %h PADDR: %h", t.PSLVERR, t.PADDR))
                    end
                end
                else if (~t.PWRITE) begin
                    if (t.PADDR <= CONFIG_REGISTER && t.PADDR[1:0] == 2'b00) begin
                        if (reg_file[t.PADDR] != t.PRDATA)
                            `uvm_error("SLAVE_scoreboard", $sformatf("Actual Data: %h Not Equal Expected: %h, PADDR: %h", t.PRDATA, reg_file[t.PADDR], t.PADDR))
                    end
                    else begin
                        if (!t.PSLVERR)
                            `uvm_error("SLAVE_scoreboard", $sformatf("SLVERR is not asserted Correctly , PSLVERR Data: %h PADDR: %h", t.PSLVERR, t.PADDR))
                    end
                end
        endfunction
    endclass


endpackage : slave_scrbrd_pkg