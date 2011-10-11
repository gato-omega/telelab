module DeviceCommandController

  def serial_create_vlan(vlan)

    p = vlan.puerto
    q = vlan.endpoint
    n = vlan.numero

    px = p.endpoint
    qx = q.endpoint

    pxname = px.nombre
    qxname = qx.nombre

    commands = "en\nconft\ninterface #{pxname}\nswitch mode access vlan #{n}\nswtich mode access\nno shutdown\nexit\ninterface #{qxname}\nswitch mode access vlan #{n}\nswtich mode access\nno shutdown".split "\n"
  end

end