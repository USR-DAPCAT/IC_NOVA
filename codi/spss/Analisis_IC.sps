*********************************.
********************************.

GET
  FILE='T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\BDIC_PLANA_N65545.sav'.
DATASET NAME BDICs WINDOW=FRONT.


**********************  SELECCIONO NOMES CASOS INCIDENTS             ************.

DATASET ACTIVATE Conjunto_de_datos4.
USE ALL.
COMPUTE filter_$=(event_IC = 1).
VARIABLE LABELS filter_$ 'event_IC = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.



****************************************************************************                              *.
**********    Calculo la Edad en data d'IC                              ******                              *.
***********         Edad a inici del estudi (01/01/2010)                                            **      *.
compute edad_IC=(ctime.days(dindexic-date.dmy(15,6,any_naix))/365.25) .
descriptivo variables edad_IC.


recode edad_IC (lo thru 44.99999=1) (45 thru 54.99999=2) (55 thru 64.99999=3) (65 thru 74.99999=4) (75 thru 84.99999=5)  (85 thru hi=6)  into edadIC_cat6.
value label  edadIC_cat6 1 "<45" 2 "[45-55)" 3 "[55-65)" 4 "[65-75)" 5 "[75-85)" 6 "85+" .
freq var=edadIC_cat6  edad_cat6.

descriptives edad_IC edad.


*******************               Frequencies                *********************.
************      Definició de variables multiples ******************.
* Definir conjuntos de respuestas múltiples.                      Comorbilidad                **************************. 
MRSETS
  /MDGROUP NAME=$Comorbilidad CATEGORYLABELS=VARLABELS VARIABLES=dem_dindex anem_dindex 
    fibau_dindex cancer_dindex ckd_dindex resp_dindex dm_in_dindex dm1_dindex dm2_dindex dep_dindex 
    dis_dindex hta_dindex artper_dindex iam_ci_dindex este_ao_dindex mval_dindex crep_dindex obs_dindex 
    disnea_dindex VALUE=1
  /DISPLAY NAME=[$Comorbilidad].


* anyic    medea_ic_pob  dem_dindex  anem_dindex  fibau_dindex  cancer_dindex  ckd_dindex  resp_dindex dm_in_dindex dm1_dindex  dm2_dindex  dep_dindex  
dis_dindex  hta_dindex  artper_dindex  iam_ci_dindex  este_ao_dindex  mval_dindex  crep_dindex  obs_dindex  disnea_dindex  anyic.


* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=anyic sexe edadIC_cat6 tab_ic_pob alris_ic_pob $Comorbilidad DISPLAY=BOTH
  /TABLE anyic [C][COUNT F40.0] + sexe [C][COUNT F40.0] + edadIC_cat6 [C][COUNT F40.0] + tab_ic_pob 
    [C][COUNT F40.0] + alris_ic_pob [C][COUNT F40.0] + $Comorbilidad [COUNT F40.0]
  /CATEGORIES VARIABLES=anyic edadIC_cat6 tab_ic_pob alris_ic_pob ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=sexe ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /CATEGORIES VARIABLES=$Comorbilidad  EMPTY=INCLUDE.

descriptives edad_IC edad.


*********************************************           TAbla de variables       *******************************.

****.
* compute  valor.ECG=0.
if( data_valor.ECG >=0) valor.ECG=1.

recode valor.ECG (sysmis=0) (1=1) .

freq var=valor.ecg.

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=edad_IC valor.FC valor.FE valor.IMC valor.K valor.MDRD valor.NYHA valor.PAD 
    valor.PAS valor.PES valor.TALLA 
    DISPLAY=BOTH
  /TABLE edad_IC [S][VALIDN F40.0, MEAN, STDDEV] + valor.FC [S][VALIDN F40.0, MEAN, STDDEV] + 
    valor.FE [S][VALIDN F40.0, MEAN, STDDEV] + valor.IMC [S][VALIDN F40.0, MEAN, STDDEV] + valor.K 
    [S][VALIDN F40.0, MEAN, STDDEV] + valor.MDRD [S][VALIDN F40.0, MEAN, STDDEV] + valor.NYHA 
    [S][VALIDN F40.0, MEAN, STDDEV] + valor.PAD [S][VALIDN F40.0, MEAN, STDDEV] + valor.PAS [S][VALIDN 
    F40.0, MEAN, STDDEV] + valor.PES [S][VALIDN F40.0, MEAN, STDDEV] + valor.TALLA [S][VALIDN F40.0, 
    MEAN, STDDEV].
