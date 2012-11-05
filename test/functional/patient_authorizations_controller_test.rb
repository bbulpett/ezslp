require 'test_helper'

class PatientAuthorizationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => PatientAuthorization.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    PatientAuthorization.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    PatientAuthorization.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to patient_authorization_url(assigns(:patient_authorization))
  end

  def test_edit
    get :edit, :id => PatientAuthorization.first
    assert_template 'edit'
  end

  def test_update_invalid
    PatientAuthorization.any_instance.stubs(:valid?).returns(false)
    put :update, :id => PatientAuthorization.first
    assert_template 'edit'
  end

  def test_update_valid
    PatientAuthorization.any_instance.stubs(:valid?).returns(true)
    put :update, :id => PatientAuthorization.first
    assert_redirected_to patient_authorization_url(assigns(:patient_authorization))
  end

  def test_destroy
    patient_authorization = PatientAuthorization.first
    delete :destroy, :id => patient_authorization
    assert_redirected_to patient_authorizations_url
    assert !PatientAuthorization.exists?(patient_authorization.id)
  end
end
