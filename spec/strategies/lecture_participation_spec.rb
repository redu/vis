require 'spec_helper'

describe LectureParticipation do
  before do
    @id = [1, 2]
    @helps = []
    @activities = []
    @answers_help = []
    @answers_activity = []
    @id_notifications = []

    @day = Date.today

    3.times do
      h = Factory(:hierarchy_notification_help, :lecture_id => @id[0],
                 :created_at => @day)
      h1 = Factory(:hierarchy_notification_help, :lecture_id => @id[1])
      Factory(:hierarchy_notification_help, :lecture_id => 3)

      @id_notifications << h1
      @helps << h
      @answers_help << Factory(:hierarchy_notification_answered_help,
                          :lecture_id => h.lecture_id,
                          :in_response_to_id => h.status_id,
                          :created_at => @day)
    end

    2.times do
      a = Factory(:hierarchy_notification_activity,
                  :lecture_id => @id[0], :created_at => @day)
      a1 = Factory(:hierarchy_notification_activity,
              :lecture_id => @id[1])
      Factory(:hierarchy_notification_activity,
              :lecture_id => 3)

      @id_notifications << a1
      @activities << a
      @answers_activity << Factory(:hierarchy_notification_answered_activity,
                                   :lecture_id => a.lecture_id,
                                   :in_response_to_id => a.status_id,
                                   :created_at => @day)
    end

    @notifications = @helps + @answers_help + @activities + @answers_activity
    @id_notifications += @notifications

    @total_helps_count = @helps.length
    @answers_help_count = @answers_help.length
    @activities_count = @activities.length
    @answers_activity_count = @answers_activity.length
  end

  subject{ LectureParticipation.new([@id[0]], @day - 9, @day) }

  it { should respond_to :helps }
  it { should_not respond_to :helps= }
  it { should respond_to :activities }
  it { should_not respond_to :activities= }
  it { should respond_to :answered_helps }
  it { should_not respond_to :answered_helps= }
  it { should respond_to :answered_activities}
  it { should_not respond_to :answered_activities= }
  it { should respond_to :visualizations }
  it { should_not respond_to :visualizations= }
  it { should respond_to :days }
  it { should_not respond_to :days= }

  it { should respond_to :helps_by_day }
  it { should_not respond_to :helps_by_day= }
  it { should respond_to :activities_by_day }
  it { should_not respond_to :activities_by_day= }
  it { should respond_to :answered_helps_by_day }
  it { should_not respond_to :answered_helps_by_day= }
  it { should respond_to :answered_activities_by_day}
  it { should_not respond_to :answered_activities_by_day= }
  it { should respond_to :visualizations_by_day }
  it { should_not respond_to :visualizations_by_day= }

  it { should respond_to :start }
  it { should respond_to :start= }
  it { should respond_to :end }
  it { should respond_to :end= }

  it "initializing correctly" do
    subject.end.should == Date.today
    subject.start.should == Date.today - 9
  end

  context "preparing queries" do
    it "should take all notifications for lecture" do
      subject.notifications.to_set.should eq(@notifications.to_set)
    end
  end

  context "executing queries" do
    it "should take all helps" do
      subject.notifications.by_type("help").to_set.should \
        eq(@helps.to_set)
    end

    it "should take all activities" do
      subject.notifications.by_type("activity").to_set.should \
        eq(@activities.to_set)
    end

    it "should take all answers from activities" do
      subject.notifications.by_type("answered_activity").to_set.should \
        eq(@answers_activity.to_set)
    end

    it "should take all answeres from helps" do
      subject.notifications.by_type("answered_help").to_set.should \
        eq(@answers_help.to_set)
    end

    it "should take all lecture visualization" do
      pending "visualizations isn't at db" do
        subject.visualizations.to_set.should eq(@visualizations)
      end
    end
  end

  context "get methods" do
    it "helps" do
      subject.helps.should eq(@helps.length)
    end

    it "activities" do
      subject.activities.should eq(@activities.length)
    end

    it "answered activities" do
      subject.answered_activities.should eq(@answers_activity.length)
    end

    it "answered helps" do
      subject.answered_helps.should eq(@answers_help.length)
    end
  end

  context "filtering queries" do
    it "by lecture" do
      lp = LectureParticipation.new(@id, @day - 9, @day)
      lp.notifications.to_set.should eq(@id_notifications.to_set)
    end

    context "by day" do
      before do
        h = Factory(:hierarchy_notification_help, :lecture_id => @id[0],
                    :created_at => @day + 1)

        Factory(:hierarchy_notification_answered_help,
                :lecture_id => h.lecture_id,
                :in_response_to_id => h.status_id,
                :created_at => @day + 1)

        a = Factory(:hierarchy_notification_activity,
                    :lecture_id => @id[0], :created_at => @day + 1)

        Factory(:hierarchy_notification_answered_activity,
                :lecture_id => a.lecture_id,
                :in_response_to_id => a.status_id,
                :created_at => @day + 1)
      end

      it "helps" do
        subject.helps_by_day.last.should eq(@total_helps_count)
      end

      it "activities" do
        subject.activities_by_day.last.should eq(@activities_count)
      end

      it "answered activities" do
        subject.answered_activities_by_day.last.should eq(@answers_activity_count)
      end

      it "answered helps" do
        subject.answered_helps_by_day.last.should eq(@answers_help_count)
      end

      it "days" do
        subject.days.last.should eq(Date.today.strftime("%-d/%m"))
      end

      it "visualizations" do
        pending "visualizations isn't at db" do
          subject.visualizations_by_day.to_set.should eq(@helps.to_set)
        end
      end
    end
  end
end
