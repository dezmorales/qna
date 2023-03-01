class SearchService
  attr_reader :query, :scope
  TYPES = %w[Question Answer User Comment All].freeze

  def initialize(query, scope = nil)
    @query = query
    @scope = scope
  end

  def call
    return nil unless TYPES.include?(@scope)
    return ThinkingSphinx.search(@query) if @scope == 'All'
    @scope.constantize.search(@query)
  end
end
