`timescale 1ns / 1ps

module ssd_top(
    input clk,
    input [3:0] btn,
    input [3:0] sw,
    output [3:0] led,
    output [6:0] seg,
    output chip_sel,
    inout [7:0] keypad
  );

  parameter clk_freq = 125_000_000;
  parameter stable_time = 10; // ms

  logic rst;

  logic btn1_debounce;
  logic btn1_pulse;
  logic [7:0] keypad_w;
  logic c_sel;
  logic is_a_key_pressed;
  logic [3:0] decode_out;
  assign rst = btn[0];
  //assign keypad_w =
  // State for the left and the right

  keypad_decoder de_inst1(
                   .clk(clk),
                   .rst(rst),
                   .row(keypad[7:4]),
                   .col(keypad[3:0]),
                   .decode_out(decode_out), // Pass to SSD Controller
                   .is_a_key_pressed(is_a_key_pressed));

  disp_ctrl ssd_i(
              //.disp_val(sw),
              .disp_val(decode_out),
              .seg_out(seg));

  debounce  #(
              .clk_freq(clk_freq),
              .stable_time(stable_time)
            )
            db_inst_1
            (
              .clk(clk),
              .rst(rst),
              .button(btn[1]),
              .result(btn1_debounce));

  single_pulse_detector #(
                          .detect_type(2'b0)
                        )
                        pls_inst_1 (
                          .clk(clk),
                          .rst(rst),
                          .input_signal(btn1_debounce),
                          .output_pulse(btn1_pulse));

  always_latch @(posedge rst, posedge btn1_pulse)
  begin
    if (rst ==1)
    begin
      c_sel = 1'b0;
    end
    else if (btn1_pulse == 1'b1)
    begin
      c_sel = ~c_sel;
    end
  end

  assign led = decode_out;
  assign chip_sel = c_sel;

endmodule
