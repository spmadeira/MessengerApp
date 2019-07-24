class Message < ApplicationRecord
    belongs_to :group
    belongs_to :user
    
    validates :user_id, presence: true
    validates :group_id, presence: true
    validates :content, presence: true
end
