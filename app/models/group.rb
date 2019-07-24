class Group < ApplicationRecord
    has_many :user_groups
    has_many :users, through: :user_groups
    has_many :messages

    validates :name, presence: true
    validates :category, presence: true
    validates :owner_id, presence: true
end
