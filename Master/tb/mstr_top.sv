module mstr_top;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shared_pkg ::*;

import mstr_test_pkg ::*;

    // CLK GEN
    bit PCLK;
    always #5 PCLK = ~PCLK;

    // Interface
    mstr_if mstr_if_inst (PCLK);

    // DUT
    apb_master 
    #(
        .DATA_WIDTH(DATA_WIDTH), 
        .ADDR_WIDTH(ADDR_WIDTH)
    )
    DUT 
    (
        .PCLK(PCLK),
        .PRESETn(mstr_if_inst.PRESETn),

        .WDATA(mstr_if_inst.WDATA),
        .WSTRB(mstr_if_inst.WSTRB),
        .ADDR(mstr_if_inst.ADDR),
        .SEL(mstr_if_inst.SEL),
        .WRn(mstr_if_inst.WRn),
        .EN(mstr_if_inst.EN),

        .DATA_OUT(mstr_if_inst.DATA_OUT),

        .PADDR(mstr_if_inst.PADDR),
        .PSEL1(mstr_if_inst.PSEL1),
        .PSEL2(mstr_if_inst.PSEL2),
        .PENABLE(mstr_if_inst.PENABLE),
        .PWRITE(mstr_if_inst.PWRITE),
        .PWDATA(mstr_if_inst.PWDATA),
        .PSTRB(mstr_if_inst.PSTRB),

        .PREADY(mstr_if_inst.PREADY),
        .PRDATA(mstr_if_inst.PRDATA),
        .PSLVERR(mstr_if_inst.PSLVERR)
    );




initial begin
    uvm_config_db #(virtual mstr_if) :: set (null,"uvm_test_top", "mstr_vif", mstr_if_inst);
    run_test("mstr_test"); 
end


endmodule 
