# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  message    :text
#  visible    :boolean          default(FALSE)
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  uuid       :string
#  slug       :string
#

class Comment < ApplicationRecord
  extend FriendlyId
  friendly_id :uuid, use: [:slugged, :finders]

  belongs_to :article
  belongs_to :user

  validates :message, presence: true

  def generate_uuid
    self.uuid = "#{self.model_name.name}-" + SecureRandom.uuid
  end

  before_create :generate_uuid
  after_create :manually_update_slug

  def manually_update_slug
    self.update_column(:slug, self.uuid)
  end
end
