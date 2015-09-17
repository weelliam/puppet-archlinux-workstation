require 'spec_helper'

describe 'archlinux_workstation::makepkg' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    :concat_basedir  => '/tmp',
    :processorcount  => 8,
    # structured facts
    :os              => { 'family' => 'Archlinux' },
    :processors      => { 'count' => 8 },
  }}

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::makepkg') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }
        
        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::makepkg') } 
      end
    end
  end # end context 'parent class'

  context 'parameters' do
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_file('/etc/makepkg.conf')
                   .with_ensure('present')
                   .with_owner('root')
                   .with_group('root')
                   .with_mode('0644')
                   .with_content(/MAKEFLAGS="-j8"/)
      }

      it { should contain_file('/tmp/sources')
                   .with_ensure('directory')
                   .with_owner('myuser')
                   .with_mode('0775')
      }

      it { should contain_file('/tmp/makepkg')
                   .with_ensure('directory')
                   .with_owner('myuser')
                   .with_mode('0775')
      }

      it { should contain_file('/tmp/makepkglogs')
                   .with_ensure('directory')
                   .with_owner('myuser')
                   .with_mode('0775')
      }

      it { should contain_file('/usr/local/bin/maketmpdirs.sh')
                   .with_ensure('present')
                   .with_mode('0755')
                   .with_content(%r"ARCHUSER=myuser")
                   .with_content(%r"for x in sources makepkg makepkglogs; do mkdir /tmp/\$x ; chown \${ARCHUSER}:wheel /tmp/\$x ; chmod 0775 /tmp/\$x; done")
      }

      it { should contain_file('/etc/systemd/system/maketmpdirs.service')
                   .with_ensure('present')
                   .with_mode('0644')
                   .with_source('puppet:///modules/archlinux_workstation/maketmpdirs.service')
                   .with_require('File[/usr/local/bin/maketmpdirs.sh]')
      }

      it { should contain_service('maketmpdirs').with({
        'enable' => true,
      }).that_requires('File[/etc/systemd/system/maketmpdirs.service]') }

    end

    describe "make_flags explicitly defined" do
      let(:params) {{
        'make_flags' => '-j1',
      }}

      it { should compile.with_all_deps }

      it do
        should contain_file('/etc/makepkg.conf') \
          .with_content(/MAKEFLAGS="-j1"/)
      end
    end

  end

end
