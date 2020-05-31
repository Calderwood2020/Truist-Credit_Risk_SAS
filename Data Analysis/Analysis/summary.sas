/* Author: Jonas */
/* Purpose: Example of Statistics analysis on 2005Q1 data */

%let _date = 2005Q1;
%let d_comb = COMB.COMB_&_date;
%let v_comb = orig_amt oltv cscore_b dti last_upb;

options nodate;

ods pdf file = "&p_data.Contents.pdf"
        style = Sapphire;

title "Content Table";
proc contents data = &d_comb varnum;
  ods select Position;
  ods output Position = content;
run;
title;

ods pdf close;

/*
● Unpaid Balance (UPB)
● LTV
● Loan Age
● Remaining Until Maturity
● Interest Rate
● Delinquency Status
● Debt-to-Income (DTI)
*/

ods output MissingValues = miss_value;
proc univariate data = &d_comb;
  var &v_comb;
run;

data content(rename = (variable = varname));
  set content(keep = variable label);
run;

proc sort data = content;
  by varname;
run;


proc sort data = miss_value;
  by varname;
run;

data tmp;
  merge miss_value(keep = varname count countnobs
                   in = miss)
        content;
  by varname;
  if miss;
run;

ods pdf file = "&p_data.Summaries.pdf"
        style = Sapphire
        startpage = never;
options orientation = landscape;

title "Statistics Summaries of &_date Data";

proc means data = &d_comb
  min mean median mode max std range
  maxdec = 0
  nmiss;
  var &v_comb;
run;

options orientation = portrait;

title2 "Missing Data Values";
proc sql;
  select varname "Variable Name", label "Label",
         count "Frequency of Missing Values",
         countnobs "Percent of Total Observations"
    from tmp;
quit;

title2 "Frequencies of Last Status";
proc freq data = &d_comb;
  tables last_stat;
run;
title;
ods pdf close;



%let id01 = %nrstr(1YqgLuVYbwK8LQGL05yiDLzt-PchZN751);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id01;
  filename url_file url "&_url";
  
  data Housing_Starts;
    infile url_file  missover dsd firstobs=2;
    input date :$10. HousingSt_Var;
    logvar = log(HousingSt_Var);
  run;
   
   
   %let id05 = %nrstr(1iDdiHWP7ihEtEh1zED3XQup0ksdNmK_J);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id05;
  filename url_file url "&_url";
  
  data TNFPayrolls ( drop = lagvar1 );
  	infile url_file missover dsd;
  	input date :$10. Payrolls;
  	lagvar1 = lag(Payrolls) ;
  	lagvar12 = lag12(Payrolls);
  	logP = log(Payrolls); /*Log transformation*/
  	MGT = log ( Payrolls / lagvar1 ) /*Monthly Growth Transformation ( ln(Xt / Xt-1) )*/ 
  	AGT = log ( Payrolls / lagvar12 ) /*Annual Growth Transformation ( ln(Xt / Xt-12) ) */
  	MRT = ( Payrolls / lagvar1 ) /* Monthly Return Transformation ( Xt / Xt-1 ) */
  	ART = ( Payrolls / lagvar12 ) /* Annual Return Transformation (Xt / Xt-12 ) */
  	MDT = dif(Payrolls) /* Monthly Difference Transformation */	
  	pctchng = ( ( Payrolls / lag( Payrolls ) ) ** 12 - 1 ) * 100;
  	AnnualGrowth = dif12( Payrolls ) / lag12( Payrolls ) * 100; /*compute percent change from the same period in the previous year*/
 	NewVar = Payrolls / lagvar1 ;
  run;
  
  
/* Log transformation: ln(x) */
/* Quarterly Growth transformation: ln(xt/xt-1) */
/* Annual Growth transformation: ln(xt/xt-4) */
/* Quarterly return transformation: xt / xt-1 */
/* Annual return transformation: xt / xt-4 */
/* Quarterly difference transformation: xt - xt-1 */
/* Annual difference transformation: xt - xt-4 */


proc univariate data = Housing_Starts normal  ; 
histogram HousingSt_Var / normal;
run;

proc means data = Housing_Starts
  min mean median mode max std range
  maxdec = 0
  nmiss;
  var HousingSt_Var;
run;



proc univariate data = TNFPayrolls normal  ; 
histogram pctchng / normal;
run;

proc means data = TNFPayrolls
  min mean median mode max std range
  maxdec = 0
  nmiss;
  var Payrolls;
run;

proc sgplot data = Housing_Starts;
  	 series x = date y = logvar;
run;


 
 
/*  proc expand data = Housing_Starts out = temp1 */
/*  			 from = month to = qtr; */
/*  			 id = date; */
/*  			 convert HousingSt_Var / observed = average; */
/*  run; */

/* 3 Month - Rolling average for Housing Starts */
%let roll_num = 3;
data temp01 ;
set Housing_Starts;
array summed[&roll_num] _temporary_;
if E = &roll_num then E = 1;
   else E + 1;
summed[E] = HousingSt_Var;
if _N_ >= &roll_num then do;
      roll_avg = mean(of summed[*]);
   end;
   format roll_avg comma10.2;
run;



quit;