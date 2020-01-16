
*.HFEPCT_entregable_adult_pop_20160601_114256

*\BBDD\DATOS_SIDIAP\HFEPCT_entregable_adult_pop_20160601_114256.txt .

GET DATA  /TYPE=TXT
  /FILE="T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\DATOS_SIDIAP\HFEPCT_entregable_adult_pop_20160601_114256.txt"
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS="|"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  id A40
  sexe A1
  any_naix F4.0
  sit_2014 A1
  dat_sit_2014 A8
  sc_bcn A2
  medea_ic_pob A2
  tab_ic_pob F1.0
  alris_ic_pob F1.0.
CACHE.
EXECUTE.
DATASET NAME poblacio WINDOW=FRONT.

******************                                       LABELS                                                                      ****.
**  sexe any_naix sit_2014 dat_sit_2014 sc_bcn medea_ic_pob tab_ic_pob alris_ic_pob PrimarioÚltimo.
variable label 
sexe "Sexe del pacient"/ 
any_naix "Any de naixement del pacient"/
sit_2014 "Situació a data 20140131"/
dat_sit_2014 "Data de situació del pacient"/
sc_bcn "Indica si el pacient pertany o no a una secció censal de Barcelona, (Sectors que començen per 68..)"/
medea_ic_pob "Quintil MEDEA/Rural segons població 2014"/
tab_ic_pob "Situació tabac a data 20100101" /
alris_ic_pob "Variable risc alcoholisme més propera a 20100101 prèvia, amb una finestra de 5 anys".

value label tab_ic_pob 0 "No fumador" 1 "fumador" 2 "exfumador" /
alris_ic_pob 0 "Sense risc" 1 "Baix" 2 "alt risc" 3 "alt risc fora de consum".

*.
compute dtsit_2014=date.dmy(NUMBER(substring(dat_sit_2014,7,2),f2),NUMBER(substring(dat_sit_2014,5,2),f2),NUMBER(substring(dat_sit_2014,1,4),f4)).
compute anysit2014=xdate.year(dtsit_2014).
freq var=anysit2014.
*.

COMPUTE IC_BASAL=0. 
IF (dindexic <= date.dmy(1,1,2010)) ic_basal=1.

recode anyic (lo thru 2009=2009) (else=copy) .
value label anyic 2009 "2009 o anterior". 
frequencies var=ic_basal anyic.

***********         Edad a inici del estudi (01/01/2010)                                            ***.
compute edad=(ctime.days(date.dmy(1,1,2010)-date.dmy(15,6,any_naix))/365.25) .
descriptivo variables edad.

**.
************         Grups d'edat: <45, 45-54, 55-65, 65-74, 75.84, >84   ***************.
**.
recode edad (lo thru 44.99999=1) (45 thru 54.99999=2) (55 thru 64.99999=3) (65 thru 74.99999=4) (75 thru 84.99999=5)  (85 thru hi=6)  into edad_cat6.
value label  edad_cat6 1 "<45" 2 "[45-55)" 3 "[55-65)" 4 "[65-75)" 5 "[75-85)" 6 "85+" .



********************.
**********************            TAULA PARADIGM                                       ***************.
*********************.
GET DATA  /TYPE=TXT
  /FILE="T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\DATOS_SIDIAP\HFEPCT_entregable_ic_pob_dx_paradigm_20160601_114256.txt"
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS="|"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  id A40
  dalta F8.0
  dbaixa A8
  grup A10
  cim10 A6.
CACHE.
EXECUTE.
DATASET NAME IC_POB_DX_PARADIGM  WINDOW=FRONT.




*****       dalta dbaixa grup cim10   .
variable label dalta "Data d'alta del problema de salut" / dbaixa "Data de baixa del problema de salut" / grup "Grup al que pertany el  CIM10" 
/ cim10 "Per 'IC' i 'CI' el codi CIM10, per la resta buit".

SAVE OUTFILE='T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\TAULA_IC_POB_DX_PARADIGM.sav'
  /COMPRESSED.



***************************            TAULA_IC_POB_DX                ***************.

