module apb_master #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)
(
    // Inputs from TB
    input wire PCLK,
    input wire PRESETn,

    input wire [DATA_WIDTH-1:0] WDATA,
    input wire [(DATA_WIDTH/8)-1:0] WSTRB,
    input wire [ADDR_WIDTH-1:0] ADDR,
    input wire [1:0] SEL, // SEL[0] for Slave 1, SEL[1] Slave 2
    input wire WRn, // 1 for Write, 0 for Read
    input wire EN, // Enable signal for the transaction

    // Outputs to TB
    output reg [DATA_WIDTH-1:0] DATA_OUT,

    // Outputs to Slave
    output wire [ADDR_WIDTH-1:0] PADDR,
    output wire PSEL1,
    output wire PSEL2,
    output reg PENABLE,
    output wire PWRITE,
    output wire [DATA_WIDTH-1:0] PWDATA,
    output wire [(DATA_WIDTH/8)-1:0] PSTRB,

    // Inputs From Slave
    input wire PREADY,
    input wire [DATA_WIDTH-1:0] PRDATA,
    input wire PSLVERR
);


    localparam STROBE_WIDTH = (DATA_WIDTH/8);

    // States
    localparam IDLE = 2'b00;
    localparam SETUP = 2'b01;
    localparam ACCESS = 2'b10;


    // State Transition Logic
    reg [1:0] cs, ns;

    always @(posedge PCLK or negedge PRESETn) begin
        if (~PRESETn) begin
            cs <= IDLE;
        end else begin
            cs <= ns;
        end
    end


    // Next State Logic
    always @(*) begin
        ns = cs; // Default to current state
        case (cs)
            IDLE: begin
                if (EN) ns = SETUP;
                else ns = IDLE;
            end
            SETUP: begin
                ns = ACCESS;
            end
            ACCESS: begin
                if (!EN) // No Other Transaction
                    begin
                        if (PREADY) ns = IDLE;
                        else ns = ACCESS; // Wait for PREADY
                    end
                else begin
                    if (PREADY) ns = SETUP; // New Transaction
                    else ns = ACCESS; // Wait for PREADY
                end
            end
        endcase
    end



    // Output Logic
    always @(*) begin
        PENABLE = 1'b0;
        DATA_OUT = {DATA_WIDTH{1'b0}};
        case (cs)
            IDLE: begin
            end  
            SETUP:
            begin
                // Setup Phase
                PENABLE = 1'b0; // Not yet enabled
            end
            ACCESS: 
            begin
                PENABLE = 1'b1; // Enable the transaction
                if (!WRn && !PSLVERR && PREADY) begin
                    DATA_OUT = PRDATA;
                end
            end
        endcase
    end

    assign PSEL1 = SEL[0];
    assign PSEL2 = SEL[1];
    assign PWRITE = WRn;
    assign PWDATA = WDATA;
    assign PSTRB = WSTRB;
    assign PADDR = ADDR;

endmodule