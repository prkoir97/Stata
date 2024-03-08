/*==============================================================================
Title: koirala_project5.do
Author: Priya Koirala
Project: #5
==============================================================================*/

cap log close _all
clear
set more off

/*==============================================================================
 Create a log file for your results
==============================================================================*/

log using "/Users/priyakoirala/Desktop/school/econometrics/projects/project5/koirala_project5.log", name(PK) replace

/*==============================================================================
The purpose of this exercise is to understand how borrower characteristics
relate to the probability of home loan approval. 

Open the LOANAPP.dta data set. It is a random sample of people who applied for
home mortgage loans. It contains information about the people's characteristics 
and a binary variable for whether their loan application got approved or not.
==============================================================================*/

use "/Users/priyakoirala/Desktop/school/econometrics/projects/project5/loanapp.dta"

/*==============================================================================
(Q1): Use a linear probability model to estimate the relationship between the
probability of loan approval (approve) and the following variables:

X1=bankruptcy
X2=hh_expenditures
X3=term
X4=apr
X5=Black
X6=Hispanic

What type of standard errors should you use?
==============================================================================*/

sum

reg approve i.bankruptcy c.hh_expenditures c.term c.apr i.black i.hisp, robust

/* For a Linear Probability Model, we should always use hetersekdasticity robust standard errors as the variance in these models are not constant, therefore, they are naturally heteroskedastic. */

/*==============================================================================
(Q2): What is the marginal effect of household expenditures on loan approval 
probability?
==============================================================================*/

/* Marginal Effect: -0.0027087.

For every $1,000 increase in household expenditure per year, the probbabilty of loan approval decreases by 0.0027. */

/*==============================================================================
(Q3): Estimate the same model as in (Q1) but use the probit functional form.

What is the marginal effect of household expenditures on loan approval 
probability when all variables are held at their mean values?
==============================================================================*/

probit approve i.bankruptcy c.hh_expenditures c.term c.apr i.black i.hisp, robust

margins, dydx(_all) at((means)_all)

/* Marginal Effect: -0.0026442. 

For every $1,000 increase in household expenditure per year (holding the mean value for all of the variables in the sample) the probability of loan approval decreases by 0.0026.*/

/*==============================================================================
(Q4): Test whether loan term and loan APR are jointly statistically significant.
Make sure to write the null and alternative hypotheses (not in Stata format).
==============================================================================*/

test term apr

/* H_0: beta3 = beta4 = 0
   H_1: beta3 != 0 and/or beta4 != 0
   
   p-value of Chi-squared statitic: |0.0150| < 0.05
   
   We reject the null hypothesis of no joint statitiscal significance. 
   
   We accept the alternate hypothesis and conclude that loan term and loan apr are jointly statistically significant.  */

/*==============================================================================
(Q5): What is the predicted probability of loan approval for someone who has
never filed for bankruptcy, has $25,000 in yearly household expenditures,
wants a 360 month term mortgage at $205 APR, is not Black, and is not Hispanic?
==============================================================================*/

probit approve i.bankruptcy c.hh_expenditures c.term c.apr i.black i.hisp, robust

scalar yhat_nonblack = _b[_cons] + _b[hh_expenditures]*25 + _b[term]*360 + _b[apr]*205

display yhat_nonblack

/* The standard normal distribution for Phi coefficient 1.45 is 0.92647. */

display normprob(_b[_cons] +_b[hh_expenditures]*25 + _b[term]*360 + _b[apr]*205)

/* The predicted probability of loan approval for someone with these charecteristics is 0.926. */

/*==============================================================================
(Q6) What is the relationship between being Black and home loan approval for an
applicant with otherwise the same characteristics as the applicant in (Q5)?

Calculate the result by hand first, and then use Stata to confirm.
==============================================================================*/

scalar yhat_nonblack = _b[_cons] + _b[hh_expenditures]*25 + _b[term]*360 + _b[apr]*205 + _b[1.black]

display yhat_nonblack

/* The standard normal distribution for Phi coefficient 0.73 is 0.76730. 

The predicted probability of home loan approval for a Black applicant with otherwise the same characteristics in (Q5) is 0.767.*/

display normprob(_b[_cons] + _b[hh_expenditures]*25 + _b[term]*360 + _b[apr]*205 + _b[1.black])

/* Black applicants: 0.767 
   Non-Black applicants: 0.926

   0.767 - 0.926 = -0.159 
   
The difference in loan approval probability for two applicants with the same characteristics where one person is Black and the other is not Black is 0.159. */

