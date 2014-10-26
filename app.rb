INITIAL_WORDS = 'I want'
FIELD_KEYWORDS = {
  'all' => '*'
}
MODEL_KEYWORDS = {
  'active debts' => 'ACTIVE_DEBTS',
  'people' => 'PEOPLE'
}

MODEL_FIELDS = {
  'ACTIVE_DEBTS' => {
    'year' => {
      field_name: 'YEAR',
      type: 'integer'
    },
    'name' => {
      field_name: 'NAME',
      type: 'string'
    }
  }
}

KEYWORDS = ['']
MODELS = []
IGNORED_WORDS = []

class Main
  def parse(phrase)
    parsed_phrase = phrase.sub(INITIAL_WORDS, '')

    puts build_query(parsed_phrase)
  end

  def build_query(phrase)
    build_select_clause + build_from_clause(phrase) + build_where_clause(phrase)
  end

  def build_select_clause
    "SELECT * "
  end

  def build_from_clause(phrase)
    from_clause = "FROM "

    MODEL_KEYWORDS.each { |k,v|
      if phrase.include? k
        from_clause += v
        @model = v
        break
      end
    }

    from_clause
  end

  def build_where_clause(phrase)
    where_clause = ""

    if phrase.include? 'from'
      from_clause = phrase[/[from].*/][/[the].*/]
      field_name = from_clause.sub!('the', '')[0..from_clause.rindex(' ')-1].strip!
      puts "from_clause: #{from_clause}"
      field_value = from_clause[from_clause.rindex(' ')..from_clause.length].strip!
      where_clause += " WHERE #{MODEL_FIELDS[@model][field_name][:field_name]} = #{field_value}"
    end

    where_clause
  end

  def build_select_fields

  end
end

text = ARGV[0]

Main.new.parse(text)
