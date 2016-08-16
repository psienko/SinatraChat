class User
  include Mongoid::Document
  has_many :messages
  field :nickname, type: String

  validates_presence_of :nickname

  def self.user_by_nick(nick)
    find_or_create_by(nickname: nick.downcase)
  end
end
