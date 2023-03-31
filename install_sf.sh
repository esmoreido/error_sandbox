sudo R -e 'Sys.setenv(PKG_CONFIG_PATH = "/usr/local/lib/pkgconfig/"); 
install.packages(\"sf\", configure.args=\"--with-proj-include=/usr/local/include/ --with-proj-lib=/usr/local/lib/ --with-proj-share=/usr/local/share/proj/ --with-gdal-config=/usr/local/bin/gdal-config --with-geos-config=/usr/local/bin/geos-config\")'
sudo R -e 'install.packages(c(\"tmap\", \"gganimate\"))'