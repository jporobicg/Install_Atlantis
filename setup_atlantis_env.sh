#!/bin/bash
# Setup script for Atlantis with old Proj4 version
# This script sets up the environment variables needed to run Atlantis

export PKG_CONFIG_PATH=/usr/local/proj4-4.9.3/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/usr/local/proj4-4.9.3/lib:$LD_LIBRARY_PATH
export CPPFLAGS="-I/usr/local/proj4-4.9.3/include $CPPFLAGS"
export LDFLAGS="-L/usr/local/proj4-4.9.3/lib $LDFLAGS"

echo "Atlantis environment variables set up successfully!"
echo "Proj4 version 4.9.3 is now configured for use with Atlantis."
echo ""
echo "To use Atlantis, you can now run:"
echo "  atlantisMerged [options]"
echo ""
echo "To make these environment variables permanent, add them to your ~/.bashrc file." 