//
// Copyright (C) 2019 Chris McClelland
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
// Single-clock block-RAM with eight byte-enables. It would be good if this number eight could be
// parameterized, but Quartus 16.1 refuses to infer altsyncram blocks if so.
//
module ram_sc_be#(
    parameter int ADDR_NBITS = 5,  // default 32 rows
    parameter int SPAN_NBITS = 8,  // each span is one byte
    parameter int NUM_SPANS = 8    // each row is eight bytes
  )(
    input  logic                                    clk_in,

    input  logic[NUM_SPANS-1 : 0]                   wrMask_in,
    input  logic[ADDR_NBITS-1 : 0]                  wrAddr_in,
    input  logic[NUM_SPANS-1 : 0][SPAN_NBITS-1 : 0] wrData_in,

    input  logic[ADDR_NBITS-1 : 0]                  rdAddr_in,
    output logic[NUM_SPANS-1 : 0][SPAN_NBITS-1 : 0] rdData_out
  );
  typedef logic[SPAN_NBITS-1 : 0] Span;  // one Span is SPAN_NBITS x 1-bit
  typedef Span[NUM_SPANS-1 : 0] Row;     // one Row is NUM_SPANS x Span
  Row[0 : 2**ADDR_NBITS-1] memArray = '0;

  always_ff @(posedge clk_in) begin: infer_regs
    if (^wrAddr_in !== 1'bX) begin
      for (int i = 0; i < NUM_SPANS; i = i + 1) begin
        if (wrMask_in[i])
          memArray[wrAddr_in][i] <= wrData_in[i];
      end
    end
    if (^rdAddr_in !== 1'bX)
      rdData_out <= memArray[rdAddr_in];
    else
      rdData_out <= 'X;
  end
endmodule
