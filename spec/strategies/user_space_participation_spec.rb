require 'spec_helper'

describe UserSpaceParticipation do
  before do
    @user_id = 1
    @space_id = 1
    @date_start = "2012-01-01"
    @date_end = "2012-01-10"
    test_date = "2012-01-05".to_date

    @helps = []
    2.times do
     @helps << Factory(:hierarchy_notification_help, :space_id => @space_id,
                       :created_at => test_date, :user_id => @user_id)
    end

    @activities = []
    2.times do
      @activities << Factory(:hierarchy_notification_activity,
                             :space_id => @space_id,
                             :created_at => test_date, :user_id => @user_id)
    end

    @answered_helps = []
    2.times do
      @answered_helps << Factory(:hierarchy_notification_answered_help,
                                 :space_id => @space_id,
                                 :created_at => test_date,
                                 :user_id => @user_id)
    end

    @answered_activities = []
    2.times do
      @answered_activities << Factory(:hierarchy_notification_answered_activity,
                                      :space_id => @space_id,
                                      :created_at => test_date,
                                      :user_id => @user_id)
    end

    @avg_grade = []
    2.times do
     @avg_grade << Factory(:hierarchy_notification, :space_id => @space_id,
                           :created_at => test_date, :user_id => @user_id,
                           :type => "exercise_finalized", :grade => 5)
    end
  end

  subject { UserSpaceParticipation.new(@user_id, @space_id,
                                       @date_start, @date_end) }

  it { should respond_to :user_id }
  it { should_not respond_to :user_id= }
  it { should respond_to :space_id }
  it { should_not respond_to :space_id= }
  it { should respond_to :data }
  it { should_not respond_to :data= }

  describe "finders - " do
    before do
      class UserSpaceParticipation
        public :helps, :activities, :answered_helps,
          :answered_activities, :average_grade
      end
    end

    it "should return total helps by space, user and period" do
      subject.helps(@user_id).should == @helps.length
    end

    it "should return total activies by space, user and period" do
      subject.activities(@user_id).should == @activities.length
    end

    it "should return total answer from helps by space, user and period" do
      subject.answered_helps(@user_id).should == @answered_helps.length
    end

    it "should return total answers from acitivies by space, user and period" do
      subject.answered_activities(@user_id).should \
        == @answered_activities.length
    end

    it "should return the average grade by user, space and period" do
      subject.average_grade(@user_id).should == @avg_grade.first.grade
    end
  end

  describe "building response - " do
    [:helps, :activities, :answered_helps,
     :answered_activities, :average_grade].each do |elem|
      it "should retrieve a data response with #{elem} as element" do
        subject.data.should have_key(elem)
      end
    end
  end
end
