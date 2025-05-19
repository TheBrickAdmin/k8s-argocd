# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rbconfig'

# Change to NAT if needed (BRIDGE is default)
BUILD_MODE = ENV['BUILD_MODE'] || "BRIDGE" 
IP_NW = "192.168.56"
MASTER_IP_START = 10
NODE_IP_START = 20

# Function to detect if the host is Windows
def is_windows?
  RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
end

# Function to get the default network interface handles both windows and linux
def default_bridge_interface
  if is_windows?
    "Intel(R) Ethernet"
  else
    `ip route | grep default | awk '{ print $5 }'`.chomp
  end
end

# Set default provider to Hyper-V if on Windows, otherwise VirtualBox
DEFAULT_PROVIDER = is_windows? ? "hyperv" : "virtualbox"

Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian12"

  # Set default provider
  config.vm.provider DEFAULT_PROVIDER do |vb, override|
    override.vm.box = "generic/debian12"
    vb.memory = 2048
    vb.cpus = 2
    # For Hyper-V, set VM integration and switch
    if DEFAULT_PROVIDER == "hyperv"
      vb.vm_integration_services = {
        guest_service_interface: true
      }
      vb.linked_clone = true
      vb.vmname = "methos_k8s"
      vb.maxmemory = 4096
      vb.cpus = 2
      vb.memory = 2048
    end
  end

  config.vm.define "control-plane" do |node|
    node.vm.hostname = "control-plane"
    node.vm.provider DEFAULT_PROVIDER do |vb|
      vb.vmname = "control-plane"
    end
    if BUILD_MODE == "BRIDGE"
      if DEFAULT_PROVIDER == "hyperv"
        node.vm.network :public_network, bridge: ENV['HYPERV_VSWITCH'] || "Default Switch"
      else
        bridge_interface = default_bridge_interface
        node.vm.network :public_network, bridge: bridge_interface
      end
    else
      node.vm.network "private_network", ip: "#{IP_NW}.#{MASTER_IP_START}"
    end
    node.vm.provision "shell" do |s|
      s.name = "configure-firewall"
      s.path = "scripts/configure-control-plane-firewall.sh"
      s.privileged = true
    end
  end

  (1..2).each do |i|
    hostname = "node-#{'%02d' % i}"
    config.vm.define "#{hostname}" do |node|
      node.vm.hostname = "#{hostname}"
      node.vm.provider DEFAULT_PROVIDER do |vb|
        vb.vmname = hostname
        vb.cpus = 1
        vb.memory = 2048
      end
      if BUILD_MODE == "BRIDGE"
        if DEFAULT_PROVIDER == "hyperv"
          node.vm.network :public_network, bridge: ENV['HYPERV_VSWITCH'] || "Default Switch"
        else
          bridge_interface = default_bridge_interface
          node.vm.network :public_network, bridge: bridge_interface
        end
      else
        node.vm.network "private_network", ip: "#{IP_NW}.#{NODE_IP_START + i}"
      end
      node.vm.provision "shell" do |s|
        s.name = "configure-firewall"
        s.path = "scripts/configure-worker-node-firewall.sh"
        s.privileged = true
      end
    end
  end

  shell_provision_configs = [
    {
      "name" => "disable-swap",
      "path" => "scripts/disable-swap.sh"
    },
    {
      "name" => "install-essential-tools",
      "path" => "scripts/install-essential-tools.sh"
    },
    {
      "name" => "allow-bridge-nf-traffic",
      "path" => "scripts/allow-bridge-nf-traffic.sh"
    },
    {
      "name" => "install-containerd",
      "path" => "scripts/install-containerd.sh"
    },
    {
      "name" => "install-kubeadm",
      "path" => "scripts/install-kubeadm.sh"
    },
    {
      "name" => "update-kubelet-config",
      "path" => "scripts/update-kubelet-config.sh",
      "args" => ["eth0"] # Change eth1 to the correct interface
    }
  ]

  shell_provision_configs.each do |cfg|
    config.vm.provision "shell" do |s|
      s.name = cfg["name"]
      s.path = cfg["path"]
      s.privileged = cfg["privileged"] ? cfg["privileged"] : true
      s.args = cfg["args"] ? cfg["args"] : []
    end
  end

  config.vm.synced_folder ".", "/vagrant", type: "rsync" if DEFAULT_PROVIDER == "hyperv"
end
