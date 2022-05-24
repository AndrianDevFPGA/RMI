/*
  Name : Rakotojaona Nambinina
  email : Andrianoelisoa.rakotojaona@gmail.com
  Description : RMI code to write data in two BRAM 
*/
`timescale 1ns / 1ps

module RMI(
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
  
  // input port
  input clk; 
  input rst; 
  input tx; 
  input [31:0] newSchedule;
  // output port
  // BRAM1 
  output reg wrEn1;
  output reg [31:0] wrAdd1;
  output reg [31:0] wrData1;
  // BRAM2 
  output reg wrEn2; 
  output reg [31:0] wrAdd2;
  output reg [31:0] wrData2;
  // sel memory after 1 clock cycle 
  output reg selMem;
  
  integer counter; // used for address 
  integer state ; // state machine
  reg ramUsed;
  
  // state transition
  always @ (posedge clk)
    begin
      if (rst)
        begin
          counter <=0;
          ramUsed <=1'bx;
          state <=0;
          // memory BRAM1 
          wrEn1 <=0;
          wrAdd1 <=32'dx;
          wrData1 <= 32'dx;
          // memory BRAM2 
          wrEn2 <=0;       
          wrAdd2 <=32'dx;   
          wrData2 <= 32'dx;
          // select memory 
          selMem <=1; // used BRAM1
        end 
      else 
        begin
          counter <= counter + 1;
          case (state)
            0:
              begin
                if (counter ==2)
                  begin
                    state <= 1;
                  end 
              end
            1:
              begin
                if (tx == 1'b1 && ramUsed == 1'b1)
                  begin
                    state <= 2;
                    counter <=0;
                  end
                if (tx == 1'b1 && ramUsed == 1'b0)
                  begin
                    state <=3;
                    counter <=0;
                  end 
              end  
            2:
              begin
                if (counter == 5)
                  begin
                    state <= 1;
                  end 
              end 
            3:
              begin
                if (counter ==5)
                  begin
                    state <= 1;
                  end 
              end 
          endcase
        end 
    end 
  
   // assign value of each state  
   always @ (negedge clk)
     begin
       case (state)
         0:
           begin
             // memory BRAM1  
             wrEn1 <=0;       
             wrAdd1 <=32'dx;   
             wrData1 <= 32'dx;
             // memory BRAM2  
             wrEn2 <=1;       
             wrAdd2 <=counter;   
             wrData2 <= newSchedule;
             //ram used 
             ramUsed <=1;  
           end
         1:
           begin
             // counter  
             //counter <= 0;
             // memory BRAM1        
             wrEn1 <=0;             
             wrAdd1 <=32'dx;         
             wrData1 <= 32'dx;      
             // memory BRAM2        
             wrEn2 <=0;             
             wrAdd2 <=32'dx;      
             wrData2 <= 32'dx;
             //ram used             
             //ramUsed <=1;    
             //selection 
             //selMem <=0;       
           end
         2:
           begin
            // memory BRAM1        
             wrEn1 <=1;             
             wrAdd1 <=counter;         
             wrData1 <= newSchedule;      
             // memory BRAM2        
             wrEn2 <=0;             
             wrAdd2 <=32'dx;      
             wrData2 <= 32'dx;
             //ram used             
             ramUsed <=0;    
             //selection 
             if (counter == 2)
               begin
                 selMem <=0;
               end 
             //selMem <=0;    
           end
         3:
           begin
             // memory BRAM1          
              wrEn1 <=0;              
              wrAdd1 <=32'dx;       
              wrData1 <= 32'dx; 
              // memory BRAM2         
              wrEn2 <=1;              
              wrAdd2 <=counter;       
              wrData2 <= newSchedule; 
              //ram used              
              ramUsed <=1;            
              //selection             
              if (counter == 2)       
                begin                 
                  selMem <=1;         
                end                   
            //selMem <=0;           
           end    
       endcase
     end           

endmodule
