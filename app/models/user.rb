class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :confirm_friend, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships
  has_many :pending_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend
  has_many :inverted_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friend_requests, through: :inverted_friendships, source: :user

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_array += inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    friends_array.compact
  end

  def request_friend(user)
    return false if relation_exist?(user)

    friendship = friendships.build
    friendship.friend_id = user.id
    friendship.confirmed = false
    friendship.save
  end

  def confirm_friend(user)
    friend = Friendship.find_by(user_id: user.id, friend_id: id)
    friend.update_attributes(confirmed: true)
    Friendship.create!(friend_id: user.id,
                       user_id: id,
                       confirmed: true)
  end

  def reject_friend(user)
    friendship = inverse_friendships.find { |friend| friend.user == user }
    friendship.destroy
  end

  def friend?(user)
    friends.include?(user)
  end

  def friendship(user)
    friendships.find { |friendship| friendship.friend_id == user.id }
  end

  def relation_exist?(user)
    friends.include?(user) || pending_friends.include?(user) || friend_requests.include?(user) || user == self
  end

  def friends_and_own_posts
    Post.where(user: (friends << self))
    # This will produce SQL query with IN. Something like: select * from posts where user_id IN (1,45,874,43);
  end
end
