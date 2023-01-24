# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id                    :uuid             not null, primary key
#  final_score           :float
#  flesch_kincaid_score  :float
#  language_tool_matches :jsonb
#  summary               :text             not null
#  title                 :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  author_id             :uuid
#  category_id           :bigint           not null
#
# Indexes
#
#  index_posts_on_author_id    (author_id)
#  index_posts_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (category_id => categories.id)
#
class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :category
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :liked_by, class_name: "User", join_table: :posts_likes
  before_save :set_scores
  before_save :set_summary

  has_rich_text :content

  def set_scores
    self.flesch_kincaid_score = LanguageService.FleschKincaidScore(plain_text_content)
    self.language_tool_matches = LanguageService.LanguageTool(plain_text_content)[:matches]

    grammar_score = (100 - (language_tool_matches.length * 10))
    grammar_score = 0 if grammar_score < 0
    likes_score = (liked_by.length * 10)
    self.final_score = (flesch_kincaid_score * 0.5) + (grammar_score * 0.5) + likes_score
  end

  def set_summary
    # first 200 characters of the content
    self.summary = plain_text_content[0..200]
  end

  def plain_text_content
    result = content.to_trix_html
    result = result.gsub(/<action-text-attachment(?:.*?)[^>]*><i(?:.*?)[^>]*><\/i>(.*?)\.(.*?)<\/action-text-attachment>/, "")
    result = result.tr("\n", " ")
    result = result.gsub("<br>", "\n" * 2)
    result = result.gsub("<p>", "")
    result = result.gsub("</p>", "\n" * 2)
    result = result.gsub(/\n{3,}/, "\n" * 2)
    result = result.gsub(/\s{2,}/, " ")
    result = ActionView::Base.full_sanitizer.sanitize(result)
    result = result.strip
    result = result.squeeze(" ")
    result
  end
end
