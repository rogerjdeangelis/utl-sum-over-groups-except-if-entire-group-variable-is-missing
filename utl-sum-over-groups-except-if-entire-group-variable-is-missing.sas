Sum over groups except if entire group variable is missing

A single datastep solution

https://communities.sas.com/t5/New-SAS-User/Sum-ifs/m-p/518829


INPUT
=====

WORK.HAVE total obs=10                    |
                                          |
   ID    GROUPER    PAID    VAR2    VAR3  |  GROUPER  PAID  VAR2   VAR3
                                          |
  111       .        100     150     200  |
  111       0        100     150     200  |
  111       .        100     150     200  |     0     300    450   600  Sums

  122       .        100     150     200  |
  122       7        100     150     200  |     7     200    300   400  Sums

  123       1        100     150     200  |     1     100    150   200  Sums

  125       .        100     150     200  |     .     100    150   200  ** no summing
  125       .        100     150     200  |     .     100    150   200  ** no summing

  130       .        100     150     200  |     5     200    300   400  Sums
  130       5        100     150     200  |


EXAMPLE OUTPUT
--------------

 WANT total obs=6

   ID    GRP    PAY    VR2    VR3

  111     0     300    450    600
  122     7     200    300    400
  123     1     100    150    200
  125     .     100    150    200
  125     .     100    150    200
  130     5     200    300    400


PROCESS
=======


data want (keep=id grp pay--vr3);

    retain id grp pay vr2 vr3 0;

    merge have have(keep=id grouper rename=grouper=grp where=(not missing(grp)));
    by id;

    pay =sum(pay,paid);
    vr2 =sum(vr2,var2);
    vr3 =sum(vr3,var3);

    if last.id or grp=. then do;
       output;
       call missing(pay,vr2,vr3);
    end;

run;quit;

OUTPUT
======

  see above

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data have;
input ID Grouper Paid VAR2 VAR3;
cards4;
111 . 100 150 200
111 0 100 150 200
111 . 100 150 200
122 . 100 150 200
122 7 100 150 200
123 1 100 150 200
125 . 100 150 200
125 . 100 150 200
130 . 100 150 200
130 5 100 150 200
;;;;
run;quit;



