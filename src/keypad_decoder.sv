`timescale 1ns / 1ps

module keypad_decoder(
    input clk,
    input rst,
    input [3:0] row,
    output [3:0] col,
    output [3:0] decode_out,
    output is_a_key_pressed
  );

  logic [19:0] sclk;
  logic [3:0] decode_reg;
  logic is_a_key_pressed_reg;

  always_ff @ (posedge clk, posedge rst)
  begin
    if (rst == 1'b1)
    begin
      decode_reg = 4'b0;
      is_a_key_pressed_reg = 1'b0;
    end
    else
    begin
        // 2ms
        if sclk = 20'd100000 begin
            col = 4'b0111;
            sclk = sclk + 1;
        end
        else if (sclk == 20'b100008) begin
            if (row == 4'b0111) begin
                decode_reg = 4'b0001; //1
                is_a_key_pressed_reg = 1'b1;
            end
            if (row == 4'b1011) begin
                decode_reg = 4'b0100; //4
                is_a_key_pressed_reg = 1'b1;
            end
            if (row == 4'b1101) begin
                decode_reg = 4'b0111; //7
                is_a_key_pressed_reg = 1'b1;
            end
            if (row == 4'b1110) begin
                decode_reg = 4'b0000; //0
                is_a_key_pressed_reg = 1'b1;
            end
        end
    end // end clk
  end // end always_ff

  assign is_a_key_pressed = is_a_key_pressed_reg;
  assign decode_out = decode_reg;

endmodule
