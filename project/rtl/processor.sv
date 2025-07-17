// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Top-Level Module (Workshop Skeleton Version)
// =============================================================================

module riscv_processor (
    input  logic clk,
    input  logic reset,
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);

    // Internal signals
    logic [31:0] pc, pc_next;
    logic [31:0] instruction;

    // TODO: Declare additional internal signals like:
    // rd1, rd2, imm_ext, src_a, src_b, alu_result, read_data, result
    // zero, pc_src, reg_write, alu_src, mem_write, etc.
    logic [31:0] rd1, rd2, imm_ext, src_a, src_b, alu_result, read_data, result;
    logic zero, pc_src, reg_write, alu_src, mem_write, reg_dest;
    // PC logic
    assign pc_next = pc + 4; // TODO: Replace with branch/jump-aware logic

    // Debug outputs
    assign pc_out = pc;
    assign instruction_out = instruction;
    

    // Module instantiations

    pc pc_reg (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    imem instruction_memory (
        .addr(pc),
        .instruction(instruction)
    );

    // TODO: Instantiate remaining modules
    // register_file
    register_file reg_file (
        .clk(clk),
        .we(reg_write),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .rd1(rd1),
        .rd2(rd2)
    );


    // immgen
    immgen imm_generator (
        .instruction(instruction),
        .imm_ext(imm_ext)
    );
    
    // alu
    alu alu (
        .src_a(src_a),
        .src_b(src_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // dmem
    dmem data_memory (
        .clk(clk),
        .addr(alu_result),
        .wdata(rd2),
        .we(mem_write),
        .rdata(read_data)
    );

    // control
    control control_unit (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .reg_dest(reg_dest),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control)
    );


    // branch_unit
    branch_unit branch_unit_inst (
        .rd1(rd1),
        .rd2(rd2),
        .funct3(instruction[14:12]),
        .branch(branch),
        .pc_src(pc_src)
    );


    always_comb begin
        src_a = rd1; 
        if (alu_src) begin
            src_b = imm_ext; // Use immediate value for ALU source B
        end else begin
            src_b = rd2; // Use register value for ALU source B
        end 
    end

    always_comb begin
        if (pc_src) begin
            pc_next = pc + imm_ext; // Branch target address
        end else if (jump) begin
            pc_next = {pc[31:28], instruction[25:0], 2'b00}; // Jump address
        end else begin
            pc_next = pc + 4; // Default next PC
        end



endmodule
