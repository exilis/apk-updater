This is a command-line tool to update the APK file on the Android Market.

# Usage

    ruby update_apk.rb <google_id> <google_pass> <full_path_to_apk>

# Notes

* Make sure you have your app available on the Android Market before executing this script. This script is designed just for UPDATING apps that are already there.
* This script depends on the encoded AndroidManifest.xml parser which was originally written by thadd. (https://github.com/thadd/axml2xml.rb)
