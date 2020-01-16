*****************            ESTUDI DE MORTALITAT incidents i prevalents          *************************************************.
****      Temps lliure de mortalitat
*.
IF ((SITUACIO2014=1 OR  SITUACIO2014=2) AND dtsit_2014<=date.dmy(31,12,2014))  temps_mortalitat=ctime.days(dtsit_2014-dtinclusio)/30.4.
IF  (SITUACIO2014=0) temps_mortalitat=ctime.days(date.dmy(31,12,2014) -dtinclusio)/30.4.
*.
variable label temps_mortalitat "Time in months during de seguiment lliure de mortalitat en incidents y prevalents" .
descriptives dtsit_2014 temps_mortalitat.
IF  temps_mortalitat<0 temps_mortalitat=ctime.days(date.dmy(31,12,2014) -dtinclusio)/30.4.
descriptives dtsit_2014 temps_mortalitat.
*.
*.
IF SITUACIO2014=1 AND dtsit_2014<=date.dmy(31,12,2014)  EVENT_MORT2014=1.
RECODE EVENT_MORT2014 (SYSMIS=0) (ELSE=COPY).

descriptives dtsit_2014.
FREQ SITUACIO2014 EVENT_MORT2014.

********************************************.

*****************         Selecciono PREVALENTS           ***********.
DATASET ACTIVATE Conjunto_de_datos1.
USE ALL.
COMPUTE filter_$=(IC_BASAL=1).
VARIABLE LABELS filter_$ 'IC_BASAL=1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
************************.

Freq  EVENT_MORT2014.

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edad_cat6 sexe EVENT_MORT2014 DISPLAY=BOTH
  /TABLE edad_cat6 [C] BY sexe [C] > EVENT_MORT2014 [C][COUNT F40.0]
  /CATEGORIES VARIABLES=edad_cat6 ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=sexe ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES POSITION=AFTER
  /CATEGORIES VARIABLES=EVENT_MORT2014 ORDER=A KEY=VALUE EMPTY=EXCLUDE.



* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edad_cat6 sexe temps_mortalitat DISPLAY=BOTH
  /TABLE edad_cat6 [C] BY sexe [C] > temps_mortalitat [S][SUM]
  /CATEGORIES VARIABLES=edad_cat6 ORDER=A KEY=VALUE EMPTY=INCLUDE TOTAL=YES POSITION=AFTER
  /CATEGORIES VARIABLES=sexe ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES POSITION=AFTER.


FREQUENCIES EVENT_MORT2014.

******************************.

COXREG temps_mortalitat
  /STATUS=EVENT_MORT2014(1)
  /PATTERN BY edad_cat6
  /CONTRAST (edad_cat6)=Indicator
  /METHOD=ENTER edad_cat6 
  /PLOT SURVIVAL OMS
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


*****************         Selecciono INCIDENTS           ***********.
DATASET ACTIVATE Conjunto_de_datos1.
USE ALL.
COMPUTE filter_$=(IC_BASAL=0).
VARIABLE LABELS filter_$ 'IC_BASAL=1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
************************.

Freq  EVENT_MORT2014  edadIC_cat6.

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edadIC_cat6 sexe EVENT_MORT2014 DISPLAY=BOTH
  /TABLE edadIC_cat6 [C] BY sexe [C] > EVENT_MORT2014 [C][COUNT F40.0]
  /CATEGORIES VARIABLES=edadIC_cat6 ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=sexe ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES POSITION=AFTER
  /CATEGORIES VARIABLES=EVENT_MORT2014 ORDER=A KEY=VALUE EMPTY=EXCLUDE.




* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edadIC_cat6 sexe temps_mortalitat DISPLAY=BOTH
  /TABLE edadIC_cat6 [C] BY sexe [C] > temps_mortalitat [S][SUM]
  /CATEGORIES VARIABLES=edadIC_cat6 ORDER=A KEY=VALUE EMPTY=INCLUDE TOTAL=YES POSITION=AFTER
  /CATEGORIES VARIABLES=sexe ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES POSITION=AFTER.


******************************.

COXREG temps_mortalitat
  /STATUS=EVENT_MORT2014(1)
  /PATTERN BY edadIC_cat6
  /CONTRAST (edadIC_cat6)=Indicator
  /METHOD=ENTER edadIC_cat6 
  /PLOT SURVIVAL OMS
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


************************************************************************************.







