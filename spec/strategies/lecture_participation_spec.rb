require 'spec_helper'

describe LectureParticipation do
  before do
    @id = 1
    @helps = []
    @activities = []
    @answers_help = []
    @answers_activity = []

    3.times do
      h = Factory(:hierarchy_notification_help, :lecture_id => @id)
      @helps << h
      @answers_help << Factory(:hierarchy_notification_answered_help,
                          :lecture_id => h.lecture_id,
                          :in_response_to_id => h.status_id)
    end

    2.times do
      a = Factory(:hierarchy_notification_activity,
                  :lecture_id => @id)
      @activities << a
      @answers_activity << Factory(:hierarchy_notification_answered_activity,
                                   :lecture_id => a.lecture_id,
                                   :in_response_to_id => a.status_id)
    end

    @notifications = @helps + @answers_help + @activities + @answers_activity

    @total_helps_count = @helps.length
    @answers_help_count = @answers_help.length
    @activities_count = @activities.length
    @answers_activity_count = @answers_activity.length
  end

  subject{ LectureParticipation.new(@id) }

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

  context "preparing queries" do
    it "should take all notifications for lecture" do
      subject.notifications.to_set.should eq(@notifications.to_set)
    end
  end

  context "executing queries" do
    it "should take all helps" do
      subject.helps.to_set.should eq(@helps.to_set)
    end

    it "should take all activities" do
      subject.activities.to_set.should eq(@activities.to_set)
    end

    it "should take all answers from activities" do
      subject.answered_activities.to_set.should eq(@answers_activity.to_set)
    end

    it "should take all answeres from helps" do
      subject.answered_helps.to_set.should eq(@answers_help.to_set)
    end
  end
end
