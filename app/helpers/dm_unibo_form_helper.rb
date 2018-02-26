module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    def dm_error_notification(options = {})
      options[:message] = self.error :base if self.error :base 
      SimpleForm::ErrorNotification.new(self, options).render
    end
  end
end

module DmUniboFormHelper
  def dm_form_for(record, options={}, &block)
    content_tag :div, class: "dm-form" do
      concat(content_tag(:div, options[:title] || @dm_form_title, class: "dm-form-title"))
      concat(content_tag(:div, class: "dm-form-body") do
        simple_form_for(record, options, &block)
      end)
    end
  end

  def vertical_form_for(record, options={}, &block)
    options[:wrapper] = :vertical_form
    options[:html] ||= {}
    options[:html][:class] ||= ""
    options[:html][:class] += ' form-vertical '
    simple_form_for(record, options, &block)
  end

  def horizontal_form_for(record, options={}, &block)
    options[:wrapper] = :horizontal_form
    options[:html] ||= {}
    options[:html][:class] ||= ""
    options[:html][:class] += ' form-horizontal '
    simple_form_for(record, options, &block)
  end

  def form_legend(what)
    raw "<legend>" + (what.new_record? ? "Nuovo " : "Modifica ") + (what.model_name.human.downcase) + "</legend>"
  end
end


