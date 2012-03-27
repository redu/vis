require 'spec_helper'

describe SubjectParticipation do
  before(:each) do
    @id = 1
    @helps = []
    @answers_help = []

    3.times do
      h = Factory(:hierarchy_notification, :subject_id => @id)
      @helps << h
      @answers_help << Factory(:hierarchy_notification,
                          :type => "answered_help",
                          :subject_id => h.subject_id,
                          :in_response_to_id => h.status_id)
    end
    @notifications = @helps + @answers_help

    2.times do
      h = Factory(:hierarchy_notification, :subject_id => 2)
      Factory(:hierarchy_notification, :type => "answered_help",
              :subject_id => h.subject_id)
    end
  end

  subject{ SubjectParticipation.new(@id) }

  it { should respond_to :helps }
  it { should_not respond_to :helps= }
  it { should respond_to :answered_helps }
  it { should_not respond_to :answered_helps= }

  context "preparing queries" do
    it "should take all notifications" do
      subject.notifications.to_set.should eq(@notifications.to_set)
    end
  end

  context "executing queries" do
    it "should take all helps" do
      subject.notifications

      subject.helps_notifications.to_set.should eq(@helps.to_set)
    end

    it "should take all answers from helps" do
      subject.notifications

      subject.answers_helps_notifications.to_set.should eq(@answers_help.to_set)
    end
  end

  context "building" do
    it "response" do
      subject.generate!

      subject.helps.should == 3
      subject.answered_helps.should == 3
    end
  end
end
