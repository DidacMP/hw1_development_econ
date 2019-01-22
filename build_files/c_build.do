/*Questions:
- consumption why divide by size? Don't we want hh consumption? Unit observation is Household
*/


clear all
global main "C:\Users\Didac\Desktop\development_econ_hw1\" //Set your directory!
cd "$main"

********************************* Consumption **********************************
use "raw_data\UNPS_2013-14_Consumption_Aggregate.dta"
gen C = cpexp30*12  // Anualize and correct by size
label var C "Consumption"

keep C HHID district_code urban ea region regurb wgt_X hsize
save "cleaned_data\C.dta", replace
