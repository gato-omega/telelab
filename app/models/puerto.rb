class Puerto < ActiveRecord::Base

  belongs_to :dispositivo
  has_one :device_connection
  has_one :endpoint, :through => :device_connection#, :class_name => 'Puerto'

  has_many :vlans

  validates :nombre, :presence => true
  validates :etiqueta, :uniqueness => true

  ## RUNTIME METHODS
  attr_accessor :current_practica
  attr_accessor :current_vlan

  ## FISICAMENTE

  # Conecta un puerto con otro, haciendo la referencia bidireccional en endpoint
  def conectar_fisicamente(other)
    #Was I connected?...disconnect other end
    if self.endpoint
      self.endpoint.endpoint=nil
    end

    #Was puerto connected?,,,disconnect its end
    if other.endpoint
      other.endpoint.endpoint=nil
    end

    self.endpoint=other
    other.endpoint=self
  end

  #Disconnects self from endpoint and returns endpoint instance
  def desconectar_fisicamente
    was_endpoint= self.endpoint
    if was_endpoint
      self.endpoint.endpoint=nil
      self.endpoint=nil
    end
    was_endpoint
  end

  def conectado_fisicamente?
    self.endpoint
  end

  ##LOGICAMENTE
  

  # Conecta un puerto con otro, haciendo la referencia bidireccional en endpoint
  def conectar_logicamente(other)
    check_context
    @current_vlan = Vlan.new
    @current_vlan.puerto = self
    @current_vlan.endpoint = other
    @current_vlan.practica =  @current_practica
    if @current_vlan.save
      @current_vlan
    end
  end

  #Disconnects self from endpoint and returns endpoint instance
  def desconectar_logicamente
    check_context
  end

  def conectado_logicamente?
    check_context
  end

  def check_context
    check_ok = false
    begin
      @current_practica = Practica.find(@current_practica.id)
      if @current_practica
        check_ok=true
      end
    rescue
    end
    if !check_ok
      raise 'Invalid vlan conenction context, check self.current_practica'
    end
  end

  #def check_vlan
  #  check_context
  #  if @current_vlan
  #
  #  end
  #end

end
