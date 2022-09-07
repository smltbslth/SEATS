*########### pisa clean ##################
	*dependent dofile (called from SEATS_w5.do)
*	global pisadata  "$path_nc/SEATS/Data/pisa"

* set label language
	global lanp $lan  // de en

*** generate main file, rename and construct variables

	use "$pisadata/pisa2012.dta", clear
	destring schoolid, replace
	merge 1:1 StIDStrt StIDSch StIDStd schoolid using "$pisadata/nachhilfe_pisa.dta", keepusing(ST2*) keep(master match) nogen

* personal info	
{
	*destring fullid, replace
	egen pid = concat(StIDStrt StIDSch StIDStd ) 
		destring pid, replace
	rename kanton region
		numlabel KANTON , add
		
	gen female = ST04Q01==1
	destring  ST03Q02 ST03Q01, replace
	rename  ST03Q02 birth
	rename ST03Q01 birthmonth
	rename TestLANG language
		destring language, replace
		recode language(148=1)(200=2)(493=3)
	gen german = language==1
		
	global person fullid pid region female birth birthmonth language german StIDStrt StIDSch StIDStd
}


* background
{
	gen lw_mother = ST11Q01==1
	gen lw_father = ST11Q02==1
	gen lw_brothers = ST11Q03==1
	gen lw_sisters = ST11Q04==1
	gen lw_siblings = ST11Q03==1 | ST11Q04==1
	gen singleparent= famstruc==1 if famstruc!=.	
	gen m_edu = 5 - ST13Q01
		replace m_edu = 5 if ST14Q04 == 1
		replace m_edu = 6 if ST14Q03 == 1
		replace m_edu = 7 if ST14Q02 == 1
		replace m_edu = 8 if ST14Q01 == 1
	rename ST15Q01 m_employment	
		gen f_edu = 5 - ST17Q01
		replace f_edu = 5 if ST18Q04 == 1
		replace f_edu = 6 if ST18Q03 == 1
		replace f_edu = 7 if ST18Q02 == 1
		replace f_edu = 8 if ST18Q01 == 1
		
	foreach p in m f {
		gen `p'yedu = 6 if `p'_edu==1
		replace `p'yedu = 9 if `p'_edu==2
		replace `p'yedu = 12.5 if `p'_edu==3
		replace `p'yedu = 12.5 if `p'_edu==4
		replace `p'yedu = 12.5 if `p'_edu==5
		replace `p'yedu = 15 if `p'_edu==6
		replace `p'yedu = 17 if `p'_edu==7
		replace `p'yedu = 21 if `p'_edu==8
		}
	gen pedu_tertiary= myedu>14 & myedu < 30
		replace pedu_tertiary=1 if fyedu>14  & fyedu < 30
		
	rename ST19Q01 f_employment		
	
	gen mig_no = immig==1  if immig!=.
	gen mig_yes = immig>1 if immig!=.
		gen mig_yesnp = mig_yes==1
		gen nomiginfo = mig_yes==.
	gen mig_2gen = immig==2 if immig!=.
	gen mig_1gen = immig==3 if immig!=.
	gen mig_age = ST21Q01 
		replace mig_age=0 if mig_age==.
	gen bornCH = ST20Q01 ==1	if ST20Q01!=.
	gen m_bornCH = ST20Q02	==1	if ST20Q02!=.
	gen f_bornCH = ST20Q03	==1	if ST20Q03!=.
	
	
	
	
	
	rename COBN_S nat_PISA	
	rename COBN_M m_nat
	rename COBN_F f_nat
	destring m_nat f_nat nat_PISA, replace
	
	destring langn, gen(homelang)
	replace homelang =. if homelang >996
	
	gen hsl = 1 if language ==1 & homelang ==1
		replace hsl = 1 if language ==1 & homelang ==648
		replace hsl = 1 if language ==1 & homelang ==649
		replace hsl = 1 if language ==2 & homelang ==200
		replace hsl = 1 if language ==2 & homelang ==604
		replace hsl = 1 if language ==3 & homelang ==493
		replace hsl = 0 if hsl==. & homelang !=.
	gen nohsl = homelang==.
	gen hslnp = hsl==1
	gen hslrnp = hsl==0
		
	rename ST28Q01 nbooks 

	
		
	global background lw_*	m_edu m_employment f_edu myedu fyedu pedu_tertiary f_employment ///
	mig_no mig_yes mig_2gen mig_1gen mig_age bornCH m_bornCH f_bornCH nat_PISA m_nat f_nat ///
	 pared hsl nohsl hslnp hslrnp homelang nbooks singleparent hisei mig_yesnp nomiginfo homepos
	*bornCH 	m_bornCH f_bornCH ageatarrival migration dirmigration indirmigration
}

