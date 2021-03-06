module Talk::Api::Tenant
  class Messenger < Talk::Api::User::Messenger
    def initialize sender, message, type = :info
      super
    end

    def sender_class
      User::Account::Tenant
    end        
  end
end