GET DATA  /TYPE=TXT
  /FILE="T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\DATOS_SIDIAP\HFEPCT_entregable_ic_pob_dx_20160601_114256.txt"
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS="|"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  id A40
  dindex A8
  dem F1.0
  dem_dindex F1.0
  anem F1.0
  anem_dindex F1.0
  fibau F1.0
  fibau_dindex F1.0
  cancer F1.0
  cancer_dindex F1.0
  ckd F1.0
  ckd_dindex F1.0
  resp F1.0
  resp_dindex F1.0
  dm_in F1.0
  dm_in_dindex F1.0
  dm1 F1.0
  dm1_dindex F1.0
  dm2 F1.0
  dm2_dindex F1.0
  dep F1.0
  dep_dindex F1.0
  dis F1.0
  dis_dindex F1.0
  hta F1.0
  hta_dindex F1.0
  artper F1.0
  artper_dindex F1.0
  iam_ci F1.0
  iam_ci_dindex F1.0
  este_ao F1.0
  este_ao_dindex F1.0
  mval F1.0
  mval_dindex F1.0
  crep F1.0
  crep_dindex F1.0
  obs F1.0
  obs_dindex F1.0
  disnea F1.0
  disnea_dindex F1.0.
CACHE.
EXECUTE.
DATASET NAME TAULA_IC_POB_DX WINDOW=FRONT.


** dindex .
compute dindexic=date.dmy(NUMBER(substring(dindex,7,2),f2),NUMBER(substring(dindex,5,2),f2),NUMBER(substring(dindex,1,4),f4)).
compute anyic=xdate.year(dindexic).

freq var=anyic. 

descriptives dindexic.





****  Labels          ***********.

Variable labels dindex 'Data de la primera IC que consti, encara que estigui donada de baixa'/
dem 'Indica si el diagnòstic de demència estava actiu o no a la data dinici de cohort'/
dem_dindex 'Indica si el diagnòstic de demència estava actiu o no a la dindex, si dindex és posterior a 20100101'/
anem 'Indica si el diagnòstic danèmia estava actiu o no a la data dinici de cohort'/
anem_dindex 'Indica si el diagnòstic de danèmia estava actiu o no a la dindex, si dindex és posterior a 20100101'/
fibau 'Indica si el diagnòstic de fibril·lació auricular estava actiu o no a la data dinici de cohort'/
fibau_dindex 'Indica si el diagnòstic de fibril·lació auricular estava actiu o no a la dindex, si dindex és posterior a 20100101'/
cancer 'Indica si el diagnòstic de cancer estava actiu o no a la data dinici de cohort'/
cancer_dindex 'Indica si el diagnòstic de cancer estava actiu o no a la dindex, si dindex és posterior a 20100101'/
ckd 'Indica si el diagnòstic de CKD estava actiu o no a la data dinici de cohort'/
ckd_dindex 'Indica si el diagnòstic de CKD estava actiu o no a la dindex, si dindex és posterior a 20100101'/
resp 'Indica si el diagnòstic de MPOC estava actiu o no a la data dinici de cohort'/
resp_dindex 'Indica si el diagnòstic de MPOC estava actiu o no a la dindex, si dindex és posterior a 20100101'/
dm_in 'Indica si el diagnòstic de dm_in estava actiu o no a la data dinici de cohort'/
dm_in_dindex 'Indica si el diagnòstic de dm_in estava actiu o no a la dindex, si dindex és posterior a 20100101'/
dm1 'Indica si el diagnòstic de dm1 estava actiu o no a la data dinici de cohort'/
dm1_dindex 'Indica si el diagnòstic de dm1 estava actiu o no a la dindex, si dindex és posterior a 20100101'/
dm2 'Indica si el diagnòstic de dm2 estava actiu o no a la data dinici de cohort'/
dm2_dindex 'Indica si el diagnòstic de dm2 estava actiu o no a la dindex, si dindex és posterior a 20100101'/
dep 'Indica si el diagnòstic de depressió estava actiu o no a la data dinici de cohort'/
dep_dindex 'Indica si el diagnòstic de depressió estava actiu o no a la dindex, si dindex és posterior a 20100101'/
dis 'Indica si el diagnòstic de dislipèmia estava actiu o no a la data dinici de cohort'/
dis_dindex 'Indica si el diagnòstic de dislipèmia estava actiu o no a la dindex, si dindex és posterior a 20100101'/
hta 'Indica si el diagnòstic dhipertensió arterial estava actiu o no a la data dinici de cohort'/
hta_dindex 'Indica si el diagnòstic dhipertensió arterial estava actiu o no a la dindex, si dindex és posterior a 20100101'/
artper 'Indica si el darteriopatia perifèrica de demència estava actiu o no a la data dinici de cohort'/
artper_dindex 'Indica si el diagnòstic darteriopatia perifèrica estava actiu o no a la dindex, si dindex és posterior a 20100101'/
iam_ci 'Indica si el diagnòstic de cardiopatia isquèmica estava actiu o no a la data dinici de cohort'/
iam_ci_dindex 'Indica si el diagnòstic de cardiopatia isquèmica estava actiu o no a la dindex, si dindex és posterior a 20100101'/
este_ao 'Indica si el destenosi aòrtica de demència estava actiu o no a la data dinici de cohort'/
este_ao_dindex 'Indica si el diagnòstic destenosi aòrtica estava actiu o no a la dindex, si dindex és posterior a 20100101'/
mval 'Indica si el diagnòstic de malaltia de vàlvula mitral estava actiu o no a la data dinici de cohort'/
mval_dindex 'Indica si el diagnòstic de malaltia de vàlvula mitral estava actiu o no a la dindex, si dindex és posterior a 20100101'/
crep 'Indica si el diagnòstic de crepitacions estava actiu o no a la data dinici de cohort'/
crep_dindex 'Indica si el diagnòstic de crepitacions estava actiu o no a la dindex, si dindex és posterior a 20100101'/
obs 'Indica si el diagnòstic dobesitat estava actiu o no a la data dinici de cohort'/
obs_dindex 'Indica si el diagnòstic dobesitat estava actiu o no a la dindex, si dindex és posterior a 20100101'/
disnea 'Indica si el diagnòstic de disnea estava actiu o no a la data dinici de cohort'/
disnea_dindex 'Indica si el diagnòstic de disnea estava actiu o no a la dindex, si dindex és posterior a 20100101'.


