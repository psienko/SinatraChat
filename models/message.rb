class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user

  validates_presence_of :user, :content
  delegate :nickname, to: :user
  field :content, type: String

  def self.build_chat_message(params)
    user = User.user_by_nick(params[:nickname])
    new(content: params[:content], user: user)
  end

  def to_json
    {
      nickname: nickname,
      content: content,
      timestamp: created_at.try(:strftime, "%H:%M:%S")
    }.to_json
  end
end
