# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :validatable

  validates :email, presence: true
  validates :name, presence: true

  has_many :user_groups
  has_many :groups, through: :user_groups

  has_one_attached :avatar

  include DeviseTokenAuth::Concerns::User

  def token_validation_response
    login_data
  end

  def login_data
    {
      user: self,
      groups: groups.as_json(:include => :messages)
    }
  end

end
