class Message < ActiveRecord::Base
  belongs_to :practica
  belongs_to :dispositivo
  belongs_to :user

  validates :practica_id, :presence => true
  validates :dispositivo_id, :presence => true
  validates :user_id, :presence => true


end
