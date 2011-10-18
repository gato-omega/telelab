class Puerto < ActiveRecord::Base

  belongs_to :dispositivo
  has_one :device_connection
  has_one :endpoint, :through => :device_connection#, :class_name => 'Puerto'

  has_many :vlans

  validates :nombre, :presence => true
  validates :etiqueta, :uniqueness => {:scope => :dispositivo_id}

  ## CONSTANTS
  ESTADOS = %w[ok bad]


  ## RUNTIME ATTRIBUTES
  attr_accessor :current_practica
  attr_accessor :current_vlan


  # Returns only physically connected ports
  # @return [Array]
  def self.conectados_fisicamente
    all.select do |puerto|
      puerto.conectado_fisicamente?
    end
  end

  ## CONEXIONES FISICAS

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

  ##LOGICAMENTE -- needs context


  # Conecta un puerto con otro, haciendo la referencia bidireccional en endpoint
  def conectar_logicamente(other)
    check_context
    if other.check_context.eql? @current_practica
      desconectar_logicamente
      puts "seee entra @current_practica 1 #{@current_practica} "
      puts "seee entra @current_vlan 1 #{@current_vlan} "

      @current_vlan = Vlan.new
      @current_vlan.puerto = self
      @current_vlan.endpoint = other
      @current_vlan.practica =  @current_practica
      if @current_vlan.save
        @current_vlan.endpoint.check_context
      else
        raise "Could not connect!#{@current_vlan.errors.inspect}"
      end
    else
      raise 'Practica contexts dont match'
    end
    @current_vlan

  end

  #Disconnects self from endpoint and returns endpoint instance
  def desconectar_logicamente
    check_context
    if @current_vlan
      was_endpoint = @current_vlan.endpoint
      if was_endpoint.eql? self
        was_endpoint = @current_vlan.puerto
      end
      @current_vlan.destroy
      was_endpoint.check_context false
      was_endpoint
    end
  end

  def conectado_logicamente?
    logical_endpoint
  end

  # Checks if puerto instance has an associated practica to allow logical connections
  def check_context(enforce=true)
    puts "Checking context"
    check_ok = false
    begin
      if @current_practica
        get_vlan
        check_ok=true
      end
    rescue
    end
    if check_ok
      @current_practica
    else
      if enforce
        raise 'Invalid vlan connection context, check @current_practica'
      else
        nil
      end
    end
  end

  # Returns logical endpoint
  def logical_endpoint
    check_context
    if @current_vlan
      @current_vlan.endpoint
    else
      nil
    end
  end

  # Sets logical endpoint
  def logical_endpoint=(other)
    self.conectar_logicamente other
  end

  # Gets the vlan from database
  private
  def get_vlan
    @current_vlan = Vlan.where((:puerto_id >> self.id || :endpoint_id >> self.id) && :practica_id >> @current_practica.id).first
  end

end
