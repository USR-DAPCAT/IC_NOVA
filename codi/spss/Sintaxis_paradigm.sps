


GET
  FILE='T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\BD2_IC_PLANA_N114575.sav'.
DATASET NAME Conjunto_de_datos4 WINDOW=FRONT.

*************         CRITERIS D'INCLUSIÓ               ******************.
*         INC1:  ICs prevalentes vivos a 31/12/2014      .
FREQ SITUACIO2014. 

COMPUTE INC1=0.
IF (SITUACIO2014=0) INC1=1. 
VARIABLE LABEL INC1 "ICs prevalentes vivos a 31/12/2014".
FREQ VAR=INC1. 
*   INC.ii   *.
if (valor.ultim.FE<=40) INC.ii=1. 
if (valor.ultim.FE>40) INC.ii=0. 
value label INC.ii 1 "FE<=40" 0 "FE>40".
freq var=INC.ii.
MEANS TABLES=valor.ultim.FE BY INC.ii
  /CELLS=MEAN COUNT min max.


*   INC.iii   *.
if (valor.ultim.NYHA>=2 and valor.ultim.NYHA<=4) INC.iii=1. 
if (valor.ultim.NYHA>4 or valor.ultim.NYHA<2) INC.iii=0. 
value label INC.iii 1 "NYHA. entre 2-4" 0 "NYHA >4 o <2".
freq var=INC.iii.
MEANS TABLES=valor.ultim.NYHA BY INC.iii
  /CELLS=MEAN COUNT min max.

*   INC.iv    *                  FARMACS DDD      **.
if (DDD.C09>=1)  INC.iv=1.
recode INC.iv (sysmis=0) (1=1). 
variable label INC.iv "ACE o ARB (Enalapril 10mg/day o eq DDD>1) últimos 3 meses".
freq var= INC.iv .

*   INC.v    *                  FARMACS DDD      **.
if (DDD.C07>=0)  INC.v=1.
recode INC.v (sysmis=0) (1=1). 
variable label INC.v "Betabloqueantes tx estable DDD>0 últimos 3 meses".
freq var=INC.v.

**********************         CRITERIS D'EXCLUSIÓ         ***.
*  EXC.i   *.
if (valor.ultim.MDRD<30) EXC.i=1. 
if (valor.ultim.MDRD>=30) EXC.i=0. 
value label EXC.i 1 "eGFR: MDRD<30" 0 "eGFR: MDRD>=30".
freq var=EXC.i. 

MEANS TABLES=valor.ultim.MDRD BY EXC.i
  /CELLS=MEAN COUNT min max.

* 
*  EXC.vi   *.
if (valor.ultim.PAS<95) EXC.vi=1. 
if (valor.ultim.PAS>=95) EXC.vi=0. 
value label EXC.vi 1 "PAS<95 o DG Hipotensió" 0 "PAS>=95".
if (dg.ultim.HIPOT>0)  EXC.vi =1.
freq var=EXC.vi. 

*   EXC.v   *. valor.ultim.K .
if (valor.ultim.K>5.4) EXC.v=1. 
if (valor.ultim.K<=5.4) EXC.v=0. 
value label EXC.v 1 "Potassi.K>5.4 o HIPKAL" 0 "Potassi. K<=5.4".
if ( dg.ultim.HK>0)  EXC.v =1.
freq var=EXC.v. 

*.
*   EXC.iii   Antecedentes 3 meses previos .   
if (dg.ultim.AIT>date.dmy(31,09,2014))  EXC.iii =1.
if (dg.ultim.AVC_NO_AIT>date.dmy(31,09,2014))  EXC.iii =1.
if (dg.ultim.IAM>date.dmy(31,09,2014))  EXC.iii =1.
if (dg.ultim.CIR_COR>date.dmy(31,09,2014))  EXC.iii =1.
if (dg.ultim.CI>date.dmy(31,09,2014))  EXC.iii =1.
**.
recode EXC.iii (1=1) (else=0).

freq var= EXC.iii .

