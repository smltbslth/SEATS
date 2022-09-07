*************************************************************************************************
*******************************bezahlte Unterstützung: Variablen generieren ******************************************
************************************************************************************************

*Daten in numeric umwandeln
destring ST200A01, replace
destring ST200A02, replace
destring ST200A03, replace
destring ST200A04, replace
destring ST200A05, replace


*** Korrektur: Wenn nachher doch tatsächlich Hinweis, dass NH genommen, dann z.b. 12211 zu 12212
*Wennn 222222 mache ich  missing

**read Korrektur
tab ST200A01
replace ST200A01 =88888 if ST200A01==11111
replace ST200A01 =22222 if ST200A01==22229
replace ST200A01 =22222 if ST200A01==22228
replace ST200A01 =22222 if ST200A01==22227
replace ST200A01 =22221 if ST200A01==28221
replace ST200A01=12222 if ST200A01==12221
replace ST200A01=22122 if ST200A01==22121
replace ST200A01=22212 if ST200A01==22211
replace ST200A01=12112 if ST200A01==12111
replace ST200A01=21112 if ST200A01==21111
replace ST200A01=21222 if ST200A01==21221 
replace ST200A01 =. if ST200A01==88888
replace ST200A01 =99999 if ST200A01==22222


**Mathe Korrektur
tab ST200A02
replace ST200A02 =88888 if ST200A02==11111
replace ST200A02 =22222 if ST200A02==22229
replace ST200A02 =22222 if ST200A02==22228
replace ST200A02 =22222 if ST200A02==22227
replace ST200A02 =12222 if ST200A02==12221
replace ST200A02 =11222 if ST200A02==11221
replace ST200A02 =12222 if ST200A02==12221
replace ST200A02 =21112 if ST200A02==21111
replace ST200A02=21222 if ST200A02==21221
replace ST200A02=22122 if ST200A02==22121
replace ST200A02=22112 if ST200A02==22111
replace ST200A02=22212 if ST200A02==22211
replace ST200A02=22221 if ST200A02==28221
replace ST200A02=21222 if ST200A02==91999
replace ST200A02 =99999 if ST200A02==22222
replace ST200A02 =99999 if ST200A02==99999


*Fremdsprache Korrektur
tab ST200A03
replace ST200A03=88888 if ST200A03==11111
replace ST200A03=22222 if ST200A03==22229
replace ST200A03=22222 if ST200A03==22228
replace ST200A03=22222 if ST200A03==22227
replace ST200A03=11212 if ST200A03==11211
replace ST200A03=12222 if ST200A03==112221
replace ST200A03=21222 if ST200A03==21221
replace ST200A03=22122 if ST200A03==22121
replace ST200A03=22212 if ST200A03==22211
replace ST200A03=22221 if ST200A03==28221
replace ST200A03=12222 if ST200A03==12221
replace ST200A03 =99999 if ST200A03==22222
replace ST200A03 =99999 if ST200A03==88888

*anderes Fach Korrektur
tab ST200A04
replace ST200A04=88888 if ST200A04==11111
replace ST200A04=22222 if ST200A04==22229
replace ST200A04=22222 if ST200A04==22228
replace ST200A04=22222 if ST200A04==22227
replace ST200A04=12112 if ST200A04==12111
replace ST200A04=12122 if ST200A04==12121
replace ST200A04=12222 if ST200A04==12221
replace ST200A04=21112 if ST200A04==21111
replace ST200A04=21222 if ST200A04==21221
replace ST200A04=22122 if ST200A04==22121
replace ST200A04=22112 if ST200A04==22111
replace ST200A04=99999 if ST200A04==22211
replace ST200A04=22221 if ST200A04==28221 
replace ST200A04 =99999 if ST200A04==22222
replace ST200A04 =99999 if ST200A04==88888



