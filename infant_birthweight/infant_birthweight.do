/*==============================================================================
Title: koirala_project1.do
Author: Priya Koirala
Project: #1
==============================================================================*/

cap log close _all
clear
set more off

/* Instructions: You will construct a Stata do-file, which will 
produce a log file that contains your Stata output. You must submit your log 
file as a PDF to Gradescope. Open the log file in Word, and start each question 
on a different page. Then print-to-PDF. The final PDF of your log file will be 
12 pages long. Note that late projects will not be accepted.

Background: Suppose you are interested in how a mother’s smoking habits during 
pregnancy affect her infant's health. You use the observational data set called 
bwght.dta to explore the relationship between smoking during pregnancy and 
infant birthweight. The data set contains two variables: the birthweight (in 
ounces) of a infant (bwght) and the number of cigarettes the mother smoked per 
day during pregnancy (cigs). */

/*==============================================================================
Create a log file for your results
==============================================================================*/

log using "/Users/priyakoirala/Desktop/school/econometrics/projects/project1/koirala_project1.log", name(PK) replace

/*==============================================================================
(Q1): Open the data set in Stata (via the use command).
==============================================================================*/

use "/Users/priyakoirala/Desktop/school/econometrics/projects/project1/bwght.dta"

/*==============================================================================
(Q2): Summarize the data in Stata. What’s the average birthweight of infants in 
the sample?
==============================================================================*/

summarize

/* The average birthweight of infants in the sample is 119.0551. */

/*==============================================================================
(Q3): Construct a binary variable (using the "gen" command) named anycig that 
equals one if the mother smoked at least one cigarette per day and equals zero 
otherwise.
==============================================================================*/

gen anycig = .
replace anycig = 1 if cig >= 1
replace anycig = 0 if cig < 1

/*==============================================================================
(Q4): Use the "tab" command to determine the share (percent) of moms who smoked 
during pregnancy.
==============================================================================*/

tab anycig

/* 15.85% of mothers smoked during pregnancy. */

/*==============================================================================
(Q5): We want to test the hypothesis that the average birthweight of infants 
born to smokers vs. non-smokers is the same. Use the "reg" command to estimate 
the following model using OLS: bwghti = β0 + β1anycigi + ui
==============================================================================*/

reg bwght anycig

/*==============================================================================
(Q6): How do you interpret β1 in this regression?
==============================================================================*/

/* β1 is the difference in the average birthweights of infants born to 
   mothers who smoked and the mothers who did not smoke during pregnancy. 

   β1 is -8.92383. */

/*==============================================================================
(Q7): How do you interpret β0?
==============================================================================*/

/* β0 represents the average (constant) birthweight of infannts, whether 
they were born to mothers who smoked during pregancny or mothers who did not. 

   β0 is 120.4693 */

/*==============================================================================
(Q8): Rather than looking at the effect of smoking versus not smoking, we want 
to determine how smoking intensity affects birthweight. Use the "reg" command 
to estimate: bwghti = β0+β1cigsi+ui
==============================================================================*/

reg bwght cigs

/*==============================================================================
(Q9): What is the marginal effect of smoking an additional cigarette on 
birthweight?
==============================================================================*/

/* For every additional cigarette smoked by pregnant mothers, an infant's 
   birthweight is estimated to decrease by 0.5096199. */

/*==============================================================================
(Q10): Using your regression results in question (8). If a mother smokes 5 
cigarettes per day, what is the effect on birthweight?
==============================================================================*/

/* Based on the model bwghti = β0+β1cigsi+ui, if we were to assign cig to equal 
   to 5 and B1 is approximated to -0.509619, then that gives us the algabraic 
   product of -2.548095. Therefore at 5 cigarettes a day the effect on 
   birthweight is that it decreases by 2.548095. */

/*==============================================================================
(Q11): Does the regression model in question (8) reflect the causal 
relationship between a mother's smoking habits and her infant's birthweight? 
Explain. (Hint: What is contained in ui?)
==============================================================================*/

/* The regression model in question 8 reflects the causal negative relationship 
   between a mother's smoking habits and an infant's birthweight. The regression 
   suggests that mother's who smoked during pregancy gave birth to infants with a 
   lower birthweight than mother's who did not smoke during pregancny. 

   We reject our hypothesis that average birthweight of infants born to mothers 
   who smoked vs non-smokers is the same. 

   However, despite our findings that there is a causal relationship between
   smoking and low infant birthweight, the model fails to reflect all of the 
   other factors that might contribute to low birthweight. Such as the 
   environtment the mother lives in, household income, diet, excersise. 
   All of these factors plus more can impact an infants birthweight. 
   (ui is the error term, it contains all of the other factors besides smoking 
   which impacts and infant's birthweight).*/ 

/*==============================================================================
==============================================================================*/

cap log close _all
