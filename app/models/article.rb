# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  category   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  uuid       :string
#  slug       :string
#

class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :uuid, use: [:slugged, :finders]

  has_many :comments
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  before_create :generate_uuid
  after_create :manually_update_slug

  def generate_uuid
    self.uuid = "#{self.model_name.name}-" + SecureRandom.uuid
  end

  def manually_update_slug
    self.update_column(:slug, self.uuid)
  end
end
