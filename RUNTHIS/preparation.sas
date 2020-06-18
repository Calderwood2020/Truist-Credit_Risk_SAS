/* Author: Zheng/Nishang */
/* Purpose1: Merge data sets for each quarter and generate the traning sample*/
/* Purpose2: Generate quarterly data and state variables*/


%put ------------------------------------------------------------------OPTION1;
* change the value of this macro variable: Q1-Q4;
%let quarter = Q2;

%put ------------------------------------------------------------------OPTION2;
* year range;
%let y_start = 2006;
%let y_end = 2017;



%put ------------------------------------------------------------------PROGRAM;
* genrate the name of data sets;
%let d_comb =;
%macro get_name();
  %do i = &y_start %to &y_end;
    %let d_comb = &d_comb COMB.comb_&i.&quarter;
  %end;
%mend get_name;

%get_name();
    
%put Using data sets: &d_comb;

* concatenate data sets;
data DATA.sample_&quarter;
  set &d_comb;
run;



* Prepare the data: create a new status variable;
proc sort data = DATA.sample_&quarter tagsort;
  by loan_id;
run;

data DATA.sample_&quarter tmp_id(keep = loan_id curr_stat 
                                 rename = (loan_id = _id curr_stat = Next_stat)
                                 );
  set DATA.sample_&quarter;
  attrib Curr_stat length = $3.
                   label = "Current State"
                   ;
    
    
  by loan_id;
  retain _def 0;
  retain _start;
    
  if first.loan_id then do;            
    _def = 0;
    _start = loan_age;
  end;
    
  if _def then delete;
    
  if ^_def then do;
    if dlq_stat = 0 then
      Curr_stat = "CUR";
    else if dlq_stat le 3 then
      Curr_stat = "DEL";
    else if dlq_stat = 999 and zb_code in ("01" "06") then
      Curr_stat = "PPY";
    else _def = 1;
  end;
  if _def then Curr_stat = "SDQ";
    
  if mod(loan_age - _start, 3) = 0 then output DATA.sample_&quarter tmp_id;
    else if last.loan_id then output DATA.sample_&quarter tmp_id;
    
run;

data DATA.sample_&quarter(drop = _:);
  merge DATA.sample_&quarter tmp_id(firstobs = 2);
  attrib Next_stat length = $3.
                   label = "Next State"
                   ;
  if loan_id ne _id then next_stat = "";
  drop tran_flg;
run;



%put ------------------------------------------------------------------STACK;
%macro merge();

  * Stacking all the sample dataset;
  data DATA.sample;
    set DATA.sample_q1 DATA.sample_q2 DATA.sample_q3 DATA.sample_q4;
  run;
  
  * Merge the loan-level data with macros by date;
  proc sort data = DATA.macros out = work.macros;
    by date;
  run;
  
  proc sort data = DATA.sample out = DATA.tmp_loan tagsort;
    by act_date;
  run;
  
  data DATA.data;
    merge DATA.tmp_loan work.macros(rename = (date = act_date));
    by act_date;
    if ^missing(loan_id);
  run;
  
  proc datasets lib = DATA;
    delete tmp:;
  run;

%mend merge;

* Merging the lona-level and macros data;

/* %merge(); */
