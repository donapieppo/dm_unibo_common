module OmniAuth
  module Strategies
    # This will create a strategy that, when the user visits `/auth/test`
    class Test
      include OmniAuth::Strategy

      option :fields, %i[name email]
      option :uid_field, :email

      def request_phase
        form = OmniAuth::Form.new(title: "User Info", url: callback_path, method: "get")
        options.fields.each do |field|
          form.text_field field.to_s.capitalize.tr("_", " "), field.to_s
        end
        form.button "Sign In"
        form.to_response
      end

      uid do
        request.params[:user_id_id]
      end

      info do
        options.fields.inject({}) do |hash, field|
          hash[field] = request.params[field.to_s]
          hash
        end
      end
    end
  end
end
