# Enable the Extra Packages for Enterprise Linux (EPEL) repository
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 

# On RHEL 7, enable the Optional repository
sudo subscription-manager repos --enable "rhel-*-optional-rpms"

# If running RHEL 7 in a public cloud, such as Amazon EC2, enable the
# Optional repository from Red Hat Update Infrastructure (RHUI) instead
sudo yum install yum-utils
sudo yum-config-manager --enable "rhel-*-optional-rpms"

# Download and install R
export R_VERSION=4.0.0
curl -O https://cdn.rstudio.com/r/centos-7/pkgs/R-${R_VERSION}-1-1.x86_64.rpm
sudo yum install R-${R_VERSION}-1-1.x86_64.rpm

# Verify installation
/opt/R/${R_VERSION}/bin/R --version

# Create symlink to R
sudo ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R
sudo ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript