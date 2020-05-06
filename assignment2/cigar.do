//Steven Yee

drop _all
set mem 300m
set more off

// cd D:\Teaching\Graduate\
capture log close
log using ps2.log, replace


// insheet using cigar_new.csv, clear
import excel using "cigar.xls", firstrow
rename *, lower

rename logconsumption lnc
rename lnprice lnp
rename logincome lny
rename logminimumpriceatneighboring lnpn

sort state year
tsset state year
estimates clear
**************************************************************
*      Part (a)                                              *
* Stata adjustments for the degree of freedom Automatically  *
**************************************************************
eststo: reg lnc L1.lnc lnp lny lnpn, r
outreg2 using "metricsC_ps2_4ae.tex", replace nocons ctitle(4a)
// esttab using "metricsC_ps2_4a.tex", replace booktabs label b(2) r2(2) se(2) gaps alignment(D{.}{.}{-1}) width(0.8\hsize) title(Regression in 4a\label{tab1}) nocons
// estimates store est4a


**************************************************************
*      Part (b)                                              *
**************************************************************
cap quiet tabulate year, generate (yeard)  
                              /*generate the year dummies */

eststo: reg lnc L1.lnc lnp lny lnpn yeard3-yeard30, r
outreg2 using "metricsC_ps2_4ae.tex", nocons drop(yeard3-yeard30) ctitle(4b)
// esttab using "metricsC_ps2_4b.tex", replace booktabs label b(2) r2(2) se(2) gaps alignment(D{.}{.}{-1}) width(0.8\hsize) title(Regression in 4b\label{tab1}) nocons 
// estimates store est4b

***************** or use the following ****************
// xi: reg lnc L1.lnc lnp lny lnpn i.year,r

**************************************************************
*      Part (c)                                              *
**************************************************************
// cap by state: gen lnc1=lnc[_n-1]
eststo: xtreg lnc L1.lnc lnp lny lnpn, fe
outreg2 using "metricsC_ps2_4ae.tex", nocons ctitle(4c)
// estimates store est4c

**************************************************************
*      Part (d)                                              *
**************************************************************

eststo: xtreg lnc L1.lnc lnp lny lnpn yeard3-yeard30, fe
outreg2 using "metricsC_ps2_4ae.tex", nocons drop(yeard3-yeard30) ctitle(4d)
testparm yeard*
// estimates store est4d

*---------------- or use the following -------------
// xi: xtreg lnc lnc1 lnp lny lnpn i.year, fe
// testparm _Iyear* 
*---------------------------------------------------


**************************************************************
*      Part (e)                                              *
**************************************************************

cap gen Dlnc=D.lnc
eststo: ivreg D.lnc (L1.Dlnc = L2.lnc) D.lnp D.lny D.lnpn  yeard3-yeard30
outreg2 using "metricsC_ps2_4ae.tex", nocons drop(yeard3-yeard30) ctitle(4e)
// estimates store est4e



**************************************************************
*      Part (g)                                              *
**************************************************************

*******g.i **********
xtabond lnc lnp lny lnpn yeard2-yeard30, lags(1)
outreg2 using "metricsC_ps2_4g.tex", nocons drop(yeard3-yeard30) ctitle(4gi)
*or
//  xi: xtabond lnc lnp lny lnpn i.year, lags(1)

*******g.ii **********
xtabond lnc lnp lny lnpn yeard2-yeard30, lags(1) maxldep(3)
outreg2 using "metricsC_ps2_4g.tex", nocons drop(yeard3-yeard30) ctitle(4gii)
* or
// xi: xtabond lnc lnp lny lnpn i.year, lags(1) maxldep(3)


*******g.iii **********
xtabond lnc lnp lny lnpn yeard2-yeard30, lags(1) maxldep(1)
outreg2 using "metricsC_ps2_4g.tex", nocons drop(yeard3-yeard30) ctitle(4giii)
*or 
// xi: xtabond lnc lnp lny lnpn i.year, lags(1) maxldep(1)


