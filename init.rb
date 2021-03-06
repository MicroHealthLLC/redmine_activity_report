require 'redmine'
require_dependency 'activity_report'
require_dependency 'activity_report/patches/project_patch'
require_dependency 'activity_report/patches/projects_helper_patch'

Redmine::Plugin.register :redmine_activity_report do
  name 'Redmine Activity Report plugin'
  url 'https://github.com/centosadmin/redmine_activity_report'
  description 'This is a plugin for Redmine which generate time reports for projects'
  version '1.0.0'
  author 'bilel kedidi'
  author_url 'github.com/bilel-kedidi'

  project_module :activity_report do
    permission :manage_activity_report_settings, {
      projects: :settings,
      activity_report_settings: :save,
    }
  end
end
