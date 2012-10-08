require 'spec_helper'

describe UserSpaceParticipation do
  before do
    @users_id = [1,2,3]
    @space_id = 1
    @date_start = "2012-01-01"
    @date_end = "2012-01-10"
    test_date = "2012-01-05".to_date

    @helps = []
    @activities = []
    @answered_helps = []
    @answered_activities = []
    @avg_grade = []

    2.times do
      @helps << Factory(:hierarchy_notification_help, :space_id => @space_id,
                        :created_at => test_date, :user_id => @users_id[0])
      @activities << Factory(:hierarchy_notification_activity,
                             :space_id => @space_id,
                             :created_at => test_date, :user_id => @users_id[1])
      @answered_helps << Factory(:hierarchy_notification_answered_help,
                                 :space_id => @space_id,
                                 :created_at => test_date,
                                 :user_id => @users_id[2])
      @answered_activities << Factory(:hierarchy_notification_answered_activity,
                                      :space_id => @space_id,
                                      :created_at => test_date,
                                      :user_id => @users_id[0])
      @avg_grade << Factory(:hierarchy_notification, :space_id => @space_id,
                            :created_at => test_date, :user_id => @users_id[1],
                            :type => "exercise_finalized", :grade => 5)

      # Destruindo statuses
      destroy = Factory(:hierarchy_notification_help, :space_id => @space_id,
                        :created_at => test_date, :user_id => @users_id[0])

      Factory(:hierarchy_notification,  :space_id => @space_id,
              :created_at => test_date, :user_id => @users_id[0],
              :status_id => destroy.status_id, :type => "remove_help")

      destroy = Factory(:hierarchy_notification_activity,
                        :space_id => @space_id,
                        :created_at => test_date, :user_id => @users_id[1])
      Factory(:hierarchy_notification,  :space_id => @space_id,
              :created_at => test_date, :user_id => @users_id[1],
              :status_id => destroy.status_id, :type => "remove_activity")

      destroy = Factory(:hierarchy_notification_answered_help,
                        :space_id => @space_id,
                        :created_at => test_date, :user_id => @users_id[2])
      Factory(:hierarchy_notification,  :space_id => @space_id,
              :created_at => test_date, :user_id => @users_id[2],
              :status_id => destroy.status_id, :type => "remove_answered_help")

      destroy = Factory(:hierarchy_notification_answered_activity,
                        :space_id => @space_id,
                        :created_at => test_date, :user_id => @users_id[0])
      Factory(:hierarchy_notification, :space_id => @space_id,
              :created_at => test_date, :user_id => @users_id[0],
              :status_id => destroy.status_id,
              :type => "remove_answered_activity")

      # Destruindo exercise_finalized
      destroy = Factory(:hierarchy_notification_exercise_finalized,
                        :space_id => @space_id,
                        :created_at => test_date, :user_id => @users_id[1])

      Factory(:hierarchy_notification, :space_id => @space_id,
              :created_at => test_date, :user_id => @users_id[1],
              :lecture_id => destroy.lecture_id,
              :type => "remove_exercise_finalized")
    end
  end

  subject { UserSpaceParticipation.new(@users_id, @space_id,
                                       @date_start, @date_end) }

  it { should respond_to :space_id }
  it { should_not respond_to :space_id= }

  describe "aggregations - " do
    before do
      class UserSpaceParticipation
        public :helps, :activities, :answered_helps,
          :answered_activities, :average_grade
      end
    end

    it "should return total helps by user" do
      subject.helps[@users_id[0]]["helps"].should == @helps.length
    end

    it "should return total activities by user" do
      subject.activities[@users_id[1]]["activities"].should \
        == @activities.length
    end

    it "should return total answers from helps by user" do
      subject.answered_helps[@users_id[2]]["answered_helps"].should \
        == @answered_helps.length
    end

    it "should return total answers from activities by user" do
      subject.answered_activities[@users_id[0]]["answered_activities"].should \
        == @answered_activities.length
    end

    context "average grade -" do
      before do
        @cond = HierarchyNotification.by_space(@space_id).
          by_period(@date_start, @date_end).
          where(:type => "exercise_finalized").selector
      end

      [:created_at, :space_id, :type].each do |key|
        it "conditions should have #{key} for group by" do
          @cond.should have_key(key)
        end
      end

      it "should return the average grade by user, space and period" do
        subject.average_grade[@users_id[1]]["average_grade"].should \
          == @avg_grade.first.grade
      end
    end
  end

  describe "building response - " do
    [:helps, :activities, :answered_helps,
     :answered_activities, :average_grade].each do |elem|
      it "should retrieve a data response with #{elem} as element" do
        subject.data(@users_id[0]).should have_key(elem)
      end
    end
  end
end
