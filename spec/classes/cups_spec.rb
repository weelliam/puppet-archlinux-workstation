require 'spec_helper'

describe 'archlinux_workstation::cups' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    let(:params) {{ }}

    it { should compile.with_all_deps }

    cups_packages = [
      'cups',
      'cups-filters',
      'cups-pdf',
      'foomatic-db',
      'foomatic-db-engine',
      'foomatic-db-nonfree',
      'ghostscript',
      'gsfonts',
      'gutenprint',
      'hplip',
      'libcups',
    ]

    cups_packages.each do |pkgname|
      describe "package #{pkgname}" do
        it { should contain_package(pkgname).with_ensure('present') }
      end
    end

    it { should contain_service('org.cups.cupsd').with({
      'enable' => true,
      'ensure' => 'running',
    }).that_requires('Package[cups]') }

  end

end
