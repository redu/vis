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
                        :created_at => test_date, :user_id => @users_id[0])
      Factory(:hierarchy_notification,  :space_id => @space_id,
              :created_at => test_date, :user_id => @users_id[0],
              :status_id => destroy.status_id, :type => "remove_activity")

      destroy = Factory(:hierarchy_notification_answered_help,
                        :space_id => @space_id,
                        :created_at => test_date, :user_id => @users_id[0])
      Factory(:hierarchy_notification,  :space_id => @space_id,
              :created_at => test_date, :user_id => @users_id[0],
              :status_id => destroy.status_id, :type => "remove_answered_help")

      destroy = Factory(:hierarchy_notification_answered_activity,
                        :space_id => @space_id,
                        :created_at => test_date, :user_id => @users_id[0])
      Factory(:hierarchy_notification, :space_id => @space_id,
              :created_at => test_date, :user_id => @users_id[0],
              :status_id => destroy.status_id,
              :type => "remove_answered_activity")
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

    context "helps -" do
      before do
        @aggre = HierarchyNotification.by_space(@space_id).
          by_period(@date_start, @date_end).status_not_removed("help").
          only(:user_id).aggregate
      end

      it "should aggregate total helps in space and period by user" do
        @aggre[0].should == { "user_id" => @users_id[0],
                              "count" => @helps.length }
      end

      it "should create a hash by user with helps" do
        hash = Hash.new
        @aggre.map { |h| hash[h["user_id"].to_i] =
                     { "helps" => h["count"].to_i }}

        hash.should == { @users_id[0] => { "helps" => @helps.length }}
      end

      it "should return total helps by user" do
        subject.helps[@users_id[0]]["helps"].should == @helps.length
      end
    end

    context "activities -" do
      before do
        @aggre = HierarchyNotification.by_space(@space_id).
          by_period(@date_start, @date_end).status_not_removed("activity").
          only(:user_id).aggregate
      end

      it "should aggregate total activities in space and period by user" do
        @aggre[0].should == { "user_id" => @users_id[1],
                              "count" => @activities.length }
      end

      it "should create a hash by user with activities" do
        hash = Hash.new
        @aggre.map { |h| hash[h["user_id"].to_i] =
                     { "activities" => h["count"].to_i }}

        hash.should == { @users_id[1] => { "activities" => @activities.length }}
      end

      it "should return total activities by user" do
         subject.activities[@users_id[1]]["activities"].should \
          == @activities.length
      end
    end

    context "answers from helps -" do
      before do
       @aggre = HierarchyNotification.by_space(@space_id).
          by_period(@date_start, @date_end).
          status_not_removed("answered_help").only(:user_id).
          aggregate
      end

      it "should aggregate total answers from helps in space and period
      by user" do
        @aggre[0].should == { "user_id" => @users_id[2],
                              "count" => @answered_helps.length }
      end

      it "should create a hash by user with answers from helps" do
        hash = Hash.new
        @aggre.map { |h| hash[h["user_id"].to_i] =
                     { "answered_helps" => h["count"].to_i }}

        hash.should == { @users_id[2] =>
                         { "answered_helps" => @answered_helps.length }}
      end

      it "should return total answers from helps by user" do
        subject.answered_helps[@users_id[2]]["answered_helps"].should \
          == @answered_helps.length
      end
    end

    context "answers from activities -" do
      before do
        @aggre = HierarchyNotification.by_space(@space_id).
          by_period(@date_start, @date_end).
          status_not_removed("answered_activity").only(:user_id).
          aggregate
      end

      it "should aggregate total answers from activities in space and period
      by user" do
        @aggre[0].should == { "user_id" => @users_id[0],
                              "count" => @answered_activities.length }
      end

      it "should create a hash by user with answers from activities" do
        hash = Hash.new
        @aggre.map { |h| hash[h["user_id"].to_i] =
                     { "answered_activities" => h["count"].to_i }}

        hash.should \
          == { @users_id[0] =>
               { "answered_activities" => @answered_activities.length }}
      end

      it "should return total answers from activities by user" do
        subject.answered_activities[@users_id[0]]["answered_activities"].should \
          == @answered_activities.length
      end
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

      it "should aggregate average grade in space and period by user " do
        avg = HierarchyNotification.average_grade(@cond)

        avg[0].should include({ "user_id" => @users_id[1],
                                "avg" => @avg_grade.first.grade })
      end

      it "should create a hash by user with average grade" do
        avg = HierarchyNotification.average_grade(@cond)

        hash = Hash.new
        avg.map { |h| hash[h["user_id"].to_i] =
                  {"average_grade" => h["avg"] }}

        hash.should == { @users_id[1] =>
                         { "average_grade" => @avg_grade.first.grade }}
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
