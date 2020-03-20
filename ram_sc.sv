//
// Copyright (C) 2020 Chris McClelland
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright  notice and this permission notice  shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// Single-clock block-RAM.
//
module makestuff_ram_sc#(
    parameter int ADDR_NBITS = 5,  // default 32 rows
    parameter int DATA_NBITS = 16  // each row is 16 bits wide
  )(
    input  logic                   clk_in,

    input  logic                   wrEnable_in,
    input  logic[ADDR_NBITS-1 : 0] wrAddr_in,
    input  logic[DATA_NBITS-1 : 0] wrData_in,

    input  logic[ADDR_NBITS-1 : 0] rdAddr_in,
    output logic[DATA_NBITS-1 : 0] rdData_out
  );
  typedef logic[DATA_NBITS-1 : 0] Data;
  Data[0 : 2**ADDR_NBITS-1] memArray = '0;

  always_ff @(posedge clk_in) begin: infer_regs
    if (^wrAddr_in !== 1'bX) begin
      if (wrEnable_in)
        memArray[wrAddr_in] <= wrData_in;
    end
    if (^rdAddr_in !== 1'bX)
      rdData_out <= memArray[rdAddr_in];
    else
      rdData_out <= 'X;
  end
endmodule
