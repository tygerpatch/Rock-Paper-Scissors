require 'test_helper'

class SiteControllerTest < ActionController::TestCase

  def test_registration_success
    post :register, :player => {:name => "Ruby", :password => "Rails", :password_confirmation => "Rails"}
    assert_redirected_to :action => 'login'
  end

  def test_registration_failed
    # passwords not the same
    post :register, :player => {:name => "Ruby", :password => "Rails", :password_confirmation => "Grails"}
    assert_response :success

    # name not unique
    post :register, :player => {:name => players(:player1).name, :password => players(:player1).password}
    assert_response :success
  end

  def test_login_success
    post :login, :player => players(:player1)
    assert_redirected_to :action => :home
    assert_equal players(:player1).id, session[:id]
  end

  def test_login_failed
    user = players(:player1)
    user.password = "Not #{user.password}"

    post :login, :player => user
    assert_response :success
    assert_nil session[:id]
  end

  def test_logout_success
    test_login_success
    get :logout
    assert_redirected_to :action => 'login'
    assert_nil session[:id]
  end
 
end
