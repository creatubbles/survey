class Survey::Answer < ActiveRecord::Base

  self.table_name = "survey_answers"

  acceptable_attributes :attempt, :option, :correct, :option_id, :question,
    :question_id, :text

  # associations
  belongs_to :attempt
  belongs_to :option
  belongs_to :question

  # validations
  validates :option_id, uniqueness: { scope: [:attempt_id, :question_id] }

  # callbacks
  after_save :characterize_answer, if: ->(a){ a.option.present? }

  #scopes
  scope :completed, -> { where.not(option_id: nil) }

  def value
    points = (self.option.nil? ? Survey::Option.find(option_id) : self.option).weight
    correct?? points : - points
  end

  def correct?
    self.correct ||= self.option.correct?
  end

  private

  def characterize_answer
    update_column(:correct, option.correct?)
  end

end
