/******************************************************************************/
/********************* Kung, Kunz, Shields 2023 SSM ***************************/
/******************************************************************************/

clear *
set maxvar 120000,perm
set mem 100m
set more off,perm
pause off
cap log close 

global m "(-1000/-1=.)"
	global ldir " "	// data source folder
	global data " " // output folder
	
	global ddir "$ldir/Derived Datasets" 			// folder for modified/derived datasets
	global main "$ldir/stata/stata13_se/ukhls"		// folder for USoc mainstage waves
	global covid "$ldir/covid-19/stata/stata13_se"	// folder for USoc Covid-19 supplementary waves


*=========================== generating data ===================================*

use "$main/xwavedat.dta",clear
mer 1:1 pidp using "$main/xwaveid.dta"
save "$ddir/everyone.dta",replace

* variables extracted *
global indall ///
	pidp pid month quarter ivfio ioutcome sex dvage birthy livewith livesp marstat  ///
	curstat employ intdat* doby_if age_if ppsex ff_ivlolw ff_everint ///
	sex_dv age_dv doby_dv marstat_dv racel_dv country gor_dv urban_dv ///
	hhresp_dv livesp_dv cohab_dv single_dv nchild_dv ndepchl_dv ///
	mnspid fnspid pns1pid pns2pid pns2sex pns1sex livpar
	
global hhresp ///
	hidp nkids* n10to15 tenure_dv fihh* hhden* intdatey intdatem intdated outcome hhsize ///
	hhresp_dv hhtype_dv ncouple_dv nonepar_dv urban_dv
	
global indresp ///
	pidp pid hidp pno childpno nch* nunder16abs n1619abs visfrnd* org orgm* orga* ///
	health disdif* dissev* hcond* paaid* paidu* chaid* caid* niserps pendd* fiyr* ///
	finnow finfut rtfnd* scsf* scun* scghq* scopng* scpar* eatlivu famsup upset /// 
	benbase1 penmex pppex pppexm sppen rtexpjb paju maju pacob payruk macob mayruk ///
	closenum socweb netcht visfrnds visfrndsy1 dvage2uk  pacurr macurr indeflv ///
	contft scl* sciso* screl* ftedany nadoptch nnatch sibling jbstat drive caruse ///
	mobuse smartmob mobcomp netpuse ukborn plbornc yr2uk4 fimn* jspayu ///
	fibe* payg* payn* seearn* lvrel* mamostcon pamostcon maage paage nrels* parmar ///
	malone palone ohch16 seekid wekid staykid* farkid relkid masee macon mafar ///90-pl
	pasee pacon pafar chsee chcon chfar ff_jbstat  ff_emplw intdat* argm argf ///
	tlkm tlkf employ jsprf sex_dv age_dv doby_dv pensioner_dv marstat_dv npn_dv ///
	j1nssec8_dv panssec8_dv paj1uknssec8_dv manssec8_dv maj1uknssec8_dv yanssec8_dv ///
	j2nssec8_dv nbrsnci_dv scdassat_dv scdascoh_dv ethn_dv fimnmisc_dv fimnprben_dv ///
	fimninvnet_dv fimnpen_dv fimnsben_dv fimnnet_dv racel_dv country gor_dv urban_dv ///
	hhresp_dv livesp_dv cohab_dv single_dv mastat_dv hhtype_dv buno_dv depchl_dv ///
	nchild_dv ndepchl_dv qfhigh_dv nqfhigh_dv qfhighfl_dv hiqual_dv nhiqual_dv ///
	jbft_dv jbsoc10_cc jbsic07_cc jbiindb_dv jbes2000 jbseg_dv jbrgsc_dv jbnssec_dv ///
	jbnssec5_dv jbnssec3_dv jbisco88_cc pasoc90_cc pasoc00_cc pasoc10_cc masoc90_cc ///
	masoc00_cc masoc10_cc scghq1_dv scghq2_dv sf12pcs_dv sf12mcs_dv ///
	distmov_dv addrmov_dv indinub_lw jbnssec8_dv jbsoc00_cc movdir adcts sclfsat1 ///
	relup currmstat nnewborn hcondn96 stendreas* jbendreas* sf1 scsf1 ///
	nchild_dv ndepchl_dv orgm6 orga6 qfhigh_dv nbrsnci_dv scopngbh*  ///
	memorig ethn_dv netpuse jbiindb_dv jbisco88

