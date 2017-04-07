
# Hooks
require 'redmine_project_email/hooks/views/view_projects_show_left_hook'

include ActionView::Helpers::UrlHelper

module RedmineProjectEmail
  def self.show_project_email
    return false unless Setting.plugin_redmine_project_email['show_project_email']
    if Setting.plugin_redmine_project_email['use_custom_email_address']
      return false unless Setting.plugin_redmine_project_email['custom_email_address'] && !Setting.plugin_redmine_project_email['custom_email_address'].blank?
    else
      # Use the 'Emission email address' from 'Settings->Email notifications'
      return false unless Setting.mail_from && !Setting.mail_from.blank?
    end
    true
  end

  def self.project_email(project)
    if Setting.plugin_redmine_project_email['use_custom_email_address']
      email = Setting.plugin_redmine_project_email['custom_email_address']
    else
      email = Setting.mail_from
    end
    email = email.gsub(/@/, "+#{project.identifier}@")
    mail_to(email, email, subject: "Issue subject", body: "Issue description.")
  end
end
