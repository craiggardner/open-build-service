require File.dirname(__FILE__) + '/../test_helper'
require 'source_controller'

FIXTURES = [
  :static_permissions,
  :roles,
  :roles_static_permissions,
  :roles_users,
  :users,
  :groups,
  :groups_users,
  :db_projects,
  :db_packages,
  :bs_roles,
  :repositories,
  :path_elements,
  :project_user_role_relationships,
  :project_group_role_relationships,
]

class ReadPermissionTests < ActionController::IntegrationTest 
  fixtures(*FIXTURES)
  
  def setup
    @controller = SourceController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    Suse::Backend.put( '/source/HiddenProject/_meta', DbProject.find_by_name('HiddenProject').to_axml)
    Suse::Backend.put( '/source/HiddenProject/pack/_meta', DbPackage.find_by_project_and_name("HiddenProject", "pack").to_axml)
    Suse::Backend.put( '/source/HiddenProject/pack/my_file', "Protected Content")
  end


  def test_basic_read_tests
    # Access as a maintainer to a hidden project
    do_read_access_all_pathes( "adrian", :success )
    do_read_access_all_pathes( "adrian_reader", :success )
# FIXME: it looks like access is always possible atm
#    do_read_access_all_pathes( "adrian_downloader", 403 )
#    do_read_access_all_pathes( "adrian_nobody", 403 )
  end

  def do_read_access_all_pathes(user, response)
    ActionController::IntegrationTest::reset_auth 
    prepare_request_with_user user, "so_alone"

    get "/source/HiddenProject"
    assert_response response
    get "/source/HiddenProject/_meta"
    assert_response response
    get "/source/HiddenProject/pack"
    assert_response response
    get "/source/HiddenProject/pack/_meta"
    assert_response response
    get "/source/HiddenProject/pack/my_file"
    assert_response response

  end
  protected :do_read_access_all_pathes

  # FIXME: to be implemented:
  # For source access:
  # * test operations on a project or package
  # * test package link creation
  # * test project link creation
  # * test creation and "accept" of requests
  # For binary access
  # * test aggregate creation
  # * test kiwi live image file creation
  # * test kiwi product file creation

  # Everything needs to be tested as user with various roles and as a group member with various roles

  # the very same must be tested also for public project, but protected package
end