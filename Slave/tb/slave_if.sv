interface slave_if (input logic PCLK);

    import shared_pkg::*;

    logic PRESETn;
    logic [ADDR_WIDTH-1:0] PADDR;
    logic PSEL;
    logic PENABLE;
    logic PWRITE;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic [(DATA_WIDTH/8)-1:0] PSTRB;
    // Outputs to Master
    logic PREADY;
    logic [DATA_WIDTH-1:0] PRDATA;
    logic PSLVERR;

    clocking cb @(posedge PCLK);
        default input #1step output #0;

        output PRESETn;
        output PADDR;
        output PSEL;
        output PENABLE;
        output PWRITE;
        output PWDATA;
        output PSTRB;
        // Outputs to Master
        input PREADY;
        input PRDATA;
        input PSLVERR;

    endclocking


    // APB BFM

    // task apb_bfm (input logic [DATA_WIDTH-1:0] wdata, input logic [ADDR_WIDTH-1:0] addr, input logic rstn, );

    // endtask


endinterface