local i=12
foreach w in k j i {
local i = `i'-1
use "$main/`w'_indresp.dta",clear
rename `w'_* *
*keep $indresp
isid pidp
tempfile indresp
save "`indresp'", replace

use "$main/`w'_indall.dta",clear
rename `w'_* *
isid pidp
keep $indall
tempfile indall
save "`indall'", replace

use "$main/`w'_hhresp.dta",clear
rename `w'_* *
isid hidp
*keep $hhresp
tempfile hhresp
save "`hhresp'", replace

use "`indresp'", replace
mer 1:1 pidp using "`indall'"
drop if _merge==2
drop _merge
mer m:1 hidp using "`hhresp'"
drop if _merge==2
drop _merge
rename * *_w`i'
rename pidp_w`i' pidp
save "$ddir/`w'_full.dta",replace
}

use "$ddir/i_full.dta",clear
mer 1:1 pidp using "$ddir/j_full.dta", gen(_m_w9_w10)
mer 1:1 pidp using "$ddir/k_full.dta", gen(_m_w9_w11)
save "$ddir/i_full.dta",replace

local pastind pidp hidp finnow finfut sclfsat1 sf1 scsf1 sf12mcs_dv sf12pcs_dv ///
	scghq1_dv scghq2_dv age_dv sex hiqual_dv jbstat jbnssec5_dv jbrgsc_dv ///
	finnow finfut gor_dv intdat* jbft_dv health urban_dv qfhigh_dv sclfsato ///
	ethn_dv
local pasthh hidp fihhmngrs_dv fihhmngrs_tc fihhmnlabgrs_dv fihhmnlabgrs_tc ///
	fihhmngrs1_dv ieqmoecd_dv fihhmnnet1_dv nkids* fihhmngrs_if hhsize
local i 9
foreach w in h g f {
local i =`i'-1
use "$main/`w'_indresp.dta",clear
rename `w'_* *
keep `pastind'
isid pidp
tempfile indresp
save "`indresp'", replace

use "$main/`w'_hhresp.dta",clear
rename `w'_* *
isid hidp
keep `pasthh'
tempfile hhresp
save "`hhresp'", replace

use "`indresp'", replace
mer m:1 hidp using "`hhresp'"
drop if _merge==2
drop _merge
rename * *_w`i'
rename pidp* pidp
tempfile `w'_supp
save "``w'_supp'", replace

use "$ddir/i_full.dta",clear
mer 1:1 pidp using "``w'_supp'"
*drop if _merge==2
drop _merge
save "$ddir/i_full.dta",replace
}

use "$covid/cb_indresp_w.dta", clear
append using "$covid/cb_indresp_t.dta", gen(_m_cbt)
save "$ddir/cb_indresp_w_and_t.dta",replace

use "$covid/cf_indresp_w.dta", clear
append using "$covid/cf_indresp_t.dta", gen(_m_cbt)
save "$ddir/cf_indresp_w_and_t.dta",replace

use "$ddir/everyone.dta",clear
mer 1:1 pidp using "$ddir/i_full.dta", gen(_m_i)
mer 1:1 pidp using "$covid/xbaseline.dta", gen(_m_bl)
mer 1:1 pidp using "$covid/ca_indresp_w.dta", gen(_m_ca)
mer 1:1 pidp using "$ddir/cb_indresp_w_and_t.dta", gen(_m_cb)
mer 1:1 pidp using "$covid/cc_indresp_w.dta", gen(_m_cc)
mer 1:1 pidp using "$covid/cd_indresp_w.dta", gen(_m_cd)
mer 1:1 pidp using "$covid/ce_indresp_w.dta", gen(_m_ce)
mer 1:1 pidp using "$ddir/cf_indresp_w_and_t.dta", gen(_m_cf)
mer 1:1 pidp using "$covid/cg_indresp_w.dta", gen(_m_cg)
mer 1:1 pidp using "$covid/ch_indresp_w.dta", gen(_m_ch)
mer 1:1 pidp using "$covid/ci_indresp_w.dta", gen(_m_ci)

save "$ddir/covid.dta",replace
exit



*=========================== cleaning data ====================================*
use "$ddir/covid.dta",clear


