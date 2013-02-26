module Talk
  module Property
    class Message < Talk::Message
      embedded_in :dialog, class_name: 'Talk::Property::Dialog', inverse_of: :messages

      alias_method :property_dialog, :dialog
      alias_method :thread, :dialog
      alias_method :thread=, :dialog=

      delegate :type, :conversation,  to: :property_dialog
      delegate :property,             to: :property_dialog

      field :sender_type, type: String

      validates :dialog,      presence: true
      validates :sender_type, presence: true, inclusion: {in: ['system', 'tenant', 'landlord']}

      def self.from sender_type, message, dialog
        self.create construct_args(sender_type, message, dialog)
      end

      protected

      def self.construct_args sender_type, message, dialog
        message_args(message).merge(sender_type: sender_type, dialog: dialog)
      end

      def self.message_args message
        [:body, :state].each do |arg|
          raise ArgumentError, "Message must contain #{arg}" unless message.respond_to?(arg)
        end
        {body: message.body, state: message.type}
      end
    end
  end
end