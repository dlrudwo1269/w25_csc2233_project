set -e  # Exit on error
set -o pipefail

# Configuration variables - modify these as needed
INSTALL_DIR="$HOME/msvbase_install"
PG_INSTALL_DIR="$INSTALL_DIR/postgres"
PGDATA="$INSTALL_DIR/pgdata"
MSVBASE_DIR="$INSTALL_DIR/MSVBASE"
VECTORDB_INSTALL_DIR="$INSTALL_DIR/vectordb"
DEPS_DIR="$INSTALL_DIR/deps"
PGUSER="$(whoami)"
PGDATABASE="vectordb"
PGPORT=5432

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print section headers
print_section() {
    echo -e "\n${GREEN}==== $1 ====${NC}\n"
}

# Function to print errors
print_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

# Function to print warnings
print_warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# Function to clean up on failure
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        print_error "Installation failed with exit code $exit_code"
        
        # Stop PostgreSQL if it's running
        if "$PG_INSTALL_DIR/bin/pg_ctl" -D "$PGDATA" status > /dev/null 2>&1; then
            print_section "Stopping PostgreSQL"
            "$PG_INSTALL_DIR/bin/pg_ctl" -D "$PGDATA" stop -m immediate
        fi
        
        # Ask user if they want to remove pgdata
        read -p "Do you want to remove pgdata directory ($PGDATA)? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_section "Removing pgdata directory"
            rm -rf "$PGDATA"
            echo "Removed $PGDATA"
        else
            print_warning "Keeping pgdata directory at $PGDATA"
        fi
    fi
}

# Set up trap to call cleanup function on script exit
trap cleanup EXIT

# Create installation directory
print_section "Creating installation directory"
mkdir -p "$INSTALL_DIR"
mkdir -p "$PG_INSTALL_DIR"
mkdir -p "$PGDATA"
mkdir -p "$VECTORDB_INSTALL_DIR"
mkdir -p "$DEPS_DIR"

# Check for required tools
print_section "Checking for required tools"
MISSING_TOOLS=()

for tool in gcc g++ git wget curl make bison flex python3; do
    if ! command -v $tool &> /dev/null; then
        MISSING_TOOLS+=($tool)
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    print_warning "The following required tools are missing: ${MISSING_TOOLS[*]}"
    print_warning "Since you don't have root access, you'll need to ask your system administrator to install these tools."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Install Boost 1.81.0 locally