*baseline hh income
capture drop econpb_inc_ind*
gen econpb_inc_ind_base=blpay_amount_dv if blpay_amount_dv>=0 & blpay_amount_dv!=.
assert econpb_inc_ind_base==. if blpay_period_dv<0 & blpay_amount_dv!=0
replace econpb_inc_ind_base=. if blpay_period_dv<0 & econpb_inc_ind_base!=0 & econpb_inc_ind_base!=.
replace econpb_inc_ind_base=0 if blwork_dv==4 & econpb_inc_ind_base==.
assert inrange(blpay_period_dv,1,10) if econpb_inc_ind_base!=. & econpb_inc_ind_base>0 
assert econpb_inc_ind_base==0 if blpay_amount_dv==0
replace econpb_inc_ind_base=econpb_inc_ind_base*52/12 if (blpay_period_dv==1 | blpay_period_dv==5) & econpb_inc_ind_base!=.
replace econpb_inc_ind_base=econpb_inc_ind_base*26/12 if blpay_period_dv==2 & econpb_inc_ind_base!=.
replace econpb_inc_ind_base=econpb_inc_ind_base/12 if blpay_period_dv==4 & econpb_inc_ind_base!=.
replace econpb_inc_ind_base=0 if econpb_inc_ind_base==. & blhours_dv==0

cap drop nadultscurr
egen nadultscurr=rowtotal(ca_hhcompc ca_hhcompd ca_hhcompe), missing
gen econpb_inc_hh_base=blhhearn_amount_dv if blhhearn_amount_dv>=0 & blhhearn_amount_dv!=.
replace econpb_inc_hh_base=. if blhhearn_period_dv<0 & econpb_inc_hh_base!=. & econpb_inc_hh_base!=0 
replace econpb_inc_hh_base=0 if blhhearn_amount_dv==0 
replace econpb_inc_hh_base=econpb_inc_hh_base*52/12 if blhhearn_period_dv==1 & econpb_inc_hh_base!=.
replace econpb_inc_hh_base=econpb_inc_hh_base*26/12 if blhhearn_period_dv==2 & econpb_inc_hh_base!=.
replace econpb_inc_hh_base=econpb_inc_hh_base/12 if blhhearn_period_dv==4 & econpb_inc_hh_base!=.
replace econpb_inc_hh_base=econpb_inc_hh_base*52/12 if blhhearn_period_dv==5 & econpb_inc_hh_base!=.
replace econpb_inc_hh_base=econpb_inc_ind_base if nadultscurr==0 & econpb_inc_hh_base==. & econpb_inc_ind_base!=.

*survey date
capture drop date_*
capture drop daysvyend_*
local i=0
foreach x in a b c d e f g h i {
local i= `i'+1
gen date_wc`i' = dofc(c`x'_surveyend)
format date_wc`i' %td
tab date_wc`i', miss gen(daysvyend_wc`i'_)
}

*to use wave9 observations if interview is in 2020, or w10 not available
cap drop useW9obs
gen useW9obs=intdaty_dv_w10==2020 & inrange(intdatm_dv_w10,1,5)

*to use 2019 observations if interview is in 2020, or w10 not available
cap drop wavetouse_2019
g wavetouse_2019 = 9 if intdaty_dv_w9==2019
replace wavetouse_2019 = 10 if intdaty_dv_w10==2019
replace wavetouse_2019 = 11 if intdaty_dv_w11==2019

cap drop wavetouse_2018
g wavetouse_2018 = 8 if intdaty_dv_w8==2018
replace wavetouse_2018 = 9 if intdaty_dv_w9==2018
replace wavetouse_2018 = 10 if intdaty_dv_w10==2018

*sex
rename sex_dv male
recode male (2=0) $m

*loneliness, mental health, age
cap drop lonely_*
gen lonely_w9 = sclonely_w9 if sclonely_w9>0
gen lonely_w10 = sclonely_w10 if sclonely_w10>0
gen lonely_w11 = sclonely_w11 if sclonely_w11>0

local i=0
foreach x in a b c d e f g h i {
	local i=`i' +1
	gen lonely_wc`i' = c`x'_sclonely if c`x'_sclonely>0
	
	foreach v in scghq1_dv scghq2_dv age  {
		rename c`x'_`v' `v'_wc`i'
	}
	rename age_wc`i' age_dv_wc`i'
}
recode scghq1_dv_* scghq2_dv_* $m

