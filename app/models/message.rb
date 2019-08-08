class Message < ApplicationRecord
    acts_as_paranoid

    belongs_to :group
    belongs_to :user
    
    validates :user_id, presence: true
    validates :group_id, presence: true
    validates :content, presence: true

    def to_json(options)
        super(include: {user_name: user.name})
    end
end
