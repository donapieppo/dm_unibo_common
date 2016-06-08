module DmUniboCommon
  module UserUpnMethods
    module ClassMethods
      # Example
      # class Thesis < ActiveRecord::Base
      #   extend DmUniboCommon::UserUpnMethods::ClassMethods
      #   belongs_to_dsa_user :supervisor
      # end
      #
      # is equinvalent to a
      # belongs_to :supervisor, class: User, foreign_key: supervisor_id
      # validate dsa_validate_supervisor
      #
      # creates the methods:
      # * <tt>supervisor_upn=</tt>
      # * <tt>supervisor_upn</tt>
      # * <tt>dsa_validate_supervisor</tt>
      # Include is for adding methods to an instance of a class and extend is for adding class methods
      def belongs_to_dsa_user(*args)
        # upns_cache[Supervisor] = 'pietro.donatini@unibo.it'
        # serve perche' supervisor_upn in lettura puo' essere .supervisor.upn
        define_method("upns_cache") do 
          @_upns_cache ||= Hash.new
        end

        args.each do |user_class|
          belongs_to user_class.to_sym, class_name: ::User, foreign_key: "#{user_class.to_s}_id".to_sym

          # examiner_upn
          define_method(user_class.to_s + "_upn") do
            upns_cache[user_class] || self.send(user_class).try(:upn)
          end

          # examiner_upn=
          define_method(user_class.to_s + "_upn=") do |upn|
            upns_cache[user_class] = upn
          end

          # validate_examiner
          # se e' definito @@_user_upn[:examiner] setto examiner da dsa
          define_method("dsa_validate_" + user_class.to_s) do 
            # il nil non comporta nulla. Se si vuole nil si mette thesis.supervisor = nil e non 
            # thesis.supervisor_upn = nil.
            # invece thesis.supervisor_upn = '' e' ok per gli update_attributes
            return if upns_cache[user_class].nil? 

            if upns_cache[user_class].blank?
              Rails.logger.info "eliminate #{user_class}_upn"
              self.send(user_class.to_s + '=', nil)
            else
              begin
                # examiner = User.find_or_syncronize(...)
                # self.send("#{user_class.to_s}=", self.send(user_class).class.find_or_syncronize(@@_user_upn[user_class]))
                self.send(user_class.to_s + '=', ::User.find_or_syncronize(upns_cache[user_class]))
              rescue => e
                Rails.logger.info "#{e.to_s} while validating #{user_class}_upn=#{upns_cache[user_class]}"
                self.errors.add("#{user_class}_upn".to_sym, e.to_s)
                self.errors.add(:base, e.to_s)
              end
            end
            true
          end

          validate "dsa_validate_#{user_class.to_s}".to_sym
        end
      end
    end
  end
end