print_section "Installing Boost 1.81.0 locally"
cd "$DEPS_DIR"
if [ ! -d "$DEPS_DIR/boost" ]; then
    print_section "Downloading Boost..."
    
    # Try multiple download methods and sources
    BOOST_DOWNLOAD_SUCCESS=false
    
    # Method 1: wget with verbose output
    echo "Trying wget from main source..."
    wget "https://boostorg.jfrog.io/artifactory/main/release/1.81.0/source/boost_1_81_0.tar.gz" \
         --no-check-certificate --verbose -O boost_download.tar.gz
    
    if [ -s "boost_download.tar.gz" ]; then
        # Check if it's a valid gzip file
        if gzip -t boost_download.tar.gz 2>/dev/null; then
            echo "Download successful and verified."
            BOOST_DOWNLOAD_SUCCESS=true
        else
            echo "Downloaded file is not a valid gzip file."
        fi
    fi
    
    # Method 2: Try alternative source with curl if first method failed
    if [ "$BOOST_DOWNLOAD_SUCCESS" = false ]; then
        echo "Trying curl from SourceForge mirror..."
        curl -L "https://sourceforge.net/projects/boost/files/boost/1.81.0/boost_1_81_0.tar.gz/download" \
             -o boost_download.tar.gz
        
        if [ -s "boost_download.tar.gz" ]; then
            if gzip -t boost_download.tar.gz 2>/dev/null; then
                echo "Download successful and verified from mirror."
                BOOST_DOWNLOAD_SUCCESS=true
            else
                echo "Downloaded file from mirror is not a valid gzip file."
            fi
        fi
    fi
    
    # Method 3: Try GitHub mirror if previous methods failed
    if [ "$BOOST_DOWNLOAD_SUCCESS" = false ]; then
        echo "Trying wget from GitHub mirror..."
        wget "https://github.com/boostorg/boost/releases/download/boost-1.81.0/boost-1.81.0.tar.gz" \
             --no-check-certificate --verbose -O boost_download.tar.gz
        
        if [ -s "boost_download.tar.gz" ]; then
            if gzip -t boost_download.tar.gz 2>/dev/null; then
                echo "Download successful and verified from GitHub mirror."
                BOOST_DOWNLOAD_SUCCESS=true
            else
                echo "Downloaded file from GitHub mirror is not a valid gzip file."
            fi
        fi
    fi
    
    # Check if any download method succeeded
    if [ "$BOOST_DOWNLOAD_SUCCESS" = false ]; then
        print_error "All download methods failed. Cannot continue without Boost."
        print_error "Please try to manually download Boost 1.81.0 and place it in $DEPS_DIR/boost_download.tar.gz"
        exit 1
    fi
    
    print_section "Extracting Boost..."
    echo "File size: $(du -h boost_download.tar.gz)"
    echo "File type: $(file boost_download.tar.gz)"
    
    # Extract with verbose output
    mkdir -p boost_extract
    tar -xvzf boost_download.tar.gz -C boost_extract
    
    if [ $? -ne 0 ]; then
        print_error "Failed to extract Boost. Cannot continue without Boost."
        exit 1
    fi
    
    # Find the extracted directory (might be boost_1_81_0 or something else)
    BOOST_DIR=$(find boost_extract -maxdepth 1 -type d | grep -v "^boost_extract$" | head -1)
    
    if [ -z "$BOOST_DIR" ]; then
        print_error "Could not find extracted Boost directory."
        exit 1
    fi
    
    echo "Found Boost directory: $BOOST_DIR"
    cd "$BOOST_DIR"
    
    # Build and install Boost
    ./bootstrap.sh --prefix="$DEPS_DIR/boost"
    if [ $? -ne 0 ]; then
        print_error "Failed to bootstrap Boost."
        exit 1
    fi
    
    ./b2 install --prefix="$DEPS_DIR/boost"
    if [ $? -ne 0 ]; then
        print_error "Failed to build and install Boost."
        exit 1
    fi
    
    cd "$DEPS_DIR"
    rm -rf boost_download.tar.gz boost_extract
else
    echo "Boost already installed locally, skipping..."
fi

# Set environment variables for Boost
export BOOST_ROOT="$DEPS_DIR/boost"
export LD_LIBRARY_PATH="$DEPS_DIR/boost/lib:$LD_LIBRARY_PATH"
export CPLUS_INCLUDE_PATH="$DEPS_DIR/boost/include:$CPLUS_INCLUDE_PATH"

# Install CMake 3.14+ locally
print_section "Installing CMake 3.14+ locally"
if ! command -v cmake &> /dev/null || [ "$(cmake --version | head -n1 | awk '{print $3}')" \< "3.14" ]; then
    cd "$DEPS_DIR"
    # Use a more reliable download method with retries and verification
    print_section "Downloading CMake..."
    wget "https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4-Linux-x86_64.tar.gz" --no-check-certificate -q --tries=3
    
    # Check if download was successful
    if [ ! -f "cmake-3.14.4-Linux-x86_64.tar.gz" ]; then
        print_error "Failed to download CMake. Trying alternative download method..."
        curl -L "https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4-Linux-x86_64.tar.gz" -o cmake-3.14.4-Linux-x86_64.tar.gz
    fi
    
    # Verify the file exists and has content
    if [ ! -s "cmake-3.14.4-Linux-x86_64.tar.gz" ]; then
        print_error "Failed to download CMake. Will try to use system CMake if available."
    else
        print_section "Extracting CMake..."
        mkdir -p cmake
        tar -xzf cmake-3.14.4-Linux-x86_64.tar.gz --strip-components=1 -C cmake
        if [ $? -ne 0 ]; then
            print_error "Failed to extract CMake. Will try to use system CMake if available."
            rm -rf cmake
        else
            export PATH="$DEPS_DIR/cmake/bin:$PATH"
            echo "CMake installed successfully at $DEPS_DIR/cmake"
        fi
        rm -f cmake-3.14.4-Linux-x86_64.tar.gz
    fi
