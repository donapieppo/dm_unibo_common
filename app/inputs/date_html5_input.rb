# attribute_name: :date
# object: 
# input_html_options: {:class=>[:datetime_picker2, :required], :required=>false, :"aria-required"=>nil, :"aria-invalid"=>nil}
# input_options: {:valid_class=>"form-group-valid", :maxlength=>false, :minlength=>false, :pattern=>false, :min_max=>false, :readonly=>false, :placeholder=>false, :as=>:datetime_picker2}
class DateHtml5Input < SimpleForm::Inputs::Base
  def attr_day
    I18n.localize(object.send(attribute_name) || Time.now, format: :date_html5)
  end

  def input(wrapper_options)
    template.content_tag(:div, class: 'input-group date', style: 'width: 75%') do
      template.concat @builder.date_field(attribute_name, 
                                           input_html_options.merge(value:  attr_day, 
                                                                    class:  'form-control', 
                                                                    html5: true))
    end
  end
end

