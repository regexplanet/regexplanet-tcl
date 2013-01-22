#!/usr/local/bin/tclsh8.5

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
			string { return "\"[string map [list \\ \\\\ \" \\" \n \\n \b \\b \r \\r \t \\t] $value]\"" }
		}
	}
}

proc get_input {} {
	global env

	if { $env(REQUEST_METHOD) == "GET" } {
	    set input "GET"
	    catch {set input $env(QUERY_STRING)} ;# doesn't have to be set
	} elseif { $env(REQUEST_METHOD) == "HEAD" } {
	    set input "HEAD"
	} elseif {![info exists env(CONTENT_LENGTH)]} {
		set input "NO CL"
	} else {
	    set length $env(CONTENT_LENGTH)
	    if {0!=[string compare $length "-1"]} {
		set input [read stdin $env(CONTENT_LENGTH)]		
	    } else {
		set input "CL=0"
	    }
	}
	return $input
}

proc get_param {data name} {
	global env
	set pairs [split $data &]
	foreach pair $pairs {
		set parts [split $pair =]
		if {$name == [lindex $parts 0]} {
			return [lindex $parts 1]
		}
	}
	return ""
}

proc get_params {data name} {
	global env
	set results {}
	set pairs [split $data &]
	foreach pair $pairs {
		set parts [split $pair =]
		if {$name == [lindex $parts 0]} {
			lappend results [lindex $parts 1]
		}
	}
	return $results
}

set data [get_input]

set regex [get_param $data "regex"]
set replacement [get_param $data "replacement"]
set options [get_params $data "options"]
set inputs [get_params $data "input"]
set callback [get_param $data "callback"]

append output "<div class=\'alert alert-warning\'>The Tcl backend is not finished yet!</div>\n"
append output "<table class=\'table table-bordered tabled-striped\' style=\'width:auto;\'>\n"
append output "\t<tr>\n"
append output "\t\t<td>Regular Expression</td>\n"
append output "\t\t<td>"
append output $regex
append output "</td>\n"
append output "\t</tr>\n"

append output "\t<tr>\n"
append output "\t\t<td>Replacement</td>\n"
append output "\t\t<td>"
append output $replacement
append output "</td>\n"
append output "\t</tr>\n"
append output "</table>\n"

append output "<table class=\'table table-bordered tabled-striped\' style=\'width:auto;\'>\n"
append output "\t<thead>\n"
append output "\t\t<tr>\n"
append output "\t\t\t<th style=\'text-align:center;\'>Test</th>\n"
append output "\t\t\t<th>Target string</th>\n"
append output "\t\t\t<th style=\'text-align:center;\'>matchVar</th>\n"
append output "\t\t\t<th>subMatch<i>n</i></th>\n"
append output "\t\t</tr>"
append output "\t</thead>"
append output "\t<tbody>"
foreach {input} $inputs {
	incr row
	if {[string length $input] == 0} {
		continue
	}
	append output "\t\t<tr>\n"
	append output "\t\t\t<td style=\'text-align:center;\'>"
	append output $row
	append output "</td>\n"
	append output "\t\t\t<td>"
	append output $input
	append output "</td>\n"
	append output "\t\t\t<td style=\'text-align:center;\'>"
	append output [regexp $regex $input]
	append output "</td>\n"
	append output "\t\t\t<td>"
	append output "</td>\n"
	append output "\t\t</tr>\n"
}
append output "\t</tbody>\n"
append output "</table>\n"

set html {}
lappend html html
lappend html "string \"$output\""
set success {}
lappend success success
lappend success "bool true"
set message {}
lappend message message
lappend message "string \"OK\""

set retval "object {$success $html $message}"

puts "Access-Control-Allow-Origin: *"
puts "Access-Control-Allow-Methods: POST, GET"
puts "Access-Control-Max-Age: 86400"

if {[info exists callback] == 1 && [string length $callback] != 0} {
	puts "Content-Type: text/plain"
	puts ""
	puts "$callback\([encode $retval]\);"
} else {
	puts "Content-Type: text/plain"
	puts ""
	puts [encode $retval]
}
