class DatetimePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    val = I18n.localize(object.send(attribute_name) || Time.now, format: :datetime_picker)
    @builder.text_field(attribute_name, 
                        input_html_options.merge(size:   20, 
                                                 width:  20,
                                                 value:  val, 
                                                 class:  'date form-control datetime_picker', 
                                                 format: :datetime_picker))
  end
end

