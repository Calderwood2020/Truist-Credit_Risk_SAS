/*  Author : Arjav Mehta
Macroeconomic Variables Analysis */
 

/* Housing Starts (Monthly)  */

  %let id01 = %nrstr(1YqgLuVYbwK8LQGL05yiDLzt-PchZN751);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id01;
  filename url_file url "&_url";
  
  data Housing_Starts ( drop = lagvar1 lagvar12 chardate ) ;
    infile url_file  missover dsd firstobs=2;
    input chardate :$10. HousingSt_Var;
    date = input(chardate,yymmdd10.);
    label
    HousingSt_Var = "Housing Starts"
  	logP_HS = "Log Transformation"
  	MGT_HS = "Monthly Growth Transformation"
  	AGT_HS = "Annual Growth Transformation"
  	MRT_HS = "Monthly Return Transformation"
  	ART_HS = "Annual Return Transformation"
  	MDT_HS = "Monthly Difference Transformation"
  	Percent_Change_HS = "Percetnage Change"
  	AG_HS = "Annual Growth in Percent"
  	;
  	format logP_HS MGT_HS AGT_HS MRT_HS ART_HS MDT_HS comma10.5 Percent_Change_HS AG_HS percent10.2 date mmddyy10.;
  	lagvar1 = lag(HousingSt_Var) ;
  	lagvar12 = lag12(HousingSt_Var);
  	logP_HS = log(HousingSt_Var); /*Log transformation*/
  	MGT_HS = log ( HousingSt_Var / lagvar1 ); /*Monthly Growth Transformation ( ln(Xt / Xt-1) )*/ 
  	AGT_HS = log ( HousingSt_Var / lagvar12 ); /*Annual Growth Transformation ( ln(Xt / Xt-12) ) */
  	MRT_HS = ( HousingSt_Var / lagvar1 ) ;/* Monthly Return Transformation ( Xt / Xt-1 ) */
  	ART_HS = ( HousingSt_Var / lagvar12 ) ;/* Annual Return Transformation (Xt / Xt-12 ) */
  	MDT_HS = dif(lag(HousingSt_Var)); /* Monthly Difference Transformation ( Xt - Xt-1 ) */	
  	Percent_Change_HS = ( ( HousingSt_Var / lag( HousingSt_Var ) ) ** 12 - 1 ) * 100;
  	AG_HS = dif12( HousingSt_Var ) / lag12( HousingSt_Var ) * 100; /*computed percent change from the same period in the previous year*/
  run;
  
  
  proc print data = Housing_Starts label;
 run;
  

/*   Univariate analysis for various variables */
title "Univariate Analysis for Housing Starts";
proc univariate data = Housing_Starts plot normaltest  ; 
var HousingSt_Var MDT_HS;
histogram / normal;
inset mean median skewness/position = ne;
run;
title;





