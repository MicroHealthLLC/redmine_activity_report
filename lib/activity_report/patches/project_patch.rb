module ActivityReport
  module ProjectPatch
    def self.included(base) # :nodoc:
      base.class_eval do
        unloadable

        # noinspection RubyArgCount
        store :activity_report_settings,
              accessors: %w(with_subprojects activity_user_ids monthly_activity_user_ids weekly_activity_user_ids daily_activity_user_ids daily_report_user_ids weekly_report_user_ids monthly_report_user_ids)

        def groups
          @groups ||= Group.active.joins(:members).where("#{Member.table_name}.project_id = ?", id).uniq
        end

      end
    end

  end
end
Project.send(:include, ActivityReport::ProjectPatch)
