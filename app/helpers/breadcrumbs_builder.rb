class BreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder

  def render
    temp = []
    @elements.each_with_index do |element, index|
      temp.push render_element(element, index)
    end
    temp.join(@context.content_tag(:span, (@options[:separator] || " &raquo; ").html_safe, :class => 'separator'))
  end

  def render_element(element, index)
    content = @context.link_to(compute_name(element), compute_path(element))
    content = @context.content_tag(:span, content, :class => "level-#{index+1} #{@context.current_page?(compute_path(element)) ? 'current_page' : nil}" )
  end

end
