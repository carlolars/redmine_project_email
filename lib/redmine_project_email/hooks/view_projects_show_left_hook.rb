module RedmineProjectEmail
  module Hooks
    class ViewProjectsShowLeftHook < Redmine::Hook::ViewListener
      render_on :view_projects_show_left, partial: 'hooks/view_projects_show_left'
    end
  end
end
