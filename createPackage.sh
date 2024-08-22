# Michael Rieder 
# Script for macOS Automator

currentuser=`stat -f "%Su" /dev/console`

for f in "$@"
do
    
    # Strip out the "/Contents" part to get the path to the .app bundle
    if [[ "$f" == */Contents ]]; then
        f="${f%/Contents}"
    fi

	# Get the file name and directory
    filename=$(basename "$f")
    dirname=$(dirname "$f")
    appname="${filename%.*}"
    
    # Path to the Info.plist file inside the app package
    plist_path="$f/Contents/Info.plist"
    

    # Extract the Bundle ID and Version from the Info.plist file
    bundle_id=$(defaults read "${plist_path}" CFBundleIdentifier)
	version=$(defaults read "${plist_path}" CFBundleShortVersionString)

    
    # Define the output .pkg file name
    pkgname="${appname}.pkg"
    
    # Build the package
    pkgbuild --install-location /Applications  --component "$f" --identifier "$bundle_id" --version "$version" --ownership recommended "/Users/${currentuser}/Desktop/$pkgname"
done