/* US GDP (Quarterly) */

  %let id02 = %nrstr(1Pyf8AO44zzDxDUfSWdwi4Bi4wUNhybgb);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id02;
  filename url_file url "&_url";
  
  data GDP (drop = chardate lagvar1 lagvar12 );
  	infile url_file missover dsd  firstobs = 2;
  	input chardate :$10. GDP_Var;
  	date = input(chardate , mmddyy10.);
  	label 
  	GDP_Var = "US GDP"
  	logP_GDP = "Log Transformation"
  	MGT_GDP = "Monthly Growth Transformation"
  	AGT_GDP = "Annual Growth Transformation"
  	MRT_GDP = "Monthly Return Transformation"
  	ART_GDP = "Annual Return Transformation"
  	MDT_GDP = "Monthly Difference Transformation"
  	pctchng_GDP = "Percentage Change"
  	AG_GDP = "Annual Growth in Percent"
  	;
  	format logP_GDP MGT_GDP AGT_GDP MRT_GDP ART_GDP MDT_GDP comma10.5 pctchng_GDP AG_GDP percent10.2 date mmddyy10.;
  	lagvar1 = lag(GDP_Var) ;
  	lagvar12 = lag12(GDP_Var);
  	logP_GDP = log(GDP_Var); /*Log transformation */
  	MGT_GDP = log ( GDP_Var / lagvar1 ); /*Quarterly Growth Transformation ( ln(Xt / Xt-1) ) */
  	AGT_GDP = log ( GDP_Var / lagvar12 ); /*Annual Growth Transformation ( ln(Xt / Xt-4) )*/
  	MRT_GDP= ( GDP_Var / lagvar1 ) ;/* Quarterly Return Transformation ( Xt / Xt-1 )*/
  	ART_GDP = ( GDP_Var / lagvar1 ) ;/* Annual Return Transformation (Xt / Xt-4 )*/
  	MDT_GDP = dif(lag(GDP_Var)); /* Quarterly Difference Transformation ( Xt - Xt-1 ) */	
  	pctchng_GDP = ( ( GDP_Var / lag( GDP_Var ) ) ** 12 - 1 ) * 100; 
  	AG_GDP = dif12( GDP_Var ) / lag12( GDP_Var ) * 100; /*computed percent change from the same period in the previous year*/
  run;
  
/*   Univariate Analysis for GDP */
title "Univariate Analysis for GDP";
proc univariate data = GDP plot normaltest  ; 
var logP_GDP AG_GDP MDT_GDP MGT_GDP;
histogram / normal;
inset mean median skewness/position = ne;
run;
title;


/* Unemployment (Monthly) */
  
  %let id03 = %nrstr(1d_FSMP5r5xM5F3LMY46UZuEwHw9m5weG);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id03;
  filename url_file url "&_url";
  
  data Unemployment (Drop = chardate lagvar1 lagvar12);
  	infile url_file missover dsd firstobs= 2;
  	input chardate:$10. Unemp_Var;
  	date = input(chardate,yymmdd10.);
  	label
  	logP_UMP = "Log Transformation"
  	MGT_UMP = "Monthly Growth Transformation"
  	AGT_UMP = "Annual Growth Transformation"
  	MRT_UMP = "Monthly Return Transformation"
  	ART_UMP = "Annual Return Transformation"
  	MDT_UMP = "Monthly Difference Transformation"
  	pctchng_UMP = "Percetnage Change"
  	AG_UMP = "Annual Growth in Percent"
  	;
  	format logP_UMP MGT_UMP AGT_UMP MRT_UMP ART_UMP MDT_UMP comma10.5 pctchng_UMP AG_UMP percentN10.2 date ddmmyy10. ;
  	lagvar1 = lag(Unemp_Var) ;
  	lagvar12 = lag12(Unemp_Var);
  	logP_UMP = log(Unemp_Var); /*Log transformation*/
  	MGT_UMP = log ( Unemp_Var / lagvar1 ); /*Monthly Growth Transformation ( ln(Xt / Xt-1) )*/ 
  	AGT_UMP = log ( Unemp_Var / lagvar12 ); /*Annual Growth Transformation ( ln(Xt / Xt-12) ) */
  	MRT_UMP = ( Unemp_Var / lagvar1 ) ;/* Monthly Return Transformation ( Xt / Xt-1 ) */
  	ART_UMP = ( Unemp_Var / lagvar12 ) ;/* Annual Return Transformation (Xt / Xt-12 ) */
  	MDT_UMP = dif(lag(Unemp_Var)); /* Monthly Difference Transformation ( Xt - Xt-1 ) */	
  	pctchng_UMP = ( ( Unemp_Var / lag( Unemp_Var ) ) ** 12 - 1 ) * 100;
  	AG_UMP = dif12( Unemp_Var ) / lag12( Unemp_Var ) * 100; /*computed percent change from the same period in the previous year*/
  run;
  