*Lernen Korrektur
tab ST200A05
replace ST200A05=88888 if ST200A05==11111
replace ST200A05=22222 if ST200A05==22229
replace ST200A05=22222 if ST200A05==22228
replace ST200A05=22222 if ST200A05==22227
replace ST200A05=11212 if ST200A05==11211
replace ST200A05=11222 if ST200A05==11221
replace ST200A05=12112 if ST200A05==12111
replace ST200A05=12222 if ST200A05==12221
replace ST200A05=21112 if ST200A05==21111
replace ST200A05=21222 if ST200A05==21221
replace ST200A05=22122 if ST200A05==22121
replace ST200A05=22212 if ST200A05==22211
replace ST200A05=22212 if ST200A05==22219
replace ST200A05=99999 if ST200A05==22222




**** Variablen Nachhilfe

*read
gen bu8_read_reg=0
replace bu8_read_reg=. if ST200A01==88888
replace bu8_read_reg=. if ST200A01==.
replace bu8_read_reg =1 if ST200A01 ==12222|ST200A01 ==21222|ST200A01 ==11222|ST200A01 ==12122 |ST200A01 ==11112|ST200A01 ==12112|ST200A01 ==12212|ST200A01 ==21112|ST200A01 ==21122|ST200A01 ==11122|ST200A01 ==11222|ST200A01 ==21212
gen bu8_read=0
replace bu8_read=. if ST200A01==88888
replace bu8_read=. if ST200A01==.
replace bu8_read=1 if bu8_read_reg==1|ST200A01 ==22112|ST200A01 ==22122|ST200A01 ==22212
tab bu8_read ST200A01, m
tab bu8_read_reg ST200A01
su bu8_read_reg if bu8_read==1

*math
gen bu8_math_reg=0
replace bu8_math_reg=. if ST200A02==88888
replace bu8_math_reg=. if ST200A02==.
replace bu8_math_reg =1 if ST200A02 ==12222|ST200A02 ==21222|ST200A02 ==11222|ST200A02 ==12122 |ST200A02 ==11112|ST200A02 ==12112|ST200A02 ==12212|ST200A02 ==21112|ST200A02 ==21122|ST200A02 ==11122|ST200A02 ==11222|ST200A02 ==21212
gen bu8_math=0
replace bu8_math=. if ST200A02==88888
replace bu8_math=. if ST200A02==.
replace bu8_math=1 if bu8_math_reg==1|ST200A02 ==22112|ST200A02 ==22122|ST200A02 ==22212
tab bu8_math ST200A02, m
tab bu8_math_reg ST200A02

*fremd
gen bu8_fremd_reg=0
replace bu8_fremd_reg=. if ST200A03==88888
replace bu8_fremd_reg=. if ST200A03==.
replace bu8_fremd_reg =1 if ST200A03 ==11212 |ST200A03 ==12222|ST200A03 ==21222|ST200A03 ==11222|ST200A03 ==12122 |ST200A03 ==11112|ST200A03 ==12112|ST200A03 ==12212|ST200A03 ==21112|ST200A03 ==21122|ST200A03 ==11122|ST200A03 ==11222|ST200A03 ==21212
gen bu8_fremd=0
replace bu8_fremd=. if ST200A03==88888
replace bu8_fremd=. if ST200A03==.
replace bu8_fremd=1 if bu8_fremd_reg==1|ST200A03 ==22112|ST200A03 ==22122|ST200A03 ==22212
tab bu8_fremd ST200A03, m
tab bu8_fremd_reg ST200A03

