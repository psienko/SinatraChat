class Message
  attr_accessor :nickname, :content, :timestamp

  def initialize(nickname: nil, content: nil)
    @nickname = nickname
    @content = content
    @timestamp = timestamp
  end

  def to_json
    {
      nickname: nickname,
      content: content,
      timestamp: timestamp
    }.to_json
  end

  private

  def timestamp
    Time.now.strftime("%H:%M:%S")
  end
end