* achievments
{
	rename PV1MATH score_math1 
	rename PV2MATH score_math2 
	rename PV3MATH score_math3 
	rename PV4MATH score_math4 
	rename PV5MATH score_math5 
	egen score_avmath = rowmean(score_math?)
	egen mathscore_std = std(score_avmath)
	
	rename PV1READ score_read1
	rename PV2READ score_read2
	rename PV3READ score_read3
	rename PV4READ score_read4
	rename PV5READ score_read5
	egen score_avread = rowmean(score_read?)
	egen readingscore_std = std(score_avread)
	
	rename PV1SCIE score_science1
	rename PV2SCIE score_science2
	rename PV3SCIE score_science3
	rename PV4SCIE score_science4
	rename PV5SCIE score_science5
	egen score_avscience = rowmean(score_science?)
	egen sciencescore_std = std(score_avscience)
	
	gen mathlevel_det = 1 if score_avmath!=.
		replace mathlevel_det = 2 if score_avmath >= 420.1
		replace mathlevel_det = 3 if score_avmath >= 482.4
		replace mathlevel_det = 4 if score_avmath >= 544.7
		replace mathlevel_det = 5 if score_avmath >= 607
		replace mathlevel_det = 6 if score_avmath >= 669.3
	
	
	gen readinglevel_det = 1 if score_avread!=.
		replace readinglevel_det = 2 if score_avread >= 407
		replace readinglevel_det = 3 if score_avread >= 480	
		replace readinglevel_det = 4 if score_avread >= 553	
		replace readinglevel_det = 5 if score_avread >= 626	
		replace readinglevel_det = 6 if score_avread >= 698		
		
		
	gen mathlevel = 1 if score_avmath!=.
		replace mathlevel = 2 if score_avmath >= 482.4
		replace mathlevel = 3 if score_avmath >= 607	
	
	gen readinglevel = 1 if score_avread!=.
		replace readinglevel = 2 if score_avread >= 480
		replace readinglevel = 3 if score_avread >= 626
		
	gen sciencelevel = 1 if score_avscience!=.
		replace sciencelevel = 2 if score_avscience >= 484.1
		replace sciencelevel = 3 if score_avscience >= 633.3	
		
	gen bacc_skill = 1 if score_avread >=553 & score_avscience>= 558.7 & score_avmath>=544.7
		replace bacc_skill =0 if bacc_skill!=1	
	gen bacc_unskill = 1 if score_avread <553 & score_avscience< 558.7 & score_avmath<544.7
		replace bacc_unskill =0 if bacc_unskill!=1
	
	global achievments score_math? score_read? score_science? score_av* mathscore_std /// 
		readingscore_std sciencescore_std mathlevel readinglevel sciencelevel ///
		 bacc_skill bacc_unskill mathlevel_det readinglevel_det
}



