  %let id01 = %nrstr(1YqgLuVYbwK8LQGL05yiDLzt-PchZN751);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id01;
  filename url_file url "&_url";
  
  data Housing_Starts;
    infile url_file  missover dsd firstobs=2;
    input date :$10. HousingSt_Var;
  run;
  
  proc contents data = Housing_Starts;
  run;
  
  proc univariate data = Housing_Starts;
  run;


  %let id02 = %nrstr(1Nolfw8rIW7gFQEbKAR3X-4KaSKUNMZzZ);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id02;
  filename url_file url "&_url";
  
  data GDP;
  	infile url_file missover dsd;
  	input date :$10. GDP_Var;
  run;
  
  
  %let id03 = %nrstr(1QhbI6yakMv9Q-8dwn0nwcJeX6kWQjJ76);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id02;
  filename url_file url "&_url";
  
  data Unemployment;
  	infile url_file missover dsd;
  	input date :$10. People_Unemp;
  run;
  
  
  %let id04 = %nrstr(1RsN5jzXeEbLtYxVs_rXvBBXrasaymG6k);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id02;
  filename url_file url "&_url";
  
  data MortgageRate30;
  	infile url_file missover dsd;
  	input date :$10. Rates;
  run;
  
  
  %let id05 = %nrstr(1iDdiHWP7ihEtEh1zED3XQup0ksdNmK_J);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id02;
  filename url_file url "&_url";
  
  data TNFPayrolls;
  	infile url_file missover dsd;
  	input date :$10. Payrolls;
  run;
  
  %let id06 = %nrstr(1o4XiUZAUk0K5eXyjyjU5jCBafpCnvcJa);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id02;
  filename url_file url "&_url";
  
  data FedFundsR;
  	infile url_file missover dsd firstobs=2;
  	input date :$10. Fed_Rate;
  run;
  
  
  %let id06 = %nrstr(1p1oHE48ef87PLNcsLdfw1AbVo0VmwwGA);
  %let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id02;
  filename url_file url "&_url";
  
  data Permits;
  	infile url_file missover dsd;
  	input date :$10. Permits;
  run;
  
  
  
  
  
  
  