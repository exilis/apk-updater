require 'rubygems'
require 'watir-webdriver'
require 'watir-webdriver/wait'
require File.dirname(__FILE__) + "/axml2xml"
require "rexml/document" 

unless ARGV.length == 3
  puts "Usage: ruby update_apk.rb <google_id> <google_pass> <full_path_to_apk>\n"
  exit
end

userid = ARGV[0]
passwd = ARGV[1]
apk_fullpath = ARGV[2]

# extract package name and version code out of the APK
begin
  xmldoc = REXML::Document.new(load_android_manifest_xml(apk_fullpath))
  version_code = xmldoc.elements['manifest'].attributes['versioncode'].to_i(16)
  package_name = xmldoc.elements['manifest'].attributes['package']
rescue
  puts "Error: failed to load APK file\n"
  exit
end

# login
b = Watir::Browser.new
b.goto 'https://market.android.com/publish/'
b.text_field(:id => 'Email').set userid
b.text_field(:id => 'Passwd').set passwd
b.button(:id => 'signIn').click

# upload & save
Watir::Wait.until { b.text.include? "All Android Market listings" }
b.goto 'https://market.android.com/publish/Home#AppEditorPlace:p=' + package_name
b.div(:id => 'gwt-debug-multiple_apk-apk_list_tab').when_present.click
b.button(:id => 'gwt-debug-apk_list-upload_button').when_present.click
b.file_field(:name, "Filedata").when_present.set(apk_fullpath)
b.button(:id => 'gwt-debug-app_editor-apk-upload-upload_button').when_present.click
b.button(:id => 'gwt-debug-bundle_upload-save_button').when_present.click
b.execute_script("window.confirm = function() {return true}")
b.a(:id, "gwt-debug-apk_list-activate_link-#{version_code}").when_present.click
b.button(:id => 'gwt-debug-multiple_apk-save_button').when_present.click
