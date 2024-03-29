class ConsentStep < ApplicationRecord
  has_many :consent_groups, dependent: :destroy

  has_many :users_reviewed,
           class_name: 'StepReview',
           dependent: :destroy

  # Suppose to be a has_one association
  # however, active admin's form builder is
  # buggy with has_one associations
  has_many :modal_fallbacks, dependent: :destroy

  has_one_attached :description_image

  attr_accessor :remove_description_image

  accepts_nested_attributes_for :consent_groups, allow_destroy: true
  accepts_nested_attributes_for :modal_fallbacks, allow_destroy: true

  validates :order, numericality: { greater_than: 0 }, uniqueness: true, on: :create
  validates :title, presence: true
  validates :popover, presence: true

  scope :ordered, -> { order(order: :asc) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id order popover study_id title tour_videos updated_at]
  end

  def modal_fallback
    modal_fallbacks.first
  end

  def parse_tour_videos
    video_links = tour_videos.split(',').map(&:strip)
    video_links.map { |link| URI.parse(link) }
  end
end
