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
end
