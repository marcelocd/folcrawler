module ArticlesHelper
  def source_select_options
    Article.sources.map{ |source| [t(source.first), source.last] }
  end
end
