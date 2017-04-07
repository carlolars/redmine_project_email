Redmine::Plugin.register :redmine_project_email do
  name 'Redmine Project Email plugin'
  author 'Carl-Oskar Larsson'
  description 'Shows the project email on the project overview page.'
  version '0.0.1'
  url 'n/a'
  author_url 'n/a'
  
  settings  partial: 'settings/redmine_project_email',
            default:
            {
              'show_project_email': false
            }
end
