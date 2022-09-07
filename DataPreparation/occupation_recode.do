******************************************************************************************************************************************
* Recodierung vocation von Kaspar Knecht, ergaenzte Version
* Ausgangslage vocation

/*labelbook e_prog_det*/

gen e_prog_simp=e_prog

* Zusammenfassen gleicher Berufe
** Recodierung Basis Do-File MZ --> Excel Spalte H (17 Lehrberufe angepasst)
replace e_prog_simp=	161100	 if e_prog==	161000 /* 161100 Bäcker/in-Konditor/in-Confiseur; 161000 Bäcker/in-Konditor/in*/ 
replace e_prog_simp=	165950	 if e_prog==	165900 /* 165950 Milchtechnologe/-technologin EFZ; 165900 Milchtechnologe/-technologin*/
replace e_prog_simp=	166600	 if e_prog==	166500 /* 166600 Müller/in EFZ; 166500 Müller/in */
replace e_prog_simp=	271400	 if e_prog==	271500 /* 271400 Automatiker/in EFZ; 271500 Automatiker/in */
replace e_prog_simp=	277300	 if e_prog==	277000 /* 277300 Elektoriker/in EFZ; 277000 Elektroniker/in */
replace e_prog_simp=	291450	 if e_prog==	291400 /* 291450 Mediamatiker/in EFZ; 291400 Mediamatiker/in */
*replace e_prog_simp=	332000	 if e_prog==	332500 /* 332000 Gipser; 332500 Gipser/in und Maler/in */
replace e_prog_simp=	335100	 if e_prog==	335000 /* 335100 Maurer/in EFZ; 335000 Maurer/in */
replace e_prog_simp=	374000	 if e_prog==	361000 /* 374000 Zeichner/in EFZ; 361000 Bauzeichner */
replace e_prog_simp=	384350	 if e_prog==	384300 /* 384350 Kaufmann/-frau EFZ E; 384300 Kaufmann/-frau E */
replace e_prog_simp=	384450	 if e_prog==	384400 /* 384450 Kaufmann/-frau EFZ B; 384400 Kaufmann/-frau B */
replace e_prog_simp=	390900	 if e_prog==	390800 /* 390900 Detailhandelsfachmann/-frau EFZ; 390800 Detailhandelsfachmann/-frau EFZ */
replace e_prog_simp=	390900	 if e_prog==	390700 /* 390900 Detailhandelsfachmann/-frau EFZ; 390700 Detailhandelsfachmann/-frau EFZ */
replace e_prog_simp=	430550	 if e_prog==	430500 /* 430550 Kaminfeger/in EFZ; 430500 Kaminfeger/in */
replace e_prog_simp=	462100	 if e_prog==	462000 /* 462100 Dentalassistent/in EFZ; 462000 Dentalassistent/in*/
replace e_prog_simp=	462800	 if e_prog==	462700 /* 462800 Fachmann/-frau Gesundheit EFZ; 462700 Fachangestellte/r Gesundheit*/
replace e_prog_simp=	467600	 if e_prog==	467500 /* 467600 Medizinische/r Praxisassistent/in EFZ; 467500 Medizinische/r Praxisassistent/in*/

** Recoding manuell Liste SDBB (mit Anforderungsprofil) --> Excel Spalte J (17 Lehrberufe angepasst)
*bysort anf_tot: table vocation, c(mean anf_math mean anf_language mean voc_type mean voc_form)
replace e_prog_simp=	130800	 if e_prog==	131100 /* 130800 Gärtner/in EFZ; 131100 Gärtner/in */
replace e_prog_simp=	270550	 if e_prog==	270500 /* 270550 Anlagen- und Apparatebauer EFZ; 270500 Anlagen und Apparatebauer */
replace e_prog_simp=	288600	 if e_prog==	288500 /* 288600 Landmaschinenmechaniker/in EFZ; 288500 Landmaschinenmechaniker/in */
replace e_prog_simp=	294100	 if e_prog==	294000 /* 294100 Motorradmechaniker/in EFZ; 294000 Motorradmechaniker/in */
replace e_prog_simp=	311510	 if e_prog==	311500 /* 311510 Mikromechaniker/in EFZ; 311500 Mikromechaniker/in */
replace e_prog_simp=	336600	 if e_prog==	336500 /* 336600 Plattenleger/in EFZ; 336500 Plattenleger/in */
replace e_prog_simp=	365350	 if e_prog==	365200 /* 365350 Konstrukteur/in EFZ; 365200 Konstrukteur/in */
replace e_prog_simp=	373600	 if e_prog==	373500 /* 373600 Geomatiker/in EFZ; 373500 Geomatiker/in */
replace e_prog_simp=	391100	 if e_prog==	391000 /* 391100 Drogist/in EFZ; 391000 Drogist/in */
replace e_prog_simp=	461100	 if e_prog==	461000 /* 461100 Augenoptiker/in EFZ; 461000 Augenoptiker/in */
replace e_prog_simp=	161100	 if e_prog==	164000 /* 161100 Bäcker/in-Konditor/in-Confiseur; 164000 Konditor/in-Confiseur/-euse */
replace e_prog_simp=	278700	 if e_prog==	278800 /* 278700 Fahrradmechaniker/in EFZ; 278800 Kleinmotorrad- und Fahrradmechniker/in */
replace e_prog_simp=	291200	 if e_prog==	291100 /* 291200 Produktionsmechaniker/in EFZ; 291100 Mechapraktiker/in */
replace e_prog_simp=	295080	 if e_prog==	283400 /* 295080 Polymechaniker/in EFZ; 283400 Grundausbildung Metallberufe */
replace e_prog_simp=	297400	 if e_prog==	297300 /* 297400 Seilbahn-Mechatroniker/in EFZ; 297300 Seilbahner/in EFZ */
replace e_prog_simp= 	297600   if e_prog==  298000 /* 297600 Spengler/in EFZ; Spengler/in-Sanitärinstallateur/in */
replace e_prog_simp=	362100	 if e_prog==	362500 /* 362100 Laborant/in EFZ; 362500 Chemielaborant/in */

