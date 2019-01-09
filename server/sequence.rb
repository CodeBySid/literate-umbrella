class Sequence < ApplicationRecord
  has_many :product_category_sequences, dependent: :destroy
  has_many :product_tag_sequences, dependent: :destroy

  DEFAULT_SEQ_START_AT = Time.zone.local(1973, 7, 20, 0, 0, 0)
  DEFAULT_SEQ_END_AT   = Time.zone.local(2029, 7, 20, 0, 0, 0)

  #
  # Given a date object, return sequence that is active now
  # find nearest start_date from sequences where end_date is after the given date
  # date: ActiveSupport::TimeWithZone (as returned by ActiveRecord)
  #
  def self.active_for(date: nil, category: nil, tag: nil)
    if category.nil? && tag.nil?
      raise "must pass either category or tag"
    end

    unless category.nil?
      unless category.is_a?(CategoryCache)
        raise "category must be a CategoryCache object"
      end
    end

    unless tag.nil?
      unless tag.is_a?(TagCache)
        raise "tag must be a TagCache object"
      end
    end

    unless date.nil?
      unless date.is_a?(ActiveSupport::TimeWithZone)
        raise "date must be ActiveSupport::TimeWithZone"
      end
    else
      Time.zone = 'Bangkok'
      date = Time.zone.now
    end

    sequence = nil

    if category.present?
      sequence = Sequence.where('status = true AND category_caches_id = ? AND start_at < ? AND end_at > ?', category.id, date, date).order(start_at: :desc, end_at: :asc, updated_at: :desc).first
    else
      sequence = Sequence.where('status = true AND tag_caches_id = ? AND start_at < ? AND end_at > ?', tag.id, date, date).order(start_at: :desc, end_at: :asc, updated_at: :desc).first
    end

    sequence
  end
end
