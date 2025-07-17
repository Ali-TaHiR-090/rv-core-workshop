// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Immediate Generator (Workshop Skeleton Version)
// =============================================================================

module immgen (
    input  logic [31:0] instruction,
    output logic [31:0] imm_ext
);

    always_comb begin
        case (instruction[6:0])
            7'b0010011, // I-type (ALU immediate)
            7'b0000011, // I-type (Load)
            7'b1100111: // I-type (JALR)
                imm_ext = {{20{instruction[31]}}, instruction[31:20]};
            7'b0100011: // S-type (Store)
                imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            7'b1100011: // B-type (Branch)
                imm_ext = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            7'b0110111, // U-type (LUI)
            7'b0010111: // U-type (AUIPC)
                imm_ext = {instruction[31:12], 12'b0};
            7'b1101111: // J-type (JAL)
                imm_ext = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            default:
                imm_ext = 32'h0000_0000;
        endcase
    end

endmodule