*full time education / employment status
label values blnonwork_dv cb_blnonwork
gen fteduc = blnonwork_dv
recode fteduc (5=1) (1/4 6 7=0) (-10/-1=.)
replace fteduc = 0 if inrange(blwork_dv,1,3)

replace fteduc=1 if cb_blnonwork==5 | cc_blnonwork==5 | cd_blnonwork==5 | ce_blnonwork==5
replace fteduc=0 if fteduc==. & fteduc!=1 & (inrange(cb_blnonwork,1,10) | inrange(cc_blnonwork,1,10) ///
	| inrange(cd_blnonwork,1,10) | inrange(ce_blnonwork,1,10))

cap drop empstatus
gen empstatus = blwork_dv if blwork_dv >=0
recode empstatus (1/3=1) (4=3)
replace empstatus=2 if empstatus==3 & blnonwork_dv==5
replace empstatus=2 if empstatus==3 & (cb_blnonwork==5 | cc_blnonwork==5 | ///
	cd_blnonwork==5 | ce_blnonwork==5 )

replace empstatus=3 if empstatus==. & fteduc!=1 & (inrange(cb_blnonwork,1,10) ///
	| inrange(cc_blnonwork,1,10) | inrange(cd_blnonwork,1,10) | inrange(ce_blnonwork,1,10) )	
	
replace empstatus=1 if empstatus==. &  (inrange(cb_blwork,1,3) | inrange(cc_blwork,1,3) ///
	| inrange(cd_blwork,1,3) | inrange(ce_blwork,1,3) )	
	

*parental education
g long pidp_dad = .
g long pidp_mum = .

forval w=11(-1)9 {
replace pidp_dad = fnspid_w`w' if (fnspid_w`w'>0 & fnspid_w`w'!=.) & wavetouse_2019==`w' 
replace pidp_mum = mnspid_w`w' if (mnspid_w`w'>0 & mnspid_w`w'!=.) & wavetouse_2019==`w' 
}
replace pidp_dad = fnspid_w10 if (fnspid_w10>0 & fnspid_w10!=.) & pidp_dad==. 
replace pidp_dad = fnspid_w9 if (fnspid_w9>0 & fnspid_w9!=.) & pidp_dad==. 

replace pidp_mum = mnspid_w10 if (mnspid_w10>0 & mnspid_w10!=.) & pidp_mum==. 
replace pidp_mum = mnspid_w9 if (mnspid_w9>0 & mnspid_w9!=.) & pidp_mum==. 

tempfile all
save "`all'", replace

keep pidp hiqual_dv_w* qfhigh_dv_w*
cap drop degree
gen degree=hiqual_dv_w10 if hiqual_dv_w10>=0
replace degree = hiqual_dv_w9 if (degree==.)&inrange(hiqual_dv_w9,1,9)
replace degree = hiqual_dv_w8 if (degree==.)&inrange(hiqual_dv_w8,1,9)
recode degree $m (1=1) (2/9=0)
replace degree=1 if degree==0 & inrange(qfhigh_dv_w10,1,2)
replace degree=1 if degree==0 & inrange(qfhigh_dv_w9,1,2)
replace degree=1 if degree==0 & inrange(qfhigh_dv_w8,1,2)

keep pidp degree
rename * *_dad 
tempfile dad
save "`dad'", replace

use "`all'", clear
keep pidp hiqual_dv_w* qfhigh_dv_w*
cap drop degree
gen degree=hiqual_dv_w10 if hiqual_dv_w10>=0
replace degree = hiqual_dv_w9 if (degree==.)&inrange(hiqual_dv_w9,1,9)
replace degree = hiqual_dv_w8 if (degree==.)&inrange(hiqual_dv_w8,1,9)
recode degree $m (1=1) (2/9=0)
replace degree=1 if degree==0 & inrange(qfhigh_dv_w10,1,2)
replace degree=1 if degree==0 & inrange(qfhigh_dv_w9,1,2)
replace degree=1 if degree==0 & inrange(qfhigh_dv_w8,1,2)

keep pidp degree
rename * *_mum 
tempfile mum
save "`mum'", replace

use "`all'", clear
mer m:1 pidp_dad using "`dad'", gen(_d_degree) 
mer m:1 pidp_mum using "`mum'", gen(_m_degree) 

