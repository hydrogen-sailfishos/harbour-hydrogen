#
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
#

Name:       harbour-hydrogen

# >> macros
# << macros

Summary:    hydrogen, a matrix client
Version:    0.4.1
Release:    1
Group:      Qt/Qt
License:    ASL 2.0
BuildArch:  noarch
URL:        https://github.com/thigg/sfos-hydrogen
Source0:    %{name}-%{version}.tar.bz2
Source1:    release.zip
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   sailfish-components-webview-qt5
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.3
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(qt5embedwidget)
BuildRequires:  pkgconfig(sailfishwebengine)
BuildRequires:  sailfish-svg2png
BuildRequires:  desktop-file-utils
BuildRequires:  git

%description
Short description of my Sailfish OS Application


%prep
%setup -q -n %{name}-%{version}
pushd hydrogen
HYDROGEN_TAG=$(git describe --tags)
if [ ! -f ../release-$HYDROGEN_TAG.zip ]
then
  echo "Missing release-$HYDROGEN_TAG.zip
  exit 1
fi
unzip ../release-$HYDROGEN_TAG.zip
popd

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/%{name}.desktop

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/%{name}-open-url.desktop

%files
%defattr(-,root,root,-)
%defattr(0644,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}*.desktop
%{_datadir}/applications/%{name}-open-url.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg
# >> files
# << files

%changelog
