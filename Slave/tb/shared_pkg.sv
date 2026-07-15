package shared_pkg;
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 32;


    typedef bit [ADDR_WIDTH-1:0] addr_t; 
    typedef enum addr_t {DATA_REGISTER = 32'h0000_0000, STATUS_REGISTER = 32'h0000_0004, CONTROL_REGISTER = 32'h0000_0008, CONFIG_REGISTER = 32'h0000_000C} addr_e;
endpackage : shared_pkg