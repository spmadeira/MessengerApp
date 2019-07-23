# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable

  validates :email, presence: true
  validates :name, presence: true
  
  has_many :user_groups
  has_many :groups, through: :user_groups

  include DeviseTokenAuth::Concerns::User
end