*****.
SAVE OUTFILE='T:\RECERCA\GRUPS_RECERCA_I '+ 
    'XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS '+ 
    'ACTIVOS\NOVARTIS_Basel\BBDD\TAULA_IC_POB_DX_N115891.sav' 
  /COMPRESSED.

*****.

*************               VARIABLES                                                                   ********************.
GET DATA  /TYPE=TXT
  /FILE="T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\DATOS_SIDIAP\HFEPCT_entregable_ic_pob_var_20160601_114256.txt" 
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS="|"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  id A40
  variable A5
  data A8
  valor F6.0.
CACHE.
EXECUTE.
DATASET NAME VARIABLES  WINDOW=FRONT.

variable label variable "Pes , Talla , IMC, NYHA, FE, ECG, MDRD, PAS, PAD , FC". 

 *** capturo data  dindex  i dtinici2010               ***************.
compute data_valor=date.dmy(NUMBER(substring(data,7,2),f2),NUMBER(substring(data,5,2),f2),NUMBER(substring(data,1,4),f4)).
compute dindexic=date.dmy(NUMBER(substring(dindex,7,2),f2),NUMBER(substring(dindex,5,2),f2),NUMBER(substring(dindex,1,4),f4)).
compute dies_dataindex= ctime.days(dindexic-data_valor). 
compute dies_dtinici2010= ctime.days(dtinici2010-data_valor). 
**.
*****  Ordenar de menor a major en valor absolut i agafo el mes petit (serà el mes proper)****. 
if dies_dataindex>-180  dies_abs_dataindex=abs(dies_dataindex).
**.
if dies_dtinici2010>-180  dies_abs_dtinici2010=abs(dies_dtinici2010).
**.
**.
if (dies_dataindex >=-180 and  variable="FC")  valor.fc=  valor.
if (dies_dtinici2010 >=-180 and  variable="FC")  valor2010.fc=  valor.

