require 'test_helper'
require 'redmine_project_email'

class ProjectEmailTest < Redmine::IntegrationTest
  fixtures  :projects,
            :trackers,
            :projects_trackers,
            :enabled_modules
  
  def setup
    @project = Project.find_by_id(1)
    @custom_email = 'custom@example.com'
    @project_email = Setting.mail_from.gsub(/@/, "%2B#{@project.identifier}@")
    @custom_project_email = @custom_email.gsub(/@/, "%2B#{@project.identifier}@")
    
    # Make sure plugin configuration is in a known state before every test
    Setting.plugin_redmine_project_email = {}
  end
  
  test 'should be true' do
    assert !Setting.mail_from.blank?
    assert @project.module_enabled?(:issue_tracking)
    assert @project.trackers.count > 0
    assert_nil Setting.plugin_redmine_project_email['show_project_email']
    assert_nil Setting.plugin_redmine_project_email['use_custom_email_address']
    assert_nil Setting.plugin_redmine_project_email['custom_email_address']
  end
  
  test 'no project email when show_project_email not enabled' do
    get "/projects/#{@project.identifier}"
    assert :success
    
    assert_no_match "mailto:#{@custom_project_email}", response.body
    assert_no_match "mailto:#{@project_email}", response.body
  end

  test 'emission email on project overview' do
    Setting.plugin_redmine_project_email['show_project_email'] = true
    
    get "/projects/#{@project.identifier}"
    assert :success
    
    assert_match "mailto:#{@project_email}", response.body
  end

  test 'custom email on project overview' do
    Setting.plugin_redmine_project_email['show_project_email'] = true
    Setting.plugin_redmine_project_email['use_custom_email_address'] = true
    Setting.plugin_redmine_project_email['custom_email_address'] = @custom_email
    
    get "/projects/#{@project.identifier}"
    assert :success
    
    assert_match "mailto:#{@custom_project_email}", response.body
  end
  
  test 'no project email when issue_tracking not enabled' do
    @project.disable_module!(:issue_tracking)
    Setting.plugin_redmine_project_email['show_project_email'] = true
    
    get "/projects/#{@project.identifier}"
    assert :success
    
    assert_no_match "mailto:#{@custom_project_email}", response.body
    assert_no_match "mailto:#{@project_email}", response.body
  end
  
  test 'no project email when no trackers enabled' do
    @project.trackers = []
    Setting.plugin_redmine_project_email['show_project_email'] = true
    
    get "/projects/#{@project.identifier}"
    assert :success
    
    assert_no_match "mailto:#{@custom_project_email}", response.body
    assert_no_match "mailto:#{@project_email}", response.body
  end
  
  test 'no project email when custom email address is empty' do
    Setting.plugin_redmine_project_email['show_project_email'] = true
    Setting.plugin_redmine_project_email['use_custom_email_address'] = true
    Setting.plugin_redmine_project_email['custom_email_address'] = ""
    
    get "/projects/#{@project.identifier}"
    assert :success
    
    assert_no_match "mailto:#{@custom_project_email}", response.body
    assert_no_match "mailto:#{@project_email}", response.body
  end
  
  test 'no project email when custom email address is nil' do
    Setting.plugin_redmine_project_email['show_project_email'] = true
    Setting.plugin_redmine_project_email['use_custom_email_address'] = true
    
    get "/projects/#{@project.identifier}"
    assert :success
    
    assert_no_match "mailto:#{@custom_project_email}", response.body
    assert_no_match "mailto:#{@project_email}", response.body
  end
  
  test 'no project email when mail_from is empty' do
    original_mail_from = Setting.mail_from
    Setting.mail_from = ""
    Setting.plugin_redmine_project_email['show_project_email'] = true
    
    get "/projects/#{@project.identifier}"
    assert :success
    
    assert_no_match "mailto:#{@custom_project_email}", response.body
    assert_no_match "mailto:#{@project_email}", response.body
    
    Setting.mail_from = original_mail_from
  end
  
  test 'no project email when mail_from is nil' do
    original_mail_from = Setting.mail_from
    Setting.mail_from = nil
    Setting.plugin_redmine_project_email['show_project_email'] = true
    
    get "/projects/#{@project.identifier}"
    assert :success
    
    assert_no_match "mailto:#{@custom_project_email}", response.body
    assert_no_match "mailto:#{@project_email}", response.body
    
    Setting.mail_from = original_mail_from
  end
end