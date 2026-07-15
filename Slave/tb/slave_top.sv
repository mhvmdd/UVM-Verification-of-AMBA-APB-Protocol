module slave_top;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shared_pkg ::*;

import slave_test_pkg ::*;

    // CLK GEN
    bit PCLK;
    always #5 PCLK = ~PCLK;

    // Interface
    slave_if slv_if (PCLK);

    // DUT
    apb_slave 
    #(
        .DATA_WIDTH(DATA_WIDTH), 
        .ADDR_WIDTH(ADDR_WIDTH)
    )
    DUT 
    (
        .PCLK(PCLK),
        .PRESETn(slv_if.PRESETn),

        .PADDR(slv_if.PADDR),
        .PSEL(slv_if.PSEL),
        .PENABLE(slv_if.PENABLE),
        .PWRITE(slv_if.PWRITE),
        .PWDATA(slv_if.PWDATA),
        .PSTRB(slv_if.PSTRB),

        .PREADY(slv_if.PREADY),
        .PRDATA(slv_if.PRDATA),
        .PSLVERR(slv_if.PSLVERR)
    );




initial begin
    uvm_config_db #(virtual slave_if) :: set (null,"uvm_test_top", "slv_vif", slv_if);
    run_test("slave_test"); 
end


endmodule 