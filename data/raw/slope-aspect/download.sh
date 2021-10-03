#!/bin/bash

GREP_OPTIONS=''

cookiejar=$(mktemp cookies.XXXXXXXXXX)
netrc=$(mktemp netrc.XXXXXXXXXX)
chmod 0600 "$cookiejar" "$netrc"
function finish {
  rm -rf "$cookiejar" "$netrc"
}

trap finish EXIT
WGETRC="$wgetrc"

prompt_credentials() {
    echo "Enter your Earthdata Login or other provider supplied credentials"
    read -p "Username (katsukic7): " username
    username=${username:-katsukic7}
    read -s -p "Password: " password
    echo "machine urs.earthdata.nasa.gov login $username password $password" >> $netrc
    echo
}

exit_with_error() {
    echo
    echo "Unable to Retrieve Data"
    echo
    echo $1
    echo
    echo "https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e114.zip"
    echo
    exit 1
}

prompt_credentials
  detect_app_approval() {
    approved=`curl -s -b "$cookiejar" -c "$cookiejar" -L --max-redirs 5 --netrc-file "$netrc" https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e114.zip -w %{http_code} | tail  -1`
    if [ "$approved" -ne "302" ]; then
        # User didn't approve the app. Direct users to approve the app in URS
        exit_with_error "Please ensure that you have authorized the remote application by visiting the link below "
    fi
}

setup_auth_curl() {
    # Firstly, check if it require URS authentication
    status=$(curl -s -z "$(date)" -w %{http_code} https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e114.zip | tail -1)
    if [[ "$status" -ne "200" && "$status" -ne "304" ]]; then
        # URS authentication is required. Now further check if the application/remote service is approved.
        detect_app_approval
    fi
}

setup_auth_wget() {
    # The safest way to auth via curl is netrc. Note: there's no checking or feedback
    # if login is unsuccessful
    touch ~/.netrc
    chmod 0600 ~/.netrc
    credentials=$(grep 'machine urs.earthdata.nasa.gov' ~/.netrc)
    if [ -z "$credentials" ]; then
        cat "$netrc" >> ~/.netrc
    fi
}

fetch_urls() {
  if command -v curl >/dev/null 2>&1; then
      setup_auth_curl
      while read -r line; do
        # Get everything after the last '/'
        filename="${line##*/}"

        # Strip everything after '?'
        stripped_query_params="${filename%%\?*}"

        curl -f -b "$cookiejar" -c "$cookiejar" -L --netrc-file "$netrc" -g -o $stripped_query_params -- $line && echo || exit_with_error "Command failed with error. Please retrieve the data manually."
      done;
  elif command -v wget >/dev/null 2>&1; then
      # We can't use wget to poke provider server to get info whether or not URS was integrated without download at least one of the files.
      echo
      echo "WARNING: Can't find curl, use wget instead."
      echo "WARNING: Script may not correctly identify Earthdata Login integrations."
      echo
      setup_auth_wget
      while read -r line; do
        # Get everything after the last '/'
        filename="${line##*/}"

        # Strip everything after '?'
        stripped_query_params="${filename%%\?*}"

        wget --load-cookies "$cookiejar" --save-cookies "$cookiejar" --output-document $stripped_query_params --keep-session-cookies -- $line && echo || exit_with_error "Command failed with error. Please retrieve the data manually."
      done;
  else
      exit_with_error "Error: Could not find a command-line downloader.  Please install curl or wget"
  fi
}

fetch_urls <<'EDSCEOF'
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e114.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e118.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n12e119.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n20e116.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n21e114.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e115.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n15e119.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n20e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e115.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e119.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e114.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e119.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n20e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n16e119.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n18e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n13e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n16e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n12e125.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n12e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n14e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n15e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n12e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e117.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n21e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n21e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n14e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n04e116.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n19e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n17e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n17e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n12e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n16e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n13e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n13e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n14e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n12e123.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n13e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n18e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e126.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n13e123.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n15e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n16e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n18e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n19e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e125.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e123.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e123.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n10e125.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n14e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n12e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n14e123.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n15e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n17e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n11e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e115.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n04e118.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e119.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e117.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e119.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n04e115.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e117.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n04e114.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n07e116.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n07e118.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e116.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n08e117.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n04e117.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e118.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e118.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e116.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n08e116.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n07e117.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e115.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n08e118.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e118.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n04e119.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e114.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e123.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n07e123.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n07e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n04e125.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e126.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n07e126.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n08e125.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e125.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n07e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e126.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n07e125.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n07e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n08e126.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n08e122.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e123.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n08e124.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n04e126.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n08e123.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e125.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e120.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e126.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n05e125.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n09e121.zip
https://e4ftl01.cr.usgs.gov//DP132/MEASURES/NASADEM_SC.001/2000.02.11/NASADEM_SC_n06e121.zip
EDSCEOF