* personality
{
	for any ST93Q04 ST93Q06 ST93Q07: replace X = 6-X
	egen perseverance_av = rowmean(ST93Q01 ST93Q03 ST93Q04 ST93Q06 ST93Q07)
		for any ST93Q01 ST93Q03 ST93Q04 ST93Q06 ST93Q07: replace perseverance_av =. if X==.
	pca ST93Q01 ST93Q03 ST93Q04 ST93Q06 ST93Q07
		predict perseverance_pca
		for any ST94Q05 ST94Q06 ST94Q09 ST94Q10 ST94Q14: replace X = 6-X
	egen openness_av = rowmean(ST94Q05 ST94Q06 ST94Q09 ST94Q10 ST94Q14)
		for any ST94Q05 ST94Q06 ST94Q09 ST94Q10 ST94Q14: replace openness_av =. if X==.
	pca ST94Q05 ST94Q06 ST94Q09 ST94Q10 ST94Q14
		predict openness_pca	
		
	global personality perseverance_av perseverance_pca persev openps openness_av openness_pca ///
	ST87Q01 ST87Q02 ST87Q03 ST87Q04 ST87Q05 ST87Q06 ST87Q07 ST87Q08 ST87Q09 ///
	ST88Q01 ST88Q02 ST88Q03 ST88Q04
}


* math
{

	egen math_interest_av = rowmean(ST29Q01 ST29Q03 ST29Q04 ST29Q06)
		replace math_interest_av = 5 - math_interest_av
		for any ST29Q01 ST29Q03 ST29Q04 ST29Q06	: replace math_interest_av =. if X==.
	pca ST29Q01 ST29Q03 ST29Q04 ST29Q06	
		predict math_interest_pca
		replace math_interest_pca = math_interest_pca * (-1)
	egen math_useful_av = rowmean(ST29Q02 ST29Q05 ST29Q07 ST29Q08)
		replace math_useful_av = 5 - math_useful_av
		for any ST29Q02 ST29Q05 ST29Q07 ST29Q08	: replace math_useful_av =. if X==.
	pca ST29Q02 ST29Q05 ST29Q07 ST29Q08
		predict math_useful_pca
		replace math_useful_pca = math_useful_pca * (-1)
	egen math_peers_av = rowmean(ST35Q01 ST35Q02 ST35Q03 ST35Q04 ST35Q05 ST35Q06)
		replace math_peers_av=5-math_peers_av
		for any ST35Q01 ST35Q02 ST35Q03 ST35Q04 ST35Q05 ST35Q06	: replace math_peers_av =. if X==.
	pca ST35Q01 ST35Q02 ST35Q03 ST35Q04 ST35Q05 ST35Q06
		predict math_peers_pca
		replace math_peers_pca = math_peers_pca * (-1)
	egen math_solve_av = rowmean(ST37Q01 ST37Q02 ST37Q03 ST37Q04 ST37Q05 ST37Q06 ST37Q07 ST37Q08)
		replace math_solve_av=5-math_solve_av
		for any ST37Q01 ST37Q02 ST37Q03 ST37Q04 ST37Q05 ST37Q06 ST37Q07 ST37Q08	: replace math_solve_av =. if X==.
	pca ST37Q01 ST37Q02 ST37Q03 ST37Q04 ST37Q05 ST37Q06 ST37Q07 ST37Q08
		predict math_solve_pca
		replace math_solve_pca = math_solve_pca * (-1)
	for any ST42Q04 ST42Q06 ST42Q07 ST42Q09: replace X = 5-X
	egen math_good_av = rowmean(ST42Q02 ST42Q04 ST42Q06 ST42Q07 ST42Q09)
		for any ST42Q02 ST42Q04 ST42Q06 ST42Q07 ST42Q09	: replace math_good_av =. if X==.
	pca ST42Q02 ST42Q04 ST42Q06 ST42Q07 ST42Q09
		predict math_good_pca
	egen math_anxiety_av = rowmean(ST42Q01 ST42Q03 ST42Q05 ST42Q08 ST42Q10)
		replace math_anxiety_av=5-math_anxiety_av
		for any ST42Q01 ST42Q03 ST42Q05 ST42Q08 ST42Q10	: replace math_anxiety_av =. if X==.
	pca ST42Q01 ST42Q03 ST42Q05 ST42Q08 ST42Q10
		predict math_anxiety_pca
		replace math_anxiety_pca = math_anxiety_pca * (-1)
	for any ST43Q01 ST43Q02 ST43Q05: replace X = 5-X
	egen math_control_av = rowmean(ST43Q01 ST43Q02 ST43Q03 ST43Q04 ST43Q05 ST43Q06)
		for any ST43Q01 ST43Q02 ST43Q03 ST43Q04 ST43Q05 ST43Q06: replace math_control_av =. if X==.
	pca ST43Q01 ST43Q02 ST43Q03 ST43Q04 ST43Q05 ST43Q06
		predict math_control_pca
	egen math_effort_av = rowmean(ST46Q01 ST46Q02 ST46Q03 ST46Q04 ST46Q05 ST46Q06 ST46Q07 ST46Q08 ST46Q09)
		replace math_effort_av=5-math_effort_av
		for any ST46Q01 ST46Q02 ST46Q03 ST46Q04 ST46Q05 ST46Q06 ST46Q07 ST46Q08 ST46Q09	: replace math_effort_av =. if X==.
	pca ST46Q01 ST46Q02 ST46Q03 ST46Q04 ST46Q05 ST46Q06 ST46Q07 ST46Q08 ST46Q09
		predict math_effort_pca
		replace math_effort_pca = math_effort_pca * (-1)
	
	
global math math_interest_av math_interest_pca math_useful_av math_useful_pca ///
	math_peers_av math_peers_pca math_solve_av math_solve_pca ///
	math_good_av math_good_pca math_anxiety_av math_anxiety_pca ///
	math_control_av math_control_pca math_effort_av math_effort_pca
}



