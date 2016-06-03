class DatePickerInput < SimpleForm::Inputs::Base
  # "date"=>"2014-09-12", "date(1i)"=>"2014", "date(2i)"=>"9", "date(3i)"=>"5", "date(4i)"=>"18", "date(5i)"=>"00"
  def input(wrapper_options)
    passed_date = object ? object.send(attribute_name) : Date.today
    val = I18n.localize(passed_date || Date.today, format: :date_picker)
    @builder.text_field(attribute_name, 
                        input_html_options.merge(size:   10, 
                                                 width:  20,
                                                 value:  val, 
                                                 class:  'date form-control date_picker', 
                                                 format: :date_picker))
    # @builder.text_field(attribute_name, input_html_options.merge(:value => I18n.localize(object.date || Time.now, :format => :form)))
    # @builder.text_field(attribute_name, input_html_options)
  end
end

