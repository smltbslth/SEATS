version 13
clear all

use "$path_data/seats/SEATS2020.dta", clear

bysort pid (ls_NEET_reg): egen UnempMonths = total(ls_NEET_reg) 
gen  wasUnemployed  = 0 
replace wasUnemployed = 1 if UnempMonths > 0

tab  wasUnemployed if year == 2020

sort pid year
order pid year  wasUnemployed UnempMonths ls_NEET_reg e_prog