# attribute_name: :date
# object: 
# input_html_options: {:class=>[:datetime_picker2, :required], :required=>false, :"aria-required"=>nil, :"aria-invalid"=>nil}
# input_options: {:valid_class=>"form-group-valid", :maxlength=>false, :minlength=>false, :pattern=>false, :min_max=>false, :readonly=>false, :placeholder=>false, :as=>:datetime_picker2}
class DatetimePicker2Input < SimpleForm::Inputs::Base
  def attr_day
    I18n.localize(object.send(attribute_name) || Time.now, format: :date_picker)
  end

  def input(wrapper_options)
    template.content_tag(:div, class: 'input-group date form_datetime', style: 'width: 75%') do
      template.concat @builder.text_field(attribute_name, 
                                           input_html_options.merge(value:  attr_day, 
                                                                    class:  'form-control date_picker mr-2', 
                                                                    format: :datetime_picker))
      template.concat(@builder.time_select(attribute_name, 
                                           input_options.merge(minute_step: 5, start_hour: 8, end_hour: 20, ignore_date: true), 
                                           input_html_options.merge(class: 'form-control mx-1')))
    end
  end
end

