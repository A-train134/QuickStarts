#!/usr/bin/bash
set -e
site_name="quickstart"
while getopts "n:o" opt; do 
	case $opt in
	n) # nginx on ubuntu
		echo "Testing and Reloading nginx..."
		if [ ! -L /etc/nginx/sites-enabled/${site_name}.conf ]; then
			echo "No Simlink"
			ln -s /etc/nginx/sites-available/basic_site.conf /etc/nginx/sites-enabled/basic_site.conf
			echo "Made Simlink"
		fi
		cp -f ./basic_site.conf /etc/nginx/sites-available/ 
		nginx -t
		nginx -s reload
		echo "Done"
		;;
	o) #nginx on [o]marchy
		echo "Testing and Reloading nginx on Omarchy..."
		cp -f ./${site_name}.conf /etc/nginx/conf.d/ 
		nginx -t
		nginx -s reload
		echo "Done"
		;;
	\?)
		echo "Invalid Option" >&2
		exit 1
		;;
	esac
done
echo "Copying Files..."
cp -rf ./basic_site/ /var/www/${site_name}
echo "Finished Copying"
exit 0
