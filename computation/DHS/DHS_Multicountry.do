/* Multicountry 1.00         Damian C Clarke                     vers:2012-09-05
*---|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8
*/
clear all
version 11.2
cap log close
set more off
set mem 1200m
set maxvar 20000

*********************************************************************************																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																								*********************************************************************************
*** (1) Globals and locals (set clean to yes to remove new files)
*********************************************************************************
global DHSFolder "~/database/DHS/ImportData"
global DHSFolder_Data "~/database/DHS/ImportData/DHS_Data1"
local clean no



cd $DHSFolder

file open surveys using "DHS_Surveys_StataUse.txt", read
file read surveys line

*********************************************************************************
*** (2) Include new variables for cross country merging
*********************************************************************************
local i 0
while r(eof)==0 {
	foreach name in code country year {
		local `name' `line'
		file read surveys line
	}
	local survey `line'
	local code_test=substr("`survey'",1,2)
	file read surveys line
	local recodes `line'
	file read surveys line
	dis in yellow "`country'"
	dis in green "`code_test'"
	dis in green "`code'"
	if "`code_test'"=="`code'" {
		cap use $DHSFolder_Data/`country'/`year'/`survey'
		if `c(rc)'==0 {
			cap mkdir $DHSFolder_Data/`recodes'
			cap gen _cou = "`country'"
			cap gen _cou_code = "`code'"
			cap gen _year = "`year'"
			cap drop s* //Here I drop all country specific variables.
			save $DHSFolder_Data/`recodes'/`survey', replace
			local ++i
		}
		else if `c(rc)'!=0 {
			dis in red "`country'"
			dis in red "`year'"
		}
	}
}
dis "`i'"
file close surveys

*********************************************************************************
*** (3) Merge files producing the World_ datasets
*********************************************************************************
/*Note that the else conditions can be removed if the computer or terminal you
are working on is quite powerful.  I tested this do file on a computer with 8gb
of virtual memory and 4 cores, and it ran fine by splitting the files into 5 
parts rather than as one file (see below). */

foreach surveytype in HR PR IR CR MR KR BR {
	clear
	local i_`surveytype' 0
	local myfiles: dir "$DHSFolder_Data/`surveytype'" files "*.dta"
	foreach survey of local myfiles {
		dis in yellow "`i_`surveytype''"
		if `i_`surveytype''==40 save $DHSFolder_Data/World_`surveytype'_p1
		else if `i_`surveytype''==41 clear
		else if `i_`surveytype''==80 save $DHSFolder_Data/World_`surveytype'_p2
		else if `i_`surveytype	''==81 clear
		else if `i_`surveytype''==120 save $DHSFolder_Data/World_`surveytype'_p3
		else if `i_`surveytype''==121 clear
		else if `i_`surveytype''==160 save $DHSFolder_Data/World_`surveytype'_p4
		else if `i_`surveytype''==161 clear
		append using "$DHSFolder_Data/`surveytype'/`survey'", force
		local ++i_`surveytype'
	}
	save $DHSFolder_Data/World_`surveytype'_p5
}

foreach surveytype in HR PR IR CR MR KR BR {
	dis "`i_`surveytype''"
}

*********************************************************************************
*** (4) Cleaning up
*********************************************************************************
if `clean'=="`yes'" {
	foreach surveytype in AH BR CR HH HR IQ IR KR ML MR OD PQ PR SQ VA VR WI WS XP XR {
	local myfiles: dir "$DHSFolder_Data/`surveytype'" files "*.dta"
	foreach survey of local myfiles {
		rm "$DHSFolder_Data/`surveytype'/`survey'"
	}
	rmdir "$DHSFolder_Data/`surveytype'"
}
else if `clean'!="`yes'" {
	dis "You have not removed files made by this program."  
	dis "If you wish to do so, change the local `clean' to yes."
}
