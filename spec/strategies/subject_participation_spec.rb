require 'spec_helper'

describe SubjectParticipation do
  before do
    @id = 1
    @helps = []
    @answers_help = []
    @finalized = []
    @enrollment = []

    3.times do
      h = Factory(:hierarchy_notification_help, :subject_id => @id)
      @helps << h
      @answers_help << Factory(:hierarchy_notification_answered_help,
                          :subject_id => h.subject_id)
    end

    2.times do
      @finalized << Factory(:hierarchy_notification_subject_finalized,
                            :subject_id => @id)
      @enrollment << Factory(:hierarchy_notification_enrollment,
                             :subject_id => @id)
    end

    @notifications = @helps + @answers_help + @finalized + @enrollment

    2.times do
      h = Factory(:hierarchy_notification_help, :subject_id => 2)
      Factory(:hierarchy_notification_answered_help,
              :subject_id => h.subject_id)
    end
  end

  subject{ SubjectParticipation.new(@id) }

  it { should respond_to :helps }
  it { should_not respond_to :helps= }
  it { should respond_to :answered_helps }
  it { should_not respond_to :answered_helps= }
  it { should respond_to :subjects_finalized }
  it { should_not respond_to :subjects_finalized= }
  it { should respond_to :enrollments}
  it { should_not respond_to :enrollments= }
  it { should respond_to :ranges}
  it { should_not respond_to :ranges= }
  it { should respond_to :markers}
  it { should_not respond_to :markers= }
  it { should respond_to :measures}
  it { should_not respond_to :measures= }

  context "preparing queries" do
    it "should take all notifications" do
      subject.notifications.to_set.should eq(@notifications.to_set)
    end
  end

  context "executing queries" do
    it "should take all helps" do
      subject.notifications.by_type("help").to_set.should eq(@helps.to_set)
    end

    it "should take all answers from helps" do
      subject.notifications.by_type("answered_help").to_set.should eq(@answers_help.to_set)
    end

    it "should take all lectures finalized" do
      subject.notifications.by_type("subject_finalized").to_set.should eq(@finalized.to_set)
    end

    it "should take all members enrolled" do
      subject.notifications.by_type("enrollment").to_set.should eq(@enrollment.to_set)
    end
  end

  context "preparing d3 response" do
    it "should return measures and markers empty only to compose the json bullet" do
      subject.ranges
      subject.markers[0].should == 0
    end

    it "should return ranges with enrollments" do
      subject.ranges.should eq([2])
    end

    it "should return ranges with subjects finalized" do
      subject.measures.should eq([2])
    end
  end

  context "get methods" do
    it "helps" do
      subject.helps.should == 3
    end

    it "answered helps" do
      subject.answered_helps.should == 3
    end

    it "subjects finalized" do
      subject.subjects_finalized.should == 2
    end

    it "enrollments" do
      subject.enrollments.should == 2
    end

    it "ranges" do
      subject.ranges.size.should == 1
    end

    it "measures" do
      subject.measures.size.should == 1
    end
  end
end
