/*******************************************************************************
Program: ECON 220C Assignment 1
Author: Steven Yee
Date: 4/20/20
Purpose:
Update: 
*******************************************************************************/

cap log using  "YeeStevenMacro220CHW1", text

use handguns.dta, clear

//1a
gen ln_violent = ln(vio)
gen ln_murder = ln(mur)
gen ln_rob = ln(rob)

reg ln_violent shall, r
estimates store violent

reg ln_murder shall, r
estimates store murder

reg ln_rob shall, r
estimates store rob

estout violent murder rob, cells("b(star fmt(a3)) se") stats(r2, labels(R-squared))
//1a The Shall lays decrease all of these crime rates at the 0.1% confidence level


//1b

reg ln_violent shall incarc_rate density pop pm1029 avginc, r
estimates store violentb

reg ln_murder shall incarc_rate density pop pm1029 avginc, r
estimates store murderb

reg ln_rob shall incarc_rate density pop pm1029 avginc, r
estimates store robb

estout violentb murderb robb, cells("b(star fmt(a3)) se") stats(r2, labels(R-squared)) drop(incarc_rate density pop pm1029 avginc)
//1b The Shall lays decrease all of these crime rates at the 0.1% confidence level. There are fewer omitted variables here so we can be more confident in our estimates

//3a
// we would expect this covariance to be negative
//3b
// The bias is downard
