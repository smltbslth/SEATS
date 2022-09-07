*########################### Labels FSO Variables ##############################


	*pid
	label var pid "person identifier" 

	*sex 
	label var sex "sex"
	label define sex  1 "male" 2 "female", replace
	
	*pob
	label var pob "country of birth"
	label val pob STATES_AND_TERRITORIESFMT

	*nationality
	label var nationality "nationality"
	label val nationality STATES_AND_TERRITORIESFMT
	
	*firstlanguage
	label var firstlanguage "main language at end of compulsory education"
	run "$pisado/Labels/firstlanguage.do"
	label val firstlanguage firstlanguage

	*cor
	label var cor "Canton of residence"
	label val cor HGDE_KTFMT
	
	
	*mor
	label var mor "Municipality of residence"
	label val mor HGDE_GDEFMT
	
	*rural 
	label var rural "Type of municipality of residence"
	label val rural STALANFMT
	
	*lingreg 
	label var lingreg "Official language in the municipality of residence"
	label val lingreg SPRGEBFMT
	
	*year 
	label var year "year"
	
	*e_prog
	label var e_prog "Detailed education code according to Swiss nomenclature"
	label val e_prog KLASSECHFMT

	
	*e_year
	label var e_year "year of educational program"
	run "$pisado/Labels/e_year.do"
	label val e_year e_year	
	
	*d_success
	label var d_success "Success in certification"
	run "$pisado/Labels/d_success.do"
	label val d_success d_success	
	
	*d_test
	label var d_test "Type of observation"
	label def d_test 1 "Education" 2 "Diploma", replace
	label val d_test d_test
	
	* e_form
	label var e_form "Mode of education/training"
	label val e_form FORMTYPFMT		
	
	*e_field1
	label var e_field1 "Field of education 1 Digit code"
	label val e_field1 BFELD13_1FMT		
	
	*e_field2
	label var e_field2 "Field of education 2 Digit code"
	label val e_field2 BFELD13_2FMT		
	
	*e_field3
	label var e_field3 "Field of education 3 Digit code"
	label val e_field3 BFELD13_3FMT		
	
	*e_shisfield3
	label var e_shisfields3 "Field of study (tertiary education) 3 Digit code"
	label val e_shisfields3 SHISFIELDS3FMT		
	
	*e_levelofstudy
	label var e_levelofstudy "Level of study (tertiary education)"
	label val e_levelofstudy LEVELOFSTUDYFMT
	
	*e_duration
	label var e_duration "duration of the education in years"
	label define e_educLength -50 "Total" -6 "No indication" -5 "Not in module" -4 "Transition not plausible" -3 "Transition not attributable" -2 "Not applicable" -1 "Value not attributable" 1 "1 year"  2 "2 years"  3 "3 years"  4 "4 years" 9 "Variable duration of the training", replace
	label val e_duration e_duration	
		
	*e_type1
	label var e_type1 "Type of education 1 Digit"
	run "$pisado/Labels/e_type1.do"
	label val e_type1 e_type1		
	
	*e_type2
	label var e_type2 "Type of education 2 Digits"
	run "$pisado/Labels/e_type2.do"
	label val e_type2 e_type2		
	
	*e_type3
	label var e_type3 "Type of education 3 Digits"
	label val e_type3 EDUCTYPE3FMT		
	
	*e_moei
	label var e_moei "Municipality of the education institution"
	label val e_moei HGDE_GDEFMT
	
	*e_moei
	label var e_coei "Canton of the education institution"
	label val e_coei HGDE_KTFMT
	
	*e_itype
	label var e_itype "Type of educational institution"
	run "$pisado/Labels/e_itype.do"
	label val e_itype e_itype	
	
	*migration
	label var migration "Migration status"
	label val migration STATMIG1LFMT
	
	*birth
	label var birth "Year of birth"
		
	*e_date
	label var e_date "date of registering education observation"
		
	*e_institution
	label var e_institution "Institute (tertiary education)"
	label val e_institution INSTITUTIONSFMT

	*e_insttype
	label var e_insttype "Type of Institute (higher education)"
	label val e_insttype INSTTYPEFMT
	
	*ageofcharrival
	label var ageofcharrival "Age of arrival in Switzerland"
	
	*source
	label var source "Data source"
	

	
	
	
	
	
