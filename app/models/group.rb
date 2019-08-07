class Group < ApplicationRecord
    acts_as_paranoid

    has_many :user_groups
    has_many :users, through: :user_groups
    has_many :messages
    has_many :invites

    validates :name, presence: true
    validates :category, presence: true
    validates :owner_id, presence: true

    def privacy
        return self.private
    end

    def external_info
        {
            id: id,
            name: name,
            category: category,
            owner: User.find(owner_id).name
        }
    end
end
