/*==============================================================================
Title: koirala_project3.do
Author: Priya Koirala
Project: #3
==============================================================================*/

cap log close _all
clear
set more off

/*==============================================================================
 Create a log file for your results
==============================================================================*/

log using "/Users/priyakoirala/Desktop/school/econometrics/projects/project3/koirala_project3.log", name(PK) replace

/*==============================================================================
The purpose of this exercise is to show how college tuition is related to
adult men's highest education level. The hypothesis is that men pursue more 
education when tuition costs are lower.

Open the HTV.dta data set. It includes data on a random sample of men in 1991.
==============================================================================*/

use "/Users/priyakoirala/Desktop/school/econometrics/projects/project3/HTV.dta"

/*==============================================================================
(Q1): Use Stata's "sum, detail" command to show more detailed summary statistics 
for the tuit18 variable. Tuit18 is the average annual tuition (measured in $1000s)
at nearby colleges when the men are 18 years old.

What is the 75th percentile of college tuition in the sample? What does it mean?
==============================================================================*/

sum tuit18, detail

/* The 75th percentile of college tuition in the sample is $11,155.03. It means that 75% of the men who were sampled have college tuition expenses that are either equal or lower than this value. */

/*==============================================================================
(Q2): Estimate a multivariable regression relating men's level of education 
(Y=educ) to nearby college tuition at age 18 (X1=tuit18), their mother's 
education (X2=motheduc), their father's education (X3=fatheduc), a binary 
variable that equals 1 if they lived in the Northeastern US at age 18 (X4=ne18), 
a binary variable that equals 1 if they lived in the North-central US at age 18 
(X5=nc18), and a binary variable that equals 1 if they lived in the Southern US 
at age 18 (X6=south18). Note that all men lived either in the Northeast US, the 
North-central US, the Western US, or the Southern US.

Use heteroskedasticity-robust standard errors. 

Interpret beta1hat in a sentence.
==============================================================================*/

reg educ tuit18 motheduc fatheduc ne18 nc18 south18, robust

di e(r2_a)

sum

/* beta1hat is -0.0099148

Other variables held constant, on average, it is estimated that for every $1000 increase in tution, the level of education for the men in the sample decreases by approximately 0.01 percentage points. */

/*==============================================================================
(Q3): Are the errors likely to be normally distributed in the model in (Q2)?
Why would it matter?
==============================================================================*/

histogram educ 

graph export "/Users/priyakoirala/Desktop/school/econometrics/projects/project3/Graph1_project3.pdf"

histogram tuit18

graph export "/Users/priyakoirala/Desktop/school/econometrics/projects/project3/Graph2_project3.pdf"

/* The errors are unlikely to be normally ditributed in the model in (Q2). When we make histogram of the educ variable, we can see that there is a high level of density at the 12 grade level. When we make a histogram of the tuit18, variable we can see that there is skew on the left side of the graph. The data does not follow a bell shaped curve, which is associaciated with a normal distrubution.

The assumption that errors are distributed normally matters because, although the assumption is not required for calculating unbiased estimates, checking the data distribution allows us a better understanding of our data. It allows us insight to any outliers we may have missed, or any other factors which could possibly have caused an extreme deviation in the data. If our data is way beyond the range of a "normal distribution", it could be difficult to draw a valid conclusion from our statistical infrences in the regression model. 

However, the normality assumption is not necessary for the validity of our regression model as data can naturally vary. Presumably, most adult men have completed some form of high school therefore, there is higher density at that grade level. In addition, it would make sense that there is a skew towards the left side regarding tuition, as there is a smaller population of people who can afford extremely high tuition costs. */                                 

/*==============================================================================
(Q4): Interpret beta6hat in a sentence.
==============================================================================*/

/* beta6hat is 0.2062903.

This means that, all other variables held constant, it is estimated that for men aged 18 who lived in the southern region of the United States, on average, had 0.21 more years of education than men who lived in the western (reference) region of the United States. */

/*==============================================================================
(Q5): Why is the variable West excluded from the model in (Q2)?
==============================================================================*/

/* The variable West is excluded from the model in (Q2) because it is used as a reference for the three binary region variables (ne18, nc18, south18) which are included in the model. If we were to include all four regional variables, the regression would result in perfect multicollinearity, which would not allow us to gain an accurate estimate of the regression coefficients. Though perfect multicollionearity itself does not generate bias in out model, it makes it difficult to interpret the regression coefficients as it inflates the standard errors of our estimates. It also makes it more difficult to identify the independent variables that are statistically significant. */

/*==============================================================================
(Q6) Test the joint statistical significance of beta4, beta5, and 
beta6. Use alpha=0.05. Write down the null and alternative hypotheses. How many 
restrictions are there? What do you conclude?
==============================================================================*/

test ne18 nc18 south18