keep age_dv_w* pidp lonely_* intdaty_dv_w* intdatm_dv_w* useW9obs male  ///
	degree_dad birthy fteduc empstatus degree_mum ///
	date_wc* wavetouse* scghq* econpb_inc_hh_base
drop if pidp==.
drop age_dv_w8 age_dv_w7 age_dv_w6
drop *_w8 *_w7 *_w6

cap drop *_baseline

recode intdaty_dv_w* intdatm_dv_w* $m


*============================ shaping data ====================================*

rename scghq1_dv_* scghq1_*
rename scghq2_dv_* scghq2_*

foreach v in lonely age_dv year month scghq1 scghq2 {
cap drop `v'_201*
g `v'_2019 = .
g `v'_2018 = .
}

forval w=9/11 {
replace lonely_2019 = lonely_w`w' if inrange(lonely_w`w',1,3) & wavetouse_2019==`w' 
replace lonely_2018 = lonely_w`w' if inrange(lonely_w`w',1,3) & wavetouse_2018==`w' 

replace scghq1_2019 = scghq1_w`w' if inrange(scghq1_w`w',0,36) & wavetouse_2019==`w' 
replace scghq1_2018 = scghq1_w`w' if inrange(scghq1_w`w',0,36) & wavetouse_2018==`w' 

replace scghq2_2019 = scghq2_w`w' if inrange(scghq2_w`w',0,12) & wavetouse_2019==`w' 
replace scghq2_2018 = scghq2_w`w' if inrange(scghq2_w`w',0,12) & wavetouse_2018==`w' 

replace age_dv_2019 = age_dv_w`w' if age_dv_w`w'!=. & wavetouse_2019==`w' 
replace age_dv_2018 = age_dv_w`w' if age_dv_w`w'!=. & wavetouse_2018==`w' 

replace year_2019 = intdaty_dv_w`w' if wavetouse_2019==`w' 
replace year_2018 = intdaty_dv_w`w' if wavetouse_2018==`w' 

replace month_2019 = intdatm_dv_w`w' if wavetouse_2019==`w' 
replace month_2018 = intdatm_dv_w`w' if wavetouse_2018==`w' 
}

replace year_2019 = intdaty_dv_w10 if inrange(lonely_w10,1,3) & lonely_2019==.
replace year_2018 = intdaty_dv_w9 if inrange(lonely_w9,1,3) & lonely_2018==.

replace month_2019 = intdatm_dv_w10 if inrange(lonely_w10,1,3) & lonely_2019==. 
replace month_2018 = intdatm_dv_w9 if inrange(lonely_w9,1,3) & lonely_2018==.

replace lonely_2019 = lonely_w10 if inrange(lonely_w10,1,3) & lonely_2019==. 
replace lonely_2018 = lonely_w9 if inrange(lonely_w9,1,3) & lonely_2018==.

foreach v in lonely age_dv scghq1 scghq2 {
replace `v'_w10 = `v'_2019
replace `v'_w9 = `v'_2018
cap drop `v'_w11
}
rename year_2019 year_w10
rename year_2018 year_w9
rename month_2019 month_w10
rename month_2018 month_w9

keep pidp age_dv_w* lonely_w* male fteduc empstatus date_wc*  ///
	degree_dad degree_mum year_* month* scghq1* scghq2* econpb* 
forval x=1/9{
local i = `x'+10
rename lonely_wc`x' lonely_w`i'

rename scghq1_wc`x' scghq1_w`i'
rename scghq2_wc`x' scghq2_w`i'

rename age_dv_wc`x' age_dv_w`i'
rename date_wc`x' date_w`i' 
}


cap drop lonely_full*
forval x=9/19{
g lonely_full_w`x' = lonely_w`x'
}
recode lonely_w* (2/3=1) (1=0)

g bal0 = 0 if lonely_w9!=. | lonely_w10!=. | lonely_w11!=. | lonely_w12!=. ///
			| lonely_w13!=. | lonely_w14!=. | lonely_w15!=. | lonely_w16!=. ///
			| lonely_w17!=. | lonely_w18!=. | lonely_w19!=. 

g bal1 = 0 if (lonely_w9!=. | lonely_w10!=.) & (lonely_w11!=. | lonely_w12!=. ///
			| lonely_w13!=. | lonely_w14!=. | lonely_w15!=. | lonely_w16!=. ///
			| lonely_w17!=. | lonely_w18!=. | lonely_w19!=. )
						