if (dies_dataindex >=-180 and  variable="FE")  valor.FE=  valor.
if (dies_dtinici2010 >=-180 and  variable="FE")  valor2010.FE=  valor.

if (dies_dataindex >=-180 and  variable="IMC")  valor.IMC=  valor.
if (dies_dtinici2010 >=-180 and  variable="IMC")  valor2010.IMC=  valor.

if (dies_dataindex >=-180 and  variable="K")  valor.K=  valor.
if (dies_dtinici2010 >=-180 and  variable="K")  valor2010.K=  valor.

if (dies_dataindex >=-180 and  variable="MDRD")  valor.mdrd=  valor.
if (dies_dtinici2010 >=-180 and  variable="MDRD")  valor2010.mdrd=  valor.

if (dies_dataindex >=-180 and  variable="NYHA")  valor.nyha=  valor.
if (dies_dtinici2010 >=-180 and  variable="NYHA")  valor2010.nyha=  valor.

if (dies_dataindex >=-180 and  variable="PAD")  valor.pad=  valor.
if (dies_dtinici2010 >=-180 and  variable="PAD")  valor2010.pad=  valor.

if (dies_dataindex >=-180 and  variable="PAS")  valor.pas=  valor.
if (dies_dtinici2010 >=-180 and  variable="PAS")  valor2010.pas=  valor.

if (dies_dataindex >=-180 and  variable="PES")  valor.pes= valor.
if (dies_dtinici2010 >=-180 and  variable="PES")  valor2010.pes= valor.

if (dies_dataindex >=-180 and  variable="TALLA")  valor.talla= valor.
if (dies_dtinici2010 >=-180 and  variable="TALLA")  valor2010.talla= valor.

if (dies_dataindex >=-180 and  variable="ECG")  valor.ecg= 1.
if (dies_dtinici2010 >=-180 and  variable="ECG")  valor2010.ecg=  1.


****      Seleccionar valors més propers a data index (+180dies)

DATASET ACTIVATE valors_dataindex.
DATASET DECLARE valors_mesproximsIC.
AGGREGATE
  /OUTFILE='valors_mesproximsIC'
  /BREAK=id
  /valor.fc=FIRST(valor.fc) 
  /valor.FE=FIRST(valor.FE) 
  /valor.IMC=FIRST(valor.IMC) 
  /valor.K=FIRST(valor.K) 
  /valor.mdrd=FIRST(valor.mdrd) 
  /valor.nyha=FIRST(valor.nyha) 
  /valor.pad=FIRST(valor.pad) 
  /valor.pas=FIRST(valor.pas) 
  /valor.pes=FIRST(valor.pes) 
  /valor.talla=FIRST(valor.talla) 
  /valor.ecg=FIRST(valor.ecg).


****      Seleccionar valors més propers a 01/01/2010 (+180dies)

DATASET ACTIVATE valorsbasals_data2010.
DATASET DECLARE valors_basals2010.
AGGREGATE
  /OUTFILE='valors_basals2010'
  /BREAK=id
  /valor2010.fc=FIRST(valor2010.fc) 
  /valor2010.FE=FIRST(valor2010.FE) 
  /valor2010.IMC=FIRST(valor2010.IMC) 
  /valor2010.K=FIRST(valor2010.K) 
  /valor2010.mdrd=FIRST(valor2010.mdrd) 
  /valor2010.nyha=FIRST(valor2010.nyha) 
  /valor2010.pad=FIRST(valor2010.pad) 
  /valor2010.pas=FIRST(valor2010.pas) 
  /valor2010.pes=FIRST(valor2010.pes) 
  /valor2010.talla=FIRST(valor2010.talla) 
  /valor2010.ecg=FIRST(valor2010.ecg).




********         ECG ---> No es una variable. si Consta considerem que esta feta          ************.
FREQUENCIES VARIABLES=variable
  /ORDER=ANALYSIS.

*************            .
SAVE OUTFILE='T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\TAULA_IC_POB_VAR_N7773004.sav'
  /COMPRESSED.
