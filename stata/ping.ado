*! Ping: check Stata's connectivity status
*! Version 1.1.0: 2013/05/28
*! Author: Damian C. Clarke 
*! Department of Economics
*! The University of Oxford
*! damian.c.clarke@economics.ox.ac.uk

capture program drop ping
program define ping, rclass
	vers 10.0
	set more off
	
	if c(os)=="Windows" {
		!ping -n 1 www.google.com > "./_ping.txt"
		!exit
	}
	else if c(os)=="Unix" {
		!ping -c 1 www.google.com > "./_ping.txt"
		!exit
	}
	else {
		!ping -c 1 www.google.com > "./_ping.txt"
		!exit
	}
	
	file open ping_result using _ping.txt, read
	file read ping_result line
	while r(eof)==0 {
		display in yellow "`line'"
		if regexm("`line'","[0-9]*")==1 local pinged 1
		file read ping_result line
	}
	file close ping_result
	cap rm ".\_ping.txt"
	
	if `pinged'==1 qui return local ping="Yes" 
	else return ping="No"
end
