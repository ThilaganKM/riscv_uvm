class data_mem_scoreboard extends uvm_component;

  `uvm_component_utils(data_mem_scoreboard)

  uvm_analysis_imp #(dmem_seq_item, data_mem_scoreboard) analysis_export;

  bit [31:0] golden_mem [63:0];

  function new(string name, uvm_component parent);
    super.new(name,parent);
    analysis_export = new("analysis_export",this);
  endfunction

  function void build_phase(uvm_phase phase);
    foreach(golden_mem[i])
      golden_mem[i] = 0;
  endfunction

  function void write(dmem_seq_item tx);

    int idx = tx.A[31:2];

    // Write happens at posedge
    if(tx.we)
      golden_mem[idx] = tx.WD;

    if(tx.ReadData !== golden_mem[idx])
      `uvm_error("DMEM_SB",
        $sformatf("Mismatch at %0d Expected=%0h Actual=%0h",
          idx, golden_mem[idx], tx.ReadData))
    else
      `uvm_info("DMEM_SB","Memory match",UVM_LOW)

  endfunction

endclass