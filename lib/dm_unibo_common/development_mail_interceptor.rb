# Action Mailer provides hooks into the Mail observer and interceptor methods. These allow you to register objects that are called during the mail delivery life cycle.
# An observer object must implement the :delivered_email(message) method which will be called once for every email sent after the email has been sent.
# An interceptor object must implement the :delivering_email(message) method which will be called before the email is sent, allowing you to make modifications to the email before it hits the delivery agents. Your object should make and needed modifications directly to the passed in Mail::Message instance.

module DmUniboCommon
  class DevelopmentMailInterceptor
    def self.delivering_email(message)
      if Rails.env.development?
        Rails.logger.info("Modify recipient mail.")
        message.subject = "[to :#{message.to} cc:#{message.cc} bcc:#{message.bcc}] #{message.subject}"
        message.to = Rails.configuration.dm_unibo_common[:interceptor_mails]
        message.cc = nil
        message.bcc = nil
      elsif !message.bcc.is_a?(Array)
        message.bcc = message.bcc ? [message.bcc] : []
      end
      if Rails.configuration.dm_unibo_common[:message_footer] && !Rails.configuration.dm_unibo_common[:message_footer].blank?
        message.body = message.body.to_s + "\n ------------------- \n" + Rails.configuration.dm_unibo_common[:message_footer]
      end
    end
  end
end