else
    echo "CMake $(cmake --version | head -n1 | awk '{print $3}') already installed, skipping..."
fi

# Clone MSVBASE repository
print_section "Cloning MSVBASE repository"
cd "$INSTALL_DIR"
if [ ! -d "$MSVBASE_DIR" ]; then
    git clone https://github.com/microsoft/MSVBASE.git "$MSVBASE_DIR"
    cd "$MSVBASE_DIR"
    
    # Initialize submodules but don't update them yet
    git submodule init
    
    # Set up sparse checkout for SPTAG before updating
    print_section "Setting up sparse checkout for SPTAG submodule"
    SPTAG_PATH="thirdparty/SPTAG"
    mkdir -p "$SPTAG_PATH"
    cd "$SPTAG_PATH"
    
    # Configure the submodule for sparse checkout
    git init
    git remote add origin https://github.com/microsoft/SPTAG.git
    git config core.sparsecheckout true
    mkdir -p .git/info
    echo "/*" > .git/info/sparse-checkout
    echo "!datasets/" >> .git/info/sparse-checkout
    
    # Fetch only what we need
    git fetch origin
    git checkout main
    
    # Initialize all SPTAG submodules recursively
    print_section "Initializing SPTAG submodules recursively"
    git submodule update --init --recursive
    
    # Return to MSVBASE directory
    cd "$MSVBASE_DIR"
    
    # Update other submodules
    git submodule update --init --recursive "thirdparty/Postgres"
    git submodule update --init --recursive "thirdparty/hnsw"
    
    # Add any other submodules you need here
else
    echo "MSVBASE repository already exists, updating..."
    cd "$MSVBASE_DIR"
    git pull
    
    # Check if SPTAG already exists
    SPTAG_PATH="thirdparty/SPTAG"
    if [ -d "$SPTAG_PATH" ]; then
        print_section "Updating SPTAG with sparse checkout"
        cd "$SPTAG_PATH"
        
        # Ensure sparse checkout is configured
        git config core.sparsecheckout true
        mkdir -p .git/info
        echo "/*" > .git/info/sparse-checkout
        echo "!datasets/" >> .git/info/sparse-checkout
        
        # Update to specific commit known to work with MSVBASE
        git fetch origin
        git checkout de5b7f8
        
        # Initialize all SPTAG submodules recursively
        print_section "Initializing SPTAG submodules recursively"
        git submodule update --init --recursive
        
        cd "$MSVBASE_DIR"
    else
        # Set up SPTAG with sparse checkout if it doesn't exist
        print_section "Setting up SPTAG with sparse checkout"
        mkdir -p "$SPTAG_PATH"
        cd "$SPTAG_PATH"
        
        git init
        git remote add origin https://github.com/microsoft/SPTAG.git
        git config core.sparsecheckout true
        mkdir -p .git/info
        echo "/*" > .git/info/sparse-checkout
        echo "!datasets/" >> .git/info/sparse-checkout
        
        git fetch origin
        git checkout de5b7f8
        
        # Initialize all SPTAG submodules recursively
        print_section "Initializing SPTAG submodules recursively"
        git submodule update --init --recursive
        
        cd "$MSVBASE_DIR"
    fi
    
    # Update other submodules
    cd "$MSVBASE_DIR/thirdparty/Postgres"
    git fetch origin
    git checkout e849f3f
    cd "$MSVBASE_DIR"
    
    # For hnsw, checkout the specific commit shown in the MSVBASE submodule
    cd "$MSVBASE_DIR/thirdparty/hnsw"
    git fetch origin
    git checkout 443d667
    cd "$MSVBASE_DIR"
    
    # Add any other submodules you need here
fi
cd "$MSVBASE_DIR"

# Apply patches
print_section "Applying patches"
cd "$MSVBASE_DIR"
if [ -f "./scripts/patch.sh" ]; then
    # Try to apply patches but continue if they fail
    ./scripts/patch.sh || {
        print_warning "Patch application failed, but continuing with the build process."
        print_warning "This might be because we're using specific commits that don't need these patches."
        print_warning "If build fails later, you may need to manually apply patches."
    }
