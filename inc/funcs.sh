test_lxc () {
	if [[ "$CMDLXC" -ne lxc ]]; then
		echo "You are not in a LXC CT"
		exit 1;
	fi
}

test_root () {
	if [[ $EUID -ne 0 ]]; then
   		echo "This script must be run as root" 
   		exit 1
	fi
}

add_repository () {
	echo "#Depot sury-php" >> /etc/apt/sources.list.d/sury-php.list
	echo "deb https://packages.sury.org/php/ buster main" >> /etc/apt/sources.list.d/sury-php.list

	echo "#Depot paquets proprietaires" >> /etc/apt/sources.list.d/non-free.list
	echo "deb http://ftp2.fr.debian.org/debian/ buster main non-free" >> /etc/apt/sources.list.d/non-free.list
	echo "deb-src http://ftp2.fr.debian.org/debian/ buster main non-free" >> /etc/apt/sources.list.d/non-free.list

	echo "#Depot multimedia" >> /etc/apt/sources.list.d/multimedia.list
	echo "deb http://www.deb-multimedia.org buster main non-free" >> /etc/apt/sources.list.d/multimedia.list

	echo "#Depot nginx" >> /etc/apt/sources.list.d/nginx.list
	echo "deb http://nginx.org/packages/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list
	echo "deb-src http://nginx.org/packages/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list

	echo "#Depot mediainfo" >> /etc/apt/sources.list.d/mediainfo.list
	echo "deb http://mediaarea.net/repo/deb/debian/ buster main" >> /etc/apt/sources.list.d/mediainfo.list

	wget -O /tmp/sury.gpg https://packages.sury.org/php/apt.gpg && apt-key add sury.gpg
	wget -O /tmp/ http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key
	wget -O /tmp/mediainfo.gpg http://mediaarea.net/repo/deb/debian/pubkey.gpg && apt-key add mediainfo.gpg

	apt update -oAcquire::AllowInsecureRepositories=true
	apt install -y --allow-unauthenticated deb-multimedia-keyring
	apt update
}

install_packages () {
	apt install -y \
  apache2-utils \
  automake \
  htop \
  build-essential \
  curl \
  ffmpeg \
  gawk \
  git \
  libcppunit-dev \
  libcurl4-openssl-dev \
  libncurses5-dev \
  libsigc++-2.0-dev \
  libsox-fmt-all \
  libsox-fmt-mp3 \
  libssl-dev \
  libtool \
  mediainfo \
  mktorrent \
  net-tools \
  nginx \
  php7.3 \
  php7.3-cli \
  php7.3-common \
  php7.3-curl \
  php7.3-fpm \
  php7.3-json \
  php7.3-mbstring \
  php7.3-opcache \
  php7.3-readline \
  php7.3-xml \
  php-geoip \
  pkg-config \
  psmisc \
  python-pip \
  rar \
  screen \
  subversion \
  unrar \
  unzip \
  sox \
  vim \
  zip \
  zlib1g-dev
}

install_xmrpc () {
	git clone https://github.com/mirror/xmlrpc-c.git /tmp/
	cd /tmp/xmlrpc-c/stable/
	./configure
	make
	make install
	cd -
}

install_libtorrent () {
	git clone https://github.com/rakshasa/libtorrent.git /tmp/
	cd /tmp/libtorrent
	git checkout v0.13.8
	./autogen.sh
	./configure --disable-debug
	make
	make install
	cd -
}

install_rtorrent () {
	git clone https://github.com/rakshasa/rtorrent.git /tmp/
	cd /tmp/rtorrent
	git checkout v0.9.8
	./autogen.sh
	./configure --with-xmlrpc-c --with-ncurses --disable-debug
	make
	make install
	cd -
	ldconfig
}

install_rutorrent () {
	git clone https://github.com/Novik/ruTorrent.git /var/www/rutorrent
}

install_rutorrentplugins () {
	# Plugin bypass cloudflare
	pip install cloudscraper

	# Plugin ratiocolor
	git clone https://github.com/Micdu70/rutorrent-ratiocolor.git /var/www/rutorrent/plugins/ratiocolor

	# Plugin Logoff
	wget -O /tmp/ https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rutorrent-logoff/logoff-1.3.tar.gz
	tar xzfv logoff-1.3.tar.gz -C /var/www/rutorrent/plugins/

	# Plugin GeoIP2
	git clone https://github.com/Micdu70/geoip2-rutorrent.git /var/www/rutorrent/plugins/geoip2

	# Plugin pausewebui
	wget -O /tmp/ https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rutorrent-pausewebui/pausewebui.1.2.zip
	unzip /tmp/pausewebui.1.2.zip -d /var/www/rutorrent/plugins/

	# Plugin filemanager
	git clone https://github.com/Micdu70/rutorrent-thirdparty-plugins.git /tmp/
	mv /tmp/filemanager /var/www/rutorrent/plugins/
	chown -R www-data:www-data /var/www/rutorrent
}