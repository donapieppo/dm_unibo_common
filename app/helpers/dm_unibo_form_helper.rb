module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    def dm_error_notification(options = {})
      options[:message] = self.error :base if self.error :base 
      SimpleForm::ErrorNotification.new(self, options).render
    end
  end
end

module DmUniboFormHelper
  def vertical_form_for(record, options={}, &block)
    simple_form_for(record, options.merge({html: { class: 'form-vertical' }, wrapper: :vertical_form}), &block)
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


