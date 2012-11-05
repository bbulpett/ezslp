require 'test_helper'

class PatientAuthorizationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert PatientAuthorization.new.valid?
  end
end