*anderes
gen bu8_anderes_reg=0
replace bu8_anderes_reg=. if ST200A04==88888
replace bu8_anderes_reg=. if ST200A04==.
replace bu8_anderes_reg =1 if ST200A04 ==12222|ST200A04 ==21222|ST200A04 ==11222|ST200A04 ==12122 |ST200A04 ==11112|ST200A04 ==12112|ST200A04 ==12212|ST200A04 ==21112|ST200A04 ==21122|ST200A04 ==11122|ST200A04 ==11222|ST200A04 ==21212
gen bu8_anderes=0
replace bu8_anderes=. if ST200A04==88888
replace bu8_anderes=. if ST200A04==.
replace bu8_anderes=1 if bu8_anderes_reg==1|ST200A04 ==22112|ST200A04 ==22122|ST200A04 ==22212
tab bu8_anderes ST200A04, m
tab bu8_anderes_reg ST200A04

*lern
gen bu8_lern_reg=0
replace bu8_lern_reg=. if ST200A05==88888
replace bu8_lern_reg=. if ST200A05==.
replace bu8_lern_reg =1 if ST200A05 ==12222|ST200A05 ==21222|ST200A05 ==11222|ST200A05 ==12122 |ST200A05 ==11112|ST200A05 ==12112|ST200A05 ==12212|ST200A05 ==21112|ST200A05 ==21122|ST200A05 ==11122|ST200A05 ==11222|ST200A05 ==21212
gen bu8_lern=0
replace bu8_lern=. if ST200A05==88888
replace bu8_lern=. if ST200A05==.
replace bu8_lern=1 if bu8_lern_reg==1|ST200A05 ==22112|ST200A05 ==22122|ST200A05 ==22212
tab bu8_lern ST200A05, m
tab bu8_lern_reg ST200A05


gen bu8=.
replace bu8=0 if bu8_read==0&bu8_math==0&bu8_fremd==0&bu8_anderes==0&bu8_lern==0
replace bu8 =1 if bu8_read ==1|bu8_math==1|bu8_fremd==1|bu8_anderes==1|bu8_lern==1 
tab bu8, m
tab bu8

gen bu8_reg=.
replace bu8_reg=0 if bu8_read_reg==0&bu8_math_reg==0&bu8_fremd_reg==0&bu8_anderes_reg==0&bu8_lern_reg==0
replace bu8_reg =1  if bu8_read_reg ==1|bu8_math_reg==1|bu8_fremd_reg==1|bu8_anderes_reg==1|bu8_lern_reg==1
tab bu8_reg 


************** Nachhilfe 4/5 Klasse

destring ST204A01, replace
destring ST204A02, replace
destring ST204A03, replace
destring ST204A04, replace
destring ST204A05, replace


*** Korrektur: Wenn nachher doch tatsächlich Hinweis, dass NH genommen, dann z.b. 12211 zu 12212

**read Korrektur
tab ST204A01
replace ST204A01 =88888 if ST204A01==11111
replace ST204A01 =22222 if ST204A01==22229
replace ST204A01 =22222 if ST204A01==22228
replace ST204A01 =22222 if ST204A01==22227
replace ST204A01 =22221 if ST204A01==28221
replace ST204A01=12222 if ST204A01==12221
replace ST204A01=22122 if ST204A01==22121
replace ST204A01=22212 if ST204A01==22211
replace ST204A01=12112 if ST204A01==12111
replace ST204A01=21112 if ST204A01==21111
replace ST204A01=11222 if ST204A01==11221
replace ST204A01=12122 if ST204A01==12121 
replace ST204A01=21222 if ST204A01==21221
replace ST204A01 =99999 if ST204A01==88888
replace ST204A01 =99999 if ST204A01==22222


**Mathe Korrektur
tab ST204A02
replace ST204A02 =88888 if ST204A02==11111
replace ST204A02 =22222 if ST204A02==22229
replace ST204A02 =22222 if ST204A02==22228
replace ST204A02 =22222 if ST204A02==22227
replace ST204A02 =12222 if ST204A02==12221
replace ST204A02 =11222 if ST204A02==11221
replace ST204A02 =12222 if ST204A02==12221
replace ST204A02 =21112 if ST204A02==21111
replace ST204A02=21222 if ST204A02==21221
replace ST204A02=22122 if ST204A02==22121
replace ST204A02=22112 if ST204A02==22111
replace ST204A02=22212 if ST204A02==22211
replace ST204A02=22221 if ST204A02==28221
replace ST204A02=11212 if ST204A02==11211
replace ST204A02=21122 if ST204A02==21121 
replace ST204A02=21222 if ST204A02==91999
replace ST204A02 =99999 if ST204A02==22222
replace ST204A02 =99999 if ST204A02==99999