else
    print_warning "patch.sh script not found, skipping patch application."
    print_warning "This might be fine if we're using specific commits that don't need patches."
fi

print_section "Building PostgreSQL from source"
cd "$MSVBASE_DIR/thirdparty/Postgres"
./configure \
  --with-blocksize=32 \
  --enable-integer-datetimes \
  --enable-thread-safety \
  --with-pgport="$PGPORT" \
  --prefix="$PG_INSTALL_DIR" \
  --without-ldap \
  --with-python \
  --without-openssl \
  --without-libxml \
  --without-libxslt

make -j$(nproc)
make install
make -C contrib install

# Set environment variables for PostgreSQL
export PATH="$PG_INSTALL_DIR/bin:$PATH"
export LD_LIBRARY_PATH="$PG_INSTALL_DIR/lib:$LD_LIBRARY_PATH"
export PostgreSQL_ROOT="$PG_INSTALL_DIR"
export PostgreSQL_INCLUDE_DIR="$PG_INSTALL_DIR/include"
export PostgreSQL_LIBRARY="$PG_INSTALL_DIR/lib"
export PKG_CONFIG_PATH="$PG_INSTALL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"
export PGSHARE="$PG_INSTALL_DIR/share"

# Build MSVBASE
print_section "Building MSVBASE"
cd "$MSVBASE_DIR"

# Get PostgreSQL paths from pg_config
PG_INCLUDEDIR=$("$PG_INSTALL_DIR/bin/pg_config" --includedir)
PG_INCLUDEDIR_SERVER=$("$PG_INSTALL_DIR/bin/pg_config" --includedir-server)
PG_PKGLIBDIR=$("$PG_INSTALL_DIR/bin/pg_config" --pkglibdir)
PG_LIBDIR=$("$PG_INSTALL_DIR/bin/pg_config" --libdir)
PG_SHAREDIR=$("$PG_INSTALL_DIR/bin/pg_config" --sharedir)

# Create all possible extension directories that might be needed
mkdir -p "$PG_PKGLIBDIR"
mkdir -p "$PG_SHAREDIR/extension"

# Configure CMake - first just configure to generate cmake_install.cmake
print_section "Configuring CMake"
mkdir -p build
cd build

# Print PostgreSQL paths for debugging
echo "PostgreSQL paths:"
echo "PG_INCLUDEDIR: $PG_INCLUDEDIR"
echo "PG_INCLUDEDIR_SERVER: $PG_INCLUDEDIR_SERVER"
echo "PG_PKGLIBDIR: $PG_PKGLIBDIR"
echo "PG_LIBDIR: $PG_LIBDIR"
echo "PG_SHAREDIR: $PG_SHAREDIR"

# Find libpq.so
PG_LIBPQ=$(find "$PG_LIBDIR" -name "libpq.so*" | head -1)
if [ -z "$PG_LIBPQ" ]; then
    PG_LIBPQ="$PG_LIBDIR/libpq.so"
    echo "Warning: libpq.so not found, using default path: $PG_LIBPQ"
fi

# Run CMake to generate files
cmake -DCMAKE_INSTALL_PREFIX="$PG_INSTALL_DIR" \
      -DPostgreSQL_PG_CONFIG="$PG_INSTALL_DIR/bin/pg_config" \
      -DPostgreSQL_ROOT="$PG_INSTALL_DIR" \
      -DPostgreSQL_INCLUDE_DIR="$PG_INCLUDEDIR" \
      -DPostgreSQL_SERVER_INCLUDE_DIR="$PG_INCLUDEDIR_SERVER" \
      -DPostgreSQL_LIBRARY="$PG_LIBPQ" \
      -DPostgreSQL_TYPE_INCLUDE_DIR="$PG_INCLUDEDIR_SERVER" \
      -DPostgreSQL_ADDITIONAL_VERSIONS="16" \
      -DPOSTGRESQL_PKGLIBDIR="$PG_PKGLIBDIR" \
      -DPOSTGRESQL_SHAREDIR="$PG_SHAREDIR" \
      -DLIBRARYONLY=ON \
      -DCMAKE_BUILD_TYPE=Release ..

