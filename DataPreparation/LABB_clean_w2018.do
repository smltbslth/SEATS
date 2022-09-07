*########### LABB clean ##################
	*dependent dofile (called from SEATS_w4.do)

/*	
global raw   "$path_nc_root/Daten/SEATS/Daten/Datenlieferungen/2021_07"
global pisadata  "$path_nc_root/Daten/SEATS/Daten/AdditionalData/pisa"
global vetdata  "$path_nc_root/Daten/SEATS/Daten/AdditionalData/VET"
global output "$path_nc_root/Daten/SEATS/Daten/Aufbereitet"
global do "$path_nc_root/Daten/SEATS/Daten/DoFiles"
global pisado "$path_nc_root/Daten/SEATS/Daten/DoFiles"	
	
global lan en		// choose between "en" and "de" to set the label language 
global latestyear 2019	// set up to which year the database goes
*/	
	
*################# LONG ########################################################
{	
	
use "$raw/pisalffinal.dta", clear // dies sind LABB

run "$do/my_labels.do" // from LabelsDocumentation.do

* keep only students that are also in our pisa 12 sample! 	ADD THE RIGHT PISA DATA SET (FORS)!!!!
	rename pisanr pid
	merge m:1 pid using "$output/pisa.dta", keepusing(pid) keep(match) nogen

	
	
* !!!!!!! until i have the proper dataset
*	rename pisanr pid
*	merge m:1 pid using "$output/tmp/pisa2012_skbf.dta", keepusing(pid) keep(match) nogen
	

* rename variables and adjust variables
	
	
	rename Stateofbirth pob
	rename Nationalitystate nationality
	rename E_firstlanguage firstlanguage 			
	rename Sp_cantonofresidence cor
	rename Sp_municipofresidence mor	// the number seems to relate to the SFOS code
	rename Urbanrural rural 
	rename Languageregion lingreg
	rename E_year year
	rename E_educprog e_prog
	rename E_educyear e_year
	rename E_gradecompletion d_success
	rename E_eventtype d_test
	rename E_formtype e_form
	rename E_bfeld1 e_field1
	rename E_bfeld2 e_field2
	rename E_bfeld3 e_field3
	rename E_educlength e_duration
		recode e_duration (1=1)(2=1.5)(3=2)(4=2.5)(5=3)(6=3.5)(7=4)		
	rename E_eductype1 e_type1
	rename E_eductype2 e_type2
	rename E_eductype3 e_type3
	rename E_municipofinst e_moei
	rename E_deliverycanton e_coei 		// e_cantonOfInst  includes 4 cases of federal maturity, otherwise same
	rename E_schooltype e_itype
	rename Statmig1 migration
	rename Yearofbirth birth
	rename E_date e_date
	rename Sex sex
	rename E_timeoff e_timeoff
	rename E_shisfields3 e_shisfields3
	rename E_levelofstudy e_levelofstudy
	rename E_institution e_institution
	rename E_insttype e_insttype
	rename Ageofcharrival ageofcharrival
	rename Source source
	rename E_classid e_classid
	
	gen E_gradecompletion = d_success
	
	run "$do/label_fso.do"

	for any pob firstlanguage mor cor: replace X=-6 if X==-9
		

* generated index
	gen modified = .
		label var modified "variables within observation modified"
		label def modified 1 "generated observation" 2 "adjusted e_year" 3 "deleted observation" 6 "dropped 1 exam", replace
		label val modified modified	
	
* add values to value labels (for the coding)

*	numlabel KLASSECHFMT e_type2  EDUCTYPE3FMT, add
	


* drop variables that are not needed
	drop Populationtype Se_* E_* Lernidcat Tfevent Sourcedemo counter 


**** cleaning observations that are double, or unlikely

*## permanently droping students
	* drop one student who entered upper secondary education already in 2011
		drop if pid==2000100024
	* this student follows two complete educational tracks at the same time. there must be a mix up
		drop if pid==1901500032
	*this student repeats the 9th grade 3 times and then starts in 2nd year of trade school
	drop if pid==2000100039 
		
*## permanently droping entries (duplicates, repetition within the same year)	
	
	/* find with: 
		drop if d_test==2
		duplicates report pid year	
	*/
	
	* these 3 students were entered in two tracks of the same school. I chose the track of the diploma
	drop if pid==1400300059 & (year==2013 | year==2014) & e_prog==103232
		replace modified=3 if pid==1400300059 & (year==2013 | year==2014) & d_test==1
	drop if pid==1400300054 & (year==2013 | year==2014) & e_prog==103275
		replace modified= 3 if pid==1400300054 & (year==2013 | year==2014) & d_test==1
	drop if pid==1400300035 & (year==2013) & e_prog==103232
		replace modified = 3 if pid==1400300035 & (year==2013) & d_test==1
		
	* this student was in an EFZ and EBA in 2012, but then continued the EBA (drop EFZ)	
	drop if pid==1400400075 & (year==2012) & e_prog==277600
		replace modified = 3 if pid==1400400075 & (year==2012) & d_test==1
		
	* this student is signed up twice for the same EFZ, but with differnt dates of registration (delete the later date)
		drop if pid==1501300041 & (year==2012) & e_date==19286
		replace modified = 3 if pid==1501300041 & (year==2012) & d_test==1

	* this student is is still signed up for first edu (not finishing it) but starts a new one (drop last year of first edu)
		drop if pid==1801000074 & (year==2015) & e_prog==471600
		replace modified = 3 if pid==1801000074 & (year==2015) & d_test==1
		
	* this student has information on an implausible FH registration from 2013 on, but also credible information on EFZ and FH in a fitting subject (drop early unfitting fh)	
		drop if pid==2002200057 & (year==2013 | year==2014 | year==2015 | year==2016) & e_field3==714
		replace modified = 3 if pid==2002200057  & (year==2013 | year==2014 | year==2015 | year==2016) & d_test==1
	
	* these two student have in 2011 already a start at EFZ, but are then in 2012 again in the first year (delete 2011 EFZ observation)
	drop if pid==6200800018 & (year==2011) & e_prog==287200
		replace modified = 3 if pid==6200800018 & (year==2011) & d_test==1
	drop if pid==6200900019 & (year==2011) & e_prog==287200
		replace modified = 3 if pid==6200900019 & (year==2011) & d_test==1	
	drop if pid==6201800009 & (year==2011) & e_prog==391600
		replace modified = 3 if pid==6201800009 & (year==2011) & d_test==1		
	
	* this student visits two types of education in 2015. Deleted the less likely
	drop if pid==1800600069 & year==2015 & e_prog==103650
		replace modified=3 if pid==1800600069 & year==2015 & d_test==1
	

*!!!!!!!!!!!!!!!!!!!!! drop for now !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
drop if ( pid==301200049 | pid==1601200061 | pid==1901400019 | pid==302200020 | pid==302400028 | pid==1601300043)



	* these students tried and failed the exams during their first and second years of longer education (?!)
	/*
	list pid  if d_test ==2 & year<2014
	*/
	
	drop if pid==401300035 & (year==2012) & d_test==2 & e_duration==3
		replace modified = 6 if pid==401300035 & (year==2012)
	drop if pid==1701000019 & (year==2012 | year==2013) & d_test==2 & e_duration==3
		replace modified = 6 if pid==1701000019 & (year==2012 | year==2013)
	drop if pid==1800300051 & (year==2013) & d_test==2 & e_duration==3
		replace modified = 6 if pid==1800300051 & (year==2013)
	drop if pid==1800500027 & (year==2013 | year==2014) & d_test==2 & e_duration==3
		replace modified = 6 if pid==1800500027 & (year==2013 | year==2014)
	drop if pid==1800900006 & (year==2012) & d_test==2 & e_duration==3
		replace modified = 6 if pid==1800900006 & (year==2012)
	drop if pid==1800900046 & (year==2013 | year==2014) & d_test==2 & e_duration==3
		replace modified = 6 if pid==1800900046 & (year==2013 | year==2014)	
	drop if pid==1401200026 & (year==2013 | year==2014) & d_test==2 & e_duration==3
		replace modified = 6 if pid==1401200026 & (year==2013 | year==2014)

       
	 
	
	* dropping the observations of students that took an exam twice in one year; dropping the failing first attemt
	/*
	duplicates tag pid year e_prog d_test, gen(dup2)
	*/
	
	for any 2000600066 1400100028 1400200075  1800700074: drop if pid==X & year==2017 & d_success==0 & e_date== 20853
			for any 2000600066 1400100028 1400200075  1800700074: replace modified=6 if pid==X & year==2017 
	drop if pid == 1900500051 & year ==2017 & d_success==0 & e_date== 21007
		replace modified=6 if pid == 1900500051 & year ==2017
	drop if pid == 1900700013 & year ==2016 & d_success==0 & e_date== 20636
		replace modified=6 if pid == 1900700013 & year ==2016	
	drop if pid == 1900800012 & year ==2015 & d_success==0 & e_date== 20270
		replace modified=6 if pid == 1900800012 & year ==2015
	drop if pid == 1900800018 & year ==2016 & d_success==0 & e_date== 20636
		replace modified=6 if pid == 1900800018 & year ==2016	
	drop if pid == 1900900054 & year ==2017 & d_success==0 & e_date== 21007
		replace modified=6 if pid == 1900900054 & year ==2017
	drop if pid == 1901300036 & year ==2015 & d_success==0 & e_date== 20270
		replace modified=6 if pid == 1901300036 & year ==2015		
	drop if pid == 1901600034 & year ==2017 & d_success==0 & e_date== 21007
		replace modified=6 if pid == 1901600034 & year ==2017
	drop if pid == 1902000011 & year ==2016 & d_success==0 & e_date== 20636
		replace modified=6 if pid == 1902000011 & year ==2016		
	drop if pid == 6200900006 & year ==2016 & d_success==0 & e_date== 20634
		replace modified=6 if pid == 6200900006 & year ==2016
	drop if pid == 6300600024 & year ==2016 & d_success==0 & e_date== 20523
		replace modified=6 if pid == 6300600024 & year ==2016		
		
**** Clean duplicates in wave 6 (2017/2018 data)
	drop if pid == 130300041 & year == 2017 & e_prog == 860800
		replace modified=3 if pid == 130300041 & year ==2017
	drop if pid == 300100023 & year == 2017 & e_prog == 864050
		replace modified=3 if pid == 300100023 & year ==2017
	drop if pid == 601900096 & year == 2017 & e_prog == 103650
		replace modified=3 if pid == 601900096 & year ==2017
	drop if pid == 803200046 & year == 2017 & e_prog == 103650
		replace modified=3 if pid == 803200046 & year ==2017
	drop if pid == 1400800072 & year == 2017 & e_prog == 384300
		replace modified=3 if pid == 1400800072 & year ==2017
	drop if pid == 1500400086 & year == 2017 & e_prog == 6003222
		replace modified=3 if pid == 1500400086 & year ==2017
	drop if pid == 1601500007 & year == 2017 & e_prog == 384350
		replace modified=3 if pid == 1601500007 & year ==2017

*** clean duplicates in 2018/2019		
	drop if Dformflag == 0	

	
	*###### generate e_prog_simp to track students if the job code is inconsistent
	run "$do/occupation_recode.do"
	label val e_prog_simp KLASSECHFMT
	label var e_prog_simp "Simplified education code according to Swiss nomenclature"
	numlabel KLASSECHFMT, add

*** isolating the degree variables (to attach them to the year they took place)
	preserve 
	keep if d_test == 2 	// only keep diploma entries
	
	gen d_EBA=d_success if e_type3== 311
	gen d_EBAprog=e_prog if e_type3== 311
	gen d_EBAprog_simp=e_prog_simp if e_type3== 311
	
	gen d_EFZ=d_success if e_type3==312 | e_type3==313
	gen d_EFZprog=e_prog if e_type3== 312 | e_type3==313
	gen d_EFZprog_simp=e_prog_simp if e_type3== 312 | e_type3==313
	
	gen d_FmA=d_success if e_type3==320
	gen d_FmAprog=e_prog if e_type3== 320
	gen d_FmAprog_simp=e_prog_simp if e_type3== 320
	
	gen d_FM=d_success if e_type3==340
	gen d_FMprog=e_prog if e_type3== 340
	gen d_FMprog_simp=e_prog_simp if e_type3== 340
	
	gen d_GM=d_success if e_type3==331
	gen d_GMprog=e_prog if e_type3== 331
	gen d_GMprog_simp=e_prog_simp if e_type3== 331
	
	gen d_BM=d_success if e_type3==351| e_type3==352
	gen d_BMprog=e_prog if e_type3== 351 | e_type3==352
	gen d_BMprog_simp=e_prog_simp if e_type3== 351 | e_type3==352
	
	gen d_Passerelle=d_success if e_type3== 410
	
	gen d_other=d_success if e_type3== 541 | e_type3==339
	gen d_otherprog_simp=e_prog_simp if e_type3== 541 | e_type3==339
	gen d_otherprog=e_prog if e_type3== 541 | e_type3==339
	
	gen d_type3=e_type3 if e_type3== 311 | e_type3==312 | e_type3==313 | e_type3==320 |  e_type3==331
	label var d_type3 "Type of diploma, based on e_type3"
	
	gen d_SEKII = d_success if e_type3== 311 | e_type3==312 | e_type3==313 | e_type3==320 |  e_type3==331
	label var d_SEKII "Diploma on SekII, i.e. 311, 312, 313, 320, 331"

*** Tertiär: HBB
	gen d_HF=d_success if e_type3== 511
	gen d_HFprog=e_prog if e_type3== 511
	
	gen d_BP=d_success if e_type3== 520
	gen d_BPprog=e_prog if e_type3== 520	

	gen d_HFP=d_success if e_type3== 530
	gen d_HFPprog=e_prog if e_type3== 530	

	
*** Tertiär: UH, FH, PH
	gen d_ta=1 if e_type3 == 612 | e_type3 == 613 | e_type3 == 614 | e_type3 == 623 | e_type3 == 624 | e_type3 == 633 | e_type3 == 634 
	gen d_ta_type=e_type3 if e_type3 == 612 | e_type3 == 613 | e_type3 == 614 | e_type3 == 623 | e_type3 == 624 | e_type3 == 633 | e_type3 == 634 

***	
	drop  d_test
	replace d_success=. if d_success!=1
	keep d_* pid year
	collapse (firstnm) d_EBA* d_EFZ* d_FmA* d_FM* d_GM* d_BM* d_type3 d_SEKII d_Passerelle d_HF d_HFprog d_BP d_BPprog d_HFP d_HFPprog d_ta d_ta_type d_other* (sum) d_success , by(pid year)	
	rename d_success d_ndip
	label var d_ndip "Number of passed diploma including BM (sum LABB var E_gradecompletion == 1)"
*	gen d_test=2
	
	label def diploma 0 "fail" 1 "pass"
	for any d_EBA d_EFZ d_FmA d_FM d_GM d_BM d_Passerelle d_HF d_BP d_HFP d_other d_SEKII d_ta: label val X diploma
	for any *prog: label val X KLASSECHFMT
	label val d_type3 EDUCTYPE3FMT
		
	save "$output/tmp/degree.dta", replace
	
	restore

	drop if d_test==2
	drop d_success
	
			
* generate an observation per student per year	
	preserve
	keep if year==2011
	keep pid
	
	expand ($latestyear - 2010)
	bysort pid: gen year=_n
	drop if year>($latestyear - 2010)
	replace year = 2010 + year
	
	save "$output/tmp/grid.dta", replace
	restore
	
merge m:1 pid year using "$output/tmp/grid.dta", nogen
		
bysort pid year:  gen dup = cond(_N==1,0,_n)		
		
*** merging the diplomas to the education

merge 1:1 pid year using "$output/tmp/degree.dta", nogen

label var d_EBA "311: Berufliche Grundbildung: EBA & Anlehre"	
label var d_EFZ "312 & 313: Berufliche Grundbildung: 3 & 4-jährige EFZ"	
label var d_FmA "320: Fachmittelschule"	
label var d_FM "340: Fachmaturitätsschule"	
label var d_GM "331: Maturitätsschule"	
label var d_BM "351 & 352: Berufsmaturitätsschule (BM I oder II)"	
label var d_Passerelle "410: Passerellenlehrgang"	
label var d_HF "511: Höhere Fachschule Diplom"	
label var d_BP "520: eidg. Fachausweis"	
label var d_other "541: Höhere Berufsbildung nicht reglementiert Diplom oder 339: Ausländische allgemeinbildende Ausbildung"	
label var d_ta "Diploma on tertiary academic level: UH, FH and PH"
label var d_ta_type "Type of diploma based on e_type3: UH, FH and PH"
label val d_ta_type EDUCTYPE3FMT	
	
xtset pid year
order pid year e_year e_duration d_test d_ndip e_prog* e_type* , first

************** generate variables
	gen g_startsekII=-3 if year==2011
	forvalues d = 2012 / $latestyear	{
		replace g_startsekII = 1 if (e_type1==3) & year==`d'	// this year = started if educ == Secondary II
		replace  g_startsekII=-3 if year==`d' & g_startsekII==.	// = not yet if missing
		replace  g_startsekII=-2 if (l.g_startsekII==1 | l.g_startsekII==-2) &  year==`d'	// in the past if last year == past or this year
		}
		label var g_startsekII "for the first time in upper secondary education, based on e_type1"
		label def g_start -8 "unlikely value" -3 "not yet" -2 "in the past" 1 "this year", replace
		label val g_startsekII g_start


* ##### clean unlikely cases where students start with second year of SEK II
/*
	ta e_year if g_startsekII ==1
	-> then weed out all the unfitting cases...
	*/
{
	unab vars: e_* d_* g_*
	global droplist `vars'
	global replist e_duration e_prog e_prog_simp e_type1 e_type2 e_type3 e_field2 e_field1 e_field3
	
	unab d_vars: d_*	
	global d_droplist `d_vars' 
	
	
* clean cases when students enter directly into the second year of education


	* 1. & 2. year are coded as year 2
	
	replace modified=2 if g_startsekII==1 & e_year==2 & f.e_year==2 & e_prog_simp==f.e_prog_simp
	replace e_year=1 if g_startsekII==1 & e_year==2 & f.e_year==2 & e_prog_simp==f.e_prog_simp
	
	
	* 1. & 2. year are coded as years 3 and then 2
		replace modified=2 if g_startsekII==1 & e_year==3 & f.e_year==2 & e_prog_simp==f.e_prog_simp
	replace e_year=1 if g_startsekII==1 & e_year==3 & f.e_year==2 & e_prog_simp==f.e_prog_simp
	
	* 1. year unlikely to be a correct entry (drop entry for that year)
	for any $droplist: replace X=. if pid==  303600021 & year==2012
		replace modified=3 if pid==  303600021 & year==2012	
		replace g_startsekII=1 if pid==  303600021 & year==2013
		replace g_startsekII=-3 if pid==  303600021 & year==2012
	
	* 1. & 2. year are coded as year 2 but there is a small shift in the e_prog_det between the two years
		replace modified=2 if  g_startsekII==1 & e_year==2 & f.e_year==2 & e_field3==f.e_field3 & e_type3==f.e_type3 & e_duration == f.e_duration
	replace e_year=1 if g_startsekII==1 & e_year==2 & f.e_year==2 & e_field3==f.e_field3 & e_type3==f.e_type3 & e_duration == f.e_duration
	
	
	* 1. & 2. year are coded as year 2 and then 1, and there is a small shift in the e_prog_det between the two years, set year 1 to 1 as well
		replace modified=2 if  g_startsekII==1 & e_year==2 & f.e_year==1 & e_prog_simp==f.e_prog_simp
	replace e_year=1 if  g_startsekII==1 & e_year==2 & f.e_year==1 & e_prog_simp==f.e_prog_simp
	
	* enters first in 2. year in one education, but starts a completely different education (from 1. year) the follwing year
		 replace modified=2 if g_startsekII==1 & e_year==2 & f.e_year==1 & e_prog_simp!=f.e_prog_simp
	replace e_year=1 if g_startsekII==1 & e_year==2 & f.e_year==1 & e_prog_simp!=f.e_prog_simp
	
	*special case with mix up of years of education, adjusted
	replace e_year=1 if pid==2601900014 & year==2013
		replace modified=2  if pid==2601900014 & year==2013
	replace e_year=2 if pid==2601900014 & year==2014
		replace modified=2  if pid==2601900014 & year==2014
	replace e_year=3 if pid==2601900014 & year==2015
		replace modified=2  if pid==2601900014 & year==2015
	
	* enters 2. year after a gap year and then continues to 3. year...
		gen marker = 1 if e_year==. & f.e_year==2 & f2.e_year==3 & f.g_startsekII==1
		replace modified=1 if marker==1
	for any $replist: replace X=f.X if marker==1
	replace e_year=1 if marker==1
	replace g_startsekII=1 if marker==1
	replace g_startsekII=-2 if l.marker==1
	drop marker
	
	* enters 2. year after repeating the 9th year of SEK I and then continues to 3. year...
		gen marker = 1 if e_year==9 & f.e_year==2 & f2.e_year==3 & f.g_startsekII==1
		replace modified=1 if marker==1
	for any $replist: replace X=f.X if marker==1
	replace e_year=1 if marker==1
	replace g_startsekII=1 if marker==1
	replace g_startsekII=-2 if l.marker==1
	drop marker
	
	* this student starts with a BM2 in 2012, which is formally not feasible (without vocational certificate)
	for any $droplist: replace X=. if pid==200900045 & year==2012 
		replace modified=3 if pid==200900045 & year==2012 
		replace g_startsekII=-3  if pid==200900045 & year==2012
		replace g_startsekII=1  if pid==200900045 & year==2013
		
	* unlikely case where student starts with transition sekII to tertiary, drop that year of edu
	for any $droplist: replace X=.  if pid==1900700015 & year==2014
		replace modified=3 if pid==1900700015 & year==2014
		replace g_startsekII=-3  if pid==1900700015 & year==2014
		replace g_startsekII=1  if pid==1900700015 & year==2015
			
	* this student visits a not recognized trade school and has years missing and mixed up, but makes a federal diploma at the end. I reconstruct the most likely educational path
	for any $replist: replace X=f.X if pid== 802400038  & year==2012
	replace g_startsekII =1 if pid== 802400038  & year==2012
	replace e_year=1 if pid== 802400038  & year==2012
		replace modified=1 if pid== 802400038  & year==2012
	replace g_startsekII=-2	   if  pid== 802400038  & year==2013
	replace e_year=3 if pid== 802400038  & year==2014	
		replace modified=2 if pid== 802400038  & year==2014
		
	* check with next update!: this student makes gap year and then 2-4 years of a 3 year education. I adjusted the e_year by -1
	replace e_year=e_year-1 if pid== 1500900042  & (year==2013 | year==2014 | year==2015)
	replace modified=2 if pid== 1500900042  & (year==2013 | year==2014 | year==2015)
	
	* makes transitory education, then enters at 2nd year and then continues to 3rd year... replace transitory by first year EFZ
		gen marker = 1 if e_type1==2 & f.e_year==2 & f2.e_year==3 & f.g_startsekII==1
		replace modified=1 if marker==1
	for any $replist: replace X=f.X if marker==1
	replace e_year=1 if marker==1
	replace g_startsekII=1 if marker==1
	replace g_startsekII=-2 if l.marker==1
	drop marker
	
	* gap year, then 2nd year of gymnasium, then 2 years of foreign education. replaced 2nd to 1st year of gymnasium
	replace e_year=1 if pid==2602000025 & year==2013
		replace modified=2 if pid==2602000025 & year==2013
	
	* first year of EFZ from different source, no year value. set first year of EFZ to first
	replace e_year=1 if pid==6200700009 & year==2012
		replace modified=2 if pid==6200700009 & year==2012
	replace e_year=1 if pid==1400500011 & year==2013
		replace modified=2 if pid==1400500011 & year==2013
	
	* mixed up years in education, but steady type of program, readjusted the years information
	replace e_year=1 if pid==1901200036 & year==2013
		replace modified=2 if pid==1901200036 & year==2013
	replace e_year=2 if pid==1901200036 & year==2014
		replace modified=2 if pid==1901200036 & year==2014
	
	* appears in 3rd year of education in 2014 and gets a diploma in 2015. created the education for 2012 and 2013	
		gen marker = 1 if e_year==. & f2.e_year==3 & (f3.d_ndip==1 |f3.d_ndip==2) & f2.g_startsekII==1 & f3.d_EFZprog_simp==f2.e_prog_simp
		replace modified=1 if marker==1
	for any $replist: replace X=f2.X if marker==1
	replace e_year=1 if marker==1
	replace g_startsekII=1 if marker==1
		replace modified=1 if l.marker==1
	for any $replist: replace X=f.X if l.marker==1
	replace e_year=2 if l.marker==1
	replace g_startsekII=-2 if l.marker==1
	replace g_startsekII=-2 if l2.marker==1
	drop marker
		
	
	* appears in 4rd year of education in 2015 and gets a diploma in 2016. created the education for 2012, 2013 and 2014	
		gen marker = 1 if e_year==. & f3.e_year==4 & (f4.d_ndip==1 |f4.d_ndip==2) & f3.g_startsekII==1 & f4.d_EFZprog_simp==f3.e_prog_simp
		replace modified=1 if marker==1
	for any $replist: replace X=f3.X if marker==1
	replace e_year=1 if marker==1
	replace g_startsekII=1 if marker==1
		replace modified=1 if l.marker==1
	for any $replist: replace X=f2.X if l.marker==1
	replace e_year=2 if l.marker==1
	replace g_startsekII=1 if l.marker==1
		replace modified=1 if l2.marker==1
	for any $replist: replace X=f.X if l2.marker==1
	replace e_year=3 if l2.marker==1
	replace g_startsekII=-2 if l.marker==1
	replace g_startsekII=-2 if l2.marker==1
	replace g_startsekII=-2 if l3.marker==1
	drop marker
	
	
	* missing years 2012 and 2013, but is in 3rd year in 2014 and in 4th in 2015
	gen marker = 1 if e_year==. & f2.e_year==3 & f3.e_year==4 & f2.g_startsekII==1 & f3.e_prog_simp==f2.e_prog_simp
		replace modified=1 if marker==1
	for any $replist: replace X=f2.X if marker==1
	replace e_year=1 if marker==1
	replace g_startsekII=1 if marker==1
		replace modified=1 if l.marker==1
	for any $replist: replace X=f.X if l.marker==1
	replace e_year=2 if l.marker==1
	replace g_startsekII=-2 if l.marker==1
	replace g_startsekII=-2 if l2.marker==1
	drop marker
	
	* year one, gap , year 3, diploma or year 4, replace year 2
		gen marker=1 if e_prog_simp==. & l.e_year==1 & l.e_prog_simp!=. & g_startsekII==-2 & f.e_prog_simp==l.e_prog_simp & f.e_year==3
	for any $replist: replace X=l.X if marker==1
	replace e_year=2 if marker==1
		replace modified=1 if marker==1
	drop marker	
		
	* makes a VET in modules, replace modules with ordered e_year	
	replace e_year=1 if pid==1801300057 & year==2015
		replace modified=2 if pid==1801300057 & year==2015
	replace e_year=2 if pid==1801300057 & year==2016
		replace modified=2 if pid==1801300057 & year==2016
		
	* reports 9th year as first year of EFZ and then from 1 to 3 in three years EFZ, replace first year with first -> leads to repetition of first year
	replace e_year=1 if pid==1900200045 & year==2013
		replace modified=2 if pid==1900200045 & year==2013	
		
		
	* non attributable value for first year, set to first year
	gen marker = 1 if e_year==-1 & g_startsekII==1
		replace e_year=1  if marker==1
		replace modified=2 if marker==1
		drop marker
		
	

	* twice 1st year and then 3rd of the same program, changed middle year to second !!!!!!!!!!! modified makes one more change than e_year, weird!!!!!!!!!!!
		replace modified=2 if e_year!=2 & l.e_year==1 & f.e_year==3 & e_prog_simp==l.e_prog_simp & e_prog_simp==f.e_prog_simp
	replace e_year=2 if l.e_year==1 & f.e_year==3 & e_prog_simp==l.e_prog_simp & e_prog_simp==f.e_prog_simp

	*this person has likely e_year 2013 and 2014 mislabeled, adjusted by +1
		replace e_year=2 if pid==6300400012 & (year==2013 | year==2014)
			replace modified=2 if pid==6300400012 & (year==2013 | year==2014)
		
	* 3rd year of EFZ listed as 9th year, recode
		replace modified=2 if year==2014 &	pid == 1500500025
	replace e_year=3 if year==2014 &	pid == 1500500025
			
	
		
***############ replace e_prog_simp for specific occupation that fork into several others	
/* Gipser/in-Trockenbauer/in EFZ ; Gipser/in und Maler/in */
replace e_prog_simp=332100 if e_prog==332500 & g_startsekII==1 & (f3.d_EFZprog_simp==332100 | f4.d_EFZprog_simp==332100)
replace e_prog_simp=332100 if e_prog==332500 & g_startsekII==-2 & l.e_prog_simp==332100 & l.e_year<=e_year


/* Maler/in EFZ ; Gipser/in und Maler/in */
replace e_prog_simp=341600 if e_prog==332500 & g_startsekII==1 & (f3.d_EFZprog_simp==341600 | f4.d_EFZprog_simp==341600)
replace e_prog_simp=341600 if e_prog==332500 & g_startsekII==-2 & l.e_prog_simp==341600 & l.e_year<=e_year
	
// 363200. Haustechnikplaner/in in 363310. Gebäudetechnikplaner/in Heizung EFZ
replace e_prog_simp=363310 if e_prog==363200 & pid==101100018		
		
// Handelsmittelschule und dann EFZ		
local ha "(e_prog==382900 | e_prog ==383000 | e_prog ==383200 | e_prog ==383100)"
local kv "e_prog_simp==384350"
local ov "(fX.e_prog_simp==384350 | fX.e_prog_simp==384450 | fX.e_prog_simp==287200)"
for num 1/4: replace e_prog_simp=fX.d_EFZprog_simp if e_prog==382900 & fX.d_EFZprog_simp==384350
for num 1/4: replace e_prog_simp=fX.d_EFZprog_simp if e_prog==382900 & fX.d_EFZprog_simp==384450
for num 1/2: replace e_prog_simp=fX.e_prog_simp if e_year==2 & `ha' & fX.e_year==X+2 & `ov'
for num 1/3: replace e_prog_simp=fX.e_prog_simp if e_year==1 & `ha' & fX.e_year==X+1 & `ov'
for num 1/3: replace e_prog_simp=f.e_prog_simp if e_year==X & `ha' & f.e_year==X & (f.`kv' | f.e_prog==287200)
replace e_prog_simp=f2.e_prog_simp if `ha' & e_year==1  & f2.e_year==2 & f.e_prog==.
	* repetitions, because of the order of changes
for num 1/3: replace e_prog_simp=f.e_prog_simp if e_year==X & `ha' & f.e_year==X & (f.`kv' | f.e_prog_simp==287200)
for num 1/3: replace e_prog_simp=fX.e_prog_simp if e_year==1 & `ha' & fX.e_year==X+1 & `ov'

// Anlehren
for num 1/2: replace e_prog_simp=fX.d_EBAprog if (e_prog>519999 & e_prog<530000) & fX.d_EBAprog!=.



***EBA

gen d_EBAmatch = .
replace d_EBAmatch=-8 if d_EBAprog!=.
replace d_EBAmatch=1 if l.e_prog_simp==d_EBAprog_simp & d_EBAprog!=.
replace d_EBAmatch=1 if l.d_EBAmatch==1 & d_EBAprog_simp==l.d_EBAprog_simp
label var d_EBAmatch "1 if l.e_prog_simp==d_EBAprog_simp"

***EFZ
		
gen d_EFZmatch = .
replace d_EFZmatch=-8 if d_EFZprog!=.
replace d_EFZmatch=1 if l.e_prog_simp==d_EFZprog_simp & d_EFZprog!=.
replace d_EFZmatch=1 if l.d_EFZmatch==1 & d_EFZprog_simp==l.d_EFZprog_simp	
label var d_EFZmatch "1 if l.e_prog_simp==d_EFZprog_simp"


	
*** unlikely e_year
	replace modified=2 if e_year>f.e_year & e_prog_simp == f.e_prog_simp 	
replace e_year=-4 if e_year>f.e_year & e_prog_simp == f.e_prog_simp 
	
	
	
*these individuals lack information on education but have a diploma, set startsekII to -8 (unlikely)
gen marker = 1 if g_startsekII!=-2 & d_SEKII !=.
bysort pid: egen ma=mean(marker)
replace g_startsekII=-8 if ma==1
drop marker ma




	
	
***GM	
	
gen d_GMmatch = .
replace d_GMmatch=-8 if d_GMprog!=.
replace d_GMmatch=1 if l.e_prog_simp==d_GMprog_simp & d_GMprog!=.	
replace d_GMmatch=1 if l.d_GMmatch==1 & d_GMprog_simp==l.d_GMprog_simp	
label var d_GMmatch "1 if l.e_prog_simp==d_GMprog_simp"

	
	
***FmA	
		
gen d_FmAmatch = .
replace d_FmAmatch=-8 if d_FmAprog!=.
replace d_FmAmatch=1 if l.e_prog_simp==d_FmAprog_simp & d_FmAprog!=.
replace d_FmAmatch=1 if l.d_FmAmatch==1 & d_FmAprog_simp==l.d_FmAprog_simp		
label var d_FmAmatch "1 if l.e_prog_simp==d_FmAprog_simp"

		
		
		
		
		




*************** generate progress variables




* E1 first SekII education
gen E1=1 if g_startsekII==1 
	replace E1 = 1 if l.E1==1 & e_prog_simp==l.e_prog_simp & e_type1==3
	replace E1 = 1 if l2.E1==1 & e_prog_simp==l2.e_prog_simp & l.e_prog_simp==. & e_type1==3 & e_year>l2.e_year
	replace E1 = 2 if E1==. & l.E1!=. & (e_year==l.e_year+1 | (e_year==l.e_year & e_year>1)) & e_type3==l.e_type3 & e_field3==l.e_field3 & e_type1==3
	replace E1 = 2 if E1==. & l.E1!=. & (e_year==l.e_year+1 | (e_year==l.e_year & e_year>1)) & e_form==10 & l.e_form==10 & e_field3==l.e_field3 & e_type1==3
	replace E1 = 2 if E1==. & l2.E1!=. & (e_year==l2.e_year+1 | (e_year==l2.e_year & e_year>1)) & e_type3==l2.e_type3 & e_field3==l2.e_field3 & e_type1==3 & e_year>l2.e_year
	replace E1 = 2 if E1==. & l2.E1!=. & (e_year==l2.e_year+1 | (e_year==l2.e_year & e_year>1)) & e_form==10 & l2.e_form==10 & e_field3==l2.e_field3 & e_type1==3 & e_year>l2.e_year
	replace E1 = l.E1 if E1==.& l.E1!=. & e_prog_simp==l.e_prog_simp & e_type1==3
label var E1 "first education on SEK II level"	
	label def E1 1 "first SEK II education" 2 "first SEK II education with (marginal) change in program"
	label val E1 E1



* D1 SekII diploma (passed)
gen D1 = d_EBA==1 | d_EFZ==1 | d_GM==1 | d_FmA==1 
label var D1 "SEK II Diploma"
	label def pass 0 "no diploma (no attempt or failed)" 1 "passed diploma", replace
	label val D1 pass
	
gen Df1 = d_EFZ==1 | d_GM==1 | d_FmA==1 
label var Df1 "full SEK II Diploma (no EBA)"
	label val Df1 pass	

gen DE1 = D1 if  (d_EBAprog_simp==l.e_prog_simp | d_EBAprog_simp==l2.e_prog_simp) | (d_EFZprog_simp==l.e_prog_simp | d_EFZprog_simp==l2.e_prog_simp) | (d_GMprog_simp==l.e_prog_simp | d_GMprog_simp==l2.e_prog_simp) | (d_FmAprog_simp==l.e_prog_simp | d_FmAprog_simp==l2.e_prog_simp)
replace DE1=0 if DE1==.
label var DE1 "Diploma for first SEK II education"
	label val DE1 pass

gen DfE1 = Df1 if (d_EFZprog_simp==l.e_prog_simp | d_EFZprog_simp==l2.e_prog_simp) | (d_GMprog_simp==l.e_prog_simp | d_GMprog_simp==l2.e_prog_simp) | (d_FmAprog_simp==l.e_prog_simp | d_FmAprog_simp==l2.e_prog_simp)
replace DfE1=0 if DfE1==.
label var DfE1 "Diploma for first full SEK II education"
	label val DfE1 pass	

* DTA Diploma that gives access to tertiary degree	
gen DTA = d_GM==1 | d_FM==1 | d_BM==1  
label var D1 "SEK II Diploma"
	label val D1 pass
	
	
* Has a (first) SEK II diploma (fullfilling the 95% goal)
gen g_dSEKII=-3 if year==2011
	forvalues d = 2012 / $latestyear	{
		replace g_dSEKII = 1 if (D1==1) & year==`d'	// this year
		replace  g_dSEKII=-3 if year==`d' & g_dSEKII==.		// not yet
		replace  g_dSEKII=-2 if (l.g_dSEKII==1 | l.g_dSEKII==-2) &  year==`d'	// in the past
		}
		label var g_dSEKII "passed first diploma on SEKII level"
		label val g_dSEKII g_start

	
	
* B1 break in first SekII education

gen B1=1 if l.E1!=. & E1==. & d_ndip==.



	gen g_ontrack=-3 if g_startsekII ==-3 | year==2011
	forvalues d = 2012 / $latestyear	{	
		replace g_ontrack = 1 if g_startsekII==1 & year==`d'							// first year
		replace g_ontrack = 1 if g_ontrack==. & g_startsekII==-2 & e_year==(l.e_year+1) & l.g_ontrack==1  & year==`d'  	//following years
		replace g_ontrack = 1 if g_ontrack==. & g_startsekII==-2 & e_year==(l.e_year+2) & l.g_ontrack==1  & e_prog_simp==l.e_prog_simp & year==`d'  	//following years with a jump
		replace g_ontrack = 1 if g_ontrack==. & g_startsekII==-2 & e_year==(l2.e_year+2) & l.e_year==. & l2.g_ontrack==1  & year==`d'  	//following years with one year gap	
		replace g_ontrack = 1 if g_ontrack==. & g_startsekII==-2 & e_year==(l3.e_year+3) & l.e_year==. & l3.g_ontrack==1  & year==`d'  	//following years with two years gap
		
		replace g_ontrack = 1 if g_ontrack==. & g_startsekII==-2 & e_year==99  & l.e_year==e_duration-1 & l.g_ontrack==1 & f.d_EFZprog_simp == l.e_prog_simp & e_prog_simp==l.e_prog_simp & year==`d'  	// a year with not defined year of education, but no delays in timeline 
		replace g_ontrack = 5 if (g_ontrack==. | g_ontrack==1) & g_startsekII==-2 & D1==1 & l.g_ontrack==1  & year==`d'  & d_type3==l.e_type3	// Diploma without delay
		
		replace g_ontrack = 2 if g_ontrack==. & g_startsekII==-2 & (e_year==l.e_year | e_year==-4 | l.e_year==-4) & (l.g_ontrack==1 | l.g_ontrack==2)  & year==`d' & E1==1  //repetition 
		replace g_ontrack = 2 if g_ontrack==. & g_startsekII==-2 & (e_year==l2.e_year | e_year==(l2.e_year+1)) & l.e_year==. & (l2.g_ontrack==1 | l2.g_ontrack==2)  & year==`d' & E1==1  //repetition with gap
		replace g_ontrack = 2 if g_ontrack==. & g_startsekII==-2 & e_year==(l2.e_year+2) & l.e_year==. & l2.g_ontrack==2  & year==`d'  	//following years with one year gap	and after delay
		replace g_ontrack = 2 if g_ontrack==. & g_startsekII==-2 & e_year==(l.e_year+1) & l.g_ontrack==2  & year==`d'  	//following years
		replace g_ontrack = 6 if  (g_ontrack==. | g_ontrack==2) & g_startsekII==-2 & D1==1 & (l.g_ontrack==2 | l2.g_ontrack==2 | l2.g_ontrack==1)  & year==`d'   & d_type3==l.e_type3	// Diploma with delay
		replace g_ontrack = 3 if g_ontrack==. & g_startsekII==-2 & g_dSEKII==-3 & E1!=1 & e_year!=. & year==`d'    //change
		replace g_ontrack = 7 if g_ontrack==. & g_startsekII==-2 & D1==1 & (l.g_ontrack==3 | l2.g_ontrack==3)  & year==`d'  	// Diploma with change
		replace g_ontrack = 7 if  (g_ontrack==. | g_ontrack==2) & g_startsekII==-2 & D1==1 & (l.g_ontrack==2 | l2.g_ontrack==2 | l2.g_ontrack==1)  & year==`d'   & d_type3!=l.e_type3	// Diploma with change after delay
		replace g_ontrack =-9 if g_ontrack==. & g_startsekII==-2 & g_dSEKII==-3 &  e_year==. & year==`d'    //gap
		
		replace g_ontrack = 5 if (g_ontrack==. | g_ontrack==1) & g_startsekII==-2 & D1==1 & l.e_prog_simp==. & ((d_type3==312 & l3.e_prog_simp==d_EFZprog_simp & l3.g_ontrack==1) |(d_type3==313 & l4.e_prog_simp==d_EFZprog_simp & l4.g_ontrack==1) |(d_FmAprog_simp==l3.e_prog_simp & l3.g_ontrack==1)) & year==`d'  	// Diploma without delay but gap in info
		replace g_ontrack = 6 if g_ontrack==. & g_startsekII==-2 & D1==1 & l.e_prog_simp==. & ((d_type3==312 & l3.e_prog_simp==d_EFZprog_simp & l3.g_ontrack==2) |(d_type3==313 & l4.e_prog_simp==d_EFZprog_simp & l4.g_ontrack==2) | (d_type3==312 & l4.e_prog_simp==d_EFZprog_simp & l4.g_ontrack==1) |(d_type3==313 & l5.e_prog_simp==d_EFZprog_simp & l5.g_ontrack==1)) & year==`d'  	// Diploma with delay and gap in info
		replace g_ontrack = 7 if g_ontrack==. & g_startsekII==-2 & D1==1 & l.e_prog_simp==. & ((d_type3==312 & l3.e_prog_simp==d_EFZprog_simp & l3.g_ontrack==3) |(d_type3==313 & l4.e_prog_simp==d_EFZprog_simp & l4.g_ontrack==3)) & year==`d'  	// Diploma without delay but gap in info
		replace g_ontrack=l.g_ontrack if g_ontrack==. & g_startsekII==-2 & g_dSEKII==-2 & year==`d'    // already finished
		replace g_ontrack=8 if g_ontrack==. & g_startsekII==-8 & (D1==1 | l.g_ontrack==8) & year==`d'    //diploma after unobserved education
		replace g_ontrack=8 if g_ontrack==. & g_startsekII==-2 & (D1==1 | l.g_ontrack==8) & year==`d' & (d_EFZprog_simp!= l3.e_prog_simp & d_EFZprog_simp!= l4.e_prog_simp)   //diploma after unobserved education and change
		replace g_ontrack=-8 if g_ontrack==. & g_startsekII==-8 & g_dSEKII==-3 & year==`d'    //unobserved (there is a diploma later)
		
		replace g_ontrack=-7 if g_ontrack==. & g_startsekII==-2 & g_dSEKII==-3 & year==`d' 
		}

		label var g_ontrack "ontrack with first SEK II education"
		label def g_ontrack -9 "gap" -8 "unobserved" -7 "unlikely/not defined"  -3 "not yet started" 1 "ontrack" 2 "delay" 3 "change" 5 "diploma ontrack" 6 "diploma with delay" 7 "diploma after change" 8 "diploma after unobserved education" , replace 
		label val g_ontrack g_ontrack
		
	
		
		
* generate marker for weird cases

gen unlikely = .
replace unlikely =1 if pid==1400900049 | pid==1800500027 | pid==1501300058 


order pid year E1 g_startsekII g_ontrack e_year e_prog e_form modified d_type3 e_type3 d_EBA d_EFZ d_FmA d_GM e_duration  d_EFZprog d_ndip  e_prog_simp d_EFZprog_simp source e_type1   cor, first


order pid year e_year e_duration E1 d_ndip e_prog* e_type* , first


* git test





format %40.0g e_prog* d_*prog* e_form e_type*
format %12.0g e_year e_duration E1 D* B1 d_ndip


save  "$output/tmp/LABBlong.dta", replace

}
}


*###################### LEVA - VET contracts ###################################
{

use "$raw/pisalevafinal.dta", clear

rename pisanr pid
rename Ac_date a_date
rename Ac_firmcanton a_cof
rename Ac_contracttype a_ctype
encode Fpi_event, gen(a_event)
rename Ac_id a_cid

format %40.0g  a_ctype
format %15.0f a_cid
tostring a_cid, replace format(%15.0f)
*drop a_cid
*rename a_cid_s a_cid
format %15s a_cid

sort pid a_date

local enddate = ($latestyear - 1959) * 365 + 14

gen year=.
forvalues y = 19174(365)`enddate' 	{
	replace year=year(`y') if a_date>=`y' & a_date<(`y'+365)
	}
gen LVA=a_event==3	
bysort pid year: egen a_LVA=total(LVA), m // Anzahl Lehrvertragsabbrüche pro Jahr

egen tag = tag(pid year a_cid)
bysort pid year: egen a_LVAc=total(tag), m // Anzahl Lehrverträge pro Jahr

gen LVEntry=a_event==2	
bysort pid year: egen a_LVEntry=total(LVEntry), m // Anzahl Eintritte pro Jahr

gen LVNew=a_event==4	
bysort pid year: egen a_LVNew=total(LVNew), m // Anzahl Neuabschlüsse pro Jahr

gen LV_d_pass=a_event==5	
bysort pid year: egen a_LV_d_pass=total(LV_d_pass), m // Anzahl Lehrvertragsabbrüche pro Jahr

gen LV_d_fail=a_event==6	
bysort pid year: egen a_LV_d_fail=total(LV_d_fail), m // Anzahl Lehrvertragsabbrüche pro Jahr


keep pid a_cof year a_LVA a_LVAc a_LVEntry a_LVNew a_LV_d_pass a_LV_d_fail
collapse (first) a_cof a_LVA a_LVAc a_LVEntry a_LVNew a_LV_d_pass a_LV_d_fail, by(pid year)

label val a_cof Ac_firmcanton
label var a_LVA "Anzahl Lehrvertragsabbrüche pro Jahr"
label var a_LVAc "Anzahl Lehrverträge pro Jahr"

label var a_LVEntry "Anzahl Erstlehrverträge pro Jahr"
label var a_LVNew "Anzahl Neuabschlüsse pro Jahr"
label var a_LV_d_pass "Anzahl bestandener Prüfungen pro Jahr"
label var a_LV_d_fail "Anzahl durchgefallener Prüfungen pro Jahr"


save  "$output/tmp/LABBleva.dta", replace
}