*Fremdsprache Korrektur
tab ST204A03
replace ST204A03=88888 if ST204A03==11111
replace ST204A03=22222 if ST204A03==22229
replace ST204A03=22222 if ST204A03==22228
replace ST204A03=22222 if ST204A03==22227
replace ST204A03=11212 if ST204A03==11211
replace ST204A03=12222 if ST204A03==112221
replace ST204A03=21222 if ST204A03==21221
replace ST204A03=22122 if ST204A03==22121
replace ST204A03=22212 if ST204A03==22211
replace ST204A03=22221 if ST204A03==28221
replace ST204A03=12222 if ST204A03==12221 
replace ST204A03 =99999 if ST204A03==22222
replace ST204A03 =99999 if ST204A03==88888


*anderes Fach Korrektur
tab ST204A04
replace ST204A04=88888 if ST204A04==11111
replace ST204A04=22222 if ST204A04==22229
replace ST204A04=22222 if ST204A04==22228
replace ST204A04=22222 if ST204A04==22227
replace ST204A04=12112 if ST204A04==12111
replace ST204A04=12122 if ST204A04==12121
replace ST204A04=12222 if ST204A04==12221
replace ST204A04=21112 if ST204A04==21111
replace ST204A04=21222 if ST204A04==21221
replace ST204A04=22122 if ST204A04==22121
replace ST204A04=22112 if ST204A04==22111
replace ST204A04=99999 if ST204A04==22211
replace ST204A04=22221 if ST204A04==28221
replace ST204A04=11212 if ST204A04==11211
replace ST204A04=21212 if ST204A04==21211  
replace ST204A04 =99999 if ST204A04==22222
replace ST204A04 =99999 if ST204A04==88888

*Lernen Korrektur
tab ST204A05
replace ST204A05=88888 if ST204A05==11111
replace ST204A05=22222 if ST204A05==22229
replace ST204A05=22222 if ST204A05==22228
replace ST204A05=22222 if ST204A05==22227
replace ST204A05=11212 if ST204A05==11211
replace ST204A05=11222 if ST204A05==11221
replace ST204A05=12112 if ST204A05==12111
replace ST204A05=12222 if ST204A05==12221
replace ST204A05=21112 if ST204A05==21111
replace ST204A05=21222 if ST204A05==21221
replace ST204A05=22122 if ST204A05==22121
replace ST204A05=22212 if ST204A05==22211
replace ST204A05=12122 if ST204A05==12121
replace ST204A05=22212 if ST204A05==22219
replace ST204A05=99999 if ST204A05==22222


**** Variablen Nachhilfe

*read
gen bu5_read_reg=0
replace bu5_read_reg=. if ST204A01==88888
replace bu5_read_reg=. if ST204A01==.
replace bu5_read_reg =1 if ST204A01 ==12222|ST204A01 ==21222|ST204A01 ==11222|ST204A01 ==12122 |ST204A01 ==11112|ST204A01 ==12112|ST204A01 ==12212|ST204A01 ==21112|ST204A01 ==21122|ST204A01 ==11122|ST204A01 ==11222|ST204A01 ==21212
gen bu5_read=0
replace bu5_read=. if ST204A01==88888
replace bu5_read=. if ST204A01==.
replace bu5_read=1 if bu5_read_reg==1|ST204A01 ==22112|ST204A01 ==22122|ST204A01 ==22212
tab bu5_read ST204A01, m
tab bu5_read_reg ST204A01

