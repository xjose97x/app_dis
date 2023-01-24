# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  slug       :string           not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_slug   (slug) UNIQUE
#  index_categories_on_title  (title) UNIQUE
#
class Category < ApplicationRecord
  has_many :posts

  before_save :generate_slug

  private

    def generate_slug
      self.slug = title.parameterize
    end
end
