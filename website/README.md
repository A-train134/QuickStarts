## Web Quickstart
- A basic quickstart for a nginx hosted website
- Rename "quickstart.conf"
- Change the site_name variable in ./setup.sh 
```bash
# setup.sh
site_name="quickstart"
```
## setup.sh
- Run setup.sh with sudo
```sh
sudo ./setup.sh  # copies files to /var/www/${site_name}
#
# copies files to /etc/nginx/sites-available and handles the symlinking
# for ubuntu
sudo ./setup.sh -n
#
#copies files to /etc/nginx/conf.d/ 
# for Arch
```
- Take note that creating the conf.d file in /etc/nginx/ 
and adding the following line to nginx.conf inside the html may be neccesary
```bash
html {
    include /etc/nginx/conf.d/*.conf;
}
```
## Nginx
- There may be issues with types_has_max_size and types_has_bucket_size
on Arch the following lines should fix the issue 
```shell
html {
    types_hash_max_size 2048;
    types_hash_bucket_size 128;
}

```
