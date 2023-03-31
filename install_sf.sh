configure
make -j4
sudo make install
./configure SQLITE3_CFLAGS=-I/usr/local/include SQLITE3_LIBS=-lsqlite3 CPPFLAGS="-I/usr/local/include -fPIC" LDFLAGS="-L/usr/local/lib"
make -j4
sudo make install
./configure CPPFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib --with-proj=/usr/local
make -j4
sudo make install
./configure
make -j4
sudo make install
sudo ldconfig
sudo R -e 'Sys.setenv(PKG_CONFIG_PATH = "/usr/local/lib/pkgconfig/"); install.packages("sf", configure.args="--with-proj-include=/usr/local/include/ --with-proj-lib=/usr/local/lib/ --with-proj-share=/usr/local/share/proj/ --with-gdal-config=/usr/local/bin/gdal-config --with-geos-config=/usr/local/bin/geos-config")'
sudo R -e 'install.packages(c("tmap", "gganimate"))'