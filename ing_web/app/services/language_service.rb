# frozen_string_literal: true

class LanguageService
  # Flesch-Kincaid reading ease score interpretation:
  # 100 - 90 |          5th grade | Very easy to read. Easily understood by an average 11-year-old student.
  #  90 - 80 |          6th grade | Easy to read. Conversational English for consumers.
  #  80 - 70 |          7th grade | Fairly easy to read.
  #  70 - 60 |    8th & 9th grade | Plain English. Easily understood by 13- to 15-year-old students.
  #  60 - 50 | 10th to 12th grade | Fairly difficult to read.
  #  50 - 30 |            College | Difficult to read.
  #  30 - 10 |   College graduate | Very difficult to read. Best understood by university graduates.
  #   10 - 0 |       Professional | Extremely difficult to read. Best understood by university graduates.
  def self.FleschKincaidScore(text)
    score = Odyssey.flesch_kincaid_re(text, false)
    return 100 if score > 100
    return 0 if score < 0

    score
  end

  def self.LanguageTool(text)
    languagetool_api = LanguageTool::API.new
    check = languagetool_api.check(text: text, language: "en-US")
    matches = check.matches.map do |match|
      {
        message: match.message,
        short_message: match.short_message,
        offset: match.offset,
        length: match.length,
        replacements: match.replacements,
        rule: {
          id: match.rule.id,
          description: match.rule.description,
          issue_type: match.rule.issue_type,
        }
      }
    end
    {
      matches: matches,
      original: check.original,
      auto_fix: check.auto_fix
    }
  end
end
