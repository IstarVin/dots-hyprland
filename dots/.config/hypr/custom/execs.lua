
hl.on("hyprland.start", function ()
    hl.exec_cmd("sleep 3 && bluetoothctl connect 2A:5F:37:03:A6:FD")
    hl.exec_cmd("mount /mnt/toshiba")
    -- hl.exec_cmd("mount /mnt/aj-server")
end)