/* H_0: beta4 = beta5 = beta6 = 0
   H_1: beta5 != 0 &/or beta5 !=0 &/or beta6 = !0
   
   This hypotheses test has three restictions.
   
   P-value for the F statistic = 0.0483 < 0.05
   
We reject the null hypothesis of no statistical significance at the 5% level and we accept the alternate hypothesis that beta4 beta5 and beta6 are jointly statistically significant. 

We conclude that the geographic locations Northeastern US, North-central US, and Southern US where men aged 18 attended college explains the variance in adult men's highest education level. We should keep the variables in the model. */
   
/*==============================================================================
(Q7) Add the variable abil (a measure of cognitive ability) to the model from 
(Q2). Does ability help explain the variation in education, even after 
controlling for tuition, parents’ education, and geographic region? Use at 
least one test statistic to justify your answer.
==============================================================================*/

reg educ tuit18 motheduc fatheduc ne18 nc18 south18 abil, robust

di e(r2_a)

/* Yes, the variable abil explains the variation in education, even after controlling for tuition, parent's education, and gegraphic region. I.e., beta7 is statistically significant.  

The adjusted R2 increases from 0.25920 in Q2 to 0.42601 when we add the variable abil. A higher adjusted R2 means that the model has improved.

H_0: beta7 = 0
H_1: beta1 != 0 

t-statistic = (beta7hat-0)/std error of beta7hat
			= 0.490 / 0.028
			= |17.5| > 2.9
			= critical value for two sided alternative where alpha = 0.05
			
So using t-statistic, we reject the null hypothesis of no statistical significance at the 5%. We conclude that a measure of cognitive ability is useful in determining adult men's highest education level. We should keep the variable abil in the model. */

/*==============================================================================
(Q8) Compare the coefficient estimates from the model in (Q2) to the estimates 
obtained from the model in (Q7). What do the differences tell us about omitted 
variable bias in the model in (Q2)?
==============================================================================*/

/* Ommiting a variable can lead to either an overestimation or underestimation of the coefficient of our independent variable. The coeffecients become unreiable, preventing the estimator from converging a probability to the true parameter value. 
					   
As we can see in the model from Q2, beta1hat has decreased from -0.00991 to -0.01896, beta2hat decreased from 0.31985 to 0.19922, beta3hat decreased from 0.17717 to 0.10496, beta4hat decreased from 0.77052 to 0.67772, beta5hat from 0.54084 to 0.46656, beta6hat increased from 0.020629 to 0.26070. 

These coeffiecents suggests that there was previously an upwards bias in our model in Q2, which has been corrected with the addition of the variable abil to the model in Q7. */

/*==============================================================================
(Q9) Test whether the relationship between father's education and adult son's 
education is the same as the relationship between mother's education and 
adult son's education. Use alpha=0.05. Write down the null and alternative 
hypotheses. How many restrictions are there? What do you conclude?
==============================================================================*/

test motheduc - fatheduc = 0

/* H_0: beta2 - beta3 = 0
   H_1: beta2 != 0 &/or beta3 != 0

   This hypotheses test has one restriction.
   
   P-value for the F-statistic: |0.0483| < 0.05

We reject the null hypothesis of no statistical significance at the 5% level. We conclude that the relationship between mother's education and adult son's education differs from the relationship between father's education and adult son's education. We should keep both variables in the estimate. */

/*==============================================================================
(Q10) Consider the variable called tuit17, which is the average tuition of 
nearby colleges when the men are 17 years old. Should we add this variable to 
the model in (Q7)? Why or why not?
==============================================================================*/

reg educ tuit18 motheduc fatheduc ne18 nc18 south18 abil tuit17, r

di e(r2_a)

/* No, we should not include the tuit17 variable into the model in (Q7), When we add variable tuit17 to our model, our adjusted r squared slightly decreases from 0.4260 to 0.4255 which suggests that the model is not a good fit. */

corre tuit17 tuit18 motheduc fatheduc ne18 nc18 south18 abil

/* Additionally, based on the data above, the correlation coeffecient between tuit17 and tuit18 is 0.9803.

This means that there is an extremely high correlation between tutiton for men aged 17 and tuition for men aged 18. By including both variables into the model, we risk having imperfect multicollinearity. Though imperfect multicollionearity itself does not generate bias in out model, it makes it difficult to interpret the regression coefficients as it inflates the standard errors of our estimates. It also makes it more difficult to identify the independent variables that are statistically significant.

For example, in the regression model in (Q7) the standard error for tuit18 is 0.0209396. However when we add tuit17 to the same regression model, we can see that the standard error for tuit18 nearly doubles to 0.0508123.

In order to avoid multicollinearity, the model should probablt only contain one of the variables, tuti17 is too similar to the variable tuit18, which essentially measures the same thing (tuition for men). */

/*==============================================================================
==============================================================================*/

cap log close _all
