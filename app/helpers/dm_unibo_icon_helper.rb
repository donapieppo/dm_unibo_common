module DmUniboIconHelper
  def google_icon
    raw '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 488 512" width="18"><!--! Font Awesome Pro 6.1.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. --><path d="M488 261.8C488 403.3 391.1 504 248 504 110.8 504 0 393.2 0 256S110.8 8 248 8c66.8 0 123 24.5 166.3 64.9l-67.5 64.9C258.5 52.6 94.3 116.6 94.3 256c0 86.5 69.1 156.6 153.7 156.6 98.2 0 135-70.4 140.8-106.9H248v-85.3h236.1c2.3 12.7 3.9 24.9 3.9 41.4z"/></svg>'
  end

  def dm_icon(name, prefix = "solid", text: nil, size: nil, fw: true)
    text = text.blank? ? "" : " #{text}"
    c = "fa-#{prefix} fa-#{name} "
    c += " fa-#{size}" if size
    c += " fa-fw" if fw
    content_tag(:i, "", class: c) + text
  end
end