margins, dydx(_all) at(bankruptcy=0 hh_expenditures=25 term=360 apr=205 black=0 hisp=0)

/* dy/dx for Black applicant: -0.1567752

There seems to be a negative relationship with being Black and approved for a home loan. The probability of a Black applicant being approved for a loan is 0.157 lower than a non-Black applicant with the same chacteristics. */

/*==============================================================================
(Q7) Now estimate a logit model where Y=approve and include the following Xs:
X1=gdlin
X2=hh_expenditures
X3=black
X4=Hispanic

What is the marginal effect of household expenditures on loan approval 
probability for someone who meets the loan guidelines, has $30,000 per year
in expenditures, is not Black, and is Hispanic?
==============================================================================*/

logit approve i.gdlin c.hh_expenditures i.black i.hisp, robust

margins, dydx(hh_expenditures) at (gdlin=1 hh_expenditures=30 black=0 hisp=1)

/* The marginal effect of household expenditures on loan approval probbability is -0.0021328 for an applicant with these characteristics.

For every $1,000 increase in household expenditure per year, the probabilty of loan approval decreases by 0.0021 for an applicant with these characteristics. */

/*==============================================================================
(Q8) Is the marginal effect of household expenditures in (Q7) statistically
significant?
==============================================================================*/

/* H_0: beta2 = 0
   H_1: beta2 != 0
   
   t-test = |-1.14| < 1.96
   
   We fail to reject the null hypothesis at the 5% significance level. We conclude that the marginal effect of household expenditures in (Q7) is not statistically significant. */

/*==============================================================================
(Q9) What is the predicted probability of loan approval for a person with the
characteristics described in (Q7)?

Please calculate by hand. Then you may use Stata to confirm.
==============================================================================*/

scalar yhat_hisp = _b[_cons] + _b[1.gdlin] + _b[hh_expenditures]*30 + _b[1.hisp]

display yhat_hisp

/* 1/(1+e^-1.85) = 0.86

The predicted probability of loan approval for an applicant with the characteristics described in (Q7) is 0.86. */

display 1/[1+exp(-1*(_b[_cons]+_b[1.gdlin]+_b[hh_expenditures]*30+_b[1.hisp]))]

/*==============================================================================
(Q10) What is the predicted probability of loan approval for a person with the
same characteristics as described in (Q7), except the person is non-Hispanic?

Please calculate by hand.
==============================================================================*/

scalar yhat_nonhisp = _b[_cons] + _b[1.gdlin] + _b[hh_expenditures]*30

display yhat_nonhisp

/* 1/(1+e^-2.82) = 0.94

The predicated probability of loan approval for a Non-Hispanic person with the same characteristics described in (Q7) is 0.94. */

display 1/[1+exp(-1*(_b[_cons]+_b[1.gdlin]+_b[hh_expenditures]*30))]

/* Hispanic applicant: 0.86
   Non-Hispanic Applicant: 0.94

   0.86 - 0.94 = -0.08 

The difference in loan approval probability between two applicants with the same characteristics where one person is Hispanic and the other one is Non-Hispanic is 0.08. */

margins, dydx(hisp) at(gdlin=1 hh_expenditures=30 black=0 hisp=1)

/* dy/dx for Hispanic applicant: -.0800818

Therefore, according to our estimation model, the probability of a Hispanic applicant being approved for a loan is 0.08 lower than a non-Hispanic applicant.*/

/*==============================================================================
(Q11) Based on your answers to the questions in this project, do you think there
is discrimination in the market for home loans?
==============================================================================*/

/* Based on the answers to the questions in this project, it seems that there is some discrimination in the market for home loans. Primarily, there seems to be a bias against Hispanic and Black applicants. 

We simulated models by changing the characteristics of applicants such as if the applicant has filed bankruptcy before, their household expenditures and the borrowing guidelines. We then compared the models from hispanic applicants to non-Hispanic applicants, and black applicants to non-Black applicants and the difference suggests that Hispanic and Black applicants are less likely to be approved for a loan possessing the same characteristics as their non-Black or non-Hispanic counterparts. 

However, we should also note that there are other variables we may not have accounted for in our sample, and therefore, this result could also be the cause of ommited variable bias. For example, credit history, capital, and work history may be some other factors that lenders look into when approving someone for a loan. In order to get a more accurate estimate from out models we may need more information regarding the applicants. 

Based on the project alone, it seems to be that Black and Hispanic applicants face discrimication in the loan approval process.   

/*==============================================================================
==============================================================================*/

