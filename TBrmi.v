/*
  Name : Rakotojaona Nambinina
  email : Andrianoelisoa.rakotojaona@gmail.com
  Description : Test bench of RMI
*/
`timescale 1ns / 1ps
module tbRMI(

    );
    
      // input port
  reg clk; 
  reg rst; 
  reg tx; 
  reg [31:0] newSchedule;
  // output port
  // BRAM1 
  wire  wrEn1;
  wire  [31:0] wrAdd1;
  wire  [31:0] wrData1;
  // BRAM2 
  wire  wrEn2; 
  wire  [31:0] wrAdd2;
  wire  [31:0] wrData2;
  // sel memory after 1 clock cycle 
  wire selMem;
    
    
     RMI UUT(
           clk,
           rst,
           tx, 
           newSchedule,
           // BRAM 1 
           wrEn1,
           wrAdd1,
           wrData1,
           // BRAM 2 
           wrEn2, 
           wrAdd2, 
           wrData2, 
           // sel Memory 
           selMem
           );
  initial
    begin
      clk =0; 
      rst =1;
      tx =0;
      newSchedule = 32'd5;
      #10 
      rst=0;
      #40 
      tx = 1;
      #200 
      tx = 0;
    end
    
  always 
    begin
      #5 clk = !clk;
    end 

endmodule
