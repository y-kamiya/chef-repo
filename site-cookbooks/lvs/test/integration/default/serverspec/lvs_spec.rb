require 'serverspec'

set :backend, :exec

describe file('/etc/sysctl.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /net.ipv4.ip_forward=1/ }
    its(:content) { should match /net.ipv4.vs.conntrack=1/ }
end

describe 'Linux Kernel parameters' do
    context linux_kernel_parameter('net.ipv4.ip_forward') do
        its(:value) { should eq 1 }
    end
    context linux_kernel_parameter('net.ipv4.vs.conntrack') do
        its(:value) { should eq 1 }
    end
end

describe iptables do
    it { should have_rule('-A POSTROUTING -m ipvs --vaddr 192.168.0.2 --vport 80 -j SNAT --to-source 192.168.0.11').with_table('nat').with_chain('POSTROUTING') }
end

describe package('keepalived') do
    it { should be_installed }
end

describe service('keepalived') do
    it { should be_enabled }
    it { should be_running }
end

describe file('/etc/keepalived/keepalived.conf') do
    it { should be_file }
    its(:content) { should match /^virtual_server 192.168.0.2 80/ }
end