** Recoding manuell Liste SDBB(ohne Anforderungsprofil); --> Excel Spalte J (9 Lehrberufe angepasst)
*table vocation if anf_tot==. 
replace e_prog_simp=	281600	 if e_prog==	281500 /* 281600 Oberflächenbeschichter/in EFZ; 281500 Galvaniker/in */
replace e_prog_simp=	331200	 if e_prog==	331000 /* 331200 Bodern-Parkettleger/in EFZ; 331000 Bodenleger/in */
replace e_prog_simp=	374000	 if e_prog==	364000 /* 374000 Zeichner/in EFZ; 364000 Hochbauzeichner/in */
replace e_prog_simp=	374000	 if e_prog==	366000 /* 374000 Zeichner/in EFZ; 366000 Landschaftsbauzeichner/in */
replace e_prog_simp=	374000	 if e_prog==	370500 /* 374000 Zeichner/in EFZ; 370500 Raumplanungszeichner/in */
replace e_prog_simp=	383000	 if e_prog==	383100 /* 383000 Handelsmittelschuldiplomand/in; 383100 Handelsmittelschuldiplomand/in P */
replace e_prog_simp=	405000	 if e_prog==	403000 /* 405000 Strassentransportfachmann/-frau EFZ; 403000 Lastwagenführer/in */
replace e_prog_simp=	482100	 if e_prog==	482000 /* 482100 Gestalter/in Werbetechnik EFZ; 482000 Gestalter/in/Designer/in */
replace e_prog_simp=	484800	 if e_prog==	480500 /* 484800 Polydesigner/in 3D EFZ; 480500 Dekorationsgestalter/in */

* Ausgangslage vocation nach Recodierung & Kontrolle Recodierung
*codebook vocation /* 134 Lehrberufe verbleiben*/

* Allgemeinbildung
replace e_prog_simp=	3180	 if e_prog>=3158 & e_prog<=3180 				// alle MAR (Gymnasium) Spezialisierungen
replace e_prog_simp=	3520	 if (e_prog>=3520 & e_prog<=3527) |  (e_prog>=103221 & e_prog<= 103275)		// alle Fachmittelschule Spezialisierungen
replace e_prog_simp=	3532	 if e_prog>=3532 & e_prog<=3537   |  (e_prog>=103311 & e_prog<=103365)		// alle Fachmaturitaetsschule Spezialisierungen
replace e_prog_simp=	9800	 if (e_prog>=9800 & e_prog<=9841) | e_prog==103710 | e_prog==103730				// alle Schulen und Klassen mit auslaendischem Program
replace e_prog_simp=	3790	 if (e_prog>=103511 & e_prog<=103561) | e_prog==3710 | e_prog==3720			// alle BM2 Spezialisierungen
replace e_prog_simp=	103410	 if (e_prog>=103410 & e_prog<=103460) 			// alle BM1 Spezialisierungen


* Berufsbildung

replace e_prog_simp=	180300	 if e_prog==	180200 		/* 180300 Bekleidungsgestalter/in EFZ; 180200 Bekleidungsgestalter/in  */
replace e_prog_simp=	192510	 if e_prog==	192500 		/* Schreiner/in EFZ; Schreiner/in   */
replace e_prog_simp=	196000	 if e_prog==	195000 		/* Zimmermann/Zimmerin EFZ; Zimmermann/Zimmerin   */
replace e_prog_simp=	261100	 if e_prog==	261000 		/* Feinwerkoptiker/in EFZ;  Feinwerkoptiker/in   */
replace e_prog_simp=	274200	 if e_prog==	274100 		/* Interactive Media Designer EFZ;  Multimediagestalter/in   */
replace e_prog_simp=	294560	 if e_prog==	294550 		/* Multimediaelektroniker/in EFZ;   Multimediaelektroniker/in   */
replace e_prog_simp=	295010	 if e_prog==	295000 		/* Netzelektriker/in EFZ;   Netzelektriker/in  */
replace e_prog_simp=	314000	 if e_prog==	313000 		/* Uhrmacher/in EFZ;   Uhrmacher/in (Rhabillage/Industrie) */
replace e_prog_simp=	316000	 if e_prog==	313300 		/* Uhrmacher/in Produktion EFZ ;   Uhrmacher/in Praktiker/in */
replace e_prog_simp=	330800	 if e_prog==	330700 		/* Bauwerktrenner/in EFZ ; Bauwerktrenner/in */
replace e_prog_simp=	332100	 if e_prog==	332000 		/* Gipser/in-Trockenbauer/in EFZ ; Gipser/in */
replace e_prog_simp=	341600	 if e_prog==	341500 		/* Maler/in EFZZ ; Maler/in */

replace e_prog_simp=	334600	 if e_prog==	334500 		/* Isolierspengler/in EFZ ; Isolierspengler/in */
replace e_prog_simp=	368600	 if e_prog==	368500 		/* Mikrozeichner/in EFZ ; Mikrozeichner/in */
replace e_prog_simp=	369600	 if e_prog==	369500 		/* Physiklaborant/in EFZ ; Physiklaborant/in */
replace e_prog_simp=	502600	 if e_prog==	502700 		/* Recyclist/in EFZ ; Recyclist/in  */




