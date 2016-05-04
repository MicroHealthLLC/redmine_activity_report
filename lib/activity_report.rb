module ActivityReport
  def self.send_activity_reports(period)
    yesterday = 12.hours.ago.to_date
    interval = if period == 'daily'
                 yesterday
               elsif period == 'weekly'
                 (yesterday.beginning_of_week..yesterday.end_of_week).to_a
               elsif period == 'monthly'
                 (yesterday.beginning_of_month..yesterday.end_of_month).to_a
               end

    projects = Project.active.select do |project|
      project.module_enabled?(:activity_report)
    end

    projects.each do |project|
      activity_user_ids = if period == 'daily'
                            project.daily_activity_user_ids
                          elsif period == 'weekly'
                            project.weekly_activity_user_ids
                          elsif period == 'monthly'
                            project.monthly_activity_user_ids
                          end

      users = project.users.where(id: activity_user_ids)

      users.each do |user|
        ActivityReportMailer.report(user, interval, project).deliver_now
      end

    end
  end

end