*******************************.

**********************            TRACTAMENTS          *************.
GET DATA  /TYPE=TXT
  /FILE="T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\DATOS_SIDIAP\HFEPCT_entregable_ic_pob_tto_20160601_114256.txt"
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS="|"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  id A40
  grp_atc7 A7
  dini A8
  dfi A8
  nddd F5.0
  grup A6.
CACHE.
EXECUTE.
DATASET NAME tractaments WINDOW=FRONT.

variable label  atc7 "Codi ATC prescrit-facturat" / 
 origen "Origen de la dada" /
 dini "Data inici de la prescripció o any i mes de la facturació" / 
 dfi "Data de fi de la prescripció, null si el registre prové de facturació" / 
 nddd "facturades el mes, si és un registre de facturació, o les prescrites al periode indicat per dini i dfi" /
 grup "Codi d'agrupador de farmacs" / 
 durada_dies "Durada en dies del període de la prescripcio".


***************************CONVERSIÓ A DDD PER PARADIGM          *******************.
****  si es facturació DDD= NDDD/30  si es prescripció DDD=dfi-dini      ***************.
compute datafi=date.dmy(NUMBER(substring(dfi,7,2),f2),NUMBER(substring(dfi,5,2),f2),NUMBER(substring(dfi,1,4),f4)).
compute dataini=date.dmy(NUMBER(substring(dini,7,2),f2),NUMBER(substring(dini,5,2),f2),NUMBER(substring(dini,1,4),f4)).
*.
**** Si es prescripció DDD es igual NDDD      *.
if dfi<>"" DDD=nddd.
if dfi="" DDD=nddd/30.
*.

***********      Reajustem requisits mínims a la dosis de IC      **.
if grp_atc7='C09AA01' ddd=ddd*0.5.
if grp_atc7='C09AA02' ddd=ddd*1.
if grp_atc7='C09AA03' ddd=ddd*1.
if grp_atc7='C09AA04' ddd=ddd*1.
if grp_atc7='C09AA05' ddd=ddd*0.5.
if grp_atc7='C09AA06' ddd=ddd*0.75.
if grp_atc7='C09AA07' ddd=ddd*1.
if grp_atc7='C09AA08' ddd=ddd*1.
if grp_atc7='C09AA09' ddd=ddd*0.75.
if grp_atc7='C09AA10' ddd=ddd*1.
if grp_atc7='C09AA11' ddd=ddd*1.
if grp_atc7='C09AA12' ddd=ddd*1.
if grp_atc7='C09AA13' ddd=ddd*2.
if grp_atc7='C09AA14' ddd=ddd*1.
if grp_atc7='C09AA15' ddd=ddd*1.
if grp_atc7='C09AA16' ddd=ddd*1.
if grp_atc7='C09CA01' ddd=ddd*1.
if grp_atc7='C09CA02' ddd=ddd*1.5.
if grp_atc7='C09CA03' ddd=ddd*0.5.
if grp_atc7='C09CA04' ddd=ddd*1.
if grp_atc7='C09CA05' ddd=ddd*1.
if grp_atc7='C09CA06' ddd=ddd*0.5.
if grp_atc7='C09CA07' ddd=ddd*1.
if grp_atc7='C09CA08' ddd=ddd*2.
if grp_atc7='C09CA09' ddd=ddd*1.