*****               ***.
*****FE <50: n %
*****FE <=35: n %
***                  **.
recode valor.FE (lo thru 49.9999=1) (50 thru hi=0) into FE50_2cat.
recode valor.FE (lo thru 35=1) (35 thru hi=0) into FE35_2cat.
recode valor.FE (lo thru 39.99999=1) (40 thru hi=0) into FE40_2cat.
*.
*.
value label FE50_2cat 1 "<50" 0 "50 o mes" .
value label FE35_2cat 1 "<=35" 0 ">35".
value label FE40_2cat 1 "<40" 0 ">40".

freq var=FE50_2cat FE35_2cat FE40_2cat  . 
*.
*.

descriptives valor.fe  valor.FE  valor2010.FE.

*.
*******************************************************              TAULA 6 .... Derivaciones al cardiologo             ***********.

* Definir conjuntos de respuestas múltiples.                      Comorbilidad                **************************. 
MRSETS
  /MDGROUP NAME=$Comorbilidad CATEGORYLABELS=VARLABELS VARIABLES= dem anem fibau cancer ckd resp dm_in dm1 dm2 dep dis hta artper iam_ci este_ao mval crep obs 
disnea VALUE=1
  /DISPLAY NAME=[$Comorbilidad].

*************      En fecha indice (diagnostico)   ******************.
MRSETS
  /MDGROUP NAME=$Comorbilidad CATEGORYLABELS=VARLABELS VARIABLES=  dem_dindex  anem_dindex  fibau_dindex  cancer_dindex  ckd_dindex  resp_dindex dm_in_dindex dm1_dindex dm2_dindex dep_dindex dis_dindex hta_dindex 
artper_dindex iam_ci_dindex este_ao_dindex mval_dindex crep_dindex obs_dindex disnea_dindex DG.ci.dindex DG.AVC_NO_AIT.dindex DG.IAM.dindex VALUE=1
  /DISPLAY NAME=[$Comorbilidad].



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
  /VLABELS VARIABLES=edad_IC valor.FC valor.FE valor.IMC valor.K valor.MDRD valor.NYHA valor.PAD 
    valor.PAS valor.PES valor.TALLA 
    DISPLAY=BOTH
  /TABLE edad_IC [S][VALIDN F40.0, MEAN, STDDEV] + valor.FC [S][VALIDN F40.0, MEAN, STDDEV] + 
    valor.FE [S][VALIDN F40.0, MEAN, STDDEV] + valor.IMC [S][VALIDN F40.0, MEAN, STDDEV] + valor.K 
    [S][VALIDN F40.0, MEAN, STDDEV] + valor.MDRD [S][VALIDN F40.0, MEAN, STDDEV] + valor.NYHA 
    [S][VALIDN F40.0, MEAN, STDDEV] + valor.PAD [S][VALIDN F40.0, MEAN, STDDEV] + valor.PAS [S][VALIDN 
    F40.0, MEAN, STDDEV] + valor.PES [S][VALIDN F40.0, MEAN, STDDEV] + valor.TALLA [S][VALIDN F40.0, 
    MEAN, STDDEV] BY DerCardio_cat2
  /CATEGORIES VARIABLES=DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE. 


DATASET ACTIVATE Conjunto_de_datos1.
MEANS TABLES=edad_IC valor.FC valor.FE valor.IMC valor.K valor.MDRD valor.NYHA valor.PAD 
    valor.PAS valor.PES valor.TALLA  BY DerCardio_cat2
  /CELLS=MEAN COUNT STDDEV
  /STATISTICS ANOVA.
 
MEANS TABLES=edad valor2010.FC valor2010.FE valor2010.IMC valor2010.K valor2010.MDRD valor2010.NYHA valor2010.PAD 
    valor2010.PAS valor2010.PES valor2010.TALLA  BY DerCardio_cat2
  /CELLS=MEAN COUNT STDDEV
  /STATISTICS ANOVA.


* edad  valor2010.fc  valor2010.FE  valor2010.IMC  valor2010.K  valor2010.mdrd  valor2010.nyha  valor2010.pad  valor2010.pas  valor2010.pes  valor2010.talla  valor2010.ecg 

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=anyic sexe edadIC_cat6 tab_ic_pob alris_ic_pob $Comorbilidad DerCardio_cat2 sit_2014  DISPLAY=BOTH
  /TABLE anyic [C] + sexe [C] + edad_cat6 [C] + tab_ic_pob [C] + alris_ic_pob [C]+ $Comorbilidad [C] + sit_2014 [C] + 
