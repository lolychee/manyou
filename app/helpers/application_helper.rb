module ApplicationHelper

  def readability_time_format(time)
    time < 3.month.ago ? l(time, :format => :long) : "#{t 'time.some_times_ago', :time => time_ago_in_words(time)}"
  end

  def rich_content(content)
    auto_mention(auto_link(sanitize(content).bbcode_to_html))
  end

  def auto_mention(text)
    text.gsub(/@([_0-9a-zA-Z]+)[:]/i) do
      username = $1
      if auto_linked?($`, $')
        $&
      else
        "@#{link_to username, user_path(username)}:"
      end
    end
  end

  # resources link helper methods
  def link_to_user(user)
    link_to user.name, user_url(user.username), :title => "#{user.name}'s person page", :class => 'user-link'
  end

  def user_avatar(user, options = {})
    options[:size] ||= 48
    #image_tag(user.gravatar_url(:size => options[:size]), :alt => "#{user.name}'s avatar", :class => 'user-avatar', :height => options[:size], :width => options[:size])
    image_tag(user.avatar.normal.url, :alt => "#{user.name}'s avatar", :class => 'user-avatar', :height => options[:size], :width => options[:size])
  end

  def link_to_user_avatar(user, options = {})
    options[:size] ||= 48
    link_to user_avatar(user, options), user_url(user.username), :title => "#{user.name}'s person page", :class => 'user-avatar-link'
  end

  def link_to_forum(forum)
  end

  def forum_avatar(forum)
  end

  def link_to_forum_avatar(forum)
  end

  def link_to_topic(topic)
  end

  def link_to_topic(tag)
  end



  def widget_box(css_class, title = nil, &block)
    content = capture(&block) if block_given?
    content = "<h3 class=\"widget-box-title\">#{title}</h3>" + content unless title == nil
    content = "<div class=\"widget-box #{css_class}\">" + content
    content += "</div>"
    content.html_safe
  end

  def user_page_class(user)
  end

  def topic_page_class(topic)
    arr = []
    arr << 'mark' if current_user.mark_ids.include? topic.id
    arr << 'track' if topic.tracker_ids.include? current_user.id
    arr.join(' ')
  end

  def reply_page_class(reply)
  end

  def tag_page_class(tag)
  end

end
