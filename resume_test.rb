require "resume"
require "test/unit"
require "rack/test"
require 'capybara'
require 'capybara/dsl'
require 'capybara/envjs'

class ResumeTest < Test::Unit::TestCase
  include Capybara::DSL
  Capybara.javascript_driver = :envjs
  
  def setup
    Capybara.app = Sinatra::Application.new
  end
  
  def test_right_path
    visit '/'
    assert current_path == "/index.html"
  end

  def test_index_page
    visit '/'
    assert page.has_content?('Zoran')
  end
  
  def test_selectors
    visit '/'
    assert page.has_selector?('ul')
  end
  
  def test_apolon
    visit '/'
    assert page.has_selector?('ul')
  end
  
  # def test_single_h1
    # visit '/'
    # assert page.execute_script("$('h1').size()") == 2
  # end

end