FE50_2cat[c] + FE35_2cat[c] + FE40_2cat[c] + valor.ECG [c]
 BY DerCardio_cat2 [C][COUNT 
    F40.0] 
  /CATEGORIES VARIABLES=sexe event_IC DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /CATEGORIES VARIABLES=edad_cat6 ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=$Comorbilidad  EMPTY=INCLUDE.


********************      cHIS *****************.


CROSSTABS
  /TABLES=DerCardio_cat2 BY anyic sexe edadIC_cat6 tab_ic_pob alris_ic_pob dem anem fibau cancer ckd resp dm_in dm1 dm2 dep dis hta artper iam_ci este_ao mval crep obs 
disnea  FE50_2cat FE35_2cat valor.ECG
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.



CROSSTABS
  /TABLES=DerCardio_cat2 BY dem_dindex anem_dindex 
    fibau_dindex cancer_dindex ckd_dindex resp_dindex dm_in_dindex dm1_dindex dm2_dindex dep_dindex 
    dis_dindex hta_dindex artper_dindex iam_ci_dindex este_ao_dindex mval_dindex crep_dindex obs_dindex 
    disnea_dindex FE50_2cat FE35_2cat valor.ECG disnea_dindex DG.ci.dindex DG.AVC_NO_AIT.dindex DG.IAM.dindex
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.



****************.
recode   Dervivacions_num (1 thru hi=1) (else=0) into DerCardio_cat2.
valuel label DerCardio_cat2 0 "Cap derivació" 1 "Alguna derivació CV o medicina interna" .
freq DerCardio_cat2.

 
******************************                  RECURSOS TAULA 7                              *****.
Variable label 
REC.MF_CEN "Visites Medicina de família, centre"  
/ REC.INF_CEN "Visita al servei d’Infermeria centre" 
/ REC.URG "Visites a centres ACUT/CUAP, independentment del servei" 
/ REC.DER_CARDIO "Derivació a cardiologia o interna"
/ REC.DER_ECOCARDIO "Derivació per ECOCARDIO"
/ REC.LAB "Prova laboratori d’una de les següents variables: HB,COLTOT, COLHDL, COLDL, GLICEMIA, HBA1C, CREAT, MDRD (MDRD4)." 
/ REC.MF_DOM "Visita Medicina de família, inclou domiciliàries" 
/ REC.INF_DOM "Visita al servei d’Infermeria, domiciliàries" .


*********************.
recode REC.MF_CEN (0=0) (1 thru hi=1) into REC.MF_CEN.v1.
recode REC.INF_CEN (0=0) (1 thru hi=1) into REC.INF_CEN.v1.
recode REC.URG (0=0) (1 thru hi=1) into REC.URG.v1.
recode REC.DER_CARDIO (0=0) (1 thru hi=1) into REC.DER_CARDIO.v1.
recode REC.DER_ECOCARDIO (0=0) (1 thru hi=1) into REC.DER_ECOCARDIO.v1.
recode REC.LAB (0=0) (1 thru hi=1) into REC.LAB.v1.
recode REC.MF_DOM (0=0) (1 thru hi=1) into REC.MF_DOM.v1.
recode REC.INF_DOM (0=0) (1 thru hi=1) into REC.INF_DOM.v1.

Variable label 
REC.MF_CEN.v1 ">=1 Visites Medicina de família, centre"  
/ REC.INF_CEN.v1 ">=1 Visita al servei d’Infermeria centre" 
/ REC.URG.v1 ">=1 Visites a centres ACUT/CUAP, independentment del servei" 
/ REC.DER_CARDIO.v1 ">=1 Derivació a cardiologia o interna"
/ REC.DER_ECOCARDIO.v1 ">=1 Derivació per ECOCARDIO"
/ REC.LAB.v1 ">=1 Prova laboratori d’una de les següents variables: HB,COLTOT, COLHDL, COLDL, GLICEMIA, HBA1C, CREAT, MDRD (MDRD4)." 
/ REC.MF_DOM.v1 ">=1 Visita Medicina de família, inclou domiciliàries" 
/ REC.INF_DOM.v1 ">=1 Visita al servei d’Infermeria, domiciliàries" .
*******.


CROSSTABS REC.DER_CARDIO.v1 BY DerCardio_cat2 .

CROSSTABS REC.DER_ECOCARDIO.v1 BY DerCardio_cat2 .