* school
{
		for any ST88Q03 ST88Q04 ST89Q02 ST89Q03 ST89Q04 ST89Q05 : replace X = 5-X
	egen school_attitude_av = rowmean(ST88Q01 ST88Q02 ST88Q03 ST88Q04 ST89Q02 ST89Q03 ST89Q04 ST89Q05)
		for any ST88Q01 ST88Q02 ST88Q03 ST88Q04 ST89Q02 ST89Q03 ST89Q04 ST89Q05	: replace school_attitude_av =. if X==.
	pca ST88Q01 ST88Q02 ST88Q03 ST88Q04 ST89Q02 ST89Q03 ST89Q04 ST89Q05
		predict school_attitude_pca
		replace school_attitude_pca = school_attitude_pca 
		for any ST91Q01 ST91Q02 ST91Q05: replace X = 5-X
	egen school_control_av = rowmean(ST91Q01 ST91Q02 ST91Q03 ST91Q04 ST91Q05 ST91Q06)
		for any ST91Q01 ST91Q02 ST91Q03 ST91Q04 ST91Q05 ST91Q06: replace school_control_av =. if X==.
	pca ST91Q01 ST91Q02 ST91Q03 ST91Q04 ST91Q05 ST91Q06
		predict school_control_pca
		
		
global school school_attitude_av school_attitude_pca school_control_av ///
	school_control_pca	
	
}

* truancy
	rename ST08Q01 school_late
		gen school_lateI = school_late!=1 if school_late!=.
	rename ST09Q01 school_skipday
		gen school_skipdayI = school_skipday!=1 if school_skipday!=.
	rename ST115Q01 school_skiplesson
		gen school_skiplessonI = school_skiplesson!=1 if school_skiplesson!=.
	gen punctuality = 1-school_lateI	

	global truancy school_late* school_skip* punctuality
 
