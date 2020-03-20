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
`timescale 1ps / 1ps

module ram_sc_tb;

  localparam int CLK_PERIOD = 10;
  `include "clocking-util.svh"

  localparam string NAME = $sformatf("ram_sc_tb");
  `include "svunit-util.svh"

  localparam int ADDR_NBITS = 5;  // i.e 2^5 = 32 addressible rows
  localparam int DATA_NBITS = 32;
  typedef logic[ADDR_NBITS-1 : 0] Addr;
  typedef logic[DATA_NBITS-1 : 0] Data;
  localparam Data XXX = 'X;

  Data wrData, rdData;
  Addr wrAddr, rdAddr;
  logic wrEnable;

  makestuff_ram_sc#(ADDR_NBITS, DATA_NBITS) uut(
    sysClk,
    wrEnable, wrAddr, wrData,  // write side
    rdAddr, rdData);           // read side

  task doWrite(Addr addr, Data data = XXX);
    if (data === XXX) begin
      data = $urandom();
    end
    wrEnable = 1;
    wrAddr = addr;
    wrData = data;
    @(posedge sysClk);
    wrEnable = 0;
    wrAddr = 'X;
    wrData = 'X;
  endtask

  task doRead(Addr addr);
    rdAddr = addr;
    @(posedge sysClk);
    rdAddr = 'X;
  endtask

  task setup();
    svunit_ut.setup();
  endtask

  task teardown();
    svunit_ut.teardown();
  endtask

  // RAM readback test; sadly this does no asserts yet; you have to verify it visually
  `SVUNIT_TESTS_BEGIN
    `SVTEST(readback)
      wrEnable = 0;
      wrAddr = 'X;
      wrData = 'X;
      rdAddr = 'X;
      @(posedge sysClk);

      for (int i = 0; i < 2**ADDR_NBITS; i = i + 1) begin
        doWrite(i);
        doWrite(i);
      end

      @(posedge sysClk);
      @(posedge sysClk);

      for (int i = 0; i < 2**ADDR_NBITS; i = i + 1) begin
        doRead(i);
      end

      @(posedge sysClk);
      @(posedge sysClk);
    `SVTEST_END
  `SVUNIT_TESTS_END
endmodule