*math
gen bu5_math_reg=0
replace bu5_math_reg=. if ST204A02==88888
replace bu5_math_reg=. if ST204A02==.
replace bu5_math_reg =1 if ST204A02 ==12222|ST204A02 ==21222|ST204A02 ==11222|ST204A02 ==12122 |ST204A02 ==11112|ST204A02 ==12112|ST204A02 ==12212|ST204A02 ==21112|ST204A02 ==21122|ST204A02 ==11122|ST204A02 ==11222|ST204A02 ==21212
gen bu5_math=0
replace bu5_math=. if ST204A02==88888
replace bu5_math=. if ST204A02==.
replace bu5_math=1 if bu5_math_reg==1|ST204A02 ==22112|ST204A02 ==22122|ST204A02 ==22212
tab bu5_math ST204A02, m
tab bu5_math_reg ST204A02

*fremd
gen bu5_fremd_reg=0
replace bu5_fremd_reg=. if ST204A03==88888
replace bu5_fremd_reg=. if ST204A03==.
replace bu5_fremd_reg =1 if ST204A03 ==11212| ST204A03 ==12222|ST204A03 ==21222|ST204A03 ==11222|ST204A03 ==12122 |ST204A03 ==11112|ST204A03 ==12112|ST204A03 ==12212|ST204A03 ==21112|ST204A03 ==21122|ST204A03 ==11122|ST204A03 ==11222|ST204A03 ==21212
gen bu5_fremd=0
replace bu5_fremd=. if ST204A03==88888
replace bu5_fremd=. if ST204A03==.
replace bu5_fremd=1 if bu5_fremd_reg==1|ST204A03 ==22112|ST204A03 ==22122|ST204A03 ==22212
tab bu5_fremd ST204A03, m
tab bu5_fremd_reg ST204A03

*anderes
gen bu5_anderes_reg=0
replace bu5_anderes_reg=. if ST204A04==88888
replace bu5_anderes_reg=. if ST204A04==.
replace bu5_anderes_reg =1 if ST204A04 ==11212 |ST204A04 ==12222|ST204A04 ==21222|ST204A04 ==11222|ST204A04 ==12122 |ST204A04 ==11112|ST204A04 ==12112|ST204A04 ==12212|ST204A04 ==21112|ST204A04 ==21122|ST204A04 ==11122|ST204A04 ==11222|ST204A04 ==21212
gen bu5_anderes=0
replace bu5_anderes=. if ST204A04==88888
replace bu5_anderes=. if ST204A04==.
replace bu5_anderes=1 if bu5_anderes_reg==1|ST204A04 ==22112|ST204A04 ==22122|ST204A04 ==22212
tab bu5_anderes ST204A04, m
tab bu5_anderes_reg ST204A04

*lern
gen bu5_lern_reg=0
replace bu5_lern_reg=. if ST204A05==88888
replace bu5_lern_reg=. if ST204A05==.
replace bu5_lern_reg =1 if ST204A05 ==12222|ST204A05 ==21222|ST204A05 ==11222|ST204A05 ==12122 |ST204A05 ==11112|ST204A05 ==12112|ST204A05 ==12212|ST204A05 ==21112|ST204A05 ==21122|ST204A05 ==11122|ST204A05 ==11222|ST204A05 ==21212
gen bu5_lern=0
replace bu5_lern=. if ST204A05==88888
replace bu5_lern=. if ST204A05==.
replace bu5_lern=1 if bu5_lern_reg==1|ST204A05 ==22112|ST204A05 ==22122|ST204A05 ==22212
tab bu5_lern ST204A05, m
tab bu5_lern_reg ST204A05


gen bu5=.
replace bu5=0 if bu5_read==0&bu5_math==0&bu5_fremd==0&bu5_anderes==0&bu5_lern==0
replace bu5 =1 if bu5_read ==1|bu5_math==1|bu5_fremd==1|bu5_anderes==1|bu5_lern==1 
tab bu5 
tab bu5 , m
tab bu5  if bu8==1

