require 'spec_helper'

describe Slimpay::Base do
  include_examples 'Expect OAuth and first requests', Slimpay::Base
end
