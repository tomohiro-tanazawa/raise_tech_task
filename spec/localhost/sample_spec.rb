require 'spec_helper'

listen_port = 3000

describe package('nginx') do
  it { should be_installed }
end

describe package('unicorn') do
  it { should be_installed.by('gem').with_version('5.4.1') }
end

describe command('ruby -v') do
  its(:stdout) { should match /ruby 2\.6\.3/ }
end

describe command('ls -al /var/www/raisetech-live8-sample-app/config')do
  its(:stdout) { should match /credentials.yml.enc/}
end

describe command('ls /usr') do
  its(:exit_status) { should eq 0}
end

describe command('ls /foo') do
  its(:stderr) { should match /No such file or directory/ }
end

describe file('/etc/passwd') do
  it { should exist}
end

describe file('/var/www/raisetech-live8-sample-app/.gitignore') do
  its(:content) { should match /config\/master.key/ }
end


describe port(listen_port) do
  it { should be_listening }
end

describe command('curl http://127.0.0.1:#{listen_port}/_plugin/head/ -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end

describe routing_table do
  it do
    should have_entry(
      :destination => '169.254.169.254',
      :interface   => 'eth0',
    )
  end
end