/*   Univariate Analysis for Unemployment */
title "Univariate Analysis for Unemployment";
proc univariate data = Unemployment plot normaltest  ; 
var Unemp_Var MDT_UMP;
histogram / normal;
inset mean median skewness/position = ne;
run;
title;


 proc sgscatter data=Unemployment;
 matrix Unemp_var MGT_UMP AGT_UMP / diagonal=(histogram normal);
 run;
  
   title "Scatter Plots";
  proc sgscatter data = Unemployment;
   compare X = date Y = Unemp_Var / grid;
  run;
  title;
  
  
/* Bivariate Analysis of Housing Starts and Unemployment */

  data XYZ (where = (date between '01Jan2005'd and '01Jan2020'd) );
  merge Housing_Starts Unemployment;
  by date;
  run;
  
  proc sgscatter data = XYZ ;
  compare X = HousingSt_Var Y = Unemp_Var;
  run;
  
  proc corr data = XYZ pearson rank;
  var HousingSt_Var MDT_HS;
  with Unemp_Var MDT_UMP;
  run;
  
  
/*   ####################### */
/*   MERGING UNEMP AND HOUSING STARTS */


data merged_Data  (where = (date between '01Jan2005'd and '01Jan2020'd) keep = date HousingSt_Var Rates GDP_Var Unemp_Var PPI_Var Permits Payrolls HPI_Var MDT_:);
   merge MortgageRate30 GDP Housing_Starts Unemployment ProducerPI Permits TNFPayrolls HPI;
   by date;
run;



proc contents data = merged_Data;
run;

proc print data = merged_Data label;
run;

proc export 
  data=merged_Data
  dbms=csv 
  outfile="/folders/myfolders/Truist-Credit_Risk_SAS/Macroecon_Final.csv" 
  replace;
run;

proc sgscatter data = merged_Data;
  compare X = MDT_HS Y = MDT_UMP / grid;
run;


proc sgscatter data = merged_Data;
  compare X = MDT_HS Y = MDT_UMP / grid;
  label MDT_HS= 'Monthly Diff Transformation Housing Starts' MDT_UMP = 'Monthly Diff Transformation Unemployment' ;
run;

proc corr data = merged_Data cov pearson nosimple;
var MDT_HS;
with MDT_UMP;
run;

proc corr data = merged_Data cov pearson nosimple;
var HousingSt_Var;
with Permits;
run;


/* Plot of two variables to see their trends */
proc sgplot data=merged_Data;
series x = date y = HousingSt_Var / lineattrs = (color = red thickness = 1
 pattern=solid);
series x = date y = Unemp_Var / lineattrs = (color = green thickness = 1
 pattern=solid) Y2AXIS;
xaxis label = 'Date' values=("01JAN06"d to "01JAN18"d by month) grid;
yaxis label = 'Housing Starts' grid ;
y2axis label = 'Unemployment' grid ;
run;

proc corr data = merged_Data pearson plots = none rank nosimple;
run;

/* proc gplot data = merged_Data; */
/* plot HousingSt_Var Unemp_Var; */
/* run; */

/*  */
/* proc corr spearman data = merged_Data; */
/* var HousingSt_Var Unemp_Var; */
/* run; */


proc corr data = merged_Data pearson nosimple plots = matrix (histogram) cov rank nosimple;
	var MDT_: ;	
	run;
	
	
	
%paint(values=-1 to 1 by 0.05, macro=setstyle,
       colors=CXEEEEEE red magenta blue cyan white
              cyan blue magenta red CXEEEEEE
              -1 -0.99 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 0.99 1);

proc template;
   edit Base.Corr.StackedMatrix;
      column (RowName RowLabel) (Matrix) * (Matrix2);
      edit matrix;
         %setstyle(backgroundcolor)
      end;
   end;
run;


proc corr data=merged_Data pearson nosimple;

run;

proc template;
   delete Base.Corr.StackedMatrix / store=sasuser.templat;
run;


  
  
