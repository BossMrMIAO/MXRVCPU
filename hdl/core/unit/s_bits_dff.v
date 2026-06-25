// *****************************
// s_bits_dff
// function: custom data width for tranfer
// ********************************

`include "../define.v"

module s_bits_dff #(
    parameter bits_width = `WORD_WIDTH  //define default bits width, default is 32 bits 
)(
    input clk,            
    input rst_n,          
    input flush_flag,      
    input hold_flag,       
    input [bits_width-1:0] zero_point, // when flush triggered, load base state
    input [bits_width-1:0] d,  
    output reg [bits_width-1:0] q  
);

// multi-bits flip-flop data transfer
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= {bits_width{1'b0}};  // reset, output all bits are 0
    end else if(flush_flag) begin
        q <= zero_point;
    end else if(hold_flag) begin
        q <= q;              
    end else begin
        q <= d;           
    end
end

endmodule
