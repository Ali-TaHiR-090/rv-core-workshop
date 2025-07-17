// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Complete Implementation
// MEDS Workshop: "Build your own RISC-V Processor in a day"
// =============================================================================


module alu (
    input  logic [31:0] a, b,
    input  logic [3:0]  alu_control,
    output logic [31:0] result,
    output logic        zero
);

    always_comb begin
        // TODO: Implement ALU operations based on alu_control signal
        // alu_control encoding:
        // 0000: ADD
        // 0001: SUB
        // 0010: AND
        // 0011: OR
        // 0100: XOR
        // 0101: SLL (Shift Left Logical)
        // 0110: SRL (Shift Right Logical)
        // 0111: SRA (Shift Right Arithmetic)
        // 1000: SLT (Set Less Than - signed)
        // 1001: SLTU (Set Less Than - unsigned)

        case (alu_control)
            4'b0000: result = a + b;              // ADD
            4'b0001: result = a - b;              // SUB
            4'b0010: result = a & b;              // AND
            4'b0011: result = a | b;              // OR
            4'b0100: result = a ^ b;              // XOR
            4'b0101: result = a << b;         // SLL (Shift Left Logical)
            4'b0110: result = a >> b;         // SRL (Shift Right Logical)
            4'b0111: result = $signed(a) >>> b; // SRA (Shift Right Arithmetic)
            4'b1000: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // SLT (Set Less Than - signed)
            4'b1001: result = (a < b) ? 32'b1 : 32'b0; // SLTU (Set Less Than - unsigned)
            // TODO: Complete rest of the ALU operations
            default: result = 32'h0000_0000;
        endcase
    end

    // TODO: Set 'zero' flag based on result
    assign zero = (result == 32'h0000_0000);

endmodule