DATASET ACTIVATE Conjunto_de_datos2.
DESCRIPTIVES VARIABLES=REC.DER_CARDIO REC.DER_ECOCARDIO REC.INF_CEN REC.INF_DOM REC.LAB REC.MF_CEN 
    REC.MF_DOM REC.URG
  /STATISTICS=MEAN SUM STDDEV MIN MAX.

DATASET ACTIVATE Conjunto_de_datos2.
DESCRIPTIVES VARIABLES= REC.MF_CEN.v1 REC.INF_CEN.v1 REC.URG.v1 REC.DER_CARDIO.v1 REC.DER_ECOCARDIO.v1 REC.LAB.v1 
    REC.MF_DOM.v1 REC.INF_DOM.v1
  /STATISTICS=MEAN SUM STDDEV MIN MAX.





recode REC.DER_CARDIO REC.DER_ECOCARDIO REC.INF_CEN REC.INF_DOM REC.LAB REC.MF_CEN 
    REC.MF_DOM REC.URG (0=0) (1=1) (else=0) into REC.DER_CARDIOv1 REC.DER_ECOCARDIOv1 REC.INF_CENv1 REC.INF_DOMv1 REC.LABv1 REC.MF_CENv1 
    REC.MF_DOMv1 REC.URGv1.

freq var= REC.DER_CARDIOv1 REC.DER_ECOCARDIOv1 REC.INF_CENv1 REC.INF_DOMv1 REC.LABv1 REC.MF_CENv1 
    REC.MF_DOMv1 REC.URGv1.


FREQUENCIES REC.DER_CARDIO REC.DER_ECOCARDIO REC.INF_CEN REC.INF_DOM REC.LAB REC.MF_CEN 
    REC.MF_DOM REC.URG.


FILTER OFF.
USE ALL.
EXECUTE.


DATASET ACTIVATE Conjunto_de_datos2.
DESCRIPTIVES VARIABLES=REC.DER_CARDIO REC.DER_ECOCARDIO REC.MF_CEN 
    REC.MF_DOM REC.INF_CEN REC.INF_DOM REC.LAB  REC.URG
  /STATISTICS=MEAN SUM STDDEV MIN MAX.


MEANS TABLES=REC.DER_CARDIO REC.DER_ECOCARDIO REC.INF_CEN REC.INF_DOM REC.LAB REC.MF_CEN REC.MF_DOM 
    REC.URG BY DerCardio_cat2
  /CELLS=MEAN COUNT STDDEV MEDIAN SUM MIN MAX 
  /STATISTICS ANOVA.

MEANS TABLES=REC.DER_CARDIOV1 REC.DER_ECOCARDIOv1 REC.INF_CENv1 REC.INF_DOMv1 REC.LABv1 REC.MF_CENv1 REC.MF_DOMv1 
    REC.URGv1 BY DerCardio_cat2
  /CELLS=MEAN  .



EXAMINE VARIABLES=REC.DER_CARDIO REC.DER_ECOCARDIO REC.INF_CEN REC.INF_DOM REC.LAB REC.MF_CEN REC.MF_DOM 
    REC.URG  BY DerCardio_cat2
  /PLOT NONE
  /PERCENTILES(5,10,25,50,75,90,95) 
  /STATISTICS NONE
  /MISSING LISTWISE
  /NOTOTAL.


EXAMINE VARIABLES=REC.DER_CARDIO REC.DER_ECOCARDIO REC.INF_CEN REC.INF_DOM REC.LAB REC.MF_CEN REC.MF_DOM 
    REC.URG
  /PLOT NONE
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE
  /STATISTICS NONE
  /MISSING LISTWISE
  /NOTOTAL.

********.

DESCRIPTIVES REC.DER_CARDIO.
FREQUENCIES REC.DER_CARDIO /STATISTICS=SUM MEAN median.

*****      Calcul de Cost total     I ESPECIFIC            ************************.
*****      Calcul de Cost total     I ESPECIFIC            ************************.
*****      Calcul de Cost total     I ESPECIFIC            ************************.
*****      Calcul de Cost total     I ESPECIFIC            ************************.
compute REC.TOTAL.cost= 118.00*REC.DER_CARDIO+56.00*REC.DER_ECOCARDIO+28.00*REC.INF_CEN+45.00*REC.INF_DOM+9.10*REC.LAB+40.00*REC.MF_CEN
+65.00*REC.MF_DOM+60.00*REC.URG.
exe.

