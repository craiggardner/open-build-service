# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + "/..") + "/test_helper"
require 'time'

class StatisticsControllerTest < ActionController::IntegrationTest

  fixtures :all

  def test_latest_added
    prepare_request_with_user "adrian", "so_alone"
    get url_for(:controller => :source, :action => :package_meta, :project => "HiddenProject", :package => "test_latest_added")
    assert_response 404
    put url_for(:controller => :source, :action => :package_meta, :project => "HiddenProject", :package => "test_latest_added"), 
        '<package project="HiddenProject" name="test_latest_added"> <title/> <description/> </package>'
    assert_response 200
    assert_xml_tag( :tag => "status", :attributes => { :code => "ok"} )

    get url_for(:controller => :statistics, :action => :latest_added)
    assert_response :success
    assert_xml_tag :tag => 'latest_added', :child => { :tag => 'package' }
    assert_xml_tag :tag => 'package', :attributes => { :name => "test_latest_added" }

    prepare_request_with_user 'tom', 'thunder'
    get url_for(:controller => :statistics, :action => :latest_added)
    assert_response :success
    assert_xml_tag :tag => 'latest_added', :child => { :tag => 'project' }
    assert_xml_tag :tag => 'project', :attributes => {
      :name => "kde4",
    }

    prepare_request_with_user "fred", "geröllheimer"
    get url_for(:controller => :source, :action => :package_meta, :project => "kde4", :package => "test_latest_added1")
    assert_response 404
    put url_for(:controller => :source, :action => :package_meta, :project => "kde4", :package => "test_latest_added1"), 
        '<package project="kde4" name="test_latest_added1"> <title/> <description/> </package>'
    assert_response 200
    assert_xml_tag( :tag => "status", :attributes => { :code => "ok"} )

    get url_for(:controller => :statistics, :action => :latest_added)
    assert_response :success
    assert_xml_tag :tag => 'latest_added', :child => { :tag => 'package' }
    assert_xml_tag :tag => 'package', :attributes => { :name => "test_latest_added1" }
  end


 def test_latest_updated
   prepare_request_with_user "adrian", "so_alone"
   get url_for(:controller => :source, :action => :package_meta, :project => "HiddenProject", :package => "test_latest_added")
   assert_response 404
   put url_for(:controller => :source, :action => :package_meta, :project => "HiddenProject", :package => "test_latest_added"), 
   '<package project="HiddenProject" name="test_latest_added"> <title/> <description/> </package>'
   assert_response 200
   assert_xml_tag( :tag => "status", :attributes => { :code => "ok"} )

   get url_for(:controller => :statistics, :action => :latest_updated)
   assert_response :success
   assert_xml_tag :tag => 'latest_updated', :child => { :tag => 'package' }
   assert_xml_tag :tag => 'package', :attributes => { :name => "test_latest_added" }

   prepare_request_with_user 'tom', 'thunder'
   get url_for(:controller => :statistics, :action => :latest_updated)
   assert_response :success
   assert_xml_tag :tag => 'latest_updated', :child => { :tag => 'project' }
   assert_xml_tag :tag => 'project', :attributes => {
     :name => "kde4",
   }

   prepare_request_with_user "fred", "geröllheimer"
   get url_for(:controller => :source, :action => :package_meta, :project => "kde4", :package => "test_latest_added1")
   assert_response 404
   put url_for(:controller => :source, :action => :package_meta, :project => "kde4", :package => "test_latest_added1"), 
   '<package project="kde4" name="test_latest_added1"> <title/> <description/> </package>'
   assert_response 200
   assert_xml_tag( :tag => "status", :attributes => { :code => "ok"} )

   get url_for(:controller => :statistics, :action => :latest_updated)
   assert_response :success
   assert_xml_tag :tag => 'latest_updated', :child => { :tag => 'package' }
   assert_xml_tag :tag => 'package', :attributes => { :name => "test_latest_added1" }
 end


 def test_timestamp_calls
   prepare_request_with_user "adrian", "so_alone"
   get url_for(:controller => :statistics, :action => :added_timestamp, :project => "HiddenProject", :package => "pack")
   assert_response 200

   get url_for(:controller => :statistics, :action => :updated_timestamp , :project => "HiddenProject", :package => "pack")
   assert_response 200

   get url_for(:controller => :statistics, :action => :added_timestamp, :project => "kde4", :package => "kdelibs")
   assert_response 200

   get url_for(:controller => :statistics, :action => :updated_timestamp, :project => "kde4", :package => "kdelibs")
   assert_response 200

   prepare_request_with_user "fred", "geröllheimer"
   get url_for(:controller => :statistics, :action => :added_timestamp, :project => "kde4", :package => "kdelibs")
   assert_response 200

   get url_for(:controller => :statistics, :action => :updated_timestamp, :project => "kde4", :package => "kdelibs")
   assert_response 200

   get url_for(:controller => :statistics, :action => :added_timestamp , :project => "HiddenProject", :package => "not_existing")
   assert_response 404

   get url_for(:controller => :statistics, :action => :updated_timestamp , :project => "HiddenProject", :package => "not_existing")
   assert_response 404

   get url_for(:controller => :statistics, :action => :added_timestamp , :project => "HiddenProject")
   assert_response 404

   get url_for(:controller => :statistics, :action => :updated_timestamp , :project => "HiddenProject")
   assert_response 404

 end

 def test_rating_and_activity
   prepare_request_with_user "adrian", "so_alone"
   get url_for(:controller => :statistics, :action => :rating, :project => "kde4", :package => "kdelibs")
   assert_response :success

   get url_for(:controller => :statistics, :action => :rating, :project => "kde4")
   assert_response :success

   get url_for(:controller => :statistics, :action => :rating , :project => "HiddenProject", :package => "NOT_EXISTING")
   assert_response 404

   get url_for(:controller => :statistics, :action => :rating , :project => "HiddenProject")
   assert_response :success

   get url_for(:controller => :statistics, :action => :activity, :project => "kde4", :package => "kdelibs")
   assert_response :success

   get url_for(:controller => :statistics, :action => :activity, :project => "kde4")
   assert_response :success

   get url_for(:controller => :statistics, :action => :activity , :project => "HiddenProject", :package => "pack")
   assert_response :success

   get url_for(:controller => :statistics, :action => :activity , :project => "HiddenProject")
   assert_response :success

   # no access to HiddenProject
   prepare_request_with_user "fred", "geröllheimer"
   get url_for(:controller => :statistics, :action => :rating, :project => "kde4", :package => "kdelibs")
   assert_response :success

   get url_for(:controller => :statistics, :action => :rating , :project => "HiddenProject")
   assert_response 404

   get url_for(:controller => :statistics, :action => :rating , :project => "HiddenProject", :package => "NOT_EXISTING")
   assert_response 404

   get url_for(:controller => :statistics, :action => :activity, :project => "kde4", :package => "kdelibs")
   assert_response :success
 end

  def test_download_counter
    prepare_request_with_user 'tom', 'thunder'
    get url_for(:controller => :statistics, :action => :download_counter)
    assert_response :success
    assert_xml_tag :tag => 'download_counter', :child => { :tag => 'count' }
    assert_xml_tag :tag => 'download_counter', :attributes => { :sum => 9302 }
    assert_xml_tag :tag => 'count', :attributes => {
      :project => 'Apache',
      :package => 'apache2',
      :repository => 'SUSE_Linux_10.1',
      :architecture => 'x86_64'
    }
    assert_xml_tag :tag => 'count', :content => '4096'
  end


  def test_download_counter_group_by
    prepare_request_with_user 'tom', 'thunder'
    # without project- & package-filter
    get url_for(:controller => :statistics, :action => :download_counter, 'group_by' => 'project' )
    assert_response :success
    assert_xml_tag :tag => 'download_counter', :child => { :tag => 'count' }
    assert_xml_tag :tag => 'download_counter', :attributes => { :all => 9302 }
    assert_xml_tag :tag => 'count', :attributes => {
      :project => 'Apache', :files => '9'
    }, :content => '8806'
    # with project- & package-filter
    get url_for(:controller => :statistics, :action => :download_counter,
      'project' => 'Apache', 'package' => 'apache2', 'group_by' => 'arch')
    assert_response :success
    assert_xml_tag :tag => 'download_counter', :child => { :tag => 'count' }
    assert_xml_tag :tag => 'download_counter',
      :attributes => { :all => 9302 }
    assert_xml_tag :tag => 'count', :attributes => {
      :arch => 'x86_64', :files => '6'
    }, :content => '5537'
  end


  def test_most_active
    prepare_request_with_user 'tom', 'thunder'
    # get most active packages
    get url_for(:controller => :statistics, :action => :most_active_packages, :limit => 0)
    assert_response :success

    assert_xml_tag :tag => 'most_active', :child => { :tag => 'package' }
    assert_xml_tag :tag => 'package', :attributes => {
      :name => "kdelibs",
      :project => "kde4",
      :update_count => 0
    }
