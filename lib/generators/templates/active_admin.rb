ActiveAdmin.register Survey::Survey do
  menu label: I18n.t("surveys")

  permit_params [
              :id, :name, :description, :active, :finished, :attempts_number,
              questions_attributes: [
                :id, :text, :question_type_id, :_destroy, options_attributes: [
                  :id, :text, :correct, :_destroy
                ]
              ]
            ]

  filter  :name,
          as: :select,
          collection: proc {
              Survey::Survey.select("distinct(name)").collect { |c|
                [c.name, c.name]
              }
          }
  filter :active,
         as: :select,
         collection: ["true", "false"]

  filter :created_at

  index do
    column :name
    column :description
    column :active
    column :attempts_number
    column :finished
    column :created_at
    actions
  end

  form do |f|
    f.inputs I18n.t("survey_details") do
      f.input  :name
      f.input  :description
      f.input  :active, as: :select, collection: ["true", "false"]
      f.input  :attempts_number
    end
    f.inputs I18n.t("questions") do
      f.has_many :questions do |q|
        q.input :text
        q.input :question_type_id, as: :select,
                collection: Survey::QuestionType.types, include_blank: false
        q.has_many :options do |a|
          a.input  :text
          a.input  :correct
        end
      end
    end
    f.actions
  end

end
