// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Program Counter (Workshop Skeleton Version)
// =============================================================================

module pc (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] pc_next,
    output logic [31:0] pc
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'h0000_0000; // Reset to address 0
        else
            // TODO: Update PC with pc_next on clock edge
            pc <= pc_next;
    end

endmodule
