Name:           pxzgrep
Version:        1.0.0+dev
Release:        0
Summary:        parallel xzgrep wrapper
Group:          System
License:        GPL
URL:            https://github.com/ETHZ-IT-SeC/pxzgrep
Source:         https://github.com/ETHZ-IT-SeC/%{name}/archive/%{version}/%{name}-%{version}.tar.gz
Prefix:         %{_prefix}
Packager: 	Axel Beckert <axel@ethz.ch>

%description
If you need to grep through terabytes of compressed log files, this
can take a lot of time if you do it serial - even on fast hardware.

But since such amounts of logs are usually not stored in a single file
and most servers today have multiple cores anyway, you can get a
massive speed up if you run multiple xzgrep processes in parallel.

pxzgrep automates this.

%prep
mkdir -p build/
%setup -q -n %{name}-%{version}

%build
make

%check
make check

%install
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
mkdir -p build/usr/bin

make DESTDIR=$RPM_BUILD_ROOT PREFIX=%{_prefix} install
rm -rf $RPM_BUILD_ROOT%{_datadir}/doc/%{name}

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
make clean
rm -rf build

%files
%defattr(-,root,root)
%doc README.md LICENSE.md CHANGELOG.md TODO.md
%doc doc/*.html
%doc doc/*.jpg
%doc doc/*.css
%{_bindir}/pxzgrep

%changelog
* Mon Oct 26 2020 Axel Beckert <axel@ethz.ch>
  - Initial RPM packaging
  