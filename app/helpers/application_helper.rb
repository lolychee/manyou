module ApplicationHelper

  def readability_time_format(time)
    time < 3.month.ago ? l(time, :format => :long) : "#{t 'time.some_times_ago', :time => time_ago_in_words(time)}"
  end

  def rich_content(content)
    auto_mention(auto_link(sanitize(content).bbcode_to_html({}, false, :enable, :image, :bold, :italics, :underline, :strikeout, :delete, :code, :ol, :ul, :link, :quote)))
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
  def link_to_user(user, options = {}, &block)
    name = yield(user) if block
    options[:class] ||= 'user-link'
    options[:title] ||= "#{user.name}'s person page"
    link_to (name || user.name), user_url(user), :title => options[:title], :class => options[:class]
  end

  def user_avatar(user, size = :normal)
    arr = {:small => 20, :normal => 48, :large => 80}
    img = user.avatar.send size
    image_tag img.url, :alt => "#{user.name}'s avatar", :class => 'user-avatar', :height => arr[size], :width => arr[size]
    #image_tag(user.gravatar_url(:size => options[:size]), :alt => "#{user.name}'s avatar", :class => 'user-avatar', :height => options[:size], :width => options[:size])
  end

  def link_to_user_avatar(user, options = {})
    options[:class] ||= 'user-avatar-link'
    options[:size]  ||= :normal
    link_to_user user, options do
      user_avatar(user, options[:size])
    end
  end

  def link_to_forum(forum)
  end

  def link_to_topic(topic, options = {}, &block)
    title = yield(topic) if block
    options[:class] ||= 'topic-link'
    options[:length] ||= 90
    options[:omission] ||= '...'
    link_to (title || topic.format_title(options[:length], options[:omission] )), topic_path(topic, :anchor => "last#{topic.replies.count}"), :class => options[:class]

  end



  def user_class(user)
    arr = []
    arr << 'follow' if current_user.follow_ids.include? user.id
    arr.join ' '
  end

  def topic_class(topic)
    arr = []
    #arr << "type-#{topic.type}"
    #arr << 'mark' if current_user.mark_ids.include? topic.id
    #arr << 'track' if topic.tracker_ids.include? current_user.id
    arr << 'untitled' if topic[:title].blank?
    arr.join ' '
  end

  def reply_class(reply)
  end

  def tag_class(tag)
  end

end
