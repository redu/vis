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

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:type) }

  context "scopes" do
    it "should take the notifications by subjects" do
      subj = 2.times.collect do
        Factory(:hierarchy_notification, :subject_id => 1)
      end

      2.times do
        Factory(:hierarchy_notification)
      end

      HierarchyNotification.by_subject(1).to_set.should eq(subj.to_set)
    end

    it "should take the notifications by typ" do
      subj = 2.times.collect do
        Factory(:hierarchy_notification, :type => "answered_help")
      end

      2.times do
        Factory(:hierarchy_notification)
      end

      HierarchyNotification.by_type("answered_help").to_set.should eq(subj.to_set)
    end
  end
end
