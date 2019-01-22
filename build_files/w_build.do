*********************************** Wealth *************************************
* Author: Dídac Martí Pinto
* Date: 25/01/2019
* Course: Development Economics (CEMFI)
********************************************************************************

clear all
global main "C:\Users\Didac\Desktop\development_econ_hw1\" //Set your directory! 
cd "$main"


****** W.1. House and other durables *******************************************
   use "raw_data\GSEC14A.dta", replace
   gen w1_h = h14q5 // h14q5 contains sum of values (p*q) per type of asset
   replace w1_h=0 if w1_h==. 
   collapse (sum) w1_h, by(HHID) // Sum values of all assets values of each household
   rename HHID hh
  
   save "cleaned_data\w1_h_temp.dta", replace // 3119 observations, no missing. 1.03e+07=mean(w1_h)
  
  
****** W.2. Land ***************************************************************
   use "raw_data\AGSEC2B", replace
   keep if a2bq9!=. 
   /* rp = mean rental price per acre and by quality. I tried to control also by 
   land quality, but the rental price for "fair" quality farms is higher than for
   high quality. And I decided to not use land quality */
   gen rp = a2bq9/a2bq5    
   drop if rp == .
   collapse (mean) rp // rp = 69778   
   
   use "raw_data\AGSEC2A", replace
   gen w2_l = 69778 * 10 * a2aq5 // w2_l = proxy for land value. It is the 15 years income 
                  // of renting the plot of land at current mean rental prices
   collapse (sum) w2_l, by(hh)
   
   save "cleaned_data\w2_l_temp.dta", replace
   
   
****** W.3. Agricultural equipment and structure capital ***********************
   use "raw_data\AGSEC10", replace
   
   gen w3_e = a10q2
   replace w3_e = 0 if a10q2 == .
   collapse (sum) w3_e, by(hh)
   
   save "cleaned_data\w3_e_temp.dta", replace
   
   
****** W.4. Livestock **********************************************************
  * Cattle and pack animals 
   use "raw_data\AGSEC6A", replace
   egen bp = mean(a6aq13b), by(LiveStockID) // mean buying price
   replace bp = 0 if bp == .
   egen sp = mean(a6aq14b), by(LiveStockID) // mean selling price
   replace sp = 0 if sp == .
   gen p = (sp + bp) / 2 if sp!=0 & bp!=0
   replace p = sp if sp>0 & bp==0
   replace p = bp if sp==0 & bp>0
   replace p = 0 if sp==0 & bp==0
   gen w4_1_c = a6aq3a*p // Cattle value
   replace w4_1_c = 0 if w4_1_c == .
   collapse (sum) w4_1_c, by(hh)
   
   save "cleaned_data\w4_1_c_temp.dta", replace
   
  * Small animals 
   use "raw_data\AGSEC6B", replace
   egen bp = mean(a6bq13b), by(ALiveStock_Small_ID) // mean buying price
   replace bp = 0 if bp == .
   egen sp = mean(a6bq14b), by(ALiveStock_Small_ID) // mean selling price
   replace sp = 0 if sp == .
   gen p = (sp + bp) / 2 if sp!=0 & bp!=0
   replace p = sp if sp>0 & bp==0
   replace p = bp if sp==0 & bp>0
   replace p = 0 if sp==0 & bp==0
   gen w4_2_s = a6bq3a*p if a6bq3a>0 // Small animals value
   replace w4_2_s = 0 if w4_2_s == .
   collapse (sum) w4_2_s, by(hh)
   
   save "cleaned_data\w4_2_s_temp.dta", replace
   
  * Poultry and others 
   use "raw_data\AGSEC6C", replace 
   egen bp = mean(a6cq13b), by(APCode) // mean buying price
   replace bp = 0 if bp == .
   egen sp = mean(a6cq14b), by(APCode) // mean selling price
   replace sp = 0 if sp == .
   gen p = (sp + bp) / 2 if sp!=0 & bp!=0
   replace p = sp if sp>0 & bp==0
   replace p = bp if sp==0 & bp>0
   replace p = 0 if sp==0 & bp==0
   gen w4_3_p = a6cq3a*p if a6cq3a>0 // Poultry value
   replace w4_3_p = 0 if w4_3_p == .
   collapse (sum) w4_3_p, by(hh)
   
   save "cleaned_data\w4_3_p_temp.dta", replace
   
   
****** Merge all datasets *****************************************************
 
   cd "$main\cleaned_data\"
   use "w1_h_temp.dta", replace
   merge 1:1 hh using "w1_h_temp.dta"
   drop _merge
   merge 1:1 hh using "w2_l_temp.dta"
   drop _merge
   merge 1:1 hh using "w3_e_temp.dta"
   drop _merge
   merge 1:1 hh using "w4_1_c_temp.dta"
   drop _merge
   merge 1:1 hh using "w4_2_s_temp.dta"
   drop _merge
   merge 1:1 hh using "w4_3_p_temp.dta"
   drop _merge
   
   replace w1_h = 0 if w1_h == .
   replace w2_l = 0 if w2_l == .
   replace w3_e = 0 if w3_e == .
   replace w4_1_c = 0 if w4_1_c == .
   replace w4_2_s = 0 if w4_2_s == .
   replace w4_3_p = 0 if w4_3_p == .   
   
   gen W = w1_h + w2_l + w3_e + w4_1_c + w4_2_s + w4_3_p // Household total wealth
   
   save "W.dta" , replace
   rm "w1_h_temp.dta" 
   rm "w2_l_temp.dta" 
   rm "w3_e_temp.dta" 
   rm "w4_1_c_temp.dta" 
   rm "w4_2_s_temp.dta" 
   rm "w4_3_p_temp.dta"
   
   *END*
