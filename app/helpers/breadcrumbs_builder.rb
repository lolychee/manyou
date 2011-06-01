class BreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder

  def render
    arr = []
    @elements.each_with_index do |element, index|
      arr.push render_element(element, index)
    end
    @context.content_tag(:ul, arr.join(@context.content_tag(:li, (@options[:separator] || " &raquo; ").html_safe, :class => 'separator')).html_safe).html_safe
  end

  def render_element(element, index)
    content = @context.link_to(compute_name(element), compute_path(element))
    content = @context.content_tag(:li, content, :class => "element level-#{index+1} #{@context.current_page?(compute_path(element)) ? 'current_page' : nil}" )
  end

end
