module DeviceCommandController

  def serial_create_vlan(vlan)

    p = vlan.puerto
    q = vlan.endpoint
    n = vlan.numero

    px = p.endpoint
    qx = q.endpoint

    pxname = px.nombre
    qxname = qx.nombre

    commands = [

        "#ENTER",
        "enable",
        "configure terminal",
        "interface #{pxname}",
        "switch mode access vlan #{n}",
        "swtich mode access",
        "no shutdown",
        "exit",
        "interface #{qxname}",
        "switch mode access vlan #{n}",
        "swtich mode access",
        "no shutdown",
        "exit",
        "exit",
        "exit"

    ]

    commands
    
  end

end