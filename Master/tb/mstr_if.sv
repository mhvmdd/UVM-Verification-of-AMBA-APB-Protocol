interface mstr_if (input logic PCLK);

    import shared_pkg::*;

    logic PRESETn;
    logic [DATA_WIDTH-1:0] WDATA;
    logic [(DATA_WIDTH/8)-1:0] WSTRB;
    logic [ADDR_WIDTH-1:0] ADDR;
    logic [1:0]SEL;
    logic WRn;
    logic EN;

    // Outputs from DUT to TB
    logic [DATA_WIDTH-1:0] DATA_OUT;

    // Outputs from DUT to Slave
    logic [ADDR_WIDTH-1:0] PADDR;
    logic PSEL1;
    logic PSEL2;
    logic PENABLE;
    logic PWRITE;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic [(DATA_WIDTH/8)-1:0] PSTRB;

    // Inputs from Slave
    logic PREADY;
    logic [DATA_WIDTH-1:0] PRDATA;
    logic PSLVERR;

    clocking cb @(posedge PCLK);
        default input #1step output #1step;

        output PRESETn;
        output WDATA;
        output WSTRB;
        output ADDR;
        output SEL;
        output WRn;
        output EN;

        // Outputs from DUT to TB
        input DATA_OUT;

        // Outputs from DUT to Slave
        input PADDR;
        input PSEL1;
        input PSEL2;
        input PENABLE;
        input PWRITE;
        input PWDATA;
        input PSTRB;

        // Inputs from Slave
        output PREADY;
        output PRDATA;
        output PSLVERR;

    endclocking


endinterface
