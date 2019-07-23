class Group < ApplicationRecord
    has_many :user, through: :user_groups
    has_many :user_groups
end
