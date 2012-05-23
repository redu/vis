require 'spec_helper'

describe UserSpaceParticipation do

  before do
    @users_id = [1,2,3]
    @space_id = 1
    @date_start = "2012-01-01"
    @date_end = "2012-01-10"
    test_date = "2012-01-05".to_date

    @helps = []
    2.times do
     @helps << Factory(:hierarchy_notification_help, :space_id => @space_id,
                       :created_at => test_date, :user_id => @users_id[0])
    end

    @activities = []
    2.times do
      @activities << Factory(:hierarchy_notification_activity, :space_id => @space_id,
                             :created_at => test_date, :user_id => @users_id[1])
    end

    @answered_helps = []
    2.times do
      @answered_helps << Factory(:hierarchy_notification_answered_help, :space_id => @space_id,
                                 :created_at => test_date, :user_id => @users_id[2])
    end

    @answered_activities = []
    2.times do
      @answered_activities << Factory(:hierarchy_notification_answered_activity, :space_id => @space_id,
                                      :created_at => test_date, :user_id => @users_id[0])
    end

    @avg_grade = []
    2.times do
     @avg_grade << Factory(:hierarchy_notification, :space_id => @space_id,
                           :created_at => test_date, :user_id => @users_id[1],
                           :type => "exercise_finalized", :grade => 5)
    end
  end

  subject { UserSpaceParticipation.new(@users_id, @space_id, @date_start, @date_end) }

  describe "finders - " do
    before do
      class UserSpaceParticipation
        public :helps, :activities, :answered_helps,
          :answered_activities, :average_grade
      end
    end

    it "should return all request for helps by space, user and period" do
      subject.helps(@users_id[0]).should == @helps.length
    end

    it "should return all request for activies by space, user and period" do
      subject.activities(@users_id[1]).should == @activities.length
    end

    it "should return all request for answer from helps by space, user and period" do
      subject.answered_helps(@users_id[2]).should == @answered_helps.length
    end

    it "should return all request for answers from acitivies by space, user and period" do
      subject.answered_activities(@users_id[0]).should == @answered_activities.length
    end

    it "should return the average grade by user, space and period" do
      subject.average_grade(@users_id[1]).should == @avg_grade.first.grade
    end
  end

  describe "building json - " do
    it "should retrive a json with a user_id as key" do
      subject.users_space_participation.first.should have_key(@users_id[0])
    end

    [:helps, :activities, :answered_helps,
     :answered_activities, :average_grade].each do |elem|
      it "should retrieve a json with #{elem} as element" do
        subject.users_space_participation.first[@users_id[0]].should have_key(elem)
      end
    end
  end

end
