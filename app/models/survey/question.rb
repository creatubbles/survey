class Survey::Question < ActiveRecord::Base

  self.table_name = "survey_questions"

  acceptable_attributes :text, :survey, options_attributes: Survey::Option::AccessibleAttributes

  # relations
  belongs_to :survey
  has_many   :options, dependent: :destroy
  accepts_nested_attributes_for :options, reject_if: ->(a) { a[:text].blank? },
                                allow_destroy: true

  # validations
  validates :text, presence: true, allow_blank: false
  validates :question_type_id, presence: true, inclusion: { in: Survey::QuestionType.type_ids }

  def correct_options
    return options.correct
  end

  def incorrect_options
    return options.incorrect
  end

  def question_type
    return Survey::QuestionType.types.key(question_type_id)
  end

  Survey::QuestionType.types.each do |key, value|
    define_method "#{key}?" do
      question_type_id == value
    end
  end
end
