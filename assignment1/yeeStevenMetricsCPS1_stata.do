/*******************************************************************************
Program: ECON 220C Assignment 1
Author: Steven Yee
Date: 4/20/20
Purpose:
Update: 
*******************************************************************************/
clear all
cls

cap log using  "YeeStevenMetricsC20CHW1", text

use handguns.dta, clear


//Part1a
gen ln_violent = log(vio)
gen ln_murder = log(mur)
gen ln_rob = log(rob)

estimates clear

eststo: reg ln_violent shall, r
eststo: reg ln_murder shall, r
eststo: reg ln_rob shall, r
label variable shall "Shall law"

esttab using "metricsC_ps1_5a.tex", replace booktabs label b(2) r2(2) se(2) gaps alignment(D{.}{.}{-1}) width(0.8\hsize) title(Regression in 5a\label{tab1})

//Part2
estimates clear
eststo: reg ln_violent shall incarc_rate density pop pm1029 avginc, r
eststo: reg ln_murder shall incarc_rate density pop pm1029 avginc, r
eststo: reg ln_rob shall incarc_rate density pop pm1029 avginc, r

esttab using "metricsC_ps1_5b.tex", replace booktabs label b(2) r2(2) se(2) gaps alignment(D{.}{.}{-1}) width(0.8\hsize) title(Regression in 5b\label{tab1}) drop(incarc_rate density pop pm1029 avginc)

//Part 4
estimates clear
tab state, gen(statedummy)
tab year, gen(yeardummy)

//4 violence
reg ln_violent shall incarc_rate density pop pm1029 avginc, r

reg ln_violent shall incarc_rate density pop pm1029 avginc statedummy*, r
estimates store violentState
testparm statedummy*

reg ln_violent shall incarc_rate density pop pm1029 avginc statedummy* yeardummy*, r
estimates store violentStateYear
testparm statedummy*
testparm year*

reg ln_violent shall incarc_rate density pop pm1029 avginc statedummy* yeardummy*, cluster(state) r
estimates store violentStateCluster

//4 murder
reg ln_murder shall incarc_rate density pop pm1029 avginc, r

reg ln_murder shall incarc_rate density pop pm1029 avginc statedummy*, r
estimates store murderState
testparm statedummy*

reg ln_murder shall incarc_rate density pop pm1029 avginc statedummy* yeardummy*, r
estimates store murderStateYear
testparm statedummy*
testparm year*

reg ln_murder shall incarc_rate density pop pm1029 avginc statedummy* yeardummy*, cluster(state) r
estimates store murderStateCluster


//4 robbery
reg ln_rob shall incarc_rate density pop pm1029 avginc, r

reg ln_rob shall incarc_rate density pop pm1029 avginc statedummy*, r
estimates store robState
testparm statedummy*

reg ln_rob shall incarc_rate density pop pm1029 avginc statedummy* yeardummy*, r
estimates store robStateYear
testparm statedummy*
testparm year*

reg ln_rob shall incarc_rate density pop pm1029 avginc statedummy* year*, cluster(state) r
estimates store robStateCluster