*###################### spell - AHV data #######################################

if $loadSpellAHV == 1 {
	
use "$raw/pisaspellfinal.dta", clear

local enddate = ($latestyear - 1960) * 365 + 195
di `enddate'

rename pisanr pid
gen year=.

*format Ds_begdate Ds_enddate %td

*forvalues y = 19175 (365)`enddate' 	{
*	replace year=year(`y') if Ds_begdate>=`y' & Ds_begdate <(`y'+365)
*	}

**** Neu nicht mehr nach Schuljahr, sondern Kalenderjahr!!!!!!!!
replace year = year(Ds_begdate)
	
sort pid year Ds_begdate	
bysort pid year: gen sn=_n

rename Ds_begdate s_begdate
rename Ds_enddate s_enddate
rename Ds_sagts s_sagts

keep year pid sn s_*
reshape wide s_*, i(pid year)j(sn)

unab sa: s_sagts*
unab bd: s_begdate*
unab ed: s_enddate*

for any `sa': 	label var X "Arbeitsmarktsstatus"
for any `sa': 	label val X SAGT3FMT
for any `bd': 	label var X "Beginn AMS"
for any `ed': 	label var X "Ende AMS"
for any `bd': 	format %td X
for any `ed': 	format %td X

save  "$output/tmp/LABBspell.dta", replace
}

