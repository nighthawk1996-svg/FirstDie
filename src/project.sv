/*
 * Copyright (c) 2024 Jacob Metoxen
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

// Hex-to-seven-segment display decoder (active-high, common-cathode).
// ui_in[3:0] = hex digit (0-F), ui_in[4] = decimal point passthrough.
// uo_out[6:0] = segments a-g, uo_out[7] = decimal point.
module tt_um_nighthawk1996_svg_FirstDie (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  logic [3:0] digit;
  logic [6:0] segments;

  assign digit = ui_in[3:0];

  always_comb begin
    unique case (digit)
      4'h0:    segments = 7'h3F;
      4'h1:    segments = 7'h06;
      4'h2:    segments = 7'h5B;
      4'h3:    segments = 7'h4F;
      4'h4:    segments = 7'h66;
      4'h5:    segments = 7'h6D;
      4'h6:    segments = 7'h7D;
      4'h7:    segments = 7'h07;
      4'h8:    segments = 7'h7F;
      4'h9:    segments = 7'h6F;
      4'hA:    segments = 7'h77;
      4'hB:    segments = 7'h7C;
      4'hC:    segments = 7'h39;
      4'hD:    segments = 7'h5E;
      4'hE:    segments = 7'h79;
      4'hF:    segments = 7'h71;
      default: segments = 7'h00;
    endcase
  end

  assign uo_out  = {ui_in[4], segments};
  assign uio_out = '0;
  assign uio_oe  = '0;

  // List all unused inputs to prevent warnings
  logic _unused;
  assign _unused = &{ena, clk, rst_n, uio_in, ui_in[7:5], 1'b0};

endmodule
