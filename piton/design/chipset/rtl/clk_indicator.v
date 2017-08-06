`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2017/08/02 09:27:46
// Module Name: clk_indicator
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//   A simple clk status indicator. Connect the output to a LED.
//
// Dependencies:
//   None.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module clk_indicator
    #(parameter DIVISOR_WIDTH = 24)
    (input wire                     clk,
    input wire                      reset_n,

    output wire                     led_blink);

    reg[DIVISOR_WIDTH-1:0]          div_cnt;

    assign led_blink = div_cnt[DIVISOR_WIDTH-1];

    always @(posedge clk) begin
        if (!reset_n) begin
            div_cnt <= 0;
        end
        else begin
            div_cnt <= div_cnt + 1;
        end
    end

endmodule