variable label REC.TOTAL.cost "Cost estimació total".

FREQUENCIES REC.TOTAL.cost /STATISTICS=SUM MEAN STDDEV median  /NTILES=4 / format=notable.

*.
compute REC.cardio.cost=REC.DER_CARDIO*118.
compute REC.DERECOCARTIO.cost= 56.00*REC.DER_ECOCARDIO.
compute REC.INF_CEN.cost= 28.00*REC.INF_CEN.
compute REC.INF_DOM.cost= 45.00*REC.INF_DOM.
compute REC.LAB.cost= 9.10*REC.LAB.
compute REC.MF_CEN.cost= 40.00*REC.MF_CEN.
compute REC.MF_DOM.cost= 65.00*REC.MF_DOM.
compute REC.URG.cost= 60.00*REC.URG.
*.
*****      Calcul de Cost total     I ESPECIFIC            ************************.
*****      Calcul de Cost total     I ESPECIFIC            ************************.
*****      Calcul de Cost total     I ESPECIFIC            ************************.

exe.

FREQUENCIES 
REC.TOTAL.cost
REC.cardio.cost
REC.DERECOCARTIO.cost 
REC.INF_CEN.cost 
REC.INF_DOM.cost 
REC.LAB.cost 
REC.MF_CEN.cost 
REC.MF_DOM.cost
REC.URG.cost
 /STATISTICS=SUM MEAN STDDEV median  /NTILES=4 / format=notable.

COMPUTE KK=REC.DER_CARDIO+REC.DER_ECOCARDIO+REC.INF_CEN+REC.INF_DOM+REC.LAB+REC.MF_CEN+REC.MF_DOM+REC.URG.
FREQ KK.

********.


* REC.DER_CARDIO.v1 REC.DER_ECOCARDIO.v1 REC.INF_CEN.v1 REC.INF_DOM.v1 REC.LAB.v1 REC.MF_CEN.v1 REC.MF_DOM.v1 REC.URG.v1.

DATASET ACTIVATE Conjunto_de_datos2.
* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=REC.DER_CARDIO.v1 REC.DER_ECOCARDIO.v1 REC.INF_CEN.v1 REC.INF_DOM.v1 REC.LAB.v1 REC.MF_CEN.v1 
REC.MF_DOM.v1 REC.URG.v1 DerCardio_cat2 
    DISPLAY=BOTH
  /TABLE REC.DER_CARDIO.v1 [C][COUNT F40.0] + REC.DER_ECOCARDIO.v1 [C][COUNT F40.0] + REC.INF_CEN.v1 [C][COUNT 
    F40.0] + REC.INF_DOM.v1 [C][COUNT F40.0] + REC.LAB.v1 [C][COUNT F40.0] + REC.MF_CEN.v1 
    [C][COUNT F40.0] + REC.MF_DOM.v1 [C][COUNT F40.0] + REC.URG.v1 [C][COUNT F40.0] BY 
    DerCardio_cat2 [C]
  /CATEGORIES VARIABLES=REC.DER_CARDIO.v1 REC.DER_ECOCARDIO.v1 REC.INF_CEN.v1 REC.INF_DOM.v1 REC.LAB.v1 REC.MF_CEN.v1 
REC.MF_DOM.v1 REC.URG.v1 ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /CATEGORIES VARIABLES=DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES POSITION=AFTER.




*****      Temps de seguiment      dtsit_2014     ****************.
compute temps_seguiment=ctime.days(dtsit_2014 -date.dmy(1,1,2010)).
IF  (SITUACIO2014=0) temps_seguiment=ctime.days(date.dmy(31,12,2014) -date.dmy(1,1,2010)).
compute anys_seguiment=temps_seguiment/365.25.


MEANS TABLES=anys_seguiment BY DerCardio_cat2
  /CELLS=MEAN COUNT MEDIAN SUM MAX 
  /STATISTICS ANOVA.