/*   Mortgage Rates (Monthly) */
  
  %let id04 = %nrstr(1raQTrq7GdUrOMPKNzWNMboJYKpekpGmK);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id04;
  filename url_file url "&_url";
  
  data MortgageRate30 ( drop = chardate lagvar1 lagvar12) ;
  	infile url_file missover dsd firstobs= 2;
  	input chardate :$10. Rates;
  	date = input(chardate,yymmdd10.);
  	label
  	logP_Rates = "Log Transformation"
  	MGT_Rates = "Monthly Growth Transformation"
  	AGT_Rates = "Annual Growth Transformation"
  	MRT_Rates = "Monthly Return Transformation"
  	ART_Rates = "Annual Return Transformation"
  	MDT_Rates = "Monthly Difference Transformation"
  	pctchng_Rates = "Percetnage Change"
  	AG_Rates = "Annual Growth in Percent"
  	;
  	format logP_Rates MGT_Rates AGT_Rates MRT_Rates ART_Rates MDT_Rates comma10.5 pctchng_Rates AG_Rates percent10.2 date ddmmyy10.;
  	lagvar1 = lag(Rates) ;
  	lagvar12 = lag12(Rates);
  	logP_Rates = log(Rates); /*Log transformation*/
  	MGT_Rates = log ( Rates / lagvar1 ); /*Monthly Growth Transformation ( ln(Xt / Xt-1) )*/ 
  	AGT_Rates = log ( Rates / lagvar12 ); /*Annual Growth Transformation ( ln(Xt / Xt-12) ) */
  	MRT_Rates = ( Rates / lagvar1 ) ;/* Monthly Return Transformation ( Xt / Xt-1 ) */
  	ART_Rates = ( Rates / lagvar12 ) ;/* Annual Return Transformation (Xt / Xt-12 ) */
  	MDT_Rates = dif(lag(Rates)); /* Monthly Difference Transformation ( Xt - Xt-1 ) */	
  	pctchng_Rates = ( ( Rates / lag( Rates ) ) ** 12 - 1 ) * 100;
  	AG_Rates = dif12( Rates ) / lag12( Rates ) * 100; /*computed percent change from the same period in the previous year*/
  run;
  
/*   Univariate Analysis for Mortgage Rates */

title "Univariate Analysis for Mortgage Rates";
proc univariate data = MortgageRate30 plot normaltest  ; 
var Rates MDT_Rates;
histogram / normal;
inset mean median skewness/position = ne;
run;
title;
  
/*   Total Non-farm Payrolls (Monthly) */
  %let id05 = %nrstr(1-B51oVV3rNplZpm9KKG4ETjtB_uVdJC5);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id05;
  filename url_file url "&_url";
  
  data TNFPayrolls ( drop = chardate lagvar1   lagvar12 );
  	infile url_file missover dsd firstobs= 2;
  	input chardate :$10. Payrolls;
  	date = input(chardate,yymmdd10.);
    label
  	logP_TNF = "Log Transformation"
  	MGT_TNF = "Monthly Growth Transformation"
  	AGT_TNF = "Annual Growth Transformation"
  	MRT_TNF = "Monthly Return Transformation"
  	ART_TNF = "Annual Return Transformation"
  	MDT_TNF = "Monthly Difference Transformation"
  	pctchng_TNF = "Percetnage Change"
  	AG_TNF = "Annual Growth in Percent"
  	;
  	format logP_TNF MGT_TNF AGT_TNF MRT_TNF ART_TNF MDT_TNF comma10.5 pctchng_TNF AG_TNF percent10.2 date ddmmyy10.;
  	lagvar1 = lag(Payrolls) ;
  	lagvar12 = lag12(Payrolls);
  	logP_TNF = log(Payrolls); /*Log transformation*/
  	MGT_TNF = log ( Payrolls / lagvar1 ); /*Monthly Growth Transformation ( ln(Xt / Xt-1) )*/ 
  	AGT_TNF = log ( Payrolls / lagvar12 ); /*Annual Growth Transformation ( ln(Xt / Xt-12) ) */
  	MRT_TNF = ( Payrolls / lagvar1 ) ;/* Monthly Return Transformation ( Xt / Xt-1 ) */
  	ART_TNF = ( Payrolls / lagvar12 ) ;/* Annual Return Transformation (Xt / Xt-12 ) */
  	MDT_TNF = dif(lag(Payrolls)); /* Monthly Difference Transformation ( Xt - Xt-1 ) */	
  	pctchng_TNF = ( ( Payrolls / lag( Payrolls ) ) ** 12 - 1 ) * 100;
  	AG_TNF = dif12( Payrolls ) / lag12( Payrolls ) * 100; /*computed percent change from the same period in the previous year*/
  run;
  

