require 'spec_helper'

describe HierarchyNotification do
  it { should have_field(:user_id) }
  it { should have_field(:type) }
  it { should have_field(:lecture_id) }
  it { should have_field(:subject_id) }
  it { should have_field(:space_id) }
  it { should have_field(:course_id) }
  it { should have_field(:status_id) }
  it { should have_field(:statusable_id) }
  it { should have_field(:statusable_type) }
  it { should have_field(:in_response_to_id) }
  it { should have_field(:in_response_to_type) }
  it { should have_field(:created_at) }
  it { should have_field(:updated_at) }
  it { should have_field(:grade) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:type) }

  context "scopes" do
    before do
      @day = ("2012-02-10").to_date
      @facs = 2.times.collect do
        Factory(:hierarchy_notification, :created_at => @day)
      end
    end

    it "should take the notifications by subjects" do
      subj = 2.times.collect do
        Factory(:hierarchy_notification, :subject_id => 1)
      end

      HierarchyNotification.by_subject(1).to_set.should eq(subj.to_set)
    end

    it "should take the notifications by lectures" do
      lec = 2.times.collect do
        Factory(:hierarchy_notification, :lecture_id => 1)
      end

      HierarchyNotification.by_lecture([1]).to_set.should eq(lec.to_set)
    end

    it "should take the notifications by type" do
      subj = 2.times.collect do
        Factory(:hierarchy_notification_answered_help)
      end

      HierarchyNotification.by_type("answered_help").to_set.should eq(subj.to_set)
    end

    it "should take helps with answers" do
      helps =[]
      id = 1
      Factory(:hierarchy_notification_help, :status_id => 3)
      2.times do
        h = Factory(:hierarchy_notification_help,
                    :status_id => id)
        helps << h
        2.times do
          Factory(:hierarchy_notification_answered_help,
                  :in_response_to_id => h.status_id)
        end
        id =+ 1
      end

      answers = HierarchyNotification.by_type("answered_help")
      HierarchyNotification.answered(answers).to_set.should eq(helps.to_set)
    end

    it "should take notifications by day" do
      Factory(:hierarchy_notification, :created_at => @day + 1)

      HierarchyNotification.by_day(@day).to_set.should eq(@facs.to_set)
    end

    it "should return the grade average from user" do
      @grade = 0
      @user_id = 1
      4.times do
        exer = Factory(:hierarchy_notification_exercise_finalized,
                      :user_id => @user_id)
        @grade += exer.grade
      end

      Factory(:hierarchy_notification_exercise_finalized,
              :user_id => 2)

      HierarchyNotification.grade_average(@user_id).should == @grade/4
    end
  end


  context "verify if a HierarchyNotification" do
    before do
      @old = HierarchyNotification.new(:user_id => 1, :subject_id => 1,
                                      :type => "enrollment")
      @old.save!
    end

    it "already exists" do
      recent = HierarchyNotification.new(:user_id => 1, :subject_id => 1,
                                         :type => "enrollment",
                                         :created_at => @old.created_at,
                                         :updated_at => @old.updated_at)

      HierarchyNotification.notification_exists?(recent).should be_true
    end

    it "doesn't exist" do
      recent = HierarchyNotification.new(:user_id => 1, :subject_id => 2,
                                         :type => "enrollment")

      HierarchyNotification.notification_exists?(recent).should be_false
    end
  end
end
