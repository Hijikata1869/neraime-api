class User < ApplicationRecord
  before_update :prevent_guest_user_action, if: :guest_user?
  before_destroy :prevent_guest_user_action, if: :guest_user?
  before_save :prevent_guest_user_action, if: :guest_user?

  has_secure_password
  has_one_attached :profile_image

  has_many :crowdednesses, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_stores, through: :favorites, source: :store

  validates :nickname, :email, :password_digest, presence: true
  validates :nickname, length: { maximum: 30 }
  validates :self_introduction, length: { maximum: 200 }

  validates :email, uniqueness: { case_sensitive: false }

  private
    def prevent_guest_user_action
        errors.add(:base, "ゲストユーザーのユーザー情報は更新できません")
        throw(:abort)
    end

    def guest_user?
      persisted? && email_was == "guest@example.com"
    end

end