/*   Univariate Analysis for Total Non-Farm Payrolls */
  
proc univariate data = TNFPayrolls normaltest  ; 
histogram Payrolls MRT_TNF / normal;
inset mean median skewness;
run;

proc means data = TNFPayrolls
  min mean median mode max std range
  maxdec = 0
  nmiss;
  var Payrolls;
run;
  
  
  
/*   Fed Funds Rate (Daily) */
  
  
  %let id06 = %nrstr(1o4XiUZAUk0K5eXyjyjU5jCBafpCnvcJa);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id06;
  filename url_file url "&_url";
  
  data FedFundsR;
  	infile url_file missover dsd firstobs=2;
  	input date :$10. Fed_Rate;
  run;
  
title "Univariate Analysis for Fed Rates";
proc univariate data = FedFundsR plot normaltest  ; 
var Fed_Rate;
histogram / normal;
inset mean median skewness/position = ne;
run;
title;
  
  
  
/*   Housing Permits (Monthly) */
  
  %let id07 = %nrstr(1b7mm8OMorXBobVMOV9hF_TI9ZBmwSn6-);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id07;
  filename url_file url "&_url";
  
  data Permits ( drop = chardate lagvar1 lagvar12);
  	infile url_file missover dsd firstobs= 2;
  	input chardate :$10. Permits;
    date = input(chardate,yymmdd10.);	
  	label
  	log_HOP = "Log Transformation"
  	MGT_HOP = "Monthly Growth Transformation"
  	AGT_HOP = "Annual Growth Transformation"
  	MRT_HOP = "Monthly Return Transformation"
  	ART_HOP = "Annual Return Transformation"
  	MDT_HOP = "Monthly Difference Transformation"
  	pctchng_HOP = "Percetnage Change"
  	AG_HOP = "Annual Growth in Percent"
  	;
  	format log_HOP MGT_HOP AGT_HOP MRT_HOP ART_HOP MDT_HOP comma10.5 pctchng_HOP AG_HOP percent10.2 date ddmmyy10.;
  	lagvar1 = lag(Permits) ;
  	lagvar12 = lag12(Permits);
  	log_HOP = log(Permits); /*Log transformation*/
  	MGT_HOP = log ( Permits / lagvar1 ); /*Monthly Growth Transformation ( ln(Xt / Xt-1) )*/ 
  	AGT_HOP = log ( Permits / lagvar12 ); /*Annual Growth Transformation ( ln(Xt / Xt-12) ) */
  	MRT_HOP = ( Permits / lagvar1 ) ;/* Monthly Return Transformation ( Xt / Xt-1 ) */
  	ART_HOP = ( Permits / lagvar12 ) ;/* Annual Return Transformation (Xt / Xt-12 ) */
  	MDT_HOP = dif(lag(Permits)); /* Monthly Difference Transformation ( Xt - Xt-1 ) */	
  	pctchng_HOP = ( ( Permits / lag( Permits ) ) ** 12 - 1 ) * 100;
  	AG_HOP = dif12( Permits ) / lag12( Permits ) * 100; /*computed percent change from the same period in the previous year*/
  run;
  