# Patch any cmake_install.cmake files that have "/extension" paths
print_section "Patching CMake installation files"
find . -name "cmake_install.cmake" -type f -exec grep -l "/extension" {} \; | while read -r file; do
    echo "Patching $file..."
    # Backup original file
    cp "$file" "${file}.backup"
    
    # Replace "/extension" with correct path
    sed -i.bak "s|\"/extension\"|\"$PG_SHAREDIR/extension\"|g" "$file"
    sed -i.bak "s|/extension|$PG_SHAREDIR/extension|g" "$file"
    
    # Show changes
    echo "Differences in $file:"
    diff "${file}.backup" "$file" || true
done

# Build and install
print_section "Building and installing MSVBASE"
make -j$(nproc)
make install

# Manually copy extension files to ensure they're in the right location
print_section "Manually copying extension files to correct location"
# Find all vectordb extension files in the build directory
find . -name "vectordb*.sql" -o -name "vectordb.control" | while read -r file; do
    echo "Found extension file: $file"
    # Copy to the PostgreSQL extension directory
    cp -v "$file" "$PG_SHAREDIR/extension/"
done

# Also check the source directory for extension files
cd "$MSVBASE_DIR"
find . -name "vectordb*.sql" -o -name "vectordb.control" | while read -r file; do
    echo "Found extension file in source: $file"
    # Copy to the PostgreSQL extension directory
    cp -v "$file" "$PG_SHAREDIR/extension/"
done

# Ensure the shared library is in the right place
if [ -f "$MSVBASE_DIR/build/vectordb/vectordb.so" ]; then
    echo "Copying vectordb.so to $PG_PKGLIBDIR/"
    cp -v "$MSVBASE_DIR/build/vectordb/vectordb.so" "$PG_PKGLIBDIR/"
fi

# Check if extension files were successfully copied
echo "Checking extension files in $PG_SHAREDIR/extension:"
ls -la "$PG_SHAREDIR/extension/"
echo "Checking extension libraries in $PG_PKGLIBDIR:"
ls -la "$PG_PKGLIBDIR/" | grep vectordb

# Restore original files if needed
find . -name "cmake_install.cmake.backup" -type f -exec dirname {} \; | uniq | while read -r dir; do
    if [ -f "$dir/cmake_install.cmake.backup" ]; then
        mv "$dir/cmake_install.cmake.backup" "$dir/cmake_install.cmake"
    fi
done

# Initialize PostgreSQL database
print_section "Initializing PostgreSQL database"
export PGDATA="$PGDATA"
export PGDATABASE="$PGDATABASE"
export PGUSER="$PGUSER"

# Initialize the database
"$PG_INSTALL_DIR/bin/initdb" -D "$PGDATA"

# Modify postgresql.conf to load vectordb
echo "shared_preload_libraries = 'vectordb'" >> "$PGDATA/postgresql.conf"

# Navigate to the extension directory
cd $PG_INSTALL_DIR/share/extension/

# Create a symbolic link with the correct version number
ln -s vectordb.sql vectordb--0.1.0.sql

# Alternatively, you could copy the file
# cp vectordb.sql vectordb--0.1.0.sql

# Start PostgreSQL
print_section "Starting PostgreSQL"
"$PG_INSTALL_DIR/bin/pg_ctl" -D "$PGDATA" -l "$INSTALL_DIR/postgres_log.log" start

# Create database and install extension
print_section "Creating database and installing extension"
"$PG_INSTALL_DIR/bin/createdb" "$PGDATABASE"
"$PG_INSTALL_DIR/bin/psql" -d "$PGDATABASE" -c "CREATE EXTENSION vectordb;"



# If we reach here, installation was successful
print_section "Installation completed successfully!"
echo "PostgreSQL with vectordb extension is now running at port $PGPORT"
echo "Data directory: $PGDATA"
echo "To connect to the database, use: $PG_INSTALL_DIR/bin/psql -d $PGDATABASE"
echo "To stop the server, use: $PG_INSTALL_DIR/bin/pg_ctl -D $PGDATA stop"
echo "To remove pgdata on failure, run: rm -rf $PGDATA"

# Reset trap before exiting successfully
trap - EXIT
exit 0