*   EXC.iv   Antecedentes MPOC .   
if (dg.ultim.MPOC>0)  EXC.iv =1.
VALUE LABEL EXC.iv "MPOC a 31/12/2014".
Variable label EXC.iv "MPOC" .
recode EXC.iv (sysmis=0) (else=copy).
freq EXC.iv.

**************************************************************************************************************************.
**************************************************************************************************************************.
**************************************************************************************************************************.

DATASET ACTIVATE Conjunto_de_datos2.
USE ALL.
COMPUTE filter_$=(INC1=1 and inc.ii>=0).
VARIABLE LABELS filter_$ 'INC1=1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


****  INC.ii  INC.iii  INC.iv         **.
****    EXC.i  EXC.iii  EXC.iv  EXC.v  EXC.vi      .
freq var= INC1 INC.ii  INC.iii  INC.iv  INC.v.
Count INC_paradigm= INC.ii  INC.iii  INC.iv  INC.v (1).
freq var=EXC.i  EXC.iii  EXC.iv  EXC.v  EXC.vi .
Count EXC_paradigm= EXC.i  EXC.iii  EXC.iv  EXC.v  EXC.vi   (1).

freq INC_paradigm EXC_paradigm.



* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=INC.ii INC.iii INC.iv INC.v INC_paradigm DISPLAY=BOTH
  /TABLE INC.ii [C][COUNT F40.0] + INC.iii [C][COUNT F40.0] + INC.iv [C][COUNT F40.0] + INC.v 
    [C][COUNT F40.0] + INC_paradigm [COUNT F40.0]
  /CATEGORIES VARIABLES=INC.ii INC.iii ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=INC.iv INC.v INC_paradigm ORDER=A KEY=VALUE EMPTY=EXCLUDE.


* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=EXC.i EXC.iii EXC.iv EXC.v EXC.vi EXC_paradigm DISPLAY=BOTH
  /TABLE EXC.i [C][COUNT F40.0] + EXC.iii [C][COUNT F40.0] + EXC.iv [C][COUNT F40.0] + EXC.v 
    [C][COUNT F40.0] + EXC.vi [C][COUNT F40.0] + EXC_paradigm [C][COUNT F40.0]
  /CATEGORIES VARIABLES=EXC.i EXC.v EXC.vi ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=EXC.iii EXC.iv EXC_paradigm ORDER=A KEY=VALUE EMPTY=EXCLUDE.



COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0 or missing(exc.i)) and 
(EXC.iii=0 or missing(EXC.iii)) and 
(EXC.iv=0 or missing(EXC.iii)) and 
(EXC.v=0 or missing(EXC.V))
).

VARIABLE LABELS filter_$ 'INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and '+
    '(EXC.i=0 or missing(exc.i)) and (EXC.iii=0 or missing(EXC.iii) AND EXC.iv=0 AND (EXC.v=0 OR '+
    'missing(EXC.V) )) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQ VAR= EXC.v. 



descriptives INC1 INC.ii INC.iii inc.iv INC.v EXC.i EXC.iii EXC.iv EXC.v EXC.vi .


***************************      filtres per criteris d'inclusio exclusio    ********.
**************************         Exclusion criteria:            **.

********   exc.i 1.
COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1).
FILTER BY filter_$.
freq EXC.i.
********   exc.i 1.
COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0 or missing(exc.i)) ).
FILTER BY filter_$.
freq EXC.iii.
*******   exc.iii.
COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0 or missing(exc.i)) and 
(EXC.iii=0 or missing(EXC.iii))
).
FILTER BY filter_$.
freq EXC.iv.
*******   exc.iv.
COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0 or missing(exc.i)) and 
(EXC.iii=0 or missing(EXC.iii)) and 
(EXC.iv=0 or missing(EXC.iv)) 
).
FILTER BY filter_$.
freq EXC.v.

********     exc.v      *.
COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0 or missing(exc.i)) and 
(EXC.iii=0 or missing(EXC.iii)) and 
(EXC.iv=0 or missing(EXC.iv)) and
(EXC.v=0 or missing(EXC.V))
).
FILTER BY filter_$.
freq EXC.vi.

