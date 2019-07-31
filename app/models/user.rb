# frozen_string_literal: true

class User < ActiveRecord::Base
  #Logic Exclusion
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :validatable

  #validates :email, presence: true
  #validates :name, presence: true
  validates :uid, presence: true
  validates :provider, presence: true

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :invites
  
  #Pesado no banco, ver como refazer
  def invite_groups
    @g = Group.new
    @array = [@g]
    
    invites.each do |invite|
      @array += [invite.group]
    end

    @array -= [@g]

    return @array
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.credentials.first_name
      user.token = auth.credentials.token
      user.expires = auth.credentials.expires
      user.expires_at = auth.credentials.expires_at
      user.refresh_token = auth.credentials.refresh_token
    end
  end

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>"}
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/png']

  include DeviseTokenAuth::Concerns::User

  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  def token_validation_response
    user_data
  end

  def user_data
    {
      user: {
        id: id,
        email: email,
        name: name,
        avatar: avatar
      },
      groups: groups.as_json(:include => :messages)
    }
  end
end