if $ENABLE_BROKEN_TEST
    assert_no_xml_tag :tag => 'package', :attributes => { :project => "HiddenProject" }
end

    # get most active projects
    get url_for(:controller => :statistics, :action => :most_active_projects, :limit => 0)
    assert_response :success
    assert_xml_tag :tag => 'most_active', :child => { :tag => 'project' }
    assert_xml_tag :tag => 'project', :attributes => {
      :name => "kde4",
      :packages => 2
    }
if $ENABLE_BROKEN_TEST
    assert_no_xml_tag :tag => 'project', :attributes => { :name => "HiddenProject" }
end

    # redo as user, seeing the hidden project
    prepare_request_with_user 'hidden_homer', 'homer'
    # get most active packages
    get url_for(:controller => :statistics, :action => :most_active_packages, :limit => 0)
    assert_response :success

    assert_xml_tag :tag => 'most_active', :child => { :tag => 'package' }
    assert_xml_tag :tag => 'package', :attributes => { :project => "HiddenProject" }

    # get most active projects
    get url_for(:controller => :statistics, :action => :most_active_projects, :limit => 0)
    assert_response :success
    assert_xml_tag :tag => 'most_active', :child => { :tag => 'project' }
    assert_xml_tag :tag => 'project', :attributes => { :name => "HiddenProject" }
  end


  # FIXME: works, but does not do anything usefull since 2.0 anymore
  #        we need a working rating mechanism, but this one is too simple.
  def test_highest_rated
    prepare_request_with_user 'tom', 'thunder'
    get url_for(:controller => :statistics, :action => :highest_rated)
    assert_response :success
    #assert_xml_tag :tag => 'collection', :child => { :tag => 'xxxxx' }
    #assert_xml_tag :tag => 'package', :attributes => {
    #  :name => "kdelibs",
    #  :xxx => "xxx",
    #}
  end


end
