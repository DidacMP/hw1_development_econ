
/* Questions:
- Which is better for consumption? nrrexp30 or cpexp30?

*/

clear all
* Set your own directory 
global main "C:\Users\Didac\Desktop\development_econ_hw1\"
cd "$main"



********************************* Consumption **********************************
use "raw_data\UNPS_2013-14_Consumption_Aggregate.dta"
keep HHID nrrexp30 cpexp30 wgt_X
save "cleaned_data\cons", replace




************************************ Income ************************************






************************************ Wealth ************************************

* W.1. House and other durables *
use "raw_data\GSEC14A.dta", clear
keep HHID h14q2 h14q5


keep if h14q2 == House



















