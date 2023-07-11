class ConsentStep < ApplicationRecord
  has_many :consent_groups, dependent: :destroy

  has_many :users_reviewed,
           class_name: 'StepReview',
           dependent: :destroy

  # Suppose to be a has_one association
  # however, active admin's form builder is
  # buggy with has_one associations
  has_many :modal_fallbacks, dependent: :destroy

  accepts_nested_attributes_for :consent_groups, allow_destroy: true
  accepts_nested_attributes_for :modal_fallbacks, allow_destroy: true

  validates :order, numericality: { greater_than: 0 }, uniqueness: true, on: :create
  validates :title, presence: true
  validates :popover, presence: true

  scope :ordered, -> { order(order: :asc) }

  def modal_fallback
    modal_fallbacks.first
  end

  def parse_tour_videos
    video_links = tour_videos.split(',').map(&:strip)
    video_links.map { |link| URI.parse(link) }
  end
end
