require 'spec_helper'

describe 'archlinux_workstation::all' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    :concat_basedir  => '/tmp',
  }}

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::all') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }
        
        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::all') } 
      end
    end
  end # end context 'parent class'

  context 'child classes' do
    describe 'classes included in all' do
      it { should contain_class('archlinux_workstation::ssh') }
      it { should contain_class('archlinux_workstation::sudo') }
      
    end
  end

end