********     exc.vi      *.
COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0 or missing(exc.i)) and 
(EXC.iii=0 or missing(EXC.iii)) and 
(EXC.iv=0 or missing(EXC.iv)) and
(EXC.v=0 or missing(EXC.V)) and 
(EXC.vi=0 or missing(EXC.vi)) 
).
FILTER BY filter_$.
freq EXC.vi.


****************************************** excloure missings d'entrada          *******************************************************.
FILTER OFF.
COUNT NMISSINGS=INC1 INC.ii INC.iii inc.iv INC.v EXC.i EXC.iii EXC.iv EXC.v EXC.vi(MISSING).
********   exc.i 1.
COMPUTE filter_$=(NMISSINGS=0 AND INC1).
FILTER BY filter_$.
freq INC1 INC.ii INC.iii inc.iv INC.v EXC.i EXC.iii EXC.iv EXC.v EXC.vi.

********   exc.i 1.
COMPUTE filter_$=(NMISSINGS=0 AND INC1 and inc.ii).
FILTER BY filter_$.
freq inc.iii.

********   exc.i 1.
COMPUTE filter_$=(NMISSINGS=0 AND INC1 and inc.ii and inc.iii).
FILTER BY filter_$.
freq inc.iv.

*******   exc.iii   .
COMPUTE filter_$=(NMISSINGS=0 AND INC1 and inc.ii and inc.iii and inc.iv).
FILTER BY filter_$.
freq inc.v.

*******   exc.iii   .
COMPUTE filter_$=(NMISSINGS=0 AND INC1 and inc.ii and inc.iii and inc.iv and inc.v).
FILTER BY filter_$.
freq inc.v.

***************   Exclusió    ************.

********   exc.i 1.
COMPUTE filter_$=(NMISSINGS=0 and INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1).
FILTER BY filter_$.
freq EXC.i.

*******   exc.iii.
COMPUTE filter_$=(NMISSINGS=0 and INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0) ).
FILTER BY filter_$.
freq EXC.iii.

*******   exc.iii.
COMPUTE filter_$=(NMISSINGS=0 and INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0) and EXC.iii=0 ).
FILTER BY filter_$.
freq EXC.iv.

*******   exc.iii.
COMPUTE filter_$=(NMISSINGS=0 and INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0) and EXC.iii=0 and EXC.iv=0  ).
FILTER BY filter_$.
freq EXC.v.

*******   exc.iii.
COMPUTE filter_$=(NMISSINGS=0 and INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0) and EXC.iii=0 and EXC.iv=0 and EXC.v=0  ).
FILTER BY filter_$.
freq EXC.vi.


*******   exc.iv.
COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0 or missing(exc.i)) and 
(EXC.iii=0 or missing(EXC.iii)) and 
(EXC.iv=0 or missing(EXC.iv)) 
).
FILTER BY filter_$.
freq EXC.v.

********     exc.v      *.
COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0 or missing(exc.i)) and 
(EXC.iii=0 or missing(EXC.iii)) and 
(EXC.iv=0 or missing(EXC.iv)) and
(EXC.v=0 or missing(EXC.V))
).
FILTER BY filter_$.
freq EXC.vi.

********     exc.vi      *.
COMPUTE filter_$=(INC1=1 and INC.ii=1 and INC.iii=1 and inc.iv=1 and INC.v=1 and
(EXC.i=0 or missing(exc.i)) and 
(EXC.iii=0 or missing(EXC.iii)) and 
(EXC.iv=0 or missing(EXC.iv)) and
(EXC.v=0 or missing(EXC.V)) and 
(EXC.vi=0 or missing(EXC.vi)) 
).
FILTER BY filter_$.
freq EXC.vi.



***************************      filtres per criteris d'inclusio exclusio    ********.
**************************         Exclusion criteria:            **.


********************************            Columna % missings                                                 ***********.

DATASET ACTIVATE Conjunto_de_datos2.
USE ALL.
COMPUTE filter_$=(INC1=1).
VARIABLE LABELS filter_$ 'INC1=1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

freq INC1 INC.ii INC.iii inc.iv INC.v .


freq EXC.i EXC.iii  EXC.iv  EXC.v  EXC.vi .