*##################### Income - AHV data #######################################

use "$raw/pisaincomefinal.dta", clear

rename pisanr pid
gen year=.

local enddate = ($latestyear - 1960) * 365 + 195

*forvalues y = 19175 (365)`enddate' 	{
*	replace year=year(`y') if ds_begdate>=`y' & ds_begdate <(`y'+365)
*	}

**** Neu nicht mehr nach Schuljahr, sondern Kalenderjahr!!!!!!!!
replace year = year(ds_begdate)
		
sort pid year ds_begdate	
bysort pid year: gen sn=_n

rename ds_begdate si_begdate
rename ds_enddate si_enddate
rename incomeS si_income

keep year pid sn si_*
reshape wide si_*, i(pid year)j(sn)

unab sa: si_income*
unab bd: si_begdate*
unab ed: si_enddate*

for any `sa': 	label var X "Einkommen"
for any `bd': 	label var X "Beginn Einkommen"
for any `ed': 	label var X "Ende Einkommen"
for any `bd': 	format %td X
for any `ed': 	format %td X

merge 1:1 pid year using "$output/tmp/LABBspell.dta", nogen
sort pid year

tsset pid year

forvalues i = 1(1)12 {
    gen si_income`i'_type = .
    forvalues j= 1(1)10 {
	    by pid: replace si_income`i'_type = s_sagts`j' if si_income`i' > 0 & si_income`i' !=. & si_enddate`i' >= s_begdate`j' & si_begdate`i' <= s_enddate`j' & s_sagts`j' <= si_income`i'_type
		by pid: replace si_income`i'_type = f.s_sagts`j' if si_income`i' > 0 & si_income`i' !=. &  si_enddate`i' >= f.s_begdate`j' & si_begdate`i' <= f.s_enddate`j' & s_sagts`j' <= si_income`i'_type
		by pid: replace si_income`i'_type = l.s_sagts`j' if si_income`i' > 0 & si_income`i' !=. &  si_enddate`i' >= l.s_begdate`j' & si_begdate`i' <= l.s_enddate`j' & s_sagts`j' <= si_income`i'_type
		by pid: replace si_income`i'_type = l2.s_sagts`j' if si_income`i' > 0 & si_income`i' !=. &  si_enddate`i' >= l2.s_begdate`j' & si_begdate`i' <= l2.s_enddate`j' & s_sagts`j' <= si_income`i'_type
	}
}

order pid year si_income1 si_income1_type si_begdate1 si_enddate1 s_sagts1 s_begdate1 s_enddate1

*** nur 300-er Einkommen behalten
forvalues i = 1(1)12 {
	gen si_income_work`i' = .
	replace si_income_work`i' = si_income`i' if si_income`i'_type  == 300
	gen si_income_edu`i' = .
	replace si_income_edu`i' = si_income`i' if si_income`i'_type  == 200 | si_income`i'_type  == 100
	}

egen income_work_av = rowmean(si_income_work1 si_income_work2 si_income_work3 si_income_work4 si_income_work5 si_income_work6 si_income_work7 si_income_work8 si_income_work9 si_income_work10 si_income_work11 si_income_work12)
egen income_work_max = rowmax(si_income_work1 si_income_work2 si_income_work3 si_income_work4 si_income_work5 si_income_work6 si_income_work7 si_income_work8 si_income_work9 si_income_work10 si_income_work11 si_income_work12)
egen income_work_min = rowmin(si_income_work1 si_income_work2 si_income_work3 si_income_work4 si_income_work5 si_income_work6 si_income_work7 si_income_work8 si_income_work9 si_income_work10 si_income_work11 si_income_work12)

egen income_edu_av = rowmean(si_income_edu1 si_income_edu2 si_income_edu3 si_income_edu4 si_income_edu5 si_income_edu6 si_income_edu7 si_income_edu8 si_income_edu9 si_income_edu10 si_income_edu11 si_income_edu12)
egen income_edu_max = rowmax(si_income_edu1 si_income_edu2 si_income_edu3 si_income_edu4 si_income_edu5 si_income_edu6 si_income_edu7 si_income_edu8 si_income_edu9 si_income_edu10 si_income_edu11 si_income_edu12)
egen income_edu_min = rowmin(si_income_edu1 si_income_edu2 si_income_edu3 si_income_edu4 si_income_edu5 si_income_edu6 si_income_edu7 si_income_edu8 si_income_edu9 si_income_edu10 si_income_edu11 si_income_edu12)

keep pid year income_work_av income_work_max income_work_min income_edu_av income_edu_max income_edu_min

save  "$output/tmp/Incomespell.dta", replace	
	

*###################### reformat spell - AHV data ##############################
if $loadSpellAHV == 1 {
use "$raw/pisaspellfinal.dta", clear

*global latestyear 2019 // letztes Jahr der Daten
global firstyear 2011 // 

rename Ds_enddate ds_enddate
rename Ds_begdate ds_begdate
rename Ds_sagts ds_sagts
rename pisanr pid

forval i= $firstyear(1)$latestyear {
*    gen working_month_`i' = 0
*	gen neet_reg_month_`i' = 0
*	gen neet_else_month_`i' = 0

	foreach j of numlist 100 200 300 400 500 600 900 {
	    gen lab_stat_`j'_`i' = 0
		replace lab_stat_`j'_`i' = lab_stat_`j'_`i' + round((ds_enddate - ds_begdate) / (365/12),1) if year(ds_begdate) == `i' & year(ds_enddate) == `i' & ds_sagts == `j' // beginnen und enden im Jahr x
		replace lab_stat_`j'_`i' = lab_stat_`j'_`i' + round((mdy(12,31,`i') - ds_begdate) / (365/12),1) if year(ds_begdate) == `i' & year(ds_enddate) > `i' & ds_sagts == `j' // beginnen im Jahr x und enden später
		replace lab_stat_`j'_`i' = lab_stat_`j'_`i' + round((ds_enddate - mdy(01,01,`i')) / (365/12),1) if year(ds_begdate) < `i' & year(ds_enddate) == `i' & ds_sagts == `j' // beginnen früher und enden im Jahr x
		replace lab_stat_`j'_`i' = lab_stat_`j'_`i' + 12 if year(ds_begdate) < `i' & year(ds_enddate) > `i' & ds_sagts == `j' // beginnen früher und enden später	    
		
	}
	
/*	replace working_month_`i' = working_month_`i' + round((ds_enddate - ds_begdate) / (365/12),1) if year(ds_begdate) == `i' & year(ds_enddate) == `i' & ds_sagts == 300 // beginnen und enden im Jahr x
	replace working_month_`i' = working_month_`i' + round((mdy(12,31,`i') - ds_begdate) / (365/12),1) if year(ds_begdate) == `i' & year(ds_enddate) > `i' & ds_sagts == 300 // beginnen im Jahr x und enden später
	replace working_month_`i' = working_month_`i' + round((ds_enddate - mdy(01,01,`i')) / (365/12),1) if year(ds_begdate) < `i' & year(ds_enddate) == `i' & ds_sagts == 300 // beginnen früher und enden im Jahr x
	replace working_month_`i' = working_month_`i' + 12 if year(ds_begdate) < `i' & year(ds_enddate) > `i' & ds_sagts == 300 // beginnen früher und enden später

	replace neet_reg_month_`i' = neet_reg_month_`i' + round((ds_enddate - ds_begdate) / (365/12),1) if year(ds_begdate) == `i' & year(ds_enddate) == `i' & ds_sagts == 400 // beginnen und enden im Jahr x
	replace neet_reg_month_`i' = neet_reg_month_`i' + round((mdy(12,31,`i') - ds_begdate) / (365/12),1) if year(ds_begdate) == `i' & year(ds_enddate) > `i' & ds_sagts == 400  // beginnen im Jahr x und enden später
	replace neet_reg_month_`i' = neet_reg_month_`i' + round((ds_enddate - mdy(01,01,`i')) / (365/12),1) if year(ds_begdate) < `i' & year(ds_enddate) == `i' & ds_sagts == 400 // beginnen früher und enden im Jahr x
	replace neet_reg_month_`i' = neet_reg_month_`i' + 12 if year(ds_begdate) < `i' & year(ds_enddate) > `i' & ds_sagts == 400  // beginnen früher und enden später

	replace neet_else_month_`i' = neet_else_month_`i' + round((ds_enddate - ds_begdate) / (365/12),1) if year(ds_begdate) == `i' & year(ds_enddate) == `i' & ds_sagts == 900 // beginnen und enden im Jahr x
	replace neet_else_month_`i' = neet_else_month_`i' + round((mdy(12,31,`i') - ds_begdate) / (365/12),1) if year(ds_begdate) == `i' & year(ds_enddate) > `i' & ds_sagts == 900  // beginnen im Jahr x und enden später
	replace neet_else_month_`i' = neet_else_month_`i' + round((ds_enddate - mdy(01,01,`i')) / (365/12),1) if year(ds_begdate) < `i' & year(ds_enddate) == `i' & ds_sagts == 900 // beginnen früher und enden im Jahr x
	replace neet_else_month_`i' = neet_else_month_`i' + 12 if year(ds_begdate) < `i' & year(ds_enddate) > `i' & ds_sagts == 900  // beginnen früher und enden später	
*/
	}

collapse (sum) lab_stat_*, by(pid)

reshape long lab_stat_100_ lab_stat_200_ lab_stat_300_ lab_stat_400_ lab_stat_500_ lab_stat_600_ lab_stat_900_, i(pid) j(year)

rename lab_stat_100_ ls_edu
rename lab_stat_200_ ls_edu_work
rename lab_stat_300_ ls_work
rename lab_stat_400_ ls_NEET_reg
rename lab_stat_500_ ls_NEET_IV
rename lab_stat_600_ ls_NEET_EO
rename lab_stat_900_ ls_NEET_unknown

label var ls_edu "Labour status 100: #months in education"
label var ls_edu_work "Labour status 200: #months in education and work"
label var ls_work "Labour status 300: #months in work (erwerbstätig)"
label var ls_NEET_reg "Labour status 400: #months in registered unemployment"
label var ls_NEET_IV "Labour status 500: #months getting IV payments"
label var ls_NEET_EO "Labour status 600: #months getting EO (Erwerbsersatzordung)"
label var ls_NEET_unknown "Labour status 900: #months NEET unknown"

save "$output/tmp/LABBspell_months.dta", replace	
}	

*### merge with long

use "$output/tmp/LABBlong.dta", clear
merge 1:1 pid year using "$output/tmp/LABBleva.dta", keep(master match) nogen
*merge 1:1 pid year using "$output/tmp/LABBspell.dta", keep(master match) nogen

if $loadSpellAHV == 1 {
merge 1:1 pid year using "$output/tmp/LABBspell_months.dta", keep(master match) nogen
}
merge 1:1 pid year using "$output/tmp/Incomespell.dta", keep(master match) nogen

save  "$output/LABB.dta", replace























