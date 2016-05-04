class ActivityReportMailer < Mailer


  default from: "#{Setting.app_title} <#{Setting.mail_from}>"

  def self.default_url_options
    Mailer.default_url_options
  end

  helper :activities
  include ActivitiesHelper

  def report(user, interval, project)
    @project = project
    @author = user
    params = {user_id: user.id}
    @days = Setting.activity_days_default.to_i


    if interval.is_a? Array
      @date_to = interval.last.to_date > Date.today ? interval.last.to_date : Date.today
      @date_from = interval.first.to_date
    else
      @date_to = interval.to_date
      @date_from = interval.to_date
    end

    @with_subprojects = @project.activity_report_settings.try(:[], 'with_subprojects').present?
    if params[:user_id].present?
      @author = User.active.find(params[:user_id])
    end

    @activity = Redmine::Activity::Fetcher.new(@author, :project => @project,
                                               :with_subprojects => @with_subprojects,
                                               :author => @author)
    pref = @author.pref
    @activity.scope_select {|t| @project.activity_report_settings.try(:[], "show_#{t}").present? }
    if @activity.scope.present?
      pref.activity_scope = @activity.scope
    else
      @activity.scope = :all
    end

    events = @activity.events(@date_from, @date_to)
    @events_by_day = events.group_by {|event|  @author.time_to_date(event.event_datetime)}

    if @events_by_day.keys.present?
      puts "Sending mail to #{@authos.to_s}"
      mail to: @author.mail,
           subject: "#{@project.name}: #{l(:label_activity)}"
    end
  end
end