gen bu5_reg=.
replace bu5_reg=0 if bu5_read_reg==0&bu5_math_reg==0&bu5_fremd_reg==0&bu5_anderes_reg==0&bu5_lern_reg==0
replace bu5_reg =1  if bu5_read_reg ==1|bu5_math_reg==1|bu5_fremd_reg==1|bu5_anderes_reg==1|bu5_lern_reg==1
tab bu5_reg 



****************** Gruende fuer Nachhilfe

gen a = substr(ST202A01 , 1, 1)
gen b = substr(ST202A01 , 2, 1)
gen c = substr(ST202A01 , 3, 1)
gen d = substr(ST202A01 , 4, 1)
gen e = substr(ST202A01 , 5, 1)
gen f = substr(ST202A01 , 6, 1)

for any a b c d e f: destring X, replace
for any a b c d e f: gen t_reason_X = X==1

label var t_reason_a "tutoring: better chances"
label var t_reason_b "tutoring: for test"
label var t_reason_c "tutoring: better grades"
label var t_reason_d "tutoring: catch up"
label var t_reason_e "tutoring: better understanding"
label var t_reason_f "tutoring: other"

drop a b c d e f


****************** Empfehlung fuer Nachhilfe

gen ad_a = substr(ST201A01 , 1, 1)
gen ad_b = substr(ST201A01 , 2, 1)
gen ad_c = substr(ST201A01 , 3, 1)
gen ad_d = substr(ST201A01 , 4, 1)
gen ad_e = substr(ST201A01 , 5, 1)
gen ad_f = substr(ST201A01 , 6, 1)

for any ad_a ad_b ad_c ad_d ad_e ad_f: destring X, replace
for any a b c d e f: gen t_advice_X = ad_X==1

label var t_advice_a "tutoring suggested by teacher: "
label var t_advice_b "tutoring suggested by parents"
label var t_advice_c "tutoring suggested by family"
label var t_advice_d "tutoring suggested by peers"
label var t_advice_e "tutoring suggested by myself"
label var t_advice_f "tutoring suggested by other"

drop ad_a ad_b ad_c ad_d ad_e ad_f


****************** Durchfuehrung Nachhilfe

gen ex_a = substr(ST203A01 , 1, 1)
gen ex_b = substr(ST203A01 , 2, 1)
gen ex_c = substr(ST203A01 , 3, 1)
gen ex_d = substr(ST203A01 , 4, 1)
gen ex_e = substr(ST203A01 , 5, 1)
gen ex_f = substr(ST203A01 , 6, 1)
gen ex_g = substr(ST203A01 , 7, 1)
gen ex_h = substr(ST203A01 , 8, 1)

for any ex_a ex_b ex_c ex_d ex_e ex_f ex_g ex_h: destring X, replace
for any a b c d e f g h: gen t_execution_X = ex_X==1

label var t_execution_a "tutoring given by student: "
label var t_execution_b "tutoring given by friend of family"
label var t_execution_c "tutoring given by teacher from different school"
label var t_execution_d "tutoring given by professional tutor"
label var t_execution_e "tutoring given by online tutor"
label var t_execution_f "tutoring given by block-course (intensive)"
label var t_execution_g "tutoring given by retired teacher"
label var t_execution_h "tutoring given by other"

drop ex_a ex_b ex_c ex_d ex_e ex_f ex_g ex_h


for any bu8_read_reg bu8_read bu8_math_reg bu8_math bu8_fremd_reg bu8_fremd bu8_anderes_reg bu8_anderes bu8_lern_reg bu8_lern bu8 bu8_reg bu5_read_reg bu5_read bu5_math_reg bu5_math bu5_fremd_reg bu5_fremd bu5_anderes_reg bu5_anderes bu5_lern_reg bu5_lern bu5 bu5_reg: rename X t_X

