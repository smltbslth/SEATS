******* SEATS wave 7: 2019 ***********

***Define directory
clear all

*global path_nc_root "C:/Users/Samuel/Nextcloud"
	
global raw   "$path_nc_root/Daten/SEATS/Daten/Datenlieferungen/2022"
global pisadata  "$path_nc_root/Daten/SEATS/Daten/AdditionalData/pisa"
global vetdata  "$path_nc_root/Daten/SEATS/Daten/AdditionalData/VET"
global output "$path_nc_root/Daten/SEATS/Daten/Aufbereitet"
global do "$path_nc_root/Daten/SEATS/Daten/DoFiles"
global pisado "$path_nc_root/Daten/SEATS/Daten/DoFiles"	
	
global lan en		// choose between "en" and "de" to set the label language 
global latestyear 2021	// set up to which year the database goes
global loadSpellAHV 1

*if `loadSpellAHV' == 1 {
********************************************************************************
* Import csv Files, nur 1. Mal nach neuer Datenlieferung

	import delimited using "$raw/PISALFFINAL.csv", delimiters(";") varnames(1) case(preserve)
		gen e_date_tmp=date(E_date,"DMY")
		drop E_date
		rename e_date_tmp E_date
	save "$raw/pisalffinal", replace
	clear
	import delimited using "$raw/PISALEVAFINAL.csv", delimiters(";") varnames(1) case(preserve)
		foreach var of varlist Ac_date {
			gen `var'_d =date(`var',"DMY")
			drop `var'
			rename `var'_d `var'
		} 	
	save "$raw/pisalevafinal", replace
	clear
if $loadSpellAHV == 1 {
	import delimited using "$raw/PISASPELLFINAL.csv", delimiters(";") varnames(1) case(preserve)
		foreach var of varlist Ds_begdate Ds_enddate Ds_entrydate Ds_exitdate1 Ds_exitdate2 {
			gen `var'_d =date(`var',"DMY")
			drop `var'
			rename `var'_d `var'
		} 
	save "$raw/pisaspellfinal", replace
	clear
}	
	import delimited using "$raw/PISAINCOMEFINAL.CSV", delimiters(";") varnames(1) case(preserve)
		foreach var of varlist ds_begdate ds_enddate {
			gen `var'_d =date(`var',"DMY")
			drop `var'
			rename `var'_d `var'
		} 
	save "$raw/pisaincomefinal", replace
	clear all
	
********************************************************************************
	
run "$do/Pisa_clean.do"
run "$do/LABB_clean_w2018.do"

***
use "$output/LABB.dta", clear
merge m:1 pid using "$output/pisa.dta", keep(match) nogen

format %12.0f pid 
*exit

* merge Anforderungsprofile
*	merge m:1 e_prog_simp using "$output/tmp/anf.dta",  keep(master match) keepusing(anf_tot anf_math anf_language anf_natscience anf_foreignlanguage) nogen
*	merge m:1 d_EFZprog_simp using "$output/tmp/anf.dta",  keep(master match) keepusing( d_EFZanf_tot  d_EFZanf_math  d_EFZanf_language  d_EFZanf_natscience  d_EFZanf_foreignlanguage) nogen
*	merge m:1  d_EBAprog_simp using "$output/tmp/anf.dta",  keep(master match) keepusing(d_EBAanf_tot d_EBAanf_math d_EBAanf_language d_EBAanf_natscience d_EBAanf_foreignlanguage) nogen

* Nachhilfe
run 	"$pisado/Nachhilfevariablen.do"
drop ST200A01 ST200A02 ST200A03 ST200A04 ST200A05 ST201A02 ST202A01 ST202A02 ST203A01 ST203A02 ST204A01 ST204A02 ST204A03 ST204A04 ST204A05
drop DTA B1

run "$do/my_labels.do" // from LabelsDocumentation.do

*gen statcode = e_prog
merge m:1 e_prog using "$output/bfs_to_sbfi.dta",  keep(master match) keepusing(sbfi_nr sbfi_current) // SBFI Berufsnummern anhängen
drop _merge 

gen SBFINr = sbfi_current
merge m:1 SBFINr using "C:\Users\Samuel\Nextcloud\Persönlicher Ordner/data/Berufe/sbfi_all.dta",  keep(master match) keepusing(anf_mean anf_math anf_langschool anf_nat anf_langfor spec Lehrdauer Anzahl_Lektionen) nogen
drop SBFINr

sort pid year 
	
save "$output/SEATS2021.dta", replace	

exit
********************************************************************************
use "$output/SEATS2020.dta", clear	

order pid year e_prog ls_edu ls_edu_work ls_work ls_NEET_reg ls_NEET_IV ls_NEET_EO ls_NEET_unknown income_work_av income_work_max income_work_min income_edu_av income_edu_max income_edu_min

bysort pid (d_EFZprog): gen d_EFZp = d_EFZprog[1]
label val d_EFZp KLASSECHFMT

bysort year d_EFZp: gen d_EFZp_no = _n
bysort  year d_EFZp: egen d_EFZp_no_max = max(d_EFZp_no) 

drop d_EFZp_no

sort pid year

replace income_work_max = . if income_work_max > 10000

bysort d_EFZp : egen income_d_EFZp=mean(income_work_max)
bysort d_EFZp : egen pisamath_d_EFZp=mean(score_avmath)

graph hbox income_work_max if d_EFZp_no>30, over(d_EFZp, sort(income_d_EFZp)) xsize(8) ysize(8) scale(0.6) graphregion(color(white)) ytitle("")

reg income_work_max female score_avmath pedu_tertiary hisei i.region
reg income_work_av female score_avmath pedu_tertiary hisei i.region

reg income_work_av female score_avmath pedu_tertiary hisei i.d_EFZp i.region

graph hbox score_avmath if edug_no_max >=60, xsize(8) ysize(8) scale(0.6) over(edu_group, sort(av_math)) graphregion(color(white)) ytitle("")

********************************************************************************
********************************************************************************
