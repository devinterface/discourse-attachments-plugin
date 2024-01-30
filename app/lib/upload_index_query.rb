# frozen_string_literal: true

class UploadIndexQuery
  def initialize(params = {}, klass = Upload, trust_levels = TrustLevel.levels)
    @params = params
    @query = initialize_query_with_order(klass)
    @trust_levels = trust_levels
  end

  attr_reader :params, :trust_levels

  SORTABLE_MAPPING = {
    "created" => "created_at"
  }

  def find_uploads(limit = 100)
    page = params[:page].to_i - 1
    page = 0 if page < 0
    find_users_query.limit(limit).offset(page * limit)
  end

  def initialize_query_with_order(klass)
    order = []

    custom_order = params[:order]
    custom_direction = params[:asc].present? ? "ASC" : "DESC"
    if custom_order.present? &&
         without_dir = SORTABLE_MAPPING[custom_order.downcase.sub(/ (asc|desc)\z/, "")]
      order << "#{without_dir} #{custom_direction}"
    end

    order << "uploads.created_at DESC" if !custom_order.present?

    query = klass.includes(upload_references: :target).order(order.reject(&:blank?).join(","))

    query = query unless params[:stats].present? && params[:stats] == false

    query = query.joins(:primary_email) if params[:show_emails] == "true"

    query
  end

  def filter_by_trust
    levels = trust_levels.map { |key, _| key.to_s }
    if levels.include?(params[:query])
      @query.where("trust_level = ?", trust_levels[params[:query].to_sym])
    end
  end

  def filter_by_search
    filter = params[:filter]
    if filter.present?
      @query.where('uploads.original_filename ILIKE ?', "%#{filter}%")
    end
  end

  def filter_exclude
    @query.where("uploads.id != ?", params[:exclude]) if params[:exclude].present?
  end

  # this might not be needed in rails 4 ?
  def append(active_relation)
    @query = active_relation if active_relation
  end

  def find_users_query
    append filter_by_trust
    append filter_exclude
    append filter_by_search
    @query
  end
end
