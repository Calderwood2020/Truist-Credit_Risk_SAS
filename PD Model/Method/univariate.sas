/* Author: Jonas */
/* Purpose: Univariate analysis for all variables */




ods powerpoint file = "&p_report/_summary.ppt"
               style = Sapphire;

ods graphics on / width=4in height=4in;


%macro loan_analysis(driver, n_driver);

  ods powerpoint exclude all;
  proc sort data = PD_DATA.data(keep = loan_id &driver final_stat) out = uni;
    by loan_id;
  run;
  
  
  data tmp;
    set uni;
    by loan_id;
    if first.loan_id;
    if final_stat = "SDQ" then def_flg = 1;
      else def_flg = 0;
    keep &driver loan_id def_flg;
  run;
  

  ods output CrossTabFreqs = tmp2;
  proc freq data = tmp;
    table &driver.*def_flg;
  run;

  
  data tmp2(keep = &driver rowpercent);
    label rowpercent = "Probability of Default (%)";
    set tmp2;
    if def_flg = 1 & _type_ = "11";
  run;
  
  ods powerpoint exclude none;
  
  title "Scatter Plots of PD by &n_driver";
  proc sgscatter data = tmp2;
    compare X = &driver Y = rowpercent / grid;
  run;
  title;
  
/*   title "Univariate Analysis of &n_driver"; */
/*   proc univariate data = tmp; */
/*   var &driver; */
/*   ods select Moments BasicMeasures ExtremeObs MissingValues; */
/*   run; */
/*   title; */
  
  ods powerpoint exclude all;
%mend loan_analysis;



%macro macro_analysis(driver, n_driver);
  
  proc sort data = DATA.macros(keep = date &driver) out = work.macros;
    by date;
  run;
  
  data tmp;
    merge work.pd work.macros(rename = (date = act_date));
    by act_date;
  run;
  
  ods powerpoint exclude none;
  title "Scatter Plots of PD by &n_driver";
  proc sgscatter data = tmp;
    compare X = &driver Y = rowpercent / grid;
  run;
  title;  
  ods powerpoint exclude all;
%mend macro_analysis;


%macro scatterloop;
  %loan_analysis(oltv, LTV);
  %loan_analysis(dti, DTI);
  %loan_analysis(cscore_b, FICO);
  %loan_analysis(fico, FICO2);
  %loan_analysis(loan_age, MOB);
  
  
  * Historical PD;
  ods powerpoint exclude all;
  proc sort data = PD_DATA.data(keep = act_date curr_stat) out = uni;
    by act_date;
  run;
  
  data uni;
    set uni;
    if curr_stat = "SDQ" then def_flg = 1;
      else def_flg = 0;
    keep act_date def_flg;
  run;

  ods output CrossTabFreqs = tmp;
  proc freq data = uni;
    table act_date*def_flg;
  run;

  data pd(keep = act_date rowpercent);
    set tmp;
    label rowpercent = "Probability of Default (%)";
    if def_flg = 1 & _type_ = "11";
  run;
  
  ods powerpoint exclude none;
  title "Scatter Plots of PD";
  proc sgscatter data = pd;
    compare X = act_date Y = rowpercent / grid;
  run;
  title;
  ods powerpoint exclude all;
  
  
  %macro_analysis(hs_mdt, HS);
  %macro_analysis(hs, HS);
  %macro_analysis(ump_mdt, UMP);
  %macro_analysis(ump, UMP);
  %macro_analysis(ppi_mdt, PPI);
  %macro_analysis(ppi, PPI);
  %macro_analysis(gdp, GDP);
  %macro_analysis(rate_mdt, Rate);
  %macro_analysis(rate, Rate);
  %macro_analysis(tnf_mdt, TNF);
%mend scatterloop;

%scatterloop;

ods powerpoint close;