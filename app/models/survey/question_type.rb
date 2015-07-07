class Survey::QuestionType
  @@available_types = {  radio: 1,
                       checkbox: 2,
                       text: 3,
                       number: 4,
                       select: 5,
                       textarea: 6
                    }

  class << self
    def types
      @@available_types
    end

    def type_names
      named = {}
      @@available_types.each{ |k, v| named[k.to_s.titleize] = v }
      named
    end

    def type_ids
      @@available_types.values
    end

    def type_keys
      @@available_types.keys
    end
  end

  @@available_types.each do |key, val|
    define_singleton_method "#{key}" do
        val
    end
  end
end
