#\!/bin/bash

# Create new clean directory
mkdir -p clean_cartessn/R clean_cartessn/man clean_cartessn/data
echo "Created clean directory structure"

# Copy essential files
cp DESCRIPTION NAMESPACE clean_cartessn/
cp -r R/* clean_cartessn/R/
cp -r man/* clean_cartessn/man/
cp -r data/* clean_cartessn/data/
echo "Copied essential files"

# Remove hidden files
find clean_cartessn -name ".*" -type f -delete
echo "Removed hidden files"

# Create package tarball
cd clean_cartessn
R CMD build .
echo "Built package"

# Install from tarball
tarball=$(ls *.tar.gz)
if [ -n "$tarball" ]; then
  R CMD INSTALL $tarball
  echo "Installed package from $tarball"
else
  echo "No tarball created, installation failed"
fi
