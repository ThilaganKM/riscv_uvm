class pc_env extends uvm_env;

    `uvm_component_utils(pc_env)

    pc_agent       agent;
    pc_scoreboard  scoreboard;

    function new(string name = "pc_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //--------------------------------------------------
        // Create Components
        //--------------------------------------------------

        agent      = pc_agent      ::type_id::create("agent", this);
        scoreboard = pc_scoreboard ::type_id::create("scoreboard", this);

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        //--------------------------------------------------
        // Connect Monitor → Scoreboard
        //--------------------------------------------------

        agent.monitor.ap.connect(scoreboard.ap_imp);

    endfunction

endclass