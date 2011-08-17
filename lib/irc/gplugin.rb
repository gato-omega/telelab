class Messenger
  include Cinch::Plugin

  def execute(m, receiver, message)
    User(receiver).send(message)
  end
end