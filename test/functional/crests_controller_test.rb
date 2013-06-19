require 'test_helper'

class CrestsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Crest.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Crest.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Crest.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to crest_url(assigns(:crest))
  end

  def test_edit
    get :edit, :id => Crest.first
    assert_template 'edit'
  end

  def test_update_invalid
    Crest.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Crest.first
    assert_template 'edit'
  end

  def test_update_valid
    Crest.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Crest.first
    assert_redirected_to crest_url(assigns(:crest))
  end

  def test_destroy
    crest = Crest.first
    delete :destroy, :id => crest
    assert_redirected_to crests_url
    assert !Crest.exists?(crest.id)
  end
end
