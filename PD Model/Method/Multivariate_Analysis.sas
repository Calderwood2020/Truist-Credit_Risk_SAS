/* Author: Arjav */
/* Purpose: Univariate analysis for all variables */






/* %let var = loan_id orig_amt orig_dte oltv dti GDP HS UMP Permits Payrolls; */
/*   proc sort data = PD_DATA.data(keep = loan_id &driver final_stat) out = uni tagsort; */
/*     by loan_id; */
/*   run; */


%let xlvar = Orig_amt oltv dti Cscore_b Curr_rte Loan_age CLTV ;
%let xmvar =  HS GDP UMP Rate PPI Permits Payroll HPI ;
%let xtrans = Rate_MDT HS_MDT UMP_MDT PPI_MDT HOP_MDT ;
%let xvar = Orig_amt oltv dti Cscore_b Curr_rte Loan_age CLTV Rate GDP HS UMP PPI Permits Payroll HPI Rate_MDT HS_MDT UMP_MDT PPI_MDT HOP_MDT;
%let tempvar = Orig_amt oltv dti Cscore_b Curr_rte Loan_age CLTV Rate_MDT HS_MDT UMP_MDT PPI_MDT HOP_MDT;



%let portion = 0.1;
%let n_seed = 7919; 
proc surveyselect data = PD_DATA.data (keep = loan_id &xmvar)
  noprint
  method = SRS
  out = temp_macro 
  rate = &portion
  seed = &n_seed;
run;
  
  
/* Standardizing the Macros   */

proc standard data = temp_macro  mean = 0 std = 1 out = xyz ;
run;

/* Finding correlation in the data since different units*/

/* Correlation for all variables */
proc corr data = temp_macro plots = none  pearson ;
var &xvar ;
run;

/* Correlation for transfromed macrovariables with loan level drivers */

proc corr data = temp_macro plots = none  pearson ;
var &tempvar ;
run;

/* Correlation for all macrovariables */

proc corr data = temp_macro plots = none  pearson ;
var &xmvar ;
run;


/* n PLOTS=SCORE(ELLIPSE NCOMP=3)  */
/* Principal Component Analysis */

proc standard data = temp_macro  mean = 0 std = 1 out = xyz ;
run;

proc princomp data = xyz out = PCA plots(ncomp = 3) = all n = 3 standard;
var &xmvar;
run;

proc plot data = PCA;
plot prin3*prin2  ;
run;

proc print data = PCA (obs=100);
run;



/* Factor Analysis */

proc factor data = xyz 
method = principal
priors= one
rotate = none 
scree;
var &xmvar;
run;


proc factor data = xyz 
method = principal
priors= one
nfactors = 3
rotate = none
fuzz = 0.3
outstat = Macros_variables
plot nplot = 3 
out = abc;
var &xmvar;
run;






/*    */
/*   data tmp; */
/*     set uni; */
/*     by loan_id; */
/*     if first.loan_id; */
/*     if final_stat = "SDQ" then def_flg = 1; */
/*       else def_flg = 0; */
/*     keep &driver loan_id def_flg; */
/*   run; */
/*    */
/*  */
/*   ods output CrossTabFreqs = tmp2; */
/*   proc freq data = tmp; */
/*     table &driver.*def_flg; */
/*   run; */
/*  */
/*    */
/*   data tmp2(keep = &driver rowpercent); */
/*     label rowpercent = "Probability of Default (%)"; */
/*     set tmp2; */
/*     if def_flg = 1 & _type_ = "11"; */
/*   run; */
/*    */
/*   ods powerpoint exclude none; */
/*    */
/*   title "Scatter Plots of PD by &n_driver"; */
/*   proc sgscatter data = tmp2; */
/*     compare X = &driver Y = rowpercent / grid; */
/*   run; */
/*   title; */
/*    */
/*   title "Univariate Analysis of &n_driver"; */
/*   proc univariate data = tmp; */
/*   var &driver; */
/*   ods select Moments BasicMeasures ExtremeObs MissingValues; */
/*   run; */
/*   title; */
/*    */
/*   ods powerpoint exclude all; */
/* %mend loan_analysis; */
/*  */
/*  */
/*  */
/* %macro macro_analysis(driver, n_driver); */
/*    */
/*   proc sort data = DATA.macros(keep = date &driver) out = work.macros; */
/*     by date; */
/*   run; */
/*    */
/*   data tmp; */
/*     merge work.pd work.macros(rename = (date = act_date)); */
/*     by act_date; */
/*   run; */
/*    */
/*   ods powerpoint exclude none; */
/*   title "Scatter Plots of PD by &n_driver"; */
/*   proc sgscatter data = tmp; */
/*     compare X = &driver Y = rowpercent / grid; */
/*   run; */
/*   title;   */
/*   ods powerpoint exclude all; */
/* %mend macro_analysis; */
/*  */
/*  */
/* %macro scatterloop; */
/*   %loan_analysis(oltv, LTV); */
/*   %loan_analysis(dti, DTI); */
/*   %loan_analysis(cscore_b, FICO); */
/*   %loan_analysis(fico, FICO2); */
/*   %loan_analysis(loan_age, MOB); */
/*    */
/*    */
/*   * Historical PD; */
/*   ods powerpoint exclude all; */
/*   proc sort data = PD_DATA.data(keep = act_date curr_stat) out = uni; */
/*     by act_date; */
/*   run; */
/*    */
/*   data uni; */
/*     set uni; */
/*     if curr_stat = "SDQ" then def_flg = 1; */
/*       else def_flg = 0; */
/*     keep act_date def_flg; */
/*   run; */
/*  */
/*   ods output CrossTabFreqs = tmp; */
/*   proc freq data = uni; */
/*     table act_date*def_flg; */
/*   run; */
/*  */
/*   data pd(keep = act_date rowpercent); */
/*     set tmp; */
/*     label rowpercent = "Probability of Default (%)"; */
/*     if def_flg = 1 & _type_ = "11"; */
/*   run; */
/*    */
/*   ods powerpoint exclude none; */
/*   title "Scatter Plots of PD"; */
/*   proc sgscatter data = pd; */
/*     compare X = act_date Y = rowpercent / grid; */
/*   run; */
/*   title; */
/*   ods powerpoint exclude all; */
/*    */
/*    */
/*   %macro_analysis(hs_mdt, HS); */
/*   %macro_analysis(hs, HS); */
/*   %macro_analysis(ump_mdt, UMP); */
/*   %macro_analysis(ump, UMP); */
/*   %macro_analysis(ppi_mdt, PPI); */
/*   %macro_analysis(ppi, PPI); */
/*   %macro_analysis(gdp, GDP); */
/*   %macro_analysis(rate_mdt, Rate); */
/*   %macro_analysis(rate, Rate); */
/*   %macro_analysis(tnf_mdt, TNF); */
/* %mend scatterloop; */
/*  */
/* %scatterloop; */
/*  */
/* ods powerpoint close; */