egen covidnmiss = rownonmiss(lonely_w11 lonely_w12 lonely_w13 lonely_w14 lonely_w15 ///
	lonely_w16 lonely_w17 lonely_w18 lonely_w19)

replace bal1 = 1 if bal1==0 & inrange(covidnmiss,6,9)

xtile basehhinc = econpb_inc_hh_base, n(3)

keep if bal1!=. 
reshape long lonely_full_w lonely_w age_dv_w date_w ///
	year_w month_w scghq1_w scghq2_w , i(pidp) j(wave)

cap drop lonelyoften_w
cap drop lonely_cont_w
g lonelyoften_w = lonely_full_w
recode lonelyoften_w (3=1) (1/2=0)
g lonely_cont_w = lonely_full_w
replace lonely_cont_w = lonely_cont_w-1

cap drop goodinc
g goodinc = basehhinc
recode goodinc (1=0) (2/3=1)




/******************************************************************************/
/************************************ FIGURES *********************************/
/******************************************************************************/
cd "$data" 

*FIGURE 2
xtset pidp wave
preserve
recode wave (9=1) (10=3) (11=5) (12=6) (13=7) (14=8) (15=10) (16=12) (17=14) (18=16) (19=18)
keep if inrange(age_dv_w,16,24)
keep if bal1!=.
keep lonely_cont_w wave pidp male
xttab lonely_cont_w

xtset pidp wave
reshape wide lonely_cont_w , i(pidp) j(wave)
foreach v in lonely_cont  {
g `v'_w2=.
g `v'_w4=.
g `v'_w9=.
g `v'_w11=.
g `v'_w13=.
g `v'_w15=.
g `v'_w17=.
}
reshape long lonely_cont_w , i(pidp) j(wave)
cap drop lonelyscore*
tab lonely_cont_w, gen(lonelyscore)

forval x=0/1 {
	if `x'==0 {
		local title "Women, 16-24"
	}
	if `x'==1 {
		local title "Men, 16-24"
	}
graph bar (mean) lonelyscore1  (mean) lonelyscore2 (mean) lonelyscore3 if male==`x', ///
	over(wave, relabel(1 "2018" 3 "2019" 5 "W1" 6 "W2" 7 "W3" ///
	8 "W4"	10 "W5" 12 "W6" 14 "W7" 16 "W8" 9 " " 11 " " 13 " " 15 " " 18 "W9" 2 " " 4 " " 17 " ") ///	
	label(labgap(*1.5) labsize(small))) stack ///
	bar(1, color(khaki)) bar(2, color(ebblue)) bar(3, color(edkblue)) graphregion(color(white)) ///
	yvaroptions(relabel(1 "Hardly ever or never" 2 "Some of the time" 3 "Often")) ///
	subtitle("`title'", si(medium)) inten(*1) linten(*1) ///
	legend(rows(1) region(style(none)) si(medsmall)) 
gr export Fig2_`x'_color.tif, replace

graph bar (mean) lonelyscore1  (mean) lonelyscore2 (mean) lonelyscore3 if male==`x', ///
	over(wave, relabel(1 "2018" 3 "2019" 5 "W1" 6 "W2" 7 "W3" ///
	8 "W4"	10 "W5" 12 "W6" 14 "W7" 16 "W8" 9 " " 11 " " 13 " " 15 " " 18 "W9" 2 " " 4 " " 17 " ")	///
	label(labgap(*1.5) labsize(small)))  stack ///
	bar(1, color(gs12)) bar(2, color(gs8)) bar(3, color(gs3))  graphregion(color(white)) ///
	yvaroptions(relabel(1 "Hardly ever or never" 2 "Some of the time" 3 "Often")) ///
	subtitle("`title'", si(medium)) inten(*1) linten(*1) ///
	legend(rows(1) region(style(none)) si(medsmall)) 
