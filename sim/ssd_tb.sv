`timescale 1ns / 1ps

module ssd_tb();

  logic clk; // Input
  logic [3:0] btn; // Input
  logic [3:0] sw; // Input
  logic [3:0] led; // Output
  logic led_g; // Output
  logic [6:0] seg; // Output
  logic chip_sel; // Output
  wire  [7:0] keypad; // Inout - bidirectional signal from DUT

  reg [7:0] keypad_inout_drive;  // locally driven value
  logic [7:0] keypad_tb;  // locally received value (optional, but models typical pad)
  
  assign keypad = (!keypad_inout_drive) ? keypad_tb : 'bZ;
  //assign keypad_inout_recv = keypad;

// for inout port u can do something like this:

// module testbench;
// wire    bidir_port;
// reg     oe;

// assign bidir_port = (!oe) ? data_tx : 1'bZ;

// when oe is low, the bidir_port, bidir_port = data_tx.. which means u can write stuff into it.. when oe is HIGH, it becomes an output port..

  parameter CP = 20;

  // ssd_top ssd_uut (.*);

  ssd_top ssd_uut (
    .clk(clk),
    .btn(btn),
    .sw(sw),
    .led(led),
    .led_g(led_g),
    .seg(seg),
    .chip_sel(chip_sel),
    .keypad(keypad)
  );

  // Process made to toggle the clock every 5ns.
  always
  begin
    clk <= 1'b1;
    #(CP/2);
    clk <= 1'b0;
    #(CP/2);
  end

  // Simulation inputs.
  initial
  begin
    sw = 4'd0;
    keypad_tb = 8'd0;
    btn = 4'd1;
    #CP;
    btn = 4'd0;

    // sw = 4'd1;
    // #CP;

    keypad_tb = 8'b1011_1011;
    #(CP * 20000000);  
   keypad_tb = 8'b0111_0111;
   #(CP * 2);
  end

endmodule
