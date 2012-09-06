class SubjectParticipation
  attr_reader :response

  def initialize(subject_id)
    @subject_id = subject_id

    self.generate!
  end

  def generate!
    self.helps
    self.answered_helps
    self.helps_answered
    self.helps_not_answered
    self.subjects_finalized
    self.enrollments

    @response = @subject_id.collect do |subject|
      { :subject_id => subject.to_i,
        :data => data(subject.to_i) }
    end
  end

  def data(id)
    { :helps => @helps[id] ? @helps[id]["helps"] : 0,
      :answered_helps => @answered_helps[id] ?
                         @answered_helps[id]["answered_helps"] : 0,
      :helps_answered => @helps_answered[id] ?
                         @helps_answered[id]["helps_answered"] : 0,
      :helps_not_answered => @helps_not_answered[id] ?
                             @helps_not_answered[id]["helps_not_answered"] : 0,
      :subjects_finalized => @subjects_finalized[id] ?
                             @subjects_finalized[id]["subjects_finalized"] : 0,
      :enrollments => @enrollments[id] ?
                      @enrollments[id]["enrollments"] : 0 }
  end

  def notifications
    HierarchyNotification.by_subject(@subject_id)
  end

  def helps
    @helps = self.notifications.status_not_removed("help").
      grouped(:subject_id, "helps")
  end

  def answered_helps
    @answered_helps = self.notifications.status_not_removed("answered_help").
      grouped(:subject_id, "answered_helps")
  end

  def helps_answered
    help = self.notifications.status_not_removed("help")
    ans = self.notifications.status_not_removed("answered_help")
    @helps_answered = help.answered(ans).grouped(:subject_id, "helps_answered")
  end

  def helps_not_answered
    # O hash inicial precisa ter a mesma chave para manter a consistência
    # no momento de fazer o merge
    helps = self.notifications.status_not_removed("help").
      grouped(:subject_id, "helps_not_answered")

    @helps_not_answered = helps.merge(@helps_answered) {
      |key, old, new| { "helps_not_answered" =>
        old["helps_not_answered"] - ( new["helps_answered"] ?
                                      new["helps_answered"] : 0 )}}
  end

  def subjects_finalized
    @subjects_finalized = not_removed("subject_finalized", "subjects_finalized")
  end

  def enrollments
    @enrollments = not_removed("enrollment", "enrollments")
  end

  # Remove da resposta todas as notificações que foram excluídas do core
  def not_removed(type, key)
    removed = notifications.by_type("remove_#{type}").
      grouped(:subject_id, "remove_#{key}")

    total = self.notifications.by_type("#{type}").
      grouped(:subject_id, "#{key}")

    total.merge(removed) { |k, old, new|
      { "#{key}" => old["#{key}"] - ( new["remove_#{key}"] ?
                                      new["remove_#{key}"] : 0 ) }}
  end
end
