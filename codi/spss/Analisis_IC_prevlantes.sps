*********************************


************************************************               SELECCIONAR CASOS PREVALENTES                **.

DATASET ACTIVATE Conjunto_de_datos1.
USE ALL.
COMPUTE filter_$=(IC_BASAL = 1).
VARIABLE LABELS filter_$ 'IC_BASAL = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.



***************   edad.

***************    edad_cat6  

****   Diagnostics :     dem  anem  fibau  cancer  ckd  resp  dm_in  dm1 dm2 dep dis hta  artper  iam_ci  este_ao  mval  crep obs  disnea .

************      Definició de variables multiples ******************.
* Definir conjuntos de respuestas múltiples.                      Comorbilidad                **************************. 
MRSETS
  /MDGROUP NAME=$Comorbilidad CATEGORYLABELS=VARLABELS VARIABLES=dem  anem  fibau  cancer  ckd  resp  dm_in  dm1 dm2 dep dis hta  artper  
iam_ci  este_ao  mval  crep obs  disnea  VALUE=1
  /DISPLAY NAME=[$Comorbilidad].
 

descriptives edad.


*******************               Frequencies                *********************.
*


* anyic    medea_ic_pob  dem_dindex  anem_dindex  fibau_dindex  cancer_dindex  ckd_dindex  resp_dindex dm_in_dindex dm1_dindex  dm2_dindex  dep_dindex  
dis_dindex  hta_dindex  artper_dindex  iam_ci_dindex  este_ao_dindex  mval_dindex  crep_dindex  obs_dindex  disnea_dindex  anyic.


* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=anyic sexe  edad_cat6 tab_ic_pob alris_ic_pob $Comorbilidad DISPLAY=BOTH
  /TABLE anyic [C][COUNT F40.0] + sexe [C][COUNT F40.0] + edad_cat6 [C][COUNT F40.0] + tab_ic_pob 
    [C][COUNT F40.0] + alris_ic_pob [C][COUNT F40.0] + $Comorbilidad [COUNT F40.0]
  /CATEGORIES VARIABLES=anyic edad_cat6 tab_ic_pob alris_ic_pob ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=sexe ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /CATEGORIES VARIABLES=$Comorbilidad  EMPTY=INCLUDE.

descriptives edad.


*********************************************           TAbla de variables       *******************************.
**.
*****   valor2010.fc  valor2010.FE valor2010.IMC valor2010.K valor2010.mdrd  valor2010.nyha  valor2010.pad valor2010.pas valor2010.pes  valor2010.talla  valor2010.ecg **.
**.
****.
***** compute  valor.ECG=0.
****if( data_valor.ECG >=0) valor.ECG=1.

recode valor2010.ecg (sysmis=0) (1=1).

freq var=valor2010.ecg.



* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=valor2010.fc valor2010.FE valor2010.IMC valor2010.K valor2010.mdrd 
    valor2010.nyha valor2010.pad valor2010.pas valor2010.pes valor2010.talla valor2010.ecg 
    DISPLAY=BOTH
  /TABLE valor2010.fc [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.FE [S][VALIDN F40.0, MEAN, 
    STDDEV] + valor2010.IMC [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.K [S][VALIDN F40.0, MEAN, 
    STDDEV] + valor2010.mdrd [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.nyha [S][VALIDN F40.0, MEAN, 
    STDDEV] + valor2010.pad [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.pas [S][VALIDN F40.0, MEAN, 
    STDDEV] + valor2010.pes [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.talla [S][VALIDN F40.0, MEAN, 
    STDDEV] + valor2010.ecg [C][COUNT F40.0]
  /CATEGORIES VARIABLES=valor2010.ecg ORDER=A KEY=VALUE EMPTY=EXCLUDE.

****.
****.
*****FE <50: n %
*****FE <=35: n %
*.
recode valor2010.FE (lo thru 49.9999=1) (50 thru hi=0) into FE50_2010_2cat.
recode valor2010.FE (lo thru 35=1) (35 thru hi=0) into FE35_2010_2cat.
recode valor2010.FE (lo thru 39.99999=1) (40 thru hi=0) into FE40_2010_2cat.
*.
*.
value label FE50_2010_2cat 1 "<50" 0 "50 o mes" .
value label FE35_2010_2cat 1 "<=35" 0 ">35".
value label FE40_2010_2cat 1 "<40" 0 ">40".
*.
freq var=FE40_2010_2cat.

*.




*.
                                                        **************            TABLA 6 DERIVACIONES CARDIOLOGIA       **.
**.

recode der_CARDIO_periode (0=0) (sysmis=0) (else=copy).


DATASET ACTIVATE Conjunto_de_datos8.
EXAMINE VARIABLES=der_CARDIO_periode
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.
*.


freq var= DerCardio_cat2.  
*.
*.

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=$Comorbilidad DerCardio_cat2 DISPLAY=BOTH
  /TABLE $Comorbilidad [C] BY DerCardio_cat2 [C][COUNT F40.0]
  /CATEGORIES VARIABLES=$Comorbilidad  EMPTY=INCLUDE
  /CATEGORIES VARIABLES=DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE.


CROSSTABS
  /TABLES=FE40_2010_2cat BY DerCardio_cat2
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT
  /COUNT ROUND CELL.





******************************         P-VALORS                                                   *****.

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=dem  anem  fibau  cancer  ckd  resp  dm_in  dm1 dm2 dep dis hta  artper  
iam_ci  este_ao  mval  crep obs  disnea DerCardio_cat2  DISPLAY=BOTH
  /TABLE dem + anem + fibau + cancer + ckd  + resp + dm_in + dm1 + dm2 + dep + dis + hta + artper + 
iam_ci + este_ao + mval + crep  + obs + disnea
BY DerCardio_cat2 [C][COUNT F40.0]
  /CATEGORIES VARIABLES=dem  anem  fibau  cancer  ckd  resp  dm_in  dm1 dm2 dep dis hta  artper  
iam_ci  este_ao  mval  crep obs  disnea DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /SIGTEST TYPE=CHISQUARE ALPHA=0.05 INCLUDEMRSETS=YES CATEGORIES=ALLVISIBLE.




****    anyic sexe edad_cat6 tab_ic_pob alris_ic_pob   ***.

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=sexe edad_cat6 tab_ic_pob alris_ic_pob sit_2014 DerCardio_cat2 DISPLAY=BOTH
  /TABLE sexe [C][COUNT F40.0] + edad_cat6 [C][COUNT F40.0] + tab_ic_pob [C][COUNT F40.0] + 
    alris_ic_pob [C][COUNT F40.0] + sit_2014 [C][COUNT F40.0] + valor.ecg[C]  BY DerCardio_cat2 [C]
  /CATEGORIES VARIABLES=sexe sit_2014 DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /CATEGORIES VARIABLES=edad_cat6 tab_ic_pob alris_ic_pob ORDER=A KEY=VALUE EMPTY=INCLUDE.


******************************         P-VALORS                                                   *****.

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=sexe edad_cat6 tab_ic_pob alris_ic_pob sit_2014 DerCardio_cat2  DISPLAY=BOTH
  /TABLE sexe + edad_cat6 + tab_ic_pob + alris_ic_pob + sit_2014 
BY DerCardio_cat2 [C][COUNT F40.0]
  /CATEGORIES VARIABLES=sexe edad_cat6 tab_ic_pob alris_ic_pob sit_2014 DerCardio_cat2 
ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /SIGTEST TYPE=CHISQUARE ALPHA=0.05 INCLUDEMRSETS=YES CATEGORIES=ALLVISIBLE.


*edad   valor2010.fc  valor2010.FE  valor2010.IMC  valor2010.K  valor2010.mdrd  valor2010.nyha  valor2010.pad  valor2010.pas  valor2010.pes  valor2010.talla

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edad   valor2010.fc  valor2010.FE  valor2010.IMC  valor2010.K  valor2010.mdrd  valor2010.nyha  valor2010.pad  valor2010.pas  
valor2010.pes  valor2010.talla 
    DISPLAY=BOTH
  /TABLE edad [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.FC [S][VALIDN F40.0, MEAN, STDDEV] + 
    valor2010.FE [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.IMC [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.K 
    [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.MDRD [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.NYHA 
    [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.PAD [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.PAS [S][VALIDN 
    F40.0, MEAN, STDDEV] + valor2010.PES [S][VALIDN F40.0, MEAN, STDDEV] + valor2010.TALLA [S][VALIDN F40.0, 
    MEAN, STDDEV] BY DerCardio_cat2
  /CATEGORIES VARIABLES=DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE.



***********************************.
*      P -valors continues          ********************************************************.
 
MEANS TABLES=edad   valor2010.fc  valor2010.FE  valor2010.IMC  valor2010.K  valor2010.mdrd  valor2010.nyha  valor2010.pad  valor2010.pas  valor2010.pes  valor2010.talla BY DerCardio_cat2
  /CELLS=MEAN COUNT STDDEV
  /STATISTICS ANOVA.


missing values der_CARDIO_periode(0).

EXAMINE VARIABLES=der_CARDIO_periode
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.
*.





