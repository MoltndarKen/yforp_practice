class User < ActiveRecord::Base
  belongs_to :group
  mount_uploader :avatar, AvatarUploader
  attr_accessor :group_key
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,authentication_keys: [:email, :group_key]
  #association
  before_validation :group_key_to_id, if: :has_group_key?

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    group_key = conditions.delete(:group_key)
    group_id = Group.where(key: group_key).first
    email = conditions.delete(:email)
 
    # devise認証を、複数項目に対応させる
    if group_id && email
      where(conditions).where(["group_id = :group_id AND email = :email",
        { group_id: group_id, email: email }]).first
    elsif conditions.has_key?(:confirmation_token)
      where(conditions).first
    else
      false
    end
  end
  def name
    "#{self.family_name}#{self.first_name}"
  end
  def name_kana
    "#{self.family_name_kana}#{self.first_name_kana}"
  end

  def full_profile?
    self.family_name? && self.first_name? && self.family_name_kana? && self.first_name_kana? && self.avatar?
  end

  private
  def has_group_key?
    group_key.present?
  end
  def group_key_to_id
    group = Group.where(key: group_key).first_or_create
    self.group_id = group.id
  end
end
