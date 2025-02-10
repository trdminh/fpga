module uart_rx #(
    parameter clk_freq_hz = 30 * 1000000, // 30 MHz
    parameter baud_rate = 115200
)(
    input wire i_clk,
    input wire i_rst,
    input wire i_uart_rx,
    output reg [7:0] o_data,
    output reg o_valid
);

    localparam START_VALUE = clk_freq_hz / baud_rate;
    localparam WIDTH = $clog2(START_VALUE);
    localparam MID_SAMPLE = START_VALUE / 2; // Middle of a baud period
    
    reg [WIDTH:0] cnt;
    reg [3:0] bit_idx;
    reg [9:0] shift_reg;
    reg sampling;

    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            cnt <= 0;
            bit_idx <= 0;
            shift_reg <= 10'b1111111111; // Idle state (UART line is high when idle)
            sampling <= 0;
            o_valid <= 0;
        end else begin
            if (!sampling) begin
                // Detect start bit (falling edge)
                if (!i_uart_rx) begin
                    sampling <= 1;
                    cnt <= MID_SAMPLE;
                    bit_idx <= 0;
                end
            end else begin
                if (cnt == 0) begin
                    cnt <= START_VALUE - 1;
                    shift_reg <= {i_uart_rx, shift_reg[9:1]};
                    bit_idx <= bit_idx + 1;
                    
                    if (bit_idx == 9) begin // Stop bit received
                        sampling <= 0;
                        if (shift_reg[9] && !shift_reg[0]) begin // Stop & Start bits valid
                            o_data <= shift_reg[8:1];
                            o_valid <= 1;
                        end
                    end
                end else begin
                    cnt <= cnt - 1;
                end
            end
        end
    end
endmodule
