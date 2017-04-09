require_dependency 'redmine_project_email'

Redmine::Plugin.register :redmine_project_email do
  name 'Redmine Project Email plugin'
  author 'Carl-Oskar Larsson'
  description 'Shows the project email on the project overview page.'
  version '1.0.0'
  url 'https://github.com/carlolars/redmine_project_email'
  author_url 'https://github.com/carlolars'
  
  settings  partial: 'settings/redmine_project_email',
            default:
            {
              'show_project_email': false,
              'use_custom_email_address': false,
              'custom_email_address': ""
            }
end
