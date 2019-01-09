#!/usr/bin/tclsh

proc encode {obj} {
	foreach {type value} $obj {
		switch $type {
			object {
				set acc {}
				foreach {key element} $value {
					set enc [encode $element]
					lappend acc "\"$key\":$enc"
				}
				set acc [join $acc ","]
				return "{$acc}"
			}
			number { return $value }
			bool { return  $value }
			array {
				set acc {}
				foreach {element} $value {
					lappend acc [encode $element]
				}
				set acc [join $acc ","]
				return "\[$acc\]"
			}
			string { return "\"$value\"" }
		}
	}
}

## $tcl_version doesn't work
#set retval {object {success {bool true} message {string "OK"} version {string tcl_version}}}
#set retval {object {success {bool true} message {string "OK"} version {string $tcl_version}}}
#set retval {object {success {bool true} message {string "OK"} version {string [info tclversion]}}}
#puts [encode $retval]

set success {}
lappend success success
lappend success "bool true"
set message {}
lappend message message
lappend message "string \"OK\""
set commit {}
lappend commit commit
lappend commit "string \"$env(COMMIT)\""
set lastmod {}
lappend lastmod lastmod
lappend lastmod "string \"$env(LASTMOD)\""
set tech {}
lappend tech tech
lappend tech "string \"Tcl $tcl_patchLevel\""
set timestamp {}
lappend timestamp timestamp
lappend timestamp "string \"$tcl_patchLevel\""
set version {}
lappend version version
lappend version "string \"$tcl_patchLevel\""

set machine {}
lappend machine "tcl_platform(machine)"
lappend machine "string $tcl_platform(machine)"
set os {}
lappend os "tcl_platform(os)"
lappend os "string $tcl_platform(os)"
set osVersion {}
lappend osVersion "tcl_platform(osVersion)"
lappend osVersion "string $tcl_platform(osVersion)"
set platform {}
lappend platform "tcl_platform(platform)"
lappend platform "string $tcl_platform(platform)"
set patchLevel {}
lappend platform "tcl_patchLevel"
lappend platform "string $tcl_patchLevel"
#LATER: byteOrder, pointerSize, wordSize
#LATER: env

set retval "object {$success $message $commit $lastmod $tech $timestamp $version $os $osVersion $platform $machine $patchLevel}"

set query_string $env(QUERY_STRING)
set pairs [split $query_string &]
foreach pair $pairs {
	if {[regexp "callback=(\[a-zA-Z\]\[-a-zA-Z0-9_\]*)" $pair] == 1} {
		set callback [string range $pair 9 end]
	}
}
if {[info exists callback] == 1} {
	puts "Content-Type: text/plain"
	puts ""
	puts "$callback\([encode $retval]\);"
} else {
	puts "Content-Type: text/plain"
	puts "Access-Control-Allow-Origin: *"
	puts "Access-Control-Allow-Methods: POST, GET"
	puts "Access-Control-Max-Age: 604800"
	puts ""
	puts [encode $retval]
}
