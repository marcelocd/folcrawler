module ArticlesHelper
  def source_select_options
    Article.sources.keys.map{ |source| [t(source), source] }
  end
end
