*****************************************;
** SAS Scoring Code for PROC Logistic;
*****************************************;

length I_Next_stat $ 3;
label I_Next_stat = 'Into: Next_stat' ;
length U_Next_stat $ 3;
label U_Next_stat = 'Unnormalized Into: Next_stat' ;
label P_Next_statCUR = 'Predicted: Next_stat=CUR' ;
label P_Next_statPPY = 'Predicted: Next_stat=PPY' ;
label P_Next_statSDQ = 'Predicted: Next_stat=SDQ' ;
label P_Next_statDEL = 'Predicted: Next_stat=DEL' ;

drop _LMR_BAD;
_LMR_BAD=0;

*** Check interval variables for missing values;
if nmiss(Curr_rte,CLTV,Cscore_b,QDT_UMP) then do;
   _LMR_BAD=1;
   goto _SKIP_000;
end;

*** Compute Linear Predictors;
drop _LP0 _LP1 _LP2;
_LP0 = 0;
_LP1 = 0;
_LP2 = 0;

*** Effect: Curr_rte;
_LP0 = _LP0 + (-0.17412926727902) * Curr_rte;
_LP1 = _LP1 + (0.05085703237978) * Curr_rte;
_LP2 = _LP2 + (-0.04329751568754) * Curr_rte;
*** Effect: CLTV;
_LP0 = _LP0 + (-0.0046582788802) * CLTV;
_LP1 = _LP1 + (-0.01901561853379) * CLTV;
_LP2 = _LP2 + (0.02136816094543) * CLTV;
*** Effect: Cscore_b;
_LP0 = _LP0 + (0.00516918885667) * Cscore_b;
_LP1 = _LP1 + (0.00531519884304) * Cscore_b;
_LP2 = _LP2 + (0.0064258125742) * Cscore_b;
*** Effect: QDT_UMP;
_LP0 = _LP0 + (-0.26343065395563) * QDT_UMP;
_LP1 = _LP1 + (-0.5547882844268) * QDT_UMP;
_LP2 = _LP2 + (0.28157823144431) * QDT_UMP;

*** Predicted values;
drop _LPMAX _MAXP _IY _P0 _P1 _P2 _P3;
_LPMAX= 0;
_LP0 =    -2.28767627654001 + _LP0;
if _LPMAX < _LP0 then _LPMAX = _LP0;
_LP1 =    -5.65468386581563 + _LP1;
if _LPMAX < _LP1 then _LPMAX = _LP1;
_LP2 =     -7.5240920916995 + _LP2;
if _LPMAX < _LP2 then _LPMAX = _LP2;
_LP0 = exp(_LP0 - _LPMAX);
_LP1 = exp(_LP1 - _LPMAX);
_LP2 = exp(_LP2 - _LPMAX);
_LPMAX = exp(-_LPMAX);
_P3 = 1 / (_LPMAX + _LP0 + _LP1 + _LP2);
_P0 = _LP0 * _P3;
_P1 = _LP1 * _P3;
_P2 = _LP2 * _P3;
_P3 = _LPMAX * _P3;
P_Next_statCUR = _P0;
_MAXP = _P0;
_IY = 1;
P_Next_statPPY = _P1;
if (_P1 >  _MAXP + 1E-8) then do;
   _MAXP = _P1;
   _IY = 2;
end;
P_Next_statSDQ = _P2;
if (_P2 >  _MAXP + 1E-8) then do;
   _MAXP = _P2;
   _IY = 3;
end;
P_Next_statDEL = _P3;
if (_P3 >  _MAXP + 1E-8) then do;
   _MAXP = _P3;
   _IY = 4;
end;
select( _IY );
   when (1) do;
      I_Next_stat = 'CUR' ;
      U_Next_stat = 'CUR' ;
   end;
   when (2) do;
      I_Next_stat = 'PPY' ;
      U_Next_stat = 'PPY' ;
   end;
   when (3) do;
      I_Next_stat = 'SDQ' ;
      U_Next_stat = 'SDQ' ;
   end;
   when (4) do;
      I_Next_stat = 'DEL' ;
      U_Next_stat = 'DEL' ;
   end;
   otherwise do;
      I_Next_stat = '';
      U_Next_stat = '';
   end;
end;
_SKIP_000:
if _LMR_BAD = 1 then do;
I_Next_stat = '';
U_Next_stat = '';
P_Next_statCUR = .;
P_Next_statPPY = .;
P_Next_statSDQ = .;
P_Next_statDEL = .;
end;