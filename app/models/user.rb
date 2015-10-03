class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
def name_kana
    "#{family_name_kana} #{first_name_kana}"
end

def full_profile?
    avatar? && family_name? && first_name? && family_name_kana? && first_name_kana?
end

private
def has_group_key?
  group_key.present?
end

end
