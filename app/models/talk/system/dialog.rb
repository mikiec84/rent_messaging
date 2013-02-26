module Talk
  module System
    class Dialog < ::Talk::Dialog
      include BasicDocument

      def self.default_state
        'info'
      end

      def self.valid_states
        %w{info warning error'}
      end

      def self.message_class
        'Talk::System::Message'
      end      

      field :state, type: String, default: default_state
      field :type,  type: String, default: 'system'

      validates :state, presence: true, inclusion: {in: valid_states }

      embeds_many :messages, class_name: message_class, as: :msg_dialog

      belongs_to :conversation, class_name: 'Talk::System::Conversation'

      class << self
        def about conversation, type = :info
          self.create conversation: conversation, type: type
        end
      end

      delegate :replier, :receiver, :initiator, to: :conversation

      def to_s
        %Q{
    id:           #{id}
    conversation: #{conversation.id if respond_to? :conversation}

    receiver:     #{receiver.name if receiver}
    state:        #{state}

    messages:     #{messages}
    }
      end
    end
  end
end