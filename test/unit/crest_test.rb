require 'test_helper'

class CrestTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Crest.new.valid?
  end
end
