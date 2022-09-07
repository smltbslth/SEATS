******* SEATS wave 7: 2019 ***********

***Define directory
clear all

*global path_nc_root "C:/Users/Samuel/Nextcloud"
	
global raw   "$path_nc_root/Daten/SEATS/Daten/Datenlieferungen/2021_02"
global pisadata  "$path_nc_root/Daten/SEATS/Daten/AdditionalData/pisa"
global vetdata  "$path_nc_root/Daten/SEATS/Daten/AdditionalData/VET"
global output "$path_nc_root/Daten/SEATS/Daten/Aufbereitet"
global do "$path_nc_root/Daten/SEATS/Daten/DoFiles"
global pisado "$path_nc_root/Daten/SEATS/Daten/DoFiles"	
	
global lan en		// choose between "en" and "de" to set the label language 
global latestyear 2019	// set up to which year the database goes

********************************************************************************
* Import csv Files, nur 1. Mal nach neuer Datenlieferung
/*	import delimited using "$raw/LABB/PISALFFINAL.csv", delimiters(";") varnames(1) case(preserve)
		gen e_date_tmp=date(E_date,"DMY")
		drop E_date
		rename e_date_tmp E_date
	save "$raw/pisalffinal", replace
	clear
	import delimited using "$raw/LEVA/PISALEVAFINAL.csv", delimiters(";") varnames(1) case(preserve)
		foreach var of varlist Ac_date {
			gen `var'_d =date(`var',"DMY")
			drop `var'
			rename `var'_d `var'
		} 	
	save "$raw/pisalevafinal", replace
	clear
	import delimited using "$raw/Spell/PISASPELLFINAL.csv", delimiters(";") varnames(1) case(preserve)
		foreach var of varlist Ds_begdate Ds_enddate Ds_entrydate Ds_exitdate1 Ds_exitdate2 {
			gen `var'_d =date(`var',"DMY")
			drop `var'
			rename `var'_d `var'
		} 
	save "$raw/pisaspellfinal", replace
	clear
	import delimited using "$raw/Einkommen/PISAINCOMEFINAL.CSV", delimiters(";") varnames(1) case(preserve)
		foreach var of varlist ds_begdate ds_enddate {
			gen `var'_d =date(`var',"DMY")
			drop `var'
			rename `var'_d `var'
		} 
	save "$raw/pisaincomefinal", replace
	clear all
*/	
********************************************************************************
	
run "$do/Pisa_clean.do"
run "$do/LABB_clean_w2018.do"

use "$output/LABB.dta", clear
merge m:1 pid using "$output/pisa.dta", keep(match) nogen

format %12.0f pid 
*exit

* merge Anforderungsprofile
	merge m:1 e_prog_simp using "$output/tmp/anf.dta",  keep(master match) keepusing(anf_tot anf_math anf_language anf_natscience anf_foreignlanguage) nogen
	merge m:1 d_EFZprog_simp using "$output/tmp/anf.dta",  keep(master match) keepusing( d_EFZanf_tot  d_EFZanf_math  d_EFZanf_language  d_EFZanf_natscience  d_EFZanf_foreignlanguage) nogen
	merge m:1  d_EBAprog_simp using "$output/tmp/anf.dta",  keep(master match) keepusing(d_EBAanf_tot d_EBAanf_math d_EBAanf_language d_EBAanf_natscience d_EBAanf_foreignlanguage) nogen

* Nachhilfe
run 	"$pisado/Nachhilfevariablen.do"
drop ST200A01 ST200A02 ST200A03 ST200A04 ST200A05 ST201A02 ST202A01 ST202A02 ST203A01 ST203A02 ST204A01 ST204A02 ST204A03 ST204A04 ST204A05
drop DTA B1

run "$do/my_labels.do" // from LabelsDocumentation.do

*merge m:1 e_prog using "$output/sbfi_codes.dta",  keep(master match) // SBFI Berufsnummern anhängen
gen statcode = e_prog
merge m:1 statcode using "$output/bfs_sbfi.dta",  keep(master match) keepusing(sbfinr despecialized current) // SBFI Berufsnummern anhängen

rename despecialized sbfi_root
rename current sbfi_current
drop _merge 


*Neue Anforderungsprofile
rename anf_* anf_org_*

gen SBFINr = sbfi_current
merge m:1 SBFINr using "$path_gd/Berufe/sbfi_current.dta",  keep(master match) keepusing(anf_mean anf_math anf_langschool anf_nat anf_langfor) nogen

sort pid year 
	
save "$output/SEATS.dta", replace	
exit
********************************************************************************
use "$output/SEATS.dta", clear	

********************************************************************************
********************************************************************************
