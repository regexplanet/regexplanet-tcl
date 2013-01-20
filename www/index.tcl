#!/usr/local/bin/tclsh8.5 

proc redirect {t} {
	puts "Status: 302 Redirect"
	puts "Location: $t"
	puts "Content-Type: text/html" 
	puts ""
	puts "<html>" 
	puts "<body>" 
	puts "<p>Redirect: <a href=\"$t\">$t</a></p>"
	puts "</body>" 
	puts "</html>"
}

redirect "http://www.regexplanet.com/advanced/tcl/index.html"
