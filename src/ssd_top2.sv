`timescale 1ns / 1ps

module ssd_top2(
    input clk,
    input [3:0] btn,
    output [3:0] led,
    output led_g,
    output [6:0] seg,
    output chip_sel,
    inout [7:0] keypad
  );

  parameter clk_freq = 50_000_000;
  parameter stable_time = 2; // ms

  logic rst;
  logic [6:0] seg_reg;
  logic [7:0] keypad_w;
  logic c_sel;
  logic c_sel_pulse;
  logic is_a_key_pressed;
  logic is_a_key_pressed_db;
  logic is_a_key_pressed_pulse;
  logic [3:0] decode_out;

  keypad_decoder de_inst1(
                   .clk(clk),
                   .rst(rst),
                   .row(keypad[7:4]),
                   .col(keypad[3:0]),
                   .decode_out(decode_out), // Pass to SSD Controller
                   .is_a_key_pressed(is_a_key_pressed));

  disp_ctrl ssd_1(
              .disp_val(decode_out),
              .seg_out(output_ssd));

  debounce  #(
              .clk_freq(clk_freq),
              .stable_time(stable_time)
            )
            db_inst_1
            (
              .clk(clk),
              .rst(rst),
              .button(is_a_key_pressed),
              .result(is_a_key_pressed_db));

  single_pulse_detector #(
                          .detect_type(2'b0)
                        )
                        pls_inst_1 (
                          .clk(clk),
                          .rst(rst),
                          .input_signal(is_a_key_pressed_db),
                          .output_pulse(is_a_key_pressed_pulse));

  pulse_gen pg_inst1(
              .clk(clk),
              .rst(rst),
              .pulse(c_sel_pulse)
            );

  always_ff @(posedge clk, posedge rst)
  begin
    if (rst == 1)
    begin
      c_sel = 1'b0;
    end
    else
    begin
      if (c_sel_pulse == 1'b1)
      begin
        c_sel = ~c_sel;
      end
    end
  end

   always_ff @ (posedge clk, posedge rst)
  begin
    if (rst == 1)
    begin
      key_press <= 0;
      decode1 <= 4'b0;
      decode2 <= 4'b0;
    end
    else
    begin
      if (is_a_key_pressed_pulse)
      begin
        key_press <= ~key_press;
      end
      if (~key_press)
      begin
        decode1 <= decode_out;
      end
      else
      begin
        decode2 <= decode_out;
      end
    end
  end

  // assign c_sel = clk ? 1'b1 : 1'b0;
  // //assign seg = seg_reg;
  // assign seg = c_sel ? 7'b1111110 : 7'b1101101;
  // assign led_g = is_a_key_pressed;
  // assign rst = btn[0];
  // assign led = decode_out;
  assign chip_sel = c_sel;

endmodule