title "Univariate Analysis for Housing Permits ";
proc univariate data =Permits  plot normaltest  ; 
var Permits MRT_HOP ;
histogram / normal;
inset mean median skewness/position = ne;
run;
title;
  
  
  
/*   Producer Price Index (Monthly) */
   
  %let id08 = %nrstr(1sWqtgRpuOFZ6JHbIQXs399JAgcxeR5zP);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id08;
  filename url_file url "&_url";
  
  data ProducerPI(drop = chardate lagvar1 lagvar12);
  	infile url_file missover dsd firstobs=2;
  	input chardate :$10. PPI_Var;
  	date = input(chardate,yymmdd10.);
  	label
  	logP_PPI = "Log Transformation"
  	MGT_PPI = "Monthly Growth Transformation"
  	AGT_PPI = "Annual Growth Transformation"
  	MRT_PPI = "Monthly Return Transformation"
  	ART_PPI = "Annual Return Transformation"
  	MDT_PPI = "Monthly Difference Transformation"
  	pctchng_PPI = "Percetnage Change"
  	AG_PPI = "Annual Growth in Percent"
  	;
  	format logP_PPI MGT_PPI AGT_PPI MRT_PPI ART_PPI MDT_PPI comma10.5 pctchng_PPI AG_PPI percent10.2 date ddmmyy10.;
  	lagvar1 = lag(PPI_Var) ;
  	lagvar12 = lag12(PPI_Var);
  	logP_PPI = log(PPI_Var); /*Log transformation*/
  	MGT_PPI = log ( PPI_Var / lagvar1 ); /*Monthly Growth Transformation ( ln(Xt / Xt-1) )*/ 
  	AGT_PPI = log ( PPI_Var / lagvar12 ); /*Annual Growth Transformation ( ln(Xt / Xt-12) ) */
  	MRT_PPI = ( PPI_Var / lagvar1 ) ;/* Monthly Return Transformation ( Xt / Xt-1 ) */
  	ART_PPI = ( PPI_Var / lagvar12 ) ;/* Annual Return Transformation (Xt / Xt-12 ) */
  	MDT_PPI = dif(lag(PPI_Var)); /* Monthly Difference Transformation ( Xt - Xt-1 ) */	
  	pctchng_PPI = ( ( PPI_Var / lag( PPI_Var ) ) ** 12 - 1 ) * 100;
  	AG_PPI = dif12( PPI_Var ) / lag12( PPI_Var ) * 100; /*computed percent change from the same period in the previous year*/
  run;
 
 title "Univariate Analysis for Producer Price Index";
proc univariate data = ProducerPI plot normaltest  ; 
var PPI_Var MRT_PPI;
histogram / normal;
inset mean median skewness/position = ne;
run;
title;
  
 
/* Consumer Price Index (Monthly) */

  %let id09 = %nrstr(1t2sUcFeJKm4nh7s5fkb7wRGUr0to8M4t);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id09;
  filename url_file url "&_url";
  
  data ConsumerPI ( drop = chardate lagvar1 lagvar12);
  	infile url_file missover dsd firstobs=2;
  	input chardate :$10. CPI_Var;
    date = input(chardate,yymmdd10.);
  	label
  	logP_CPI = "Log Transformation"
  	MGT_CPI = "Monthly Growth Transformation"
  	AGT_CPI = "Annual Growth Transformation"
  	MRT_CPI = "Monthly Return Transformation"
  	ART_CPI = "Annual Return Transformation"
  	MDT_CPI = "Monthly Difference Transformation"
  	pctchng_CPI = "Percetnage Change"
  	AG_CPI = "Annual Growth in Percent"
  	;
  	format logP_CPI MGT_CPI AGT_CPI MRT_CPI ART_CPI MDT_CPI comma10.5 pctchng_CPI AG_CPI percent10.2 date ddmmyy10.;
  	lagvar1 = lag(CPI_Var) ;
  	lagvar12 = lag12(CPI_Var);
  	logP_CPI = log(CPI_Var); /*Log transformation*/
  	MGT_CPI = log ( CPI_Var / lagvar1 ); /*Monthly Growth Transformation ( ln(Xt / Xt-1) )*/ 
  	AGT_CPI = log ( CPI_Var / lagvar12 ); /*Annual Growth Transformation ( ln(Xt / Xt-12) ) */
  	MRT_CPI = ( CPI_Var / lagvar1 ) ;/* Monthly Return Transformation ( Xt / Xt-1 ) */
  	ART_CPI = ( CPI_Var / lagvar12 ) ;/* Annual Return Transformation (Xt / Xt-12 ) */
  	MDT_CPI = dif(lag(CPI_Var)); /* Monthly Difference Transformation ( Xt - Xt-1 ) */	
  	pctchng_CPI = ( ( CPI_Var / lag( CPI_Var ) ) ** 12 - 1 ) * 100;
  	AG_CPI = dif12( CPI_Var ) / lag12( CPI_Var ) * 100; /*computed percent change from the same period in the previous year*/
  run;
  
  
