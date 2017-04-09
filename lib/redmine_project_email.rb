# Hooks
require_dependency 'redmine_project_email/hooks/view_projects_show_left_hook'

include ActionView::Helpers::UrlHelper

module RedmineProjectEmail
  def self.show_project_email?(project)
    # No use sending emails to a project without issue_tracer enabled
    return false unless project.module_enabled?(:issue_tracking)

    # There is no use sending emails to a project without trackers
    return false unless project.trackers.count > 0

    return false unless Setting.plugin_redmine_project_email['show_project_email']

    if Setting.plugin_redmine_project_email['use_custom_email_address']
      # Using the custom email address configured in the plugin configuration
      return false unless Setting.plugin_redmine_project_email['custom_email_address'] && !Setting.plugin_redmine_project_email['custom_email_address'].blank?
    else
      # Using the 'Emission email address' from 'Settings->Email notifications'
      return false unless Setting.mail_from && !Setting.mail_from.blank?
    end

    true
  end

  def self.project_email(project)
    # Use Redmine's emission email or the custom email.
    if Setting.plugin_redmine_project_email['use_custom_email_address']
      email = Setting.plugin_redmine_project_email['custom_email_address']
    else
      email = Setting.mail_from
    end
    # Insert '+<project.identifier>' before the @ in the email address
    email = email.gsub(/@/, "+#{project.identifier}@")
    mail_to(email, email, subject: "Issue subject", body: "Issue description.")
  end
end
