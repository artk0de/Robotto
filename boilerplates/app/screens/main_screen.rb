screen :main_screen do
  keyboard do
    make_response "Sample response" #response are required
    button :btn_1, "Btn1" do
      # do something
    end

    button :btn_2, "Btn2" do
      # do something
    end

    line :btn_1, :btn_2
    # - - - - - - -
    # Init keyboard
    # - - - - - - -
  end


  keyboard_inline :kb_inline do
    # - - - - - -
    # Init inline keyboard
    # - - - - - -
  end


  text do |text|
    # - - - - - - - - - - - -
    # Process user's message
    # - - - - - - - - - - - -
  end

  after do
    # - - - - - -
    # After hook
    # - - - - - -
  end
end
