global do
  command '/command' do
    # command without params
  end

  command '/command2' do |params|
    # command with params
  end

  helpers do
    # - - - - - - - - - - -
    # Define global helpers
    # - - - -  - - - - - - -
  end
end