**************************************************************************         RECALCUL DIAGNOSTICS IAM, AVC, CI   A DATA_INDEX I A DATA 
***************            DG's nous recalculats   dindex i 01/01/2010       *************.
*************  dindex    ****.
*****      DG.AVC_NO_AIT.dindex DG.AVC_NO_AIT         .
IF dg.ultim.AVC_NO_AIT<= dindexic OR  dg.primer.AVC_NO_AIT <= dindexic DG.AVC_NO_AIT.dindex=1.
IF (dg.ultim.AVC_NO_AIT<= data.dmy(01,01,2010) OR dg.primer.AVC_NO_AIT <= data.dmy(01,01,2010)) DG.AVC_NO_AIT=1.
****                                                *.
*****      DG.ci.dindex DG.ci           *.
IF (dg.ultim.ci<= dindexic OR dg.primer.ci <= dindexic) DG.ci.dindex=1.
IF (dg.ultim.ci<= data.dmy(01,01,2010) OR dg.primer.ci <= data.dmy(01,01,2010)) DG.ci=1.
***.
***.  dg.primer.IAM      ****.
IF (dg.ultim.IAM<= dindexic OR dg.primer.IAM <= dindexic) DG.IAM.dindex=1.
IF (dg.ultim.IAM<= data.dmy(01,01,2010) OR  dg.primer.IAM <= data.dmy(01,01,2010)) DG.IAM=1.
****.
recode   DG.AVC_NO_AIT.dindex DG.AVC_NO_AIT DG.ci.dindex DG.ci DG.IAM.dindex DG.IAM (1=1) (else=0).
*****      DG.IAM.dindex DG.IAM   .
*****.
if DG.IAM.dindex=1 DG.ci.dindex=1.
if DG.IAM=1 DG.ci=1.

********************************************.
*************************************.



*************************************          ..
**********************  SELECCIONO NOMES CASOS INCIDENTS             ************.
USE ALL.
COMPUTE filter_$=(event_IC = 1).
VARIABLE LABELS filter_$ 'event_IC = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* Definir conjuntos de respuestas múltiples.                      Comorbilidad                **************************. 
MRSETS
  /MDGROUP NAME=$Comorbilidad CATEGORYLABELS=VARLABELS VARIABLES=  DG.ci.dindex  DG.AVC_NO_AIT.dindex  DG.IAM.dindex  dem_dindex VALUE=1
  /DISPLAY NAME=[$Comorbilidad].

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=$Comorbilidad DerCardio_cat2 sit_2014  DISPLAY=BOTH
  /TABLE  $Comorbilidad [C] + sit_2014 [C] 
 BY DerCardio_cat2 [C][COUNT 
    F40.0] 
  /CATEGORIES VARIABLES= DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /CATEGORIES VARIABLES=$Comorbilidad  EMPTY=INCLUDE.

* Definir conjuntos de respuestas múltiples.                      Comorbilidad                **************************. 
MRSETS
  /MDGROUP NAME=$Comorbilidad CATEGORYLABELS=VARLABELS VARIABLES=  DG.ci DG.AVC_NO_AIT DG.IAM  dem VALUE=1
  /DISPLAY NAME=[$Comorbilidad].


* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=$Comorbilidad DerCardio_cat2 sit_2014  DISPLAY=BOTH
  /TABLE  $Comorbilidad [C] + sit_2014 [C] 
 BY DerCardio_cat2 [C][COUNT 
    F40.0] 
  /CATEGORIES VARIABLES= DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /CATEGORIES VARIABLES=$Comorbilidad  EMPTY=INCLUDE.


CROSSTABS
  /TABLES=DG.AVC_NO_AIT DG.ci DG.IAM BY DerCardio_cat2
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT
  /COUNT ROUND CELL.


**********************  SELECCIONO NOMES CASOS PREVALENTS              ************.
USE ALL.
COMPUTE filter_$=( IC_BASAL = 1).
VARIABLE LABELS filter_$ 'event_IC = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* Definir conjuntos de respuestas múltiples.                      Comorbilidad                **************************. 
MRSETS
  /MDGROUP NAME=$Comorbilidad CATEGORYLABELS=VARLABELS VARIABLES=  DG.ci DG.AVC_NO_AIT DG.IAM  dem VALUE=1
  /DISPLAY NAME=[$Comorbilidad].

* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=$Comorbilidad DerCardio_cat2 sit_2014  DISPLAY=BOTH
  /TABLE  $Comorbilidad [C] + sit_2014 [C] 
 BY DerCardio_cat2 [C][COUNT 
    F40.0] 
  /CATEGORIES VARIABLES= DerCardio_cat2 ORDER=A KEY=VALUE EMPTY=EXCLUDE
  /CATEGORIES VARIABLES=$Comorbilidad  EMPTY=INCLUDE.


CROSSTABS
  /TABLES=DG.AVC_NO_AIT DG.ci DG.IAM BY DerCardio_cat2
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT
  /COUNT ROUND CELL.

************************************************************************************************************.



