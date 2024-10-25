#
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
#

Name:       harbour-hydrogen

# >> macros
%define zipversion 0.5.1
# << macros

Summary:    hydrogen, a matrix client
Version:    0.5.0
Release:    1
Group:      Qt/Qt
License:    ASL 2.0
BuildArch:  noarch
URL:        https://github.com/hydrogen-sailfishos/harbour-hydrogen
Source0:    %{name}-%{version}.tar.bz2
Source1:    https://github.com/element-hq/hydrogen-web/releases/download/v0.5.1/hydrogen-web-%{zipversion}.tar.gz
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   libsailfishapp-launcher
Requires:   sailfish-components-webview-qt5
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.3
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(qt5embedwidget)
BuildRequires:  pkgconfig(sailfishwebengine)
BuildRequires:  sailfish-svg2png
BuildRequires:  desktop-file-utils

%description
Hydrogen is "A minimal Matrix chat client, focused on performance, offline
functionality, and broad browser support"

This App packages Hydrogen matrix client in a webview + SailfishOS integration.

%if 0%{?_chum}
Title: Hydrogen
Type: desktop-application
Categories:
 - InstantMessaging
 - Network
Custom:
  Repo: https://github.com/hydrogen-sailfishos/harbour-hydrogen
PackageIcon: https://raw.githubusercontent.com/hydrogen-sailfishos/harbour-hydrogen/hackathon/icons/svgs/harbour-hydrogen.svg
Links:
  Homepage: https://github.com/hydrogen-sailfishos/harbour-hydrogen
  Bugtracker: https://github.com/hydrogen-sailfishos/harbour-hydrogen/issues
  Hackathon: https://github.com/orgs/hydrogen-sailfishos/projects/1/
%endif

%prep
%setup -q -n %{name}-%{version}
%if 0%{?sailfishos_version}
sed -i "s/unreleased/%{version}/" qml/pages/AppSettingsPage.qml
if [ ! -f %{SOURCE1} ]
then
  echo "Missing %{SOURCE1}"
  exit 1
fi
mkdir -p hydrogen/target # supports building locally
tar -C hydrogen/target -xvzf %{SOURCE1}
%endif

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
