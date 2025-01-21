# NOTES

```tf
    # Establishes connection to be used by all
    # generic remote provisioners (i.e. file/remote-exec)
    connection {
      type     = "ssh"
      user     = "checker"
      password = "checker"
      host     = self.ssh_host
    }

    provisioner "remote-exec" {
        inline = [
          "echo checker | sudo -S -i",
          "sudo rm -f /etc/machine-id",
          "sudo rm -f /var/lib/dbus/machine-id",
          "sudo systemd-machine-id-setup",
          "sudo systemctl restart systemd-networkd",
        ]
	  }
```