<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is a combinational hex-to-seven-segment display decoder.

- `ui_in[3:0]` selects a hex digit from 0x0 to 0xF.
- `ui_in[4]` is a decimal-point passthrough.
- `uo_out[6:0]` drives the seven segments (a-g), active-high, for a common-cathode display.
- `uo_out[7]` drives the decimal point segment, mirroring `ui_in[4]`.
- `uio_in`/`uio_out` are unused (`uio_oe` is tied to 0, so `uio` pins are inputs and ignored).

The output updates combinationally, with no dependency on `clk` or `rst_n`.

## How to test

Drive `ui_in[3:0]` with a 4-bit value (0-15) and observe `uo_out[6:0]` match the
standard seven-segment encoding for that hex digit (e.g. `ui_in = 4'h0` produces
`uo_out[6:0] = 0x3F`, all segments except `g` lit). Toggle `ui_in[4]` to check the
decimal point on `uo_out[7]`. See `test/test.py` for the full expected segment
table and automated checks across all 16 digits.

## External hardware

None required. Optionally connect `uo_out[6:0]` (and `uo_out[7]` for the decimal
point) to a common-cathode seven-segment display through current-limiting
resistors.
