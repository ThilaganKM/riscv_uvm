class pc_agent extends uvm_agent;

    `uvm_component_utils(pc_agent)

    pc_sequencer sequencer;
    pc_driver    driver;
    pc_monitor   monitor;

    virtual pc_if vif;

    function new(string name = "pc_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //--------------------------------------------------
        // Get Interface
        //--------------------------------------------------

        if (!uvm_config_db #(virtual pc_if)::get(this, "", "vif", vif))
            `uvm_fatal("AGENT", "Virtual interface not set")

        //--------------------------------------------------
        // Create Components
        //--------------------------------------------------

        sequencer = pc_sequencer::type_id::create("sequencer", this);
        driver    = pc_driver   ::type_id::create("driver", this);
        monitor   = pc_monitor  ::type_id::create("monitor", this);

        //--------------------------------------------------
        // Pass Interface Down
        //--------------------------------------------------

        uvm_config_db #(virtual pc_if.DRIVER)::set(this, "driver", "vif", vif);
        uvm_config_db #(virtual pc_if.MONITOR)::set(this, "monitor", "vif", vif);

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        //--------------------------------------------------
        // Connect Driver ↔ Sequencer
        //--------------------------------------------------

        driver.seq_item_port.connect(sequencer.seq_item_export);

    endfunction

endclass