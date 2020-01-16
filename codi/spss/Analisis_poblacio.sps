

GET
  FILE='T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\BDPOBLACIO_PLANA_N5533160.sav'.
DATASET NAME poblacio WINDOW=FRONT.

*.
******.
*.
freq var=  any_naix. 

FILTER OFF.
USE ALL.
SELECT IF (any_naix ~= missing(any_naix)).
EXECUTE.


*************************            Recodificacions ***.

COMPUTE IC_BASAL=0. 
IF (dindexic < date.dmy(1,1,2010)) ic_basal=1.


freq  sc_bcn  edad_cat6 sexe  IC_BASAL  anyic  sit_2014 IC_BASAL .


descriptives edat. 


* Tablas personalizadas. 
CTABLES 
  /VLABELS VARIABLES=sexe edad_cat6 sc_bcn anyic sit_2014 IC_BASAL edad 
    DISPLAY=BOTH 
  /TABLE sexe [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + edad_cat6 [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + sc_bcn [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + anyic [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + sit_2014 [COUNT F40.0, COLPCT.COUNT PCT40.1] 
+ IC_BASAL [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + edad [S][MEAN, STDDEV] 
  /CATEGORIES VARIABLES=sexe sc_bcn sit_2014 IC_BASAL ORDER=A KEY=VALUE EMPTY=EXCLUDE 
  /CATEGORIES VARIABLES=edad_cat6 anyic ORDER=A KEY=VALUE EMPTY=INCLUDE.

*******************.

********************      REPLICAR TAULA NOMÉS BARCELONA                                     *********************************.

DATASET ACTIVATE Conjunto_de_datos2.
USE ALL.
COMPUTE filter_$=(sc_bcn="Si").
VARIABLE LABELS filter_$ 'sc_bcn="DD" (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


* Tablas personalizadas. 
CTABLES 
  /VLABELS VARIABLES=sexe edad_cat6 sc_bcn anyic sit_2014 IC_BASAL edad 
    DISPLAY=BOTH 
  /TABLE sexe [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + edad_cat6 [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + sc_bcn [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + anyic [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + sit_2014 [COUNT F40.0, COLPCT.COUNT PCT40.1] 
+ IC_BASAL [C][COUNT F40.0, COLPCT.COUNT PCT40.1] + edad [S][MEAN, STDDEV] 
  /CATEGORIES VARIABLES=sexe sc_bcn sit_2014 IC_BASAL ORDER=A KEY=VALUE EMPTY=EXCLUDE 
  /CATEGORIES VARIABLES=edad_cat6 anyic ORDER=A KEY=VALUE EMPTY=INCLUDE.

filter off. 

select all.


freq var=sc_bcn.


******************************************************************************************************************************************.


* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edad_cat6 IC_BASAL DISPLAY=BOTH
  /TABLE edad_cat6 [C][COUNT F40.0, ROWPCT.COUNT PCT40.1] BY IC_BASAL [C]
  /CATEGORIES VARIABLES=edad_cat6 ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=IC_BASAL ORDER=A KEY=VALUE EMPTY=EXCLUDE.


*******************.
**************         Cálcul temps lliure de IC desde 01/01/2010  fins 31/12/2012   o IC o T o Exitus    ************.
freq variables=anyic.
if  anyic>0 temps=ctime.days(dindexic-date.dmy(01,01,2010)) . 
if  missing(anyic) and  (sit_2014~= "A") temps=ctime.days(dtsit_2014-date.dmy(01,01,2010)).
if  missing(anyic) and  (sit_2014 ="A") temps=ctime.days(date.dmy(31,12,2014)-date.dmy(01,01,2010)).
descriptives var=temps.
********************************************************************.

*****      DATA SITUACIÓ      ***.
*****          dtsit_2014             ***.
COMPUTE SITUACIO2014=0.
IF (sit_2014= "D" and dtsit_2014 <= date.dmy(31,12,2014)) SITUACIO2014=1.
IF (sit_2014= "T" and dtsit_2014 <= date.dmy(31,12,2014)) SITUACIO2014=2.
value labels SITUACIO2014 0 "Actiu" 1 "Difunt" 2 "Trasllat".

freq var=SITUACIO2014.


********************.

********************            GENERAR EVENT_IC  SI IC ES PRODUEIX EN PERIODE 2010-2014       **..
if temps>=0 event_IC=0.
if anyic>=2010 event_IC=1.
*************************************************.
freq var=event_IC.

CROSSTABS
  /TABLES=edad_cat6 BY IC_BASAL
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.


* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edad_cat6 IC_BASAL sexe DISPLAY=BOTH
  /TABLE edad_cat6 [C][COUNT F40.0] BY IC_BASAL [C] > sexe [C]
  /CATEGORIES VARIABLES=edad_cat6 ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=IC_BASAL sexe ORDER=A KEY=VALUE EMPTY=EXCLUDE.


* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edad_cat6 sexe IC_BASAL DISPLAY=BOTH
  /TABLE edad_cat6 > sexe [COUNT F40.0, ROWPCT.COUNT PCT40.1] BY IC_BASAL [C]
  /CATEGORIES VARIABLES=edad_cat6 ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=sexe IC_BASAL ORDER=A KEY=VALUE EMPTY=EXCLUDE.

*************************************************************************************************************.
***************************         Selecció de població a Risc, sense IC a 2009    *******************.
***.
DATASET ACTIVATE Conjunto_de_datos1.
USE ALL.
COMPUTE filter_$=(temps >= 0).
VARIABLE LABELS filter_$ 'temps > 0 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

descriptives variables=  temps.

***********         Calculem la edad en IC       **********.

CROSSTABS
  /TABLES=anyic edad_cat6 BY sexe
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.


CROSSTABS
  /TABLES=edad_cat6 BY event_IC
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.



* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edad_cat6 sexe event_IC DISPLAY=BOTH
  /TABLE edad_cat6 [C] BY sexe [C] > event_IC [C][COUNT F40.0]
  /CATEGORIES VARIABLES=edad_cat6 ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=sexe ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES POSITION=AFTER
  /CATEGORIES VARIABLES=event_IC ORDER=A KEY=VALUE EMPTY=EXCLUDE.




DATASET ACTIVATE Conjunto_de_datos1.
MEANS TABLES=temps BY edad_cat6
  /CELLS=COUNT SUM.


******************************.

variable label edad_cat6 "Age group" .


COXREG temps
  /STATUS=event_IC(1)
  /PATTERN BY edad_cat6
  /CONTRAST (edad_cat6)=Indicator
  /METHOD=ENTER edad_cat6 
  /PLOT SURVIVAL OMS
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


*******************************************************************************************************.

USE ALL.
COMPUTE filter_$=(event_IC=1).
VARIABLE LABELS filter_$ 'event_IC=1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES variables=edad_cat6. 


***************************************************.

***************************************************         Objectiu: Determinar the life years lost potentially associated to HF          *.
***************************************************         Calculo el AVPP        *.

DATASET ACTIVATE Conjunto_de_datos1.
FILTER OFF.
USE ALL.
EXECUTE.

freq var=situacio2014.

**************         Cálcul edat en data de situacio defunció i edad a 31/12/2014 o edad en trasllat     ************.
IF (SITUACIO2014= 1) edat_defuncio=ctime.days(dtsit_2014-date.dmy(15,6,any_naix))/365.25.
*.
**************         Cálcul edat en ultima SITUACIO anterior a 31/12/2014                                          ************.
IF (SITUACIO2014= 1) edat_sit14=ctime.days(dtsit_2014-date.dmy(15,6,any_naix))/365.25.
IF (SITUACIO2014= 2) edat_sit14=ctime.days(dtsit_2014-date.dmy(15,6,any_naix))/365.25.
IF (SITUACIO2014= 0) edat_sit14=ctime.days(date.dmy(31,12,2014) -date.dmy(15,6,any_naix))/365.25.
*.
*****         Limit d'edat inferior i superior segons INE 1-79 anys --> 20-79:
*.
****   Fer grups d'edat :

Recode edat_sit14 (17.5 thru 19.9999999=1) (20 thru 24.99999999999=2) (25 thru 29.9999999=3) (30 thru 34.999999=4) (35 thru 39.99999999999=5)
(40 thru 44.9999999999999999=6) (45 thru 49.999999999999999999=7) (50 thru 54.999999999999999999=8) (55 thru 59.999999999999999=9) 
(60 thru 64.99999999999=10) (65 thru 69.99999999999=11) (70 thru 74.9999999999=12) (75 thru 79.9999999999=13) (80 thru 86.99999999=14) (87 thru hi=15) into edat_sit14cat2.

if missing(edat_sit14cat2) edat_sit14cat2=-1.

missing values edat_sit14cat2 (-1).

value label edat_sit14cat2 1 "[18-20)"  2 "[20-25)" 3 "[25-30)" 4 "[30-35)" 5 "[35-40)" 6 "[40-45)" 7 "[45-50)" 8 "[50-55)" 9 "[55-60)" 10 "[60-65)" 
11 "[65-70)"12 "[70-75)" 13 "[75-80)" 14 "[80-86)" 15 "86+".

freq var edat_sit14cat2.



MEANS TABLES=edat_sit14 BY edat_sit14cat2
  /CELLS=MEAN COUNT STDDEV MIN MAX.
* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edat_sit14cat2 SITUACIO2014 DISPLAY=BOTH
  /TABLE edat_sit14cat2 [COUNT F40.0] BY SITUACIO2014
  /CATEGORIES VARIABLES=edat_sit14cat2 SITUACIO2014 ORDER=A KEY=VALUE EMPTY=INCLUDE.

descriptives edat_defuncio.  
freq SITUACIO2014.

compute IC2014=0.
if ( anyic>0) IC2014=1.

freq var=IC2014.
************************************.
*.
****.
*.
* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edat_sit14cat2 IC2014 SITUACIO2014 DISPLAY=BOTH
  /TABLE edat_sit14cat2 [C][COUNT F40.0] BY IC2014 > SITUACIO2014 [C]
  /CATEGORIES VARIABLES=edat_sit14cat2 SITUACIO2014 ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=IC2014 ORDER=A KEY=VALUE EMPTY=EXCLUDE.

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edat_sit14cat2 IC2014 SITUACIO2014 DISPLAY=BOTH
  /TABLE edat_sit14cat2 [C][COUNT F40.0] BY IC2014 >  sexe > SITUACIO2014 [C] 
  /CATEGORIES VARIABLES=edat_sit14cat2 SITUACIO2014 ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=IC2014 ORDER=A KEY=VALUE EMPTY=EXCLUDE.



