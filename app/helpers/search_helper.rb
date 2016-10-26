module SearchHelper
  include Twitter::Autolink

  def auto_link_content message_str=''
    auto_link(message_str)
  end
end
