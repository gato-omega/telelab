class Puerto < ActiveRecord::Base
  belongs_to :dispositivo
  has_one :device_connection
  has_one :endpoint, :through => :device_connection#, :class_name => 'Puerto'

  # Conecta un puerto con otro, haciendo la referencia bidireccional en endpoint
  def conectar(puerto)
    #Was I connected?...disconnect other end
    if self.endpoint
      self.endpoint.endpoint=nil
    end

    #Was puerto connected?,,,disconnect its end
    if puerto.endpoint
      puerto.endpoint.endpoint=nil
    end

    self.endpoint=puerto
    puerto.endpoint=self
  end

  #Disconnects self from endpoint and returns endpoint instance
  def desconectar
    was_endpoint= self.endpoint
    if was_endpoint
      self.endpoint.endpoint=nil
      self.endpoint=nil
    end    
    was_endpoint
  end

  def conectado?
    self.endpoint
  end

end