gr export Fig2_`x'_bw.tif, replace
}	
restore
	
	

*FIGURES 3-7
global yl "lp(dash) lw(thin) lc(black%75)"

xtset pidp wave
foreach fig in fig3 fig4 fig5 fig6 fig7 { 
if "`fig'" == "fig3"  {
	local if1 "male==0 & inrange(age_dv_w,16,24)"
	local if2 "male==1 & inrange(age_dv_w,16,24)"
	local leg "order(2 "Women, 16-24" 4 "Men, 16-24")"
}
else if "`fig'" == "fig4"  {
	local if1 "male==0 & inrange(age_dv_w,25,39)"
	local if2 "male==1 & inrange(age_dv_w,25,39)"
	local leg "order(2 "Women, 25-39" 4 "Men, 25-39")"
}
else if "`fig'" == "fig5"  {
	local if1 "degree_mum==0 & inrange(age_dv_w,16,24)"
	local if2 "degree_mum==1 & inrange(age_dv_w,16,24)"
	local leg "order(2 "Mother without degree, 16-24" 4 "Mother with degree, 16-24")"
}
else if "`fig'" == "fig6"  {
	local if1 "goodinc==0 & inrange(age_dv_w,16,24)"
	local if2 "goodinc==1 & inrange(age_dv_w,16,24)"
	local leg "order(2 "Income tercile 1 (lowest), 16-24" 4 "Income terciles 2-3, 16-24")"
}
else if "`fig'" == "fig7"  {
	local if1 "empstatus==1 & inrange(age_dv_w,16,24)"
	local if2 "empstatus==2 & inrange(age_dv_w,16,24)"
	local leg "order(2 "Employed, 16-24" 4 "Full time education, 16-24")"
}

xtset pidp wave
xtreg lonely_w ib10.wave if `if1' , fe vce(cl pidp)
est sto reg1 
xtreg lonely_w ib10.wave if `if2' , fe vce(cl pidp)
est sto reg2 

coefplot (reg1,m(o) mc(ebblue) ciopts(lc(ebblue)) offset(-0.1)) ///
	(reg2, m(d) mc(khaki) ciopts(lc(khaki)) offset(0.1)) , /// 
	vert omit keep(*wave*) legend(`leg' region(style(none)) si(msmall) ) ///
	relocate(10.wave=3 11.wave=5 12.wave=6 13.wave=7 14.wave=8 ///
	15.wave=10 16.wave=12 17.wave=14 18.wave=16 19.wave=18) ylabel(-0.1(0.1)0.2, labs(msmall)) ///
	xlabel(1 "2018" 3 "2019" 5 "W1" 6 "W2" 7 "W3" 8 "W4" 10 "W5" 12 "W6" 14 "W7" 16 "W8" ///
	9 " " 11 " " 13 " " 15 " " 18 "W9" 2 " " 4 " " 17 " " , labsize(msmall) labgap(*3) noticks) ///
	addplot(scatteri 0 2.82, m(o) mc(ebblue) || scatteri 0 3.18, m(d) mc(khaki)) ///
	yline(0, $yl) graphregion(color(white)) name(`fig'_col, replace) bgcolor(white) scheme(s2mono) 
gr combine `fig'_col, iscale(*0.85) graphregion(color(white))
gr export `fig'_col.tif, replace

coefplot (reg1,m(o) mc(gs0) ciopts(lc(gs0)) offset(-0.1)) ///
		(reg2, m(d) mc(gs11) ciopts(lc(gs11)) offset(0.1)) , /// 
	vert omit keep(*wave*) legend(`leg' region(style(none)) si(msmall) ) ///
	relocate(10.wave=3 11.wave=5 12.wave=6 13.wave=7 14.wave=8 ///
	15.wave=10 16.wave=12 17.wave=14 18.wave=16 19.wave=18) ylabel(-0.1(0.1)0.2, labs(msmall)) ///
	xlabel(1 "2018" 3 "2019" 5 "W1" 6 "W2" 7 "W3" 8 "W4" 10 "W5" 12 "W6" 14 "W7" 16 "W8" ///
	9 " " 11 " " 13 " " 15 " " 18 "W9" 2 " " 4 " " 17 " " , labsize(msmall) labgap(*3) noticks) ///
	addplot(scatteri 0 2.82, m(o) mc(gs0) || scatteri 0 3.18, m(d) mc(gs11)) ///
	yline(0, $yl) graphregion(color(white)) name(`fig'_bw, replace) bgcolor(white) scheme(s2mono)  
gr combine `fig'_bw, iscale(*0.85) graphregion(color(white))
gr export `fig'_bw.tif, replace
}
