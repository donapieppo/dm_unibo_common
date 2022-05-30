module DmUniboIconHelper 
  def dmicon(name, text: "", size: 18, prefix: 'fas', style: '')
    text = text.blank? ? '' : " #{text}"
    content_tag(:i, '', style: "font-size: #{size}px; #{style}", class: "#{prefix} fa-#{name}") + text
  end

  def fwdmicon(name, text: "", size: 18, prefix: 'fas')
    raw "<i style=\"font-size: #{size}px\" class=\"#{prefix} fa-#{name} fa-fw\"></i> #{text}"
  end

  def big_dmicon(name, text: "", size: 24, prefix: 'fas')
    dmicon(name, text: text, size: size, prefix: prefix)
  end
end
