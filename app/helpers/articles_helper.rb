module ArticlesHelper
  def source_select_options
    Article.sources.map{ |source| [t(source.first), source.last] }
  end

  def tag_select_options
    Tag.all.map{ |tag| [tag.name, tag.id] }
  end
end
