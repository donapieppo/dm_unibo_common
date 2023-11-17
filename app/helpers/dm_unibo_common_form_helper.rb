module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    def dm_error_notification(options = {})
      options[:message] = self.object.errors[:base].first if self.object.errors[:base].any?
      SimpleForm::ErrorNotification.new(self, options).render
    end
  end
end

module DmUniboCommonFormHelper
  def dm_form_default_title(record)
    record = record[-1] if record.is_a?(Array)
    (record.new_record? ? t(:new) : t(:edit)) + " " + t("activerecord.models." + record.class.name.underscore).downcase
  end

  def dm_form_for(record, options = {}, &block)
    title = options.delete(:title) || @dm_form_title || dm_form_default_title(record)
    content_tag :div, class: "dm-form" do
      concat(content_tag(:div, title, class: "dm-form-title"))
      concat(content_tag(:div, class: "dm-form-body") do
        simple_form_for(record, options, &block)
      end)
    end
  end

  def vertical_form_for(record, options = {}, &block)
    options[:wrapper] = :vertical_form
    options[:html] ||= {}
    options[:html][:class] ||= ""
    options[:html][:class] += " form-vertical "
    simple_form_for(record, options, &block)
  end

  def horizontal_form_for(record, options = {}, &block)
    options[:wrapper] = :horizontal_form
    options[:html] ||= {}
    options[:html][:class] ||= ""
    options[:html][:class] += " form-horizontal "
    simple_form_for(record, options, &block)
  end
end
