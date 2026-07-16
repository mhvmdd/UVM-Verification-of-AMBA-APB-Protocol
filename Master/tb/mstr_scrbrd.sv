package mstr_scrbrd_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;

    import mstr_txn_pkg::*;


    class mstr_scrbrd extends uvm_scoreboard;
        `uvm_component_utils(mstr_scrbrd)

        mstr_txn scrbrd_txn;

        uvm_analysis_imp #(mstr_txn, mstr_scrbrd) imp;


        function new (string name = "mstr_scrbrd", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            imp = new("imp", this);

            scrbrd_txn = mstr_txn::type_id::create("scrbrd_txn");

        endfunction

function void write (mstr_txn t);
    if (t.PRESETn) begin
        if (t.PADDR != t.ADDR)
            `uvm_error("MSTR_scoreboard", $sformatf("PADDR: %h != ADDR: %h", t.PADDR, t.ADDR))

        if (t.PSEL1 != t.SEL[0])
            `uvm_error("MSTR_scoreboard", $sformatf("PSEL1: %b != SEL[0]: %b", t.PSEL1, t.SEL[0]))

        if (t.PSEL2 != t.SEL[1])
            `uvm_error("MSTR_scoreboard", $sformatf("PSEL2: %b != SEL[1]: %b", t.PSEL2, t.SEL[1]))

        if (t.PWRITE != t.WRn)
            `uvm_error("MSTR_scoreboard", $sformatf("PWRITE: %b != WRn: %b", t.PWRITE, t.WRn))

        if (t.PWDATA != t.WDATA)
            `uvm_error("MSTR_scoreboard", $sformatf("PWDATA: %h != WDATA: %h", t.PWDATA, t.WDATA))

        if (t.PSTRB != t.WSTRB)
            `uvm_error("MSTR_scoreboard", $sformatf("PSTRB: %b != WSTRB: %b", t.PSTRB, t.WSTRB))

        if (!t.PENABLE)
            `uvm_error("MSTR_scoreboard", "PENABLE should be 1 during access phase")

        if (!t.WRn && !t.PSLVERR) begin
            if (t.DATA_OUT != t.PRDATA)
                `uvm_error("MSTR_scoreboard", $sformatf("DATA_OUT: %h != PRDATA: %h", t.DATA_OUT, t.PRDATA))
        end
        else begin
            if (t.DATA_OUT != {DATA_WIDTH{1'b0}})
                `uvm_error("MSTR_scoreboard", $sformatf("DATA_OUT should be 0, got: %h", t.DATA_OUT))
        end
    end
endfunction
    endclass


endpackage : mstr_scrbrd_pkg
