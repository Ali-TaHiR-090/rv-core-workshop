// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Complete Implementation
// MEDS Workshop: "Build your own RISC-V Processor in a day"
// =============================================================================

// =============================================================================
// CONTROL UNIT MODULE
// =============================================================================

module control (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_write,
    output logic       mem_to_reg,
    output logic       branch,
    output logic       jump,
    output logic [3:0] alu_control
);


    always_comb begin
        // Default values
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        mem_write   = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        alu_control = 4'b0000;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1'b1;
                case ({funct3, funct7[5]})
                    4'b0000: alu_control = 4'b0000; // ADD
                    4'b0001: alu_control = 4'b0001; // SUB
                    {0x4,0}: alu_control = 4'b0100 // XOR
                    {0x4,0}: alu_control = 4'b0011 // OR
                    {0x7,0}: alu_control = 4'b0010 // AND
                    {0x1,0}: alu_control = 4'b0101; // SLL
                    {0x5,0}: alu_control = 4'b0110; // SRL
                    {0x5,1}: alu_control = 4'b0111; // SRA
                    {0x2,0}: alu_control = 4'b1000; // SLT
                    {0x3,0}: alu_control = 4'b1001; // SLTU

                endcase
            end

            // I-type (0010011)
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                case (funct3)
                    3'b000: alu_control = 4'b0000; // ADDI
                    3'b010: alu_control = 4'b1000; // SLTI
                    3'b011: alu_control = 4'b1001; // SLTIU
                    3'b100: alu_control = 4'b0100; // XORI
                    3'b110: alu_control = 4'b0011; // ORI
                    3'b111: alu_control = 4'b0010; // ANDI
                    3'b001: 
                        if (!funct7[5]) begin
                            alu_control = 4'b0101; // SLLI
                        end else begin 

                        end
                    3'b101: begin
                        if (funct7[5]) begin
                            alu_control = 4'b0111; // SRAI
                        end else begin
                            alu_control = 4'b0110; // SRLI
                        end
                    end
                endcase
            end
            // Load (0000011)
            7'b0000011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                mem_to_reg = 1'b1; // Load data to register
                case (funct3)
                    3'b000, {0x4}: alu_control = 4'b0000; // LB, LBU
                    3'b001, {0x5}: alu_control = 4'b0000; // LH, LHU
                    3'b010: alu_control = 4'b0000; // LW
            endcase
            end
            // Store (0100011)
            7'b0100011: begin
                alu_src   = 1'b1;
                mem_write = 1'b1;
                case (funct3)
                    3'b000: alu_control = 4'b0000; // SB
                    3'b001: alu_control = 4'b0000; // SH
                    3'b010: alu_control = 4'b0000; // SW
                endcase
            end
            // Branch (1100011)
            7'b1100011: begin
                branch = 1'b1;
                case (funct3)
                    3'b000: alu_control = 4'b0001; // BEQ
                    3'b001: alu_control = 4'b0001; // BNE
                    3'b100: alu_control = 4'b1000; // BLT
                    3'b101: alu_control = 4'b1001; // BGE
                    3'b110: alu_control = 4'b1000; // BLTU
                    3'b111: alu_control = 4'b1001; // BGEU
                endcase
            end
            
            // JAL (1101111)
            7'b1101111: begin
                reg_write = 1'b1;
                jump      = 1'b1;
            end

            // LUI (0110111)
            7'b0110111: begin
                reg_write = 1'b1;
                alu_control = 4'b0000; // LUI sets the upper immediate
            end

            default: begin
                // NOP or unsupported instruction

            end
        endcase
            
    end
endmodule
