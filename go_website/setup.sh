set -e
site_name="basic_site"
echo "site_name: ${site_name}"
while getopts "ucas:" opt; do 
	case $opt in
	u) # nginx on ubuntu
		echo "Testing and Reloading nginx..."
		if [ ! -L /etc/nginx/sites-enabled/${site_name}.conf ]; then
			echo "No Simlink"
			ln -s /etc/nginx/sites-available/${site_name}.conf /etc/nginx/sites-enabled/${site_name}.conf
			echo "Made Simlink"
		fi
		cp -f ./${site_name}.conf /etc/nginx/sites-available/ 
		nginx -t
		nginx -s reload
		echo "Done"
		;;
	a) #nginx on [a]rch/omarchy
		echo "Testing and Reloading nginx on Omarchy..."
		if [ -e "/etc/nginx/conf.d/" ]; then
			echo "/etc/nginx/conf.d/ exists"
			cp -f ./${site_name}.conf /etc/nginx/conf.d/ 
			nginx -t
			nginx -s reload
		else
			echo "/etc/nginx/conf.d/ doesn't exist"
			echo "Please Create conf.d and modify nginx.conf"
		fi
		echo "Done"
		;;
	c) #copy files to /var/www/
		echo "Copying Files..."
		cp -rf ./basic_site/ /var/www/${site_name}
		echo "Finished Copying"
		;;
	s) #sqlite3 database table creation
		echo "Creating or modifing db"
		if [ -e "$OPTARG" ]; then
			echo "Path exists"
			sqlite3 "$OPTARG" <<-EOF
			create table if not exists users(
			id integer primary key,
			email text not null unique,
			password text not null,
			role text not null default 'user'
			);
			EOF
			sqlite3 "$OPTARG" <<-EOF
			create table if not exists posts(
			id integer primary key autoincrement,
			email text not null,
			title text not null,
			body text not null,
			imagepath text,
			created_at datetime default current_timestamp
			);
			EOF
		else
			echo "Path does not exist"
		fi
		echo "Done"
		;;
	\?)
		echo "Invalid Option" >&2
		exit 1
		;;
	esac
done
	# *) # no match
	echo "Options"
	echo "-u handle nginx on [u]buntu"
	echo "-a handle nginx on [a]rch/ubuntu"
	echo "-c copy site files to /var/www/."
	echo "-s /path/to/db create sql tables"
	#
	# 	;;
exit 0
