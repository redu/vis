require 'spec_helper'

describe SubjectParticipation do
  before do
    @id = [1,2]
    @n_id = 3
    @helps = []
    @answers_help = []
    @finalized = []
    @enrollment = []
    @notifications = []

    3.times do
      h = Factory(:hierarchy_notification_help, :subject_id => @id[0])
      @helps << h
      @answers_help << Factory(:hierarchy_notification_answered_help,
                               :subject_id => h.subject_id,
                               :in_response_to_id => h.status_id)

      # Destruindo help
      destroy = Factory(:hierarchy_notification_help, :subject_id => @id[0])
      @notifications << destroy
      @notifications << Factory(:hierarchy_notification,
                                :subject_id => @id[0],
                                :status_id => destroy.status_id,
                                :type => "remove_help")

      # Destruindo answered help
      destroy = Factory(:hierarchy_notification_answered_help,
                        :subject_id => @id[0])
      @notifications << destroy
      @notifications << Factory(:hierarchy_notification,
                                :subject_id => @id[0],
                                :status_id => destroy.status_id,
                                :type => "remove_answered_help")
    end

    2.times do
      @finalized << Factory(:hierarchy_notification_subject_finalized,
                            :subject_id => @id[1])
      @enrollment << Factory(:hierarchy_notification_enrollment,
                             :subject_id => @id[1])
    end

    # Pedido de ajuda não respondido
    @helps_n = [Factory(:hierarchy_notification_help, :subject_id => @id[0])]

    # Remoções
    @remove_enrollment = [Factory(:hierarchy_notification_remove_enrollment,
                                :subject_id => @id[1])]
    @remove_finalized = [Factory(:hierarchy_notification_remove_subject_finalized,
                                :subject_id => @id[1])]

    @notifications += @helps_n + @helps + @answers_help + @remove_finalized
    @notifications += @finalized + @enrollment + @remove_enrollment

    # Notificações fora dos subject em id
    2.times do
      h = Factory(:hierarchy_notification_help, :subject_id => @n_id)
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

  it { should respond_to :response }
  it { should_not respond_to :response= }

  context "preparing queries" do
    it "should take all notifications" do
      subject.notifications.to_set.should eq(@notifications.to_set)
    end
  end

  context "get methods grouped by subject" do
    it "helps" do
      subject.helps[@id[0]]["helps"].should == @total_helps_count
    end

    it "answered helps" do
      subject.answered_helps[@id[0]]["answered_helps"].should == @answers_count
    end

    it "helps answered" do
      subject.helps_answered[@id[0]]["helps_answered"].should \
        == @helps_ans_count
    end

    it "helps not answered" do
      subject.helps_not_answered[@id[0]]["helps_not_answered"] \
        == @helps_not_ans_count
    end

    it "subjects finalized don't removed" do
      removed = @remove_finalized.length
      subject.subjects_finalized[@id[1]]["subjects_finalized"].should \
        == @finalized_count - removed
    end

    it "enrollments don't removed" do
      subject.enrollments[@id[1]]["enrollments"].should \
        == @enroll_count - @remove_enrollment.length
    end
  end

  context "bulding response - " do
    [:helps, :answered_helps, :helps_answered, :helps_not_answered,
     :subjects_finalized, :enrollments].each do |elem|
       it "should retrieve a data response with #{elem} as element" do
         subject.data(@id[0]).should have_key(elem)
       end
     end
  end
end
