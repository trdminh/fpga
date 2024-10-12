// Created with Corsair v1.0.4

module gpio_output_ip #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System
    input clk,
    input rst,
    // GPIO_0.DATA_OUT
    output [15:0] csr_gpio_0_data_out_out,

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
// [0x0] - GPIO_0 - General Purpose Register for Output
//------------------------------------------------------------------------------
wire [31:0] csr_gpio_0_rdata;
assign csr_gpio_0_rdata[31:16] = 16'h0;

wire csr_gpio_0_wen;
assign csr_gpio_0_wen = wen && (waddr == 32'h0);

wire csr_gpio_0_ren;
assign csr_gpio_0_ren = ren && (raddr == 32'h0);
reg csr_gpio_0_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_gpio_0_ren_ff <= 1'b0;
    end else begin
        csr_gpio_0_ren_ff <= csr_gpio_0_ren;
    end
end
//---------------------
// Bit field:
// GPIO_0[15:0] - DATA_OUT - Data to send to GPIO outputs (e.g., LEDs)
// access: rw, hardware: o
//---------------------
reg [15:0] csr_gpio_0_data_out_ff;

assign csr_gpio_0_rdata[15:0] = csr_gpio_0_data_out_ff;

assign csr_gpio_0_data_out_out = csr_gpio_0_data_out_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_gpio_0_data_out_ff <= 16'h0;
    end else  begin
     if (csr_gpio_0_wen) begin
            if (wstrb[0]) begin
                csr_gpio_0_data_out_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_gpio_0_data_out_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_gpio_0_data_out_ff <= csr_gpio_0_data_out_ff;
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
            32'h0: rdata_ff <= csr_gpio_0_rdata;
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