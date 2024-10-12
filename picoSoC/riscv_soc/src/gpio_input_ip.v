// Created with Corsair v1.0.4

module gpio_input_ip #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System
    input clk,
    input rst,
    // GPIO_1.DATA_IN
    input [15:0] csr_gpio_1_data_in_in,

    // Local Bus
    input  [ADDR_W-1:0] waddr,
    input  [DATA_W-1:0] wdata,
    input               wen,
    input  [STRB_W-1:0] wstrb,
    output              wready,
    input  [ADDR_W-1:0] raddr,
    input               ren,
    output [DATA_W-1:0] rdata,
    output              rvalid
);
//------------------------------------------------------------------------------
// CSR:
// [0x0] - GPIO_1 - General Purpose Register for Output
//------------------------------------------------------------------------------
wire [31:0] csr_gpio_1_rdata;
assign csr_gpio_1_rdata[15:0] = 16'h0;


wire csr_gpio_1_ren;
assign csr_gpio_1_ren = ren && (raddr == 32'h0);
reg csr_gpio_1_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_gpio_1_ren_ff <= 1'b0;
    end else begin
        csr_gpio_1_ren_ff <= csr_gpio_1_ren;
    end
end
//---------------------
// Bit field:
// GPIO_1[31:16] - DATA_IN - Data from GPIO inputs (e.g., switches)
// access: ro, hardware: i
//---------------------
reg [15:0] csr_gpio_1_data_in_ff;

assign csr_gpio_1_rdata[31:16] = csr_gpio_1_data_in_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_gpio_1_data_in_ff <= 16'h0;
    end else  begin
              begin            csr_gpio_1_data_in_ff <= csr_gpio_1_data_in_in;
        end
    end
end


//------------------------------------------------------------------------------
// Write ready
//------------------------------------------------------------------------------
assign wready = 1'b1;

//------------------------------------------------------------------------------
// Read address decoder
//------------------------------------------------------------------------------
reg [31:0] rdata_ff;
always @(posedge clk) begin
    if (rst) begin
        rdata_ff <= 32'h0;
    end else if (ren) begin
        case (raddr)
            32'h0: rdata_ff <= csr_gpio_1_rdata;
            default: rdata_ff <= 32'h0;
        endcase
    end else begin
        rdata_ff <= 32'h0;
    end
end
assign rdata = rdata_ff;

//------------------------------------------------------------------------------
// Read data valid
//------------------------------------------------------------------------------
reg rvalid_ff;
always @(posedge clk) begin
    if (rst) begin
        rvalid_ff <= 1'b0;
    end else if (ren && rvalid) begin
        rvalid_ff <= 1'b0;
    end else if (ren) begin
        rvalid_ff <= 1'b1;
    end
end

assign rvalid = rvalid_ff;

endmodule