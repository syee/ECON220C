// Steven Yee
// Metrics C PS 4
// 6/4/20

clear

set more off
capture log using ca_heating.log, replace
insheet using ca_heating.csv
describe

/*In the data set, we have yi. We need to define yij */
gen d1=0
gen d2=0
gen d3=0
gen d4=0
gen d5=0

replace d1=1 if depvar ==1
replace d2=1 if depvar ==2
replace d3=1 if depvar ==3
replace d4=1 if depvar ==4
replace d5=1 if depvar ==5

/* Conditional logit of depvar on alternative-specific regressor (ic, oc)
First reshape data so 5 observations per household - one for each heating option.
*/

reshape long d ic oc, i(idcase) j(alterntv)
describe
/* part (a) */
/* I use clogit below. Check out the new lecture note on binary choice models 
 on TED and see why clogit, which is designed for fixed-effect logits,
 can be used here
  You can also try using the command asclogit */

clogit d ic oc, group(idcase)

/* The coefficients have the expected signs and are different from zero*/


/* part (b) */

predict phat if e(sample)

sort alterntv
by alterntv: sum phat
tab depvar

/* part (c) */

scalar beta1 = _b[oc]
scalar beta2 = _b[ic]
disp beta1/beta2

//They are willing to increase the installation cost by a dollar if it decreases the operating cost by $0.73. This is not reasonable given a reasonable discount rate that values today more than the future. I'm here for a long time, not a good time so I'm happy to take that dollar decrease each year. But I want a gooder time than this implies.

/* part (d) */
// This means r = 136%
// This is not reasonable. Empirical discount rates are typically in the high 90%





/* part (e)  */


tab alterntv, gen(alt_dummy) 

clogit d ic oc alt_dummy1-alt_dummy4, group(idcase)
predict phat1 if e(sample)
sort alterntv
by alterntv: sum phat1
tab depvar

/* We can identify the relative alternative specific constants if we assume a base category and then subtract that constant from all the other alternatives. So we are able to identify the relative alternative-specific constant but not able to identify the actual levels unless we make an assumption about the value of the base category constant (we often assume it is 0). It doesn't matter which starting point we choose. Now the estimated probabilities match almost exactly.
*/

/* part (f) */

scalar beta1 = _b[oc]
scalar beta2 = _b[ic]
disp beta1/beta2

//wtp = 4.563. This implies an r value = 0.21913556. This seems much more reasonable.


/* part (g)   */

gen income2 = income*alt_dummy2
gen income3 = income*alt_dummy3
gen income4 = income*alt_dummy4
gen income5 = income*alt_dummy5

clogit d ic oc alt_dummy2-alt_dummy5 income2-income5, group(idcase)

/* If you just include income as a regressor on its own with the same constant for all aternatives, you can't estimate any effects. This is because it would affect each alternative the same way and have no effect since we make our decision ordinally. If you transform it so the coefficient can vary by alternative, then you can include it. */


/* part (h) with no income */

clogit d ic oc alt_dummy2-alt_dummy5, group(idcase)
preserve
replace ic = ic*0.9 if alterntv==5
predict phat2 if e(sample)
sort alterntv
by alterntv: sum phat2
tab depvar
restore

//The rebate raises the predicted share of houses with heat pumps (system 5) by ~1%.


/* part (i) */
sca beta1 = _b[ic]
sca beta2 = _b[oc]
sca gamma1 =0
sca gamma2 =_b[alt_dummy2]
sca gamma3 =_b[alt_dummy3]
sca gamma4 =_b[alt_dummy4]
sca gamma5 =_b[alt_dummy5]
sca gamma6 =_b[alt_dummy3]

/* create alternative 6 */
expand 2 if alterntv==3
sort idcase alterntv
by idcase:  replace alterntv = 6 if _n==4

/* Compute the predicted probability manually */

gen expo = exp(beta1*ic+beta2*oc+gamma1) if alterntv==1  /* the numberator*/
replace expo = exp(beta1*ic+beta2*oc+gamma2) if alterntv==2
replace expo = exp(beta1*ic+beta2*oc+gamma3) if alterntv==3
replace expo = exp(beta1*ic+beta2*oc+gamma4) if alterntv==4
replace expo = exp(beta1*ic+beta2*oc+gamma5) if alterntv==5
replace expo = exp(beta1*(ic+200)+beta2*oc*0.75+gamma6) if alterntv==6


by idcase: egen expo_mean = mean(expo)
gen phat3 = expo/(6*expo_mean)

sort alterntv
by alterntv: sum phat3
tab depvar

/* the predicted market share ~ 10.4%. The bulk of the market share comes from taking customers away from heating system 1 since heating system sees the biggest drop. */

log close


