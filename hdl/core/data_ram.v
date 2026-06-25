//***********************************************
// data_rom
// funtion: DATA_RAM, only to store the results of CPU running
//***********************************************

`include "define.v"

module data_ram (
    input clk,
    input rst_n,

    input[`PORT_ADDR_WIDTH]         data_ram_addr_i,
    input[`PORT_DATA_WIDTH]         data_ram_wr_data_i,
    input                           data_ram_wr_en_i,    
    
    output[`PORT_DATA_WIDTH]        data_ram_rd_data_o
);

    reg [`PORT_ADDR_WIDTH]_DATA_RAM[0:`DATA_RAM_DEPTH-1];


    integer i;

    // MEM read logic, immmediately return
    assign data_ram_rd_data_o = _DATA_RAM[data_ram_addr_i >> 2];

    // initial and MEM write logic, need reset all Zero due to not load instructions
    always @(posedge clk or negedge rst_n) begin : WRITE_LOGIC
        if(rst_n == `RstEnable) begin
            // now need to intialize to set all Zero 
            // or the simulation results are ALL PASS due to state 'X' captured to mislead the simulation.
            for (i = 0; i < `DATA_RAM_DEPTH ; i=i+1) begin
                _DATA_RAM[i] = `ZeroWord;
            end
        end
        else if(data_ram_wr_en_i) begin
            _DATA_RAM[data_ram_addr_i >> 2] <= data_ram_wr_data_i;
        end
    end


    
endmodule
