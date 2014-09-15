#!/bin/sh
# Optware pre-installation script, Leon Kos 2006, 2008
# added -verbose_wget to some lines, MrAlvin 2009

REPOSITORY=http://ipkg.nslu2-linux.org/feeds/optware/ddwrt/cross/stable
TMP=/tmp

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/opt/bin:/opt/sbin
unset LD_PRELOAD
unset LD_LIBRARY_PATH

_check_config()
{
	echo "Checking system config ..."

	GATEWAY=$(netstat -rn |
		sed -n 's/^0.0.0.0[ \t]\{1,\}\([0-9.]\{8,\}\).*/\1/p' )

	if [ -n "${GATEWAY}" ]; then
		echo "Using ${GATEWAY} as the default gateway."
	else
		echo "Error: no default gateway!"
		exit 2
	fi

	if [ -s /etc/resolv.conf ]; then
		echo "Using the following nameserver(s):"
		if grep nameserver /etc/resolv.conf ; then
			GATEWAY_SUBNET=$(echo "${GATEWAY}" |
				sed 's/\.[0-9]\{1,3\}\.[0-9]\{1,3\}$//')
			if [ "${GATEWAY_SUBNET}" = "192.168" ]; then
				if grep -q ${GATEWAY} /etc/resolv.conf ; then
					echo "Gateway ${GATEWAY} is also a nameserver."
				else
					echo "Warning: local nameserver is different than gateway!"
					echo "Check config or enter:"
					if test -L /etc/resolv.conf ; then 
						echo "  sed -i s/192.168.*/${GATEWAY}/ /tmp/resolv.conf"
					else
						echo "  sed -i s/192.168.*/${GATEWAY}/ /etc/resolv.conf"
					fi
					echo "and try again, or wait to see if your download continues anyway."
				fi
			fi
		else
			echo "Error: no nameserver specified in /etc/resolv.conf"
			exit 5
		fi
	else
		echo "Error: empty or nonexistent /etc/resolv.conf"
		exit 3
	fi

	if mount | grep -q /opt ; then
		[ -d /opt/etc ] && echo "Warning: /opt partition is not empty!"
	else
		echo "Error: /opt partition not mounted."
		echo "For running Optware on JFFS (not recommended), enter"
		echo "    mkdir /jffs/opt"
		echo "    mount -o bind /jffs/opt /opt"
		echo "to correct this."
		exit 4
	fi
}


_install_package()
{
	PACKAGE=$1

	echo "Installing package ${PACKAGE} ..."
	echo "   Some newer versions of DD-WRT does not show download progress bar,"
	echo "   so just be patient - or check STATUS -> BANDWIDTH tab for download"
	echo "   activity in your routers Web-GUI, and then still wait a minute or two."

	wget -O ${TMP}/${PACKAGE} ${REPOSITORY}/${PACKAGE}
	cd  ${TMP} 
	tar xzf ${TMP}/${PACKAGE} 
	tar xzf ${TMP}/control.tar.gz
	cd /

	if [ -f ${TMP}/preinst ] ; then
		sh ${TMP}/preinst
		rm -f ${TMP}/preints
	fi

	tar xzf ${TMP}/data.tar.gz
	if [ -f ${TMP}/postinst ] ; then
		sh ${TMP}/postinst
		rm -f ${TMP}/postinst
	fi

	rm -f ${TMP}/data.tar.gz
	rm -f ${TMP}/control.tar.gz
	rm -f ${TMP}/control
	rm -f ${TMP}/${PACKAGE}
}

_check_config
_install_package uclibc-opt_0.9.28-13_mipsel.ipk
_install_package ipkg-opt_0.99.163-10_mipsel.ipk
/opt/sbin/ldconfig
/opt/bin/ipkg -verbose_wget update
/opt/bin/ipkg -force-reinstall -verbose_wget install uclibc-opt
/opt/bin/ipkg -force-reinstall -verbose_wget install ipkg-opt