* future
{

		destring ST205A01, replace
	rename ST205A01 plans
	replace plans=. if plans>20
	gen plan_work = plans==	12
	gen plan_ORST= plans==1
	gen plan_interim=plans==2 | plans==3 | plans==1
	gen plan_voc=plans==5 | plans==6  | plans==4 | plans==7 | plans==8
	gen plan_gymnasium=plans==10
	gen plan_otherschool= plans==9
	gen plan_otheredu= plans==12 | plans==13
	gen plan_NA = plans==14
	unab plans: plan_*
	for any `plan': replace X=. if plans==.
	gen planfd = 1 if plans==10 | plans==9
		replace planfd = 2 if plans==5 | plans==6  | plans==4 | plans==7 | plans==8
		replace planfd = 3 if plans==1
		replace planfd = 4 if plans==2 
		replace planfd = 5 if plans==3 | plans == 12 | plans == 13
	gen plan_directstart = plan_gymnasium ==1  | plan_otherschool ==1 | plan_voc ==1 if plans!=.
	gen plan_GE = plan_gymnasium ==1  | plan_otherschool ==1 if plan_directstart==1
	rename ST205A02 plan_occupation
	
		
	global future plans planfd plan_occupation plan_* 
}
 
* homework (for Bildungsbericht)
	global homework ST200A01 ST200A02 ST200A03 ST200A04 ST200A05 ST201A01 ST201A02 ST202A01 ST202A02 ST203A01 ST203A02 ST204A01 ST204A02 ST204A03 ST204A04 ST204A05

* opportunity to learn (curriculum)
	rename ST76Q02 OTL_appliedT
	rename ST76Q01 OTL_appliedL
	rename ST75Q02 OTL_pureT
	rename ST75Q01 OTL_pureL
	rename ST74Q02 OTL_proceduralT
	rename ST74Q01 OTL_proceduralL
	rename ST73Q02 OTL_algebraT
	rename ST73Q01 OTL_algebraL
	
	global OTL OTL_*
	
* ever repeated	
	gen rep_primary = ST07Q01==2 | ST07Q01==3
	gen rep_sek1 = ST07Q02==2 | ST07Q02==3
	gen rep_sek2 = ST07Q03==2 | ST07Q03==3
	
	gen rep_primary_cont = ST07Q01 
	gen rep_sek1_cont = ST07Q02 
	gen rep_sek2_cont = ST07Q03 
	
	global rep  rep_primary rep_sek1 rep_sek2 rep_primary_cont rep_sek1_cont rep_sek2_cont
	 
	
	
* booklet info
	gen sci_test = Bookid== 1 | Bookid== 2 | Bookid== 3 | Bookid== 5 | Bookid== 7 | Bookid== 8 | Bookid== 10 | Bookid==12 | Bookid== 13
	gen read_test = Bookid== 2 | Bookid== 3 | Bookid== 4 | Bookid== 6 | Bookid==8 | Bookid==9 | Bookid==11 | Bookid==12 | Bookid==13



* pisa school (1 if gymnasium)
	gen pisabs =1 if cellidne == 101 | cellidne == 301 | cellidne == 501 | cellidne == 701 /// 
	| cellidne == 805 | cellidne == 1101 | cellidne == 1701 | cellidne == 2001 | cellidne == 10201 /// 
	  | cellidne == 11806  | cellidne == 12301 | cellidne == 1022001 | cellidne == 1023001 /// 
	   | cellidne == 1024001
	replace pisabs=0 if pisabs==. & cellidne!=.   



* merging track information (imported from excel sheet)	
	merge m:1 cellidne using "$pisadata/tracks_for_pisa.dta", nogen
	
	
 keep $person $background $achievments $personality $math $school $future $truancy $OTL ///
  W_FSTUWT senwgt_STU schoolid escs $homework $rep read_test sci_test pisabs cellidne natprog track
  
  

 order fullid, first
 
 
* mark representative observations


/* 

 Sämtliche Kantone
der französischsprachigen Schweiz, der Kanton Tessin
sowie die Deutschschweizer Kantone Aargau, Bern
(deutschsprachiger Teil), St.Gallen, Solothurn und Wallis
(deutschsprachiger Teil) nutzten PISA 2012 für kantonale
Zusatzstichproben.
 
 */

	gen repr=region==2 | region==10 | region==11 | region==17 | region==19 | region==21 | region==22 | region==23 | region==24 | region==25
		label var repr "sampled in one of the representative regions" 
		replace repr=0 if region==10 & language==1

	gen repregion=region if repr==1
	replace repregion=2001 if region==2 & language==1
	replace repregion=2003 if region==2 & language==3
	replace repregion=2301 if region==23 & language==1
	replace repregion=2303 if region==23 & language==3

	label define KANTON 2001 "be (de)", add
	label define KANTON 2003 "be (fr)", add
	label define KANTON 2301 "vs (de)", add
	label define KANTON 2303 "vs (fr)", add

	label val repregion KANTON
	label var repregion "kanton (representative sample)"

 
run 	"$pisado/Labels/pisa_label_$lanp.do"
 
save "$output/pisa.dta", replace

	

