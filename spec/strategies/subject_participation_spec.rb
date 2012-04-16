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
                          :subject_id => h.subject_id,
                          :in_response_to_id => h.status_id)
    end

    2.times do
      @finalized << Factory(:hierarchy_notification_subject_finalized,
                            :subject_id => @id)
      @enrollment << Factory(:hierarchy_notification_enrollment,
                             :subject_id => @id)
    end

    @helps_n = [Factory(:hierarchy_notification_help, :subject_id => @id)]

    @notifications = @helps_n + @helps + @answers_help + @finalized + @enrollment

    2.times do
      h = Factory(:hierarchy_notification_help, :subject_id => 2)
      Factory(:hierarchy_notification_answered_help,
              :subject_id => h.subject_id)
    end

    @total_helps_count = @helps.length + @helps_n.length
    @answers_count = @answers_help.length
    @helps_ans_count = @helps.length
    @helps_not_ans_count = @helps_n.length
    @enroll_count = @enrollment.length
    @finalized_count = @finalized.length
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
      subject.notifications.by_type("help").to_set.should eq((@helps + @helps_n).to_set)
    end

    it "should take all answers from helps" do
      subject.notifications.by_type("answered_help").to_set.should eq(@answers_help.to_set)
    end

    it "should take all helps with answers from helps" do
      ans = subject.notifications.by_type("answered_help")
      subject.notifications.by_type("help").answered(ans).to_set == @helps.to_set
    end

    it "should take all lectures finalized" do
      subject.notifications.by_type("subject_finalized").to_set.should eq(@finalized.to_set)
    end

    it "should take all members enrolled" do
      subject.notifications.by_type("enrollment").to_set.should eq(@enrollment.to_set)
    end
  end

  context "preparing d3 response" do
    it "should return ranges with enrollments" do
      subject.ranges.should eq([@enroll_count])
    end

    it "should return measures with subjects finalized" do
      subject.measures.should eq([@finalized_count])
    end

    it "should return markers with the same value of the range to compose the json bullet" do
      subject.markers[0].should == subject.measures[0]
    end
  end

  context "get methods" do
    it "helps" do
      subject.helps.should == @total_helps_count
    end

    it "answered helps" do
      subject.answered_helps.should == @answers_count
    end

    it "helps answered" do
      subject.helps_answered.should == @helps_ans_count
    end

    it "helps not answered" do
      subject.helps_not_answered == @helps_not_ans_count
    end

    it "subjects finalized" do
      subject.subjects_finalized.should == @finalized_count
    end

    it "enrollments" do
      subject.enrollments.should == @enroll_count
    end

    it "ranges" do
      subject.ranges.size.should == 1
    end

    it "measures" do
      subject.measures.size.should == 1
    end

    it "markers" do
      subject.markers.size.should == 1
    end
  end
end
