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
      activity_user_ids = project.activity_user_ids

      users = project.users.where(id: activity_user_ids)

      users.each do |user|
        ActivityReportMailer.report(period, user, interval, project).deliver_now
      end

    end
  end

end
