//***********************************************
// inst_rom
// funtion: ROM, to load local instructions and store the results of CPU running 
//***********************************************

`include "define.v"

module inst_rom (
    input clk,
    input rst_n,
    // address for IFU (actually from PC_REG)
    input[`PORT_ADDR_WIDTH]         inst_rom_pc_i,
    // the instruction sent to IFU
    output[`PORT_DATA_WIDTH]        inst_rom_inst_data_o,

    // interface for MEM to read or write INST_ROM when operating STORAGE related INST
    input[`PORT_ADDR_WIDTH]         inst_rom_addr_i,
    input[`PORT_DATA_WIDTH]         inst_rom_wr_data_i,
    input                           inst_rom_wr_en_i,    
    output[`PORT_DATA_WIDTH]        inst_rom_rd_data_o
);

    reg [`PORT_ADDR_WIDTH]_INST_ROM[0:`INST_ROM_DEPTH-1];

    integer i;

    // read data logic, immediately return
    assign inst_rom_inst_data_o = _INST_ROM[inst_rom_pc_i >> 2];
    assign inst_rom_rd_data_o = _INST_ROM[inst_rom_addr_i >> 2];

    // initial and write data from MEM
    always @(posedge clk or negedge rst_n) begin : WRITE_LOGIC
        if(rst_n == `RstEnable) begin
            // not initialize, load INST from binary file directly
            // for (i = 0; i < `DATA_RAM_DEPTH ; i=i+1) begin
            //     _DATA_RAM[i] = `ZeroWord;
            // end
        end
        else if(inst_rom_wr_en_i) begin
            _INST_ROM[inst_rom_addr_i >> 2] <= inst_rom_wr_data_i;
        end
    end
    
endmodule

