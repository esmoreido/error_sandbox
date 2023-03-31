wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/u/udunits2-2.2.20-2.el7.x86_64.rpm
wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/u/udunits2-devel-2.2.20-2.el7.x86_64.rpm
yum install udunits2-devel-2.2.20-2.el7.x86_64.rpm
yum install udunits2-2.2.20-2.el7.x86_64.rpm

wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/g/geos-3.4.2-2.el7.x86_64.rpm
wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/g/geos-devel-3.4.2-2.el7.x86_64.rpm
yum install geos-*

wget http://download.osgeo.org/gdal/2.4.1/gdal-2.4.1.tar.gz
tar -zxvf gdal-2.4.1.tar.gz
cd gdal-2.4.1; 
./configure; make -j4; make install
echo "/usr/local/lib" /etc/ld.so.conf.d/libgdal-x86_64.conf
ldconfig
cp -p /usr/local/lib/libgdal.so.20* /usr/lib64/

cd ../
wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/proj-4.8.0-4.el7.x86_64.rpm
wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/proj-devel-4.8.0-4.el7.x86_64.rpm
yum install proj-4.8.0-4.el7.x86_64.rpm proj-devel-4.8.0-4.el7.x86_64.rpm