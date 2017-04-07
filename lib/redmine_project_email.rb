
# Hooks
require 'redmine_project_email/hooks/views/view_projects_show_left_hook'

include ActionView::Helpers::UrlHelper

module RedmineProjectEmail
  def self.show_project_email
    return false unless Setting.plugin_redmine_project_email['show_project_email']
    return false unless Setting.mail_from && !Setting.mail_from.blank?
    true
  end

  def self.project_email(project)
    email = Setting.mail_from
    email = email.gsub(/@/, "+#{project.identifier}@")
    mail_to(email, email, subject: "Issue subject", body: "Issue description.")
  end
end