**********************         ARA fer un acumulat ultims 3 mesos entre 01/10/2014 - 31/12/2014      **.
if missing(dataini) dataini=date.dmy(1,NUMBER(substring(dini,5,2),f2),NUMBER(substring(dini,1,4),f4)).
string atc3 (a3).
compute ATC3=substring(grp_atc7,1,3).
freq var=atc3.
*.
*******************Calculem dies exposats tres mesos anteriors a desembre 2014  i ddd acumulades en cada tram  *******.
******         Si data inici es anterior a octubre 2014 i fi es superior a gener 2014 cobreix tot el periode (90 dies)     ********************.
if (ATC3="C07" and dataini<=date.dmy(01,10,2014) and datafi>=date.dmy(31,12,2014)) dies_C07=90 .
****      Acaba entre octubre i desembre             **.
if (ATC3="C07" and dataini<=date.dmy(01,10,2014) and datafi>date.dmy(01,10,2014) and datafi<date.dmy(31,12,2014) ) dies_C07=ctime.days(datafi-date.dmy(01,10,2014)) .
*****      Inicia entre octubre i desembre  ****.
if (ATC3="C07" and dataini>date.dmy(01,10,2014) and dataini<=date.dmy(01,10,2014) and datafi>=date.dmy(31,12,2014)) dies_C07=ctime.days(date.dmy(31,12,2014)-dataini) .
******   FActuració       **.
if ATC3="C07" and missing(datafi) and dataini>=date.dmy(01,10,2014) and  dataini<=date.dmy(31,12,2014)  dies_C07=30.
******   .
if ATC3="C07" nddd.C07= dies_C07*ddd.

*******************Calculem dies exposats tres mesos anteriors a desembre 2014  i ddd acumulades en cada tram  *******.
******         Si data inici es anterior a octubre 2014 i fi es superior a gener 2014 cobreix tot el periode      ********************.
if (ATC3="C09" and dataini<=date.dmy(01,10,2014) and datafi>=date.dmy(31,12,2014)) dies_C09=90 .
****      Acaba entre octubre i desembre             **.
if (ATC3="C09" and dataini<=date.dmy(01,10,2014) and datafi>date.dmy(01,10,2014) and datafi<date.dmy(31,12,2014) ) dies_C09=ctime.days(datafi-date.dmy(01,10,2014)) .
*****      Inicia entre octubre i desembre  ****.
if (ATC3="C09" and dataini>date.dmy(01,10,2014) and dataini<=date.dmy(01,10,2014) and datafi>=date.dmy(31,12,2014)) dies_C09=ctime.days(date.dmy(31,12,2014)-dataini) .
******   FActuració       **.
if ATC3="C09" and missing(datafi) and dataini>=date.dmy(01,10,2014) and  dataini<=date.dmy(31,12,2014)  dies_C09=30.
******   .
*******         Calculo Nddd per tram       **.
if ATC3="C09" nddd.C09= dies_C09*ddd.
*****.

AGGREGATE 
  /OUTFILE='KIKI' 
  /BREAK=id 
  /nddd.C07_sum=SUM(nddd.C07) 
  /nddd.C09_sum=SUM(nddd.C09) 
  /dies_C09_sum=SUM(dies_C09) 
  /dies_C07_sum=SUM(dies_C07) 
  /N_BREAK=N. 

*.
************************                                                            ********.
********************************************************************************.


SAVE OUTFILE='T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\TAULA_IC_PO_TTO_N12251939.sav'
  /COMPRESSED.

****************.
**********************         RECURSOS                                                    ******************.
GET DATA  /TYPE=TXT
  /FILE="T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\DATOS_SIDIAP\HFEPCT_entregable_ic_pob_recursos_20160601_114256.txt"
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS="|"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  id A40
  tipus A13
  data A8.
CACHE.
EXECUTE.
DATASET NAME RECURSOS  WINDOW=FRONT.

VARIABLE LABEL tipus "Recurs sanitari" / data "Data de utilització". 

frequencies variables tipus.
compute data_der=date.dmy(NUMBER(substring(data,7,2),f2),NUMBER(substring(data,5,2),f2),NUMBER(substring(data,1,4),f4)).
compute anyder=xdate.year(data_der).
*.
if  (tipus = "DER_CARDIO" AND ANYDER<2015 AND anyder>2009)  SELECT=1 . 
*.
freq anyder.


**         Agregem Nombre de petidions per recurs                ************.

DATASET ACTIVATE RECURSOS.
DATASET DECLARE RECURSOS_PACIENT_RECURS.
AGGREGATE
  /OUTFILE='RECURSOS_PACIENT_RECURS'
  /BREAK=id tipus
  /NPETICIONS=N.

***      Reestructurem per tipo de recurs          **.

SORT CASES BY id tipus.
CASESTOVARS
  /ID=id
  /INDEX=tipus
  /GROUPBY=VARIABLE.