title "Univariate Analysis for Consumer Price Index";
proc univariate data = ConsumerPI plot normaltest  ; 
var CPI_Var MRT_CPI;
histogram / normal;
inset mean median skewness/position = ne;
run;
title;
  
  

/*   Housing Price Index (Monthly) */
  
  %let id010 = %nrstr(1A7XOhOGCHBizwh5_4sTNgMqYBPRVIvqH);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id010;
  filename url_file url "&_url";
  
  data HPI ( drop = chardate lagvar1 lagvar12);
  	infile url_file missover dsd firstobs=2;
  	input chardate :$10. HPI_Var;
  	date = input(chardate,yymmdd10.);
  	label
  	logP_HPI = "Log Transformation"
  	MGT_HPI = "Monthly Growth Transformation"
  	AGT_HPI = "Annual Growth Transformation"
  	MRT_HPI = "Monthly Return Transformation"
  	ART_HPI = "Annual Return Transformation"
  	MDT_HPI = "Monthly Difference Transformation"
  	pctchng_HPI = "Percetnage Change"
  	AG_HPI = "Annual Growth in Percent"
  	;
  	format logP_HPI MGT_HPI AGT_HPI MRT_HPI ART_HPI MDT_HPI comma10.5 pctchng_HPI AG_HPI percent10.2 date ddmmyy10.;
  	lagvar1 = lag(HPI_Var) ;
  	lagvar12 = lag12(HPI_Var);
  	logP_HPI = log(HPI_Var); /*Log transformation*/
  	MGT_HPI = log ( HPI_Var / lagvar1 ); /*Monthly Growth Transformation ( ln(Xt / Xt-1) )*/ 
  	AGT_HPI = log ( HPI_Var / lagvar12 ); /*Annual Growth Transformation ( ln(Xt / Xt-12) ) */
  	MRT_HPI = ( HPI_Var / lagvar1 ) ;/* Monthly Return Transformation ( Xt / Xt-1 ) */
  	ART_HPI = ( HPI_Var / lagvar12 ) ;/* Annual Return Transformation (Xt / Xt-12 ) */
  	MDT_HPI = dif(lag(HPI_Var)); /* Monthly Difference Transformation ( Xt - Xt-1 ) */	
  	pctchng_HPI = ( ( HPI_Var / lag( HPI_Var ) ) ** 12 - 1 ) * 100;
  	AG_HPI = dif12( HPI_Var ) / lag12( HPI_Var ) * 100; /*computed percent change from the same period in the previous year*/
  run;
  
  
title "Univariate Analysis for Housing Price Index";
proc univariate data = HPI plot normaltest  ; 
var HPI_Var MRT_HPI;
histogram / normal;
inset mean median skewness/position = ne;
run;
title;
  
  
  
/*   */
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



  