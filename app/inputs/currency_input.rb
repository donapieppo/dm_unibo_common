class CurrencyInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    input_html_options[:class] << 'form-control-inline numeric integer'
    @builder.text_field(attribute_name, input_html_options) + 
    template.content_tag(:span, " <strong>,00 &euro;</strong>".html_safe)
    #template.content_tag(:span, ",00 &euro;".html_safe, class: "input-group-addon")
  end
end
