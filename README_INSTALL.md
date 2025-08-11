# Atlantis Installation Guide for Ubuntu

This guide explains how to install Atlantis on Ubuntu systems when encountering Proj4 library compatibility issues.

## Problem Description

Atlantis was written to use the old Proj4 API (version 4.x), but modern Ubuntu systems (22.04+) come with Proj4 version 8.x, which uses a completely different API. The old API functions like `pj_init` were removed in Proj4 version 6.0.0, causing compilation failures.

## Prerequisites

- Ubuntu 20.04 or later (tested on Ubuntu 22.04)
- Basic command line knowledge
- Sudo privileges
- Internet connection for downloading Proj4 source

## Required System Packages

First, install the necessary development tools and dependencies:

```bash
sudo apt update
sudo apt install build-essential autoconf automake libtool pkg-config
sudo apt install libxml2-dev libnetcdf-dev
```

## Installation Steps

### Step 1: Download and Install Old Proj4 Version

Download and compile Proj4 version 4.9.3 (the last version with the old API):

```bash
cd /tmp
wget https://download.osgeo.org/proj/proj-4.9.3.tar.gz
tar -xzf proj-4.9.3.tar.gz
cd proj-4.9.3
./configure --prefix=/usr/local/proj4-4.9.3
make -j$(nproc)
sudo make install
```

### Step 2: Set Up Environment Variables

Set up the environment to use the old Proj4 version:

```bash
export PKG_CONFIG_PATH=/usr/local/proj4-4.9.3/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/usr/local/proj4-4.9.3/lib:$LD_LIBRARY_PATH
export CPPFLAGS="-I/usr/local/proj4-4.9.3/include $CPPFLAGS"
export LDFLAGS="-L/usr/local/proj4-4.9.3/lib $LDFLAGS"
```

### Step 3: Build Atlantis

Navigate to your Atlantis source directory and build:

```bash
cd /path/to/your/atlantis/source
./configure CPPFLAGS="-I/usr/local/proj4-4.9.3/include" LDFLAGS="-L/usr/local/proj4-4.9.3/lib"
make
sudo make install
```

## Alternative: Using the Build Script

If you have the `build.sh` script, you can use it after setting up the environment:

```bash
# Set up environment first
export PKG_CONFIG_PATH=/usr/local/proj4-4.9.3/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/usr/local/proj4-4.9.3/lib:$LD_LIBRARY_PATH
export CPPFLAGS="-I/usr/local/proj4-4.9.3/include $CPPFLAGS"
export LDFLAGS="-L/usr/local/proj4-4.9.3/lib $LDFLAGS"

# Then run the build script
./build.sh
```

## Verification

After installation, verify that Atlantis is working:

```bash
which atlantisMerged
atlantisMerged --help
```

## Environment Setup Script

A setup script `setup_atlantis_env.sh` is provided to easily configure the environment:

```bash
source setup_atlantis_env.sh
```

## Making Environment Variables Permanent

To avoid setting environment variables every time, add them to your `~/.bashrc`:

```bash
echo 'export PKG_CONFIG_PATH=/usr/local/proj4-4.9.3/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/proj4-4.9.3/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export CPPFLAGS="-I/usr/local/proj4-4.9.3/include $CPPFLAGS"' >> ~/.bashrc
echo 'export LDFLAGS="-L/usr/local/proj4-4.9.3/lib $LDFLAGS"' >> ~/.bashrc
source ~/.bashrc
```

## Troubleshooting

### Common Issues

1. **"Proj4 library is required" error during configure:**
   - Ensure environment variables are set correctly
   - Verify that `/usr/local/proj4-4.9.3/lib/libproj.so` exists
   - Check that pkg-config can find the old Proj4: `pkg-config --cflags --libs proj`

2. **"proj_api.h: No such file or directory" error during compilation:**
   - Ensure `CPPFLAGS` includes the old Proj4 include path
   - Verify that `/usr/local/proj4-4.9.3/include/proj_api.h` exists

3. **"undefined reference to pj_init" error during linking:**
   - Ensure `LDFLAGS` includes the old Proj4 library path
   - Verify that the old Proj4 library contains the required symbols: `nm -D /usr/local/proj4-4.9.3/lib/libproj.so | grep pj_init`

### Verification Commands

```bash
# Check if old Proj4 is installed
ls -la /usr/local/proj4-4.9.3/lib/
ls -la /usr/local/proj4-4.9.3/include/

# Check if pkg-config finds the old Proj4
pkg-config --cflags --libs proj

# Check if required functions exist in the library
nm -D /usr/local/proj4-4.9.3/lib/libproj.so | grep pj_init
```

## File Locations After Installation

- **Atlantis executable**: `/usr/local/bin/atlantisMerged`
- **Libraries**: `/usr/local/lib/` (various `libat*.a` files)
- **Headers**: `/usr/local/include/Atlantis-3.0/Atlantis/`
- **Old Proj4**: `/usr/local/proj4-4.9.3/`

## Why This Approach?

This solution:
- **Preserves Atlantis source code** - no modifications needed
- **Maintains compatibility** - uses the exact API that Atlantis expects
- **Isolates dependencies** - old Proj4 doesn't interfere with system libraries
- **Provides reproducibility** - others can follow the same steps

## System Requirements

- **Minimum**: Ubuntu 20.04 LTS
- **Recommended**: Ubuntu 22.04 LTS or later
- **Architecture**: x86_64 (tested), should work on other architectures
- **Memory**: At least 2GB RAM for compilation
- **Disk Space**: Approximately 500MB for Proj4 + Atlantis

## Support

If you encounter issues:
1. Check that all prerequisites are installed
2. Verify environment variables are set correctly
3. Ensure the old Proj4 version compiled successfully
4. Check the troubleshooting section above

## License

This installation method follows the same license terms as the original Atlantis and Proj4 software. 