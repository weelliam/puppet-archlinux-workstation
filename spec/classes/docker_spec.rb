require 'spec_helper'

describe 'archlinux_workstation::docker' do
  let(:facts) { spec_facts }

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::docker') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }

        it { should contain_file('/etc/conf.d')
                     .with({
                       :ensure => 'directory',
                       :owner  => 'root',
                       :group  => 'root',
                       :mode   => '0755'
                      })
                     .that_comes_before('Class[docker]')
        }

        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::docker') }
      end
    end
  end # end context 'parent class'
  context 'parameters' do
    let(:facts) { spec_facts }
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_class('docker') }
    end

    describe 'virtual user has group added' do
      let(:params) {{ }}

      it { should compile.with_all_deps }
      it { should contain_user('myuser')
                   .with_groups(['sys', 'docker'])
                   .that_requires(['Group[myuser]', 'Class[docker]'])
      }
    end

  end

end
