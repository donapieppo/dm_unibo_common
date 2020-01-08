# @builder.text_field(attribute_name, merged_input_html_options)  ->
# "<input class="form-control ..." aria-invalid=\"true\" type=\"text\" value=\"1000.0\" name=\"repayment[payment]\" id=\"repayment_payment\" />"
class CurrencyFloatInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    currency = (options.delete(:currency) || '€').html_safe

    # {:class=>[:currency_float2, :optional], :required=>false, :"aria-required"=>nil, :"aria-invalid"=>true}
    input_html_options[:class] << 'numeric integer'
    merged_input_html_options = merge_wrapper_options(input_html_options, wrapper_options)

    input_group_class = 'input-group' # to have input-group-prepend
    input_group_class << ' is-invalid' if @builder.object.errors[attribute_name] # or .invalid-feedback is not displayed

    template.content_tag(:div, class: input_group_class) do 
      template.content_tag(:div, class: "input-group-prepend") do
        template.content_tag(:div, currency, class: "input-group-text") 
      end +
      @builder.text_field(attribute_name, merged_input_html_options) 
    end
  end
end

