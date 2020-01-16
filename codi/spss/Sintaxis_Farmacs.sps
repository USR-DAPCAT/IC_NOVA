*******************************************************************************.
*.
*.
GET
  FILE='T:\RECERCA\GRUPS_RECERCA_I XARXES\GRUPS\ACREDITADOS\Cardiovascular\A_PROYECTOS\A_IC\A_PROYECTOS ACTIVOS\NOVARTIS_Basel\BBDD\BDSPSS\IC_POB_TTO_N12562913.sav'.
DATASET NAME FARMACS  WINDOW=FRONT.
*.
*************************************         Estudio farmacos                ********************************************.
**********         PATRONES DE TRATAMIENTOS             *****************************************************.
*.
********      Treatment prescibed at baseline        TRACTAMENT PRESCRIT A INICI I FINAL/ANY DE SEGUIMENT                 ***.
********      Treatment prescibed at baseline        TRACTAMENT PRESCRIT A INICI I FINAL/ANY DE SEGUIMENT                 ***.
********      Treatment prescibed at baseline        TRACTAMENT PRESCRIT A INICI I FINAL/ANY DE SEGUIMENT                 ***.
********      Treatment prescibed at 1 year follwoing index      ***.
*.
*.
**********        Genero dues dates : 1. Data_inclusio (1/1/2010 pels prevalents)  (Data IC Incidents)
**********                                       2. Data_any_seguiment (+12 mesos) o Data fi de seguiment (Defunció o trasllat o 31/12/2014) *.
* dtinclusio .
if (dindexic>date.dmy(01,01,2010)) dtinclusio= dindexic.
if (dindexic<=date.dmy(01,01,2010)) dtinclusio= date.dmy(01,01,2010).
* dtanyseguiment    *.
compute dtanyseguiment=DATESUM(dtinclusio, 12, "months", 'closest').
if dtanyseguiment>date.dmy(31,12,2014) dtanyseguiment=date.dmy(31,12,2014).
* Si es exitus abans de 12 mesos s'asigna data fi de de seguiment *.
if  (sit_2014="D" or sit_2014="T") and (dtsit_2014<=dtanyseguiment)  dtanyseguiment= dtsit_2014.
*.
*.
variable label dtanyseguiment "Data al any de seguiment, o fi de periode anterior al any o exitus" .
*.
*********      Ara he de calcular si la presa del farmac estava entre +-30 dies (60 dies finestra) en la data d'iniclusió  (dtinclusio) .
*********      Ara he de calcular si la presa  del farmac estava 60 dies previs (60 dies finestra) anterior a data any seguiment (dtanyseguiment) .
***.

*** Calculo data fi en funció del nddd.
compute datafi.nddd=DATESUM(dataini, nddd, "days", 'closest').

*********         INDICADOR FARMAC_INI / FARMAC_FI          *.
* Si inici o fi de farmac esta en una finestra de 60 dies (+- 30 dies data índex) finestra al voltant de data d'inici. 
compute farmac_ini=0.
if  (dataini>=DATESUM(dtinclusio, -30, "days", 'closest') and dataini<=DATESUM(dtinclusio, 30, "days", 'closest')) farmac_ini=1. 
if  (datafi.nddd>=DATESUM(dtinclusio, -30, "days", 'closest') and datafi.nddd<=DATESUM(dtinclusio, 30, "days", 'closest')) farmac_ini=1. 
**.
* Si inici o fi de farmac esta entre 60 dies abans del fi de seguiment o l'any posterior. 
compute farmac_1anyfi=0.
if  (dataini>=DATESUM(dtanyseguiment, -60, "days", 'closest'))  and (dataini<=dtanyseguiment) farmac_1anyfi=1. 
if  (datafi.nddd>=DATESUM(dtanyseguiment, -60, "days", 'closest')) and (datafi.nddd<=dtanyseguiment) farmac_1anyfi=1. 
freq var  farmac_1anyfi.
**.
**.

*********************         SELECCIONO NOMÉS FACTURACIÓ   (N-> 10.000.000)          ***.
DATASET COPY  facturacio. 
DATASET ACTIVATE  facturacio. 
FILTER OFF. 
USE ALL. 
SELECT IF (missing(datafi)). 
EXECUTE.
**********************************************************************.
**.
*** S'hauria d'agregar per pacients - farmacs que vull computar si pren farmac inici i final (ID-grup) ***. 
DATASET ACTIVATE FARMACS.
DATASET DECLARE PAKI.
AGGREGATE
  /OUTFILE='PAKI'
  /BREAK=id ATC_GRUP2
  /farmac_ini=MAX(farmac_ini) 
  /farmac_1anyfi=MAX(farmac_1anyfi).

***.

RECODE ATC_GRUP ("DIU_HFEPCT"="DIU").

FREQ VAR=ATC_GRUP2.

SORT CASES BY id ATC_GRUP2.
CASESTOVARS
  /ID=id
  /INDEX=ATC_GRUP2
  /GROUPBY=VARIABLE.

VARIABLE LABEL  farmac_ini.ARA2  "ARA2 +-30 dies inici de seguiment" /
farmac_ini.BBK "BBK +-30 dies inici de seguiment" / 
farmac_ini.BCCA "BCCA +-30 dies inici de seguiment" 
farmac_ini.DIGOX f"DIGOX +-30 dies inici de seguiment" /
farmac_ini.DIU_ALDOSTERONA "DIU ALDOSTERONA +-30 dies inici de seguiment"  / 
farmac_ini.DIU_ASA  "DIU ASA +-30 dies inici de seguiment" /
farmac_ini.DIU_HFEPCT "DIU RESTA+-30 dies inici de seguiment" /
farmac_ini.HYDRA "HYDRA +-30 dies inici de seguiment" / 
farmac_ini.IECA "IECA +-30 dies inici de seguiment" /
farmac_ini.IVAB "IVAB +-30 dies inici de seguiment"/
farmac_ini.NITRAT "NITRAT+-30 dies inici de seguiment" /
farmac_1anyfi.ARA2 "ARA2 +-30 o 60 dies abans final/1any de seguiment" / 
farmac_1anyfi.BBK "BBK +-30 o 60 dies abans final/1any de seguiment" / 
farmac_1anyfi.BCCA "BCCA +-30 o 60 dies abans final/1any de seguiment" / 
farmac_1anyfi.DIGOX "DIGOX +-30 o 60 dies abans final/1any de seguiment" / 
farmac_1anyfi.DIU_ALDOSTERONA "DIU ALDOSTERONA +-30 o 60 dies abans final/1any de seguiment" /
farmac_1anyfi.DIU_ASA "DIU ASA +-30 o 60 dies abans final/1any de seguiment"/
farmac_1anyfi.DIU_HFEPCT  "DIU +-30 o 60 dies abans final/1any de seguiment"/ 
farmac_1anyfi.HYDRA "HYDRA +-30 o 60 dies abans final/1any de seguiment" / 
farmac_1anyfi.IECA "IECA +-30 o 60 dies abans final/1any de seguiment" / 
farmac_1anyfi.IVAB "IVAB +-30 o 60 dies abans final/1any de seguiment" / 
farmac_1anyfi.NITRAT "NITRAT+-30 o 60 dies abans final/1any de seguiment".


recode  farmac_ini.ARA2 farmac_ini.BBK farmac_ini.BCCA farmac_ini.DIGOX farmac_ini.DIU_ALDOSTERONA 
    farmac_ini.DIU_ASA farmac_ini.DIU_HFEPCT farmac_ini.HYDRA farmac_ini.IECA farmac_ini.IVAB 
    farmac_ini.NITRAT farmac_1anyfi.ARA2 farmac_1anyfi.BBK farmac_1anyfi.BCCA farmac_1anyfi.DIGOX 
    farmac_1anyfi.DIU_ALDOSTERONA farmac_1anyfi.DIU_ASA farmac_1anyfi.DIU_HFEPCT farmac_1anyfi.HYDRA 
    farmac_1anyfi.IECA farmac_1anyfi.IVAB farmac_1anyfi.NITRAT   (SYSMIS=0) (1=1) (0=0).


*************************            ARA HO ADJUNTO A POBLACIÓ          **.

**.
**.

********         CALCUL DE SWITCH , PERSISTENCIA, ADHERENCIA                      *****.

***   ordenar per ID i data prescripció . 

sort by id dataini.

***    Seleccionar prescripcions desde data index    **.
***.

**********************      CANVI DE TRACTAMENT (SWICH)        *******************************.
***.
***   Nou tractament prescrit despres de Data index  , Despres d'una discontinuitat >30 dies,  
***.
*******     calcular 1a data despres de la data index amb tractament despres de > 30 dies de tractament  .
******      Si un te una discontinuitat de 30 dies o menys no es considera canvi de tractament
***.
******   S'ha de calcular temps entre Data index i seguent tractament. 

if (dindexic<data.dmy(01,01,2010)) dindexic=data.dmy(01,01,2010).

if (id<>lag(id)) temps_txprevi=ctime.days( dataini-lag(dindexic))  . 
if (id=lag(id)) temps_txprevi=ctime.days( dataini-lag(dataini))  . 

********                        PERSISTENCIA                                                                    ***. 
*.
* Persistencia (A nivel de cada fármaco): (Numérica)
* - Tiempo trascurrido bajo un mismo tratamiento des de la fecha de inicio de TX hasta: Tiempo mínimo entre 
****      Calcular dos dates: 
         1. Data 1a facturació despres de data index (dt1_fx)
         2. Data última facturació amb tractament previ fi de seguiment (dtfi_fx) **.
*.
***. 1 Data 1a facturació despres de data index (dt1_fx) **.
*.
****         Si en data d'inclusio porta farmac = dt1_fx= data_index    *.
****         Si en data d'inclusio no porta farmac = dt1_fx= dataini si dataini>dtinclusio     *.
if farmac_ini=1 dt1_fx=dtinclusio.
if (farmac_ini=0 and dataini>=dtinclusio)  dt1_fx=dataini.
****.
****.
********************         Selecciono només FACTURACIÓ    POSTERIOR A DATA D'INCLUSIÓ             ****.
DATASET ACTIVATE Conjunto_de_datos2.
DATASET COPY  facturacio_posterior_datainclusio.
DATASET ACTIVATE  facturacio_posterior_datainclusio.
FILTER OFF.
USE ALL.
SELECT IF (missing(datafi) and dataini >= dtinclusio).
EXECUTE.
DATASET ACTIVATE  Conjunto_de_datos2.



****   dtfi_fx  (primera discontinuitat o final de seguiment)  ************.
*** Computar el temps entre una data i guardar la data previa dins de cada farmac   **.

******               CAMBIAR grup per  ----> ATC_GRUP   (Agrupació ben feta segons codis ATC7)         **.
*.
compute ATC_GRUP=ATC_GRUP2.
sort cases by id(A) ATC_GRUP(A) datafi.nddd(A).
if  (dataini>=dtinclusio and (id=lag(id) and ATC_GRUP=lag(ATC_GRUP)))  temps_entreFX=ctime.days(dataini-lag(datafi.nddd)).
if  (dataini>=dtinclusio and (id=lag(id) and ATC_GRUP=lag(ATC_GRUP)))  data_lag60=lag(datafi.nddd).
exe.
*.

***   Agregar primera data (si ha passat més de 60 dies entre dates) *  --> Llavors tenim primera data que hi ha una discontinuitat >60 dies .
DATASET COPY  pepi.
DATASET ACTIVATE  pepi.
FILTER OFF.
USE ALL.
SELECT IF (temps_entreFX >= 62 and missing(datafi)).
EXECUTE.
DATASET ACTIVATE  Conjunto_de_datos1.
*.
****         Ordeno perque quedi la primera data abans del gap60  data_lag60 i agafo la minima data          *.
DATASET ACTIVATE pepi.
SORT CASES BY id(A) ATC_GRUP(A) data_lag60(A).
*.
DATASET ACTIVATE pepi.
DATASET DECLARE primera_data_gap60.
AGGREGATE
  /OUTFILE='primera_data_gap60'
  /BREAK=id ATC_GRUP
  /data_lag60_min=MIN(data_lag60).
*.

****      Fusiono la data del gap60             **************.
*.
MATCH FILES /FILE=*
  /TABLE='primera_data_gap60'
  /BY id ATC_GRUP.
EXECUTE.


* data_lag60_min .

***************         Data FI_fx ********************.
***   dtfi_fx  (primera discontinuitat o final de seguiment ( dtsit_2014 o 31/12/2014) )  ************.
compute dtfi_fx=data_lag60_min.
if (farmac_ini and missing(dtfi_fx) and  sit_2014="D" or sit_2014="T")  dtfi_fx= dtsit_2014.
if (farmac_ini and missing(dtfi_fx) and  sit_2014="D" or sit_2014="T")  dtfi_fx= dtsit_2014.
if (farmac_ini and missing(dtfi_fx)) dtfi_fx=date.dmy(31,12,2014).
***************************************                        *.
variable label dtfi_fx  "(primera discontinuitat o final de seguiment ( dtsit_2014 o 31/12/2014) )".

DATASET DECLARE PRIMER_LAG_FX.
AGGREGATE
  /OUTFILE='PRIMER_LAG_FX'
  /BREAK=id ATC_GRUP2
  /data_lag60_min=min(data_lag60_min2)
 /dtfi_fx_min=MIN(dtfi_fx)
/dtini_fx_min=MIN(dt1_fx).

*****            Reestructurar       per FX         ***.

SORT CASES BY id ATC_GRUP2.
CASESTOVARS
  /ID=id
  /INDEX=ATC_GRUP2
  /GROUPBY=VARIABLE.
*.
*                    data_lag60_min                             *.
*.
*.
**********                                       2. Data_any_seguiment (+12 mesos) o Data fi de seguiment (Defunció o trasllat o 31/12/2014) *.
* dtinclusio .
if (dindexic>date.dmy(01,01,2010)) dtinclusio= dindexic.
if (dindexic<=date.dmy(01,01,2010)) dtinclusio= date.dmy(01,01,2010).
* dtanyseguiment    *.
compute dtanyseguiment=DATESUM(dtinclusio, 12, "months", 'closest').
if dtanyseguiment>date.dmy(31,12,2014) dtanyseguiment=date.dmy(31,12,2014).
*.
*.
************************************                  Amb BD IC 114.000      ** calculo per PERCISTENCE  cada FX temps daTA 1 fx FINS DATA PRIMER GAP **.

**** **.
****      ARA2 BBK BCCA DIGOX DIU_HFEPCT HYDRA IECA IVAB NITRAT         **.

***   Dates fi superiors a 31/12/2014 ****.
*.
if dtfi_fx_min.ARA2>date.dmy(31,12,2014) dtfi_fx_min.ARA2=date.dmy(31,12,2014).
if dtfi_fx_min.DIGOX>date.dmy(31,12,2014) dtfi_fx_min.DIGOX=date.dmy(31,12,2014).
if dtfi_fx_min.DIU_HFEPCT>date.dmy(31,12,2014) dtfi_fx_min.DIU_HFEPCT=date.dmy(31,12,2014).
if dtfi_fx_min.IECA>date.dmy(31,12,2014) dtfi_fx_min.IECA=date.dmy(31,12,2014).
if dtfi_fx_min.IVAB>date.dmy(31,12,2014) dtfi_fx_min.IVAB=date.dmy(31,12,2014).
if dtfi_fx_min.NITRAT>date.dmy(31,12,2014) dtfi_fx_min.NITRAT=date.dmy(31,12,2014).
if dtfi_fx_min.HYDRA>date.dmy(31,12,2014) dtfi_fx_min.HYDRA=date.dmy(31,12,2014).
if dtfi_fx_min.BCCA>date.dmy(31,12,2014) dtfi_fx_min.BCCA=date.dmy(31,12,2014).
if dtfi_fx_min.BBK>date.dmy(31,12,2014) dtfi_fx_min.BBK=date.dmy(31,12,2014).
if dtfi_fx_min.DIUALDOS>date.dmy(31,12,2014) dtfi_fx_min.DIUALDOS=date.dmy(31,12,2014).
if dtfi_fx_min.DIUASA>date.dmy(31,12,2014) dtfi_fx_min.DIUASA=date.dmy(31,12,2014).
if dtfi_fx_min.IVAB>date.dmy(31,12,2014) dtfi_fx_min.IVAB=date.dmy(31,12,2014).
 

*.
if sit_2014="D" data_exitus=dtsit_2014.
* ARA2 .
if dtini_fx_min.ARA2>=dtinclusio and farmac_ini.ARA2  percistenceARA2= ctime.days(data_lag60_min.ARA2-dtini_fx_min.ARA2).
if dtini_fx_min.ARA2>=dtinclusio and farmac_ini.ARA2 and missing(percistenceARA2) percistenceARA2= ctime.days(dtfi_fx_min.ARA2-dtini_fx_min.ARA2).
if dtini_fx_min.ARA2>=dtinclusio and missing(percistenceARA2) percistenceARA2= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.ARA2).
missing values percistenceARA2(lo thru 0).
*.
* BBK .
if dtini_fx_min.BBK>=dtinclusio and farmac_ini.BBK  percistenceBBK= ctime.days(data_lag60_min.BBK-dtini_fx_min.BBK).
if dtini_fx_min.BBK>=dtinclusio and farmac_ini.BBK and missing(percistenceBBK) percistenceBBK= ctime.days(dtfi_fx_min.BBK-dtini_fx_min.BBK).
if dtini_fx_min.BBK>=dtinclusio and missing(percistenceBBK) percistenceBBK= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.BBK).

*.
* BCCA .
if dtini_fx_min.BCCA>=dtinclusio and farmac_ini.BCCA  percistenceBCCA= ctime.days(data_lag60_min.BCCA-dtini_fx_min.BCCA).
if dtini_fx_min.BCCA>=dtinclusio and farmac_ini.BCCA and missing(percistenceBCCA) percistenceBCCA= ctime.days(dtfi_fx_min.BCCA-dtini_fx_min.BCCA).
if dtini_fx_min.BCCA>=dtinclusio and missing(percistenceBCCA) percistenceBCCA= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.BCCA).
*.
* DIGOX .
if dtini_fx_min.DIGOX>=dtinclusio and farmac_ini.DIGOX  percistenceDIGOX= ctime.days(data_lag60_min.DIGOX-dtini_fx_min.DIGOX).
if dtini_fx_min.DIGOX>=dtinclusio and farmac_ini.DIGOX and missing(percistenceDIGOX) percistenceDIGOX= ctime.days(dtfi_fx_min.DIGOX-dtini_fx_min.DIGOX).
if dtini_fx_min.DIGOX>=dtinclusio and missing(percistenceDIGOX) percistenceDIGOX= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.DIGOX).
*.
* DIU_HFEPCT .  dtfi_fx_min.DIU_HFEPCT  data_lag60_min.DIU_HFEPCT  farmac_ini.DIU.
if dtini_fx_min.DIU_HFEPCT>=dtinclusio and farmac_ini.DIU  percistenceDIU_HFEPCT= ctime.days(data_lag60_min.DIU_HFEPCT-dtini_fx_min.DIU_HFEPCT).
if dtini_fx_min.DIU_HFEPCT>=dtinclusio and farmac_ini.DIU and missing(percistenceDIU_HFEPCT) percistenceDIU_HFEPCT= ctime.days(dtfi_fx_min.DIU_HFEPCT-dtini_fx_min.DIU_HFEPCT).
if dtini_fx_min.DIU_HFEPCT>=dtinclusio and missing(percistenceDIU_HFEPCT) percistenceDIU_HFEPCT= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.DIU_HFEPCT).
*.
* HYDRA .
if dtini_fx_min.HYDRA>=dtinclusio and farmac_ini.HYDRA  percistenceHYDRA= ctime.days(data_lag60_min.HYDRA-dtini_fx_min.HYDRA).
if dtini_fx_min.HYDRA>=dtinclusio and farmac_ini.HYDRA and missing(percistenceHYDRA) percistenceHYDRA= ctime.days(dtfi_fx_min.HYDRA-dtini_fx_min.HYDRA).
if dtini_fx_min.HYDRA>=dtinclusio and missing(percistenceHYDRA) percistenceHYDRA= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.HYDRA).
*.
* IECA .
if dtini_fx_min.IECA>=dtinclusio and farmac_ini.IECA  percistenceIECA= ctime.days(data_lag60_min.IECA-dtini_fx_min.IECA).
if dtini_fx_min.IECA>=dtinclusio and farmac_ini.IECA and missing(percistenceIECA) percistenceIECA= ctime.days(dtfi_fx_min.IECA-dtini_fx_min.IECA).
if dtini_fx_min.IECA>=dtinclusio and missing(percistenceIECA) percistenceIECA= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.IECA).
*.
* IVAB .
if dtini_fx_min.IVAB>=dtinclusio and farmac_ini.IVAB  percistenceIVAB= ctime.days(data_lag60_min.IVAB-dtini_fx_min.IVAB).
if dtini_fx_min.IVAB>=dtinclusio and farmac_ini.IVAB and missing(percistenceIVAB) percistenceIVAB= ctime.days(dtfi_fx_min.IVAB-dtini_fx_min.IVAB).
if dtini_fx_min.IVAB>=dtinclusio and missing(percistenceIVAB) percistenceIVAB= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.IVAB).
*.
* NITRAT .
if dtini_fx_min.NITRAT>=dtinclusio and farmac_ini.NITRAT  percistenceNITRAT= ctime.days(data_lag60_min.NITRAT-dtini_fx_min.NITRAT).
if dtini_fx_min.NITRAT>=dtinclusio and farmac_ini.NITRAT and missing(percistenceNITRAT) percistenceNITRAT= ctime.days(dtfi_fx_min.NITRAT-dtini_fx_min.NITRAT).
if dtini_fx_min.NITRAT>=dtinclusio and missing(percistenceNITRAT) percistenceNITRAT= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.NITRAT).
*.
* DIUALDOS .
if dtini_fx_min.DIUALDOS>=dtinclusio and farmac_ini.DIU_ALDOSTERONA  percistenceDIUALDO= ctime.days(data_lag60_min.DIUALDO- dtini_fx_min.DIUALDOS).
if dtini_fx_min.DIUALDOS>=dtinclusio and farmac_ini.DIU_ALDOSTERONA and missing(percistenceDIUALDO) percistenceNITRAT= ctime.days(dtfi_fx_min.DIUALDOS-dtini_fx_min.DIUALDOS).
if dtini_fx_min.DIUALDOS>=dtinclusio and missing(percistenceDIUALDO) percistenceDIUALDO= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.DIUALDOS).
*.
* DIUASA  .
if dtini_fx_min.DIUASA>=dtinclusio and farmac_ini.DIU_ASA  percistenceDIUASA= ctime.days(data_lag60_min.DIUASA-dtini_fx_min.DIUASA).
if dtini_fx_min.DIUASA>=dtinclusio and farmac_ini.DIU_ASA and missing(percistenceDIUASA) percistenceNITRAT= ctime.days(dtfi_fx_min.DIUASA-dtini_fx_min.DIUASA).
if dtini_fx_min.DIUASA>=dtinclusio and missing(percistenceDIUASA) percistenceDIUASA= ctime.days(min(data_exitus,date.dmy(31,12,2014))-dtini_fx_min.DIUASA).
*.
recode percistenceARA2 percistenceBBK percistenceBCCA percistenceDIGOX percistenceDIU_HFEPCT 
    percistenceHYDRA percistenceIECA percistenceIVAB percistenceNITRAT (lo THRU 0=SYSMIS) (else=copy).

recode percistenceDIUALDO  percistenceDIUASA (lo THRU 0=SYSMIS) (else=copy).


DESCRIPTIVES  percistenceARA2 percistenceBBK percistenceBCCA percistenceDIGOX percistenceDIU_HFEPCT 
    percistenceHYDRA percistenceIECA percistenceIVAB percistenceNITRAT.

DESCRIPTIVES percistenceDIU_HFEPCT percistenceDIUALDO percistenceDIUASA .


*********                        ADHERENCIA      (Percistence / Temps de seguiment )                                                                ***.
*.
if  sit_2014="A" or sit_2014="T" temps_seguiment2=ctime.days(date.dmy(31,12,2014)- dtinclusio).
if  sit_2014="D" temps_seguiment2=ctime.days(data_exitus- dtinclusio).
*.
compute ADH_ARA2= percistenceARA2 / temps_seguiment2.
compute ADH_BBK= percistenceBBK / temps_seguiment2.
compute ADH_BCCA= percistenceBCCA / temps_seguiment2.
compute ADH_DIGOX= percistenceDIGOX / temps_seguiment2.
compute ADH_DIU= percistenceDIU_HFEPCT / temps_seguiment2.
compute ADH_HYDRA= percistenceHYDRA / temps_seguiment2.
compute ADH_IECA= percistenceIECA / temps_seguiment2.
compute ADH_IVAB= percistenceIVAB / temps_seguiment2.
compute ADH_NITRAT= percistenceNITRAT / temps_seguiment2.
compute ADH_DIUALDO= percistenceDIUALDO / temps_seguiment2.
compute ADH_DIUASA= percistenceDIUASA / temps_seguiment2.

exe.

descriptives  percistenceARA2 percistenceBBK percistenceBCCA percistenceDIGOX percistenceDIU_HFEPCT 
    percistenceHYDRA percistenceIECA percistenceIVAB percistenceNITRAT percistenceDIUALDO percistenceDIUASA .

descriptives  ADH_ARA2 ADH_BBK ADH_BCCA ADH_DIGOX ADH_DIU ADH_HYDRA ADH_IECA ADH_IVAB ADH_NITRAT ADH_DIUALDO ADH_DIUASA.

***********                                                                                                                  ***.

******************.
***************         SWITCH                        *****************.
FREQ VAR= gap.tt_sum paro.tt_sum nou.tt_sum.
* No switch: Continuitat de tractament, cap tractament afegit *.
if  gap.tt_sum=0 and nou.tt_sum=0 switch=0.
* Si Switch: 1 o més gaps grans o nou tractament afegit *.
if gap.tt_sum>=1 or nou.tt_sum>=1 switch=1.
descriptives gap.tt_sum paro.tt_sum nou.tt_sum.
freq var=SWITCH.
recode SWITCH (sysmis=9) (else=copy). 
***************         RECLASSIFICAR SWITCH (MISSING) AMB TRACTAMENT RETIRAT  / Prescrit      **.
if switch=9 and (dtini_fx_min.ARA2>=0 or dtini_fx_min.BBK>=0 or dtini_fx_min.BCCA>=0 or  dtini_fx_min.DIGOX>=0 or dtini_fx_min.DIU_HFEPCT>=0 or  
    dtini_fx_min.HYDRA>=0 or dtini_fx_min.IECA>=0 or  dtini_fx_min.IVAB>=0 or dtini_fx_min.NITRAT>=0) switch=99 .
if (switch=9 or switch=99) and (FX_INI_NUM>0) switch=99 .
if (switch=9 or switch=99 or  switch=999) and (FX_FI_NUM>0) switch=99 .


value label SWITCH 1 "Gap>=60 dies del mateix tractament abans de fi de tractament / Nou tractament afegit" 
0 "Continuitat del mateix tractament, sense canvis ni adicions" 
9 " No consta tractament retirat post diagnostic"
99 "Només consta tractament prescrit post diagnostic".


CROSSTABS
  /TABLES= switch BY IC_BASAL
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

******************      PERCISTENCE             **************.
MEANS TABLES=percistenceARA2 percistenceBBK percistenceBCCA percistenceDIGOX percistenceDIU_HFEPCT 
    percistenceHYDRA percistenceIECA percistenceIVAB percistenceNITRAT  percistenceDIUALDO percistenceDIUASA BY IC_BASAL
  /CELLS=MEAN COUNT STDDEV MEDIAN MIN MAX.

******************      ADHERENCE                            *.

MEANS TABLES=ADH_ARA2 ADH_BBK ADH_BCCA ADH_DIGOX ADH_DIU ADH_HYDRA ADH_IECA ADH_IVAB ADH_NITRAT ADH_DIUALDO ADH_DIUASA BY IC_BASAL
  /CELLS=MEAN COUNT STDDEV MEDIAN MIN MAX.

****.
******************************************************                  COMBINACIONS DE FARMACS                         *****.
********************************************************                                                                                         ****.
*****      Combinacions de farmacs             ****.
*ACEi mono
ACEi+BB
ACEi+MRA
ACEi+BB+MRA
ACEi+BB+MRA+ivabradine
ARB mono
ARB+BB
ARB+MRA
ARB+BB+MRA
ARB+BB+MRA+ivabradine
BB mono
BB+MRA
MRA mono
Ivabradine mono
Oral diuretics mono
ACEi+ARB
ACEi+ARB+BB
ACEi+ARB+MRA
*****************************.

count FX_INI_NUM=farmac_ini.ARA2 farmac_ini.BBK farmac_ini.BCCA farmac_ini.DIGOX farmac_ini.DIU farmac_ini.HYDRA 
    farmac_ini.IECA farmac_ini.IVAB farmac_ini.NITRAT (1).

count FX_FI_NUM=farmac_1anyfi.ARA2 farmac_1anyfi.BBK farmac_1anyfi.BCCA farmac_1anyfi.DIGOX farmac_1anyfi.DIU 
    farmac_1anyfi.HYDRA farmac_1anyfi.IECA farmac_1anyfi.IVAB farmac_1anyfi.NITRAT (1).

* farmac_ini.ARA2 farmac_ini.BBK farmac_ini.BCCA farmac_ini.DIGOX farmac_ini.DIU farmac_ini.HYDRA 
    farmac_ini.IECA farmac_ini.IVAB farmac_ini.NITRAT

* farmac_1anyfi.ARA2 farmac_1anyfi.BBK farmac_1anyfi.BCCA farmac_1anyfi.DIGOX farmac_1anyfi.DIU 
    farmac_1anyfi.HYDRA farmac_1anyfi.IECA farmac_1anyfi.IVAB farmac_1anyfi.NITRAT .


***************      MONO TERAPIA          *.
*ACEi mono   .
if FX_INI_NUM=1 AND farmac_ini.IECA=1 FxIniMono_IECA=1.
variable label FxIniMono_IECA "ACEi mono" .
*ARB mono   .
if FX_INI_NUM=1 AND farmac_ini.ARA2=1 FxIniMono_ARA2=1.
variable label FxIniMono_ARA2 "ARB mono" .
*BB mono   .
if FX_INI_NUM=1 AND farmac_ini.BBK=1 FxIniMono_BBK=1.
variable label FxIniMono_BBK "BB mono" .
* Diuretics mono   .
if FX_INI_NUM=1 AND farmac_ini.DIU=1 FxIniMono_DIU=1.
variable label FxIniMono_DIU "Diuretics mono" .
* Ivabradine mono   .
if FX_INI_NUM=1 AND farmac_ini.IVAB=1 FxIniMono_IVAB=1.
variable label FxIniMono_IVAB " Ivabradine mono" .
*.
****      Diureticos MONO   ***     farmac_ini.DIU_ALDOSTERONA   farmac_ini.DIU_ASA. 
* Diuretics mono ALDOSTERONA .   *.
if FX_INI_NUM=1 AND FxINIMono_DIU and farmac_ini.DIU_ALDOSTERONA=1 FxINIMono_DIU_ALDOS=1. 
variable label FxINIMono_DIU_ALDOS "Diuretics ALDOSTERONA mono" .
* Diuretics mono  ASA  .  
if FX_INI_NUM=1 AND FxINIMono_DIU and farmac_ini.DIU_ASA FxINIMono_DIU_ASA=1.
variable label FxINIMono_DIU_ASA "Diuretics ASA mono" .
**.


**************         BITERAPIA                *.
*ACEi+BB .
if FX_INI_NUM=2 AND farmac_ini.IECA AND farmac_ini.BBK FxIniBi_IECA_BBK=1.
variable label FxIniBi_IECA_BBK "ACEi+BB".
*ACEi+Diuretics.
if FX_INI_NUM=2 AND farmac_ini.IECA=1 AND farmac_ini.DIU FxIniBi_ACE_DIU=1.
variable label FxIniBi_ACE_DIU "ACEi+DIU".
* ARB+BB .
if FX_INI_NUM=2 AND farmac_ini.ARA2=1 AND farmac_ini.BBK FxIniBi_ARA2_BBK=1.
variable label FxIniBi_ARA2_BBK "ARB+BB".
* BB+Diuretics.
if FX_INI_NUM=2 AND farmac_ini.BBK AND farmac_ini.DIU FxIniBi_DIU_BBK=1.
variable label FxIniBi_DIU_BBK "BB+Diuretics".
* ARB+Diuretics *.
if FX_INI_NUM=2 AND farmac_ini.DIU AND  farmac_ini.ARA2 FxIniBi_DIU_ARA2=1.
variable label FxIniBi_DIU_ARA2 "ARB+Diuretics".
*ACEi+ARA2 .
if FX_INI_NUM=2 AND farmac_ini.IECA AND farmac_ini.ARA2 FxIniBi_IECA_ARA2=1.
variable label FxIniBi_IECA_ARA2 "ACEi+ARA2".
****.

**************         BITERAPIA DIU: ALDOS  ( farmac_ini.DIU_ALDOSTERONA)     ****.
*ACEi+Diuretics.
if FX_INI_NUM=2 AND farmac_ini.IECA=1 AND farmac_ini.DIU_ALDOSTERONA  FxIniBi_ACE_DIUALDO=1.
variable label FxIniBi_ACE_DIUALDO "ACEi+DIU ALDOS".
* BB+Diuretics.
if FX_INI_NUM=2 AND farmac_ini.BBK AND farmac_ini.DIU_ALDOSTERONA FxIniBi_BBK_DIUALDO=1.
variable label FxIniBi_BBK_DIUALDO "BB+Diuretics ALDOS".
* ARB+Diuretics *.
if FX_INI_NUM=2 AND farmac_ini.DIU_ALDOSTERONA AND  farmac_ini.ARA2 FxIniBi_ARA2_DIUALDO=1.
variable label FxIniBi_ARA2_DIUALDO "ARB+Diuretics ALDOS".
*.
*.
*.
**************         TRITERAPIA            *.
*ACEi+BB+Diuretic.
if FX_INI_NUM=3 AND farmac_ini.IECA AND farmac_ini.BBK AND farmac_ini.DIU FxIniTR_IECA_BBK_DIU=1.
variable label FxIniTR_IECA_BBK_DIU "ACEi+BB+Diuretic".
*ARB+BB+Diuretic.
if FX_INI_NUM=3 AND farmac_ini.ARA2 AND farmac_ini.BBK AND farmac_ini.DIU FxIniTR_ARA2_BBK_DIU=1.
variable label FxIniTR_ARA2_BBK_DIU "ARB+BB+Diuretic".
*ACEi+ARB+BB.
if FX_INI_NUM=3 AND farmac_ini.IECA AND farmac_ini.BBK AND farmac_ini.ARA2 FxIniTR_IECA_BBK_ARA2=1.
variable label FxIniTR_IECA_BBK_ARA2 "ACEi+ARB+BB".
*ACEi+ARB+Diuretic.
if FX_INI_NUM=3 AND farmac_ini.IECA AND farmac_ini.DIU AND farmac_ini.ARA2 FxIniTR_IECA_DIU_ARA2=1.
variable label FxIniTR_IECA_DIU_ARA2 "ACEi+ARB+Diuretic".

*.
************         TRIPLETEAPIA AMB DIURETICS ALDO     (farmac_ini.DIU_ALDOSTERONA)  **. 
*ACEi+BB+Diuretic.
if FX_INI_NUM=3 AND farmac_ini.IECA AND farmac_ini.BBK AND farmac_ini.DIU_ALDOSTERONA FxIniTR_IECA_BBK_DIUALDO=1.
variable label FxIniTR_IECA_BBK_DIUALDO "ACEi+BB+Diuretic ALDO".
*ARB+BB+Diuretic.
if FX_INI_NUM=3 AND farmac_ini.ARA2 AND farmac_ini.BBK AND farmac_ini.DIU_ALDOSTERONA FxIniTR_ARA2_BBK_DIUALDO=1.
variable label FxIniTR_ARA2_BBK_DIUALDO "ARB+BB+Diuretic ALDO".
*
*ACEi+ARB+Diuretic ALDO.
if FX_INI_NUM=3 AND farmac_ini.IECA AND farmac_ini.DIU_ALDOSTERONA AND farmac_ini.ARA2 FxIniTR_IECA_DIUALDO_ARA2=1.
variable label FxIniTR_IECA_DIUALDO_ARA2 "ACEi+ARB+DiureticALDO".

************************************************************************.
*************      QUATETERAPIA             *.
* ACEi+BB+Diuretic+ivabradine .
if FX_INI_NUM=4 AND farmac_ini.IECA AND farmac_ini.BBK AND farmac_ini.DIU AND farmac_ini.IVAB FxIniQT_IECA_BBK_DIU_IVAB=1.
variable label FxIniQT_IECA_BBK_DIU_IVAB "ACEi+BB+Diuretico+Ivabradine".
* ARB+BB+Diuretic+Ivabradine .
if FX_INI_NUM=4 AND farmac_ini.ARA2 AND farmac_ini.BBK AND farmac_ini.DIU AND farmac_ini.IVAB FxIniQT_ARA2_BBK_DIU_IVAB=1.
variable label FxIniQT_ARA2_BBK_DIU_IVAB "ARB+BB+Diuretic+Ivabradine".
*.
************  farmac_ini.DIU_ALDOSTERONA .
* ACEi+BB+Diuretic ALDO +ivabradine .
if FX_INI_NUM=4 AND farmac_ini.IECA AND farmac_ini.BBK AND farmac_ini.DIU_ALDOSTERONA AND farmac_ini.IVAB FxIniQT_IECA_BBK_DIUALDO_IVAB=1.
variable label FxIniQT_IECA_BBK_DIUALDO_IVAB "ACEi+BB+Diuretico ALDO+Ivabradine".
* ARB+BB+Diuretic+Ivabradine .
if FX_INI_NUM=4 AND farmac_ini.ARA2 AND farmac_ini.BBK AND farmac_ini.DIU_ALDOSTERONA AND farmac_ini.IVAB FxIniQT_ARA2_BBK_DIUALDO_IVAB=1.
variable label FxIniQT_ARA2_BBK_DIUALDO_IVAB "ARB+BB+Diuretic ALDO+Ivabradine".

*.
****************************.
recode  FxIniMono_IECA FxIniMono_ARA2 FxIniMono_BBK FxIniMono_DIU FxIniMono_IVAB FxIniBi_IECA_BBK 
    FxIniBi_ACE_DIU FxIniBi_ARA2_BBK FxIniBi_DIU_BBK FxIniBi_DIU_ARA2 FxIniBi_IECA_ARA2 
    FxIniTR_IECA_BBK_DIU FxIniTR_ARA2_BBK_DIU FxIniTR_IECA_BBK_ARA2 FxIniTR_IECA_DIU_ARA2 
    FxIniQT_IECA_BBK_DIU_IVAB FxIniQT_ARA2_BBK_DIU_IVAB (sysmis=0) (else=copy).

********************************.

freq var=  FxIniMono_IECA FxIniMono_ARA2 FxIniMono_BBK FxIniMono_DIU FxIniMono_IVAB FxIniBi_IECA_BBK 
    FxIniBi_ACE_DIU FxIniBi_ARA2_BBK FxIniBi_DIU_BBK FxIniBi_DIU_ARA2 FxIniBi_IECA_ARA2 
    FxIniTR_IECA_BBK_DIU FxIniTR_ARA2_BBK_DIU FxIniTR_IECA_BBK_ARA2 FxIniTR_IECA_DIU_ARA2 
    FxIniQT_IECA_BBK_DIU_IVAB FxIniQT_ARA2_BBK_DIU_IVAB.


**********************                  Ara mateix FINAL DE TRACTAMENT             *****************.
**********************                  Ara mateix FINAL DE TRACTAMENT             *****************.
**********************                  Ara mateix FINAL DE TRACTAMENT             *****************.
**********************                  Ara mateix FINAL DE TRACTAMENT             *****************.
**********************                  Ara mateix FINAL DE TRACTAMENT             *****************.
**********************                  Ara mateix FINAL DE TRACTAMENT             *****************.
**********************                  Ara mateix FINAL DE TRACTAMENT             *****************.
*.
*. farmac_1anyfi.ARA2 farmac_1anyfi.BBK farmac_1anyfi.BCCA farmac_1anyfi.DIGOX farmac_1anyfi.DIU 
    farmac_1anyfi.HYDRA farmac_1anyfi.IECA farmac_1anyfi.IVAB farmac_1anyfi.NITRAT 
*.
***************      MONO TERAPIA          *.
*ACEi mono   .
if FX_FI_NUM=1 AND farmac_1anyfi.IECA=1 FxFIMono_IECA=1.
variable label FxFIMono_IECA "ACEi mono" .
*ARB mono   .
if FX_FI_NUM=1 AND farmac_1anyfi.ARA2=1 FxFIMono_ARA2=1.
variable label FxFIMono_ARA2 "ARB mono" .
*BB mono   .
if FX_FI_NUM=1 AND farmac_1anyfi.BBK=1 FxFIMono_BBK=1.
variable label FxFIMono_BBK "BB mono" .
* Diuretics mono   .
if FX_FI_NUM=1 AND farmac_1anyfi.DIU=1 FxFIMono_DIU=1.
variable label FxFIMono_DIU "Diuretics mono" .
* Ivabradine mono   .
if FX_FI_NUM=1 AND farmac_1anyfi.IVAB=1 FxFIMono_IVAB=1.
variable label FxFIMono_IVAB " Ivabradine mono" .
*.
****      Diureticos MONO   ***     farmac_ini.DIU_ALDOSTERONA   farmac_ini.DIU_ASA. 
* Diuretics mono ALDOSTERONA .   *.
if FX_FI_NUM=1 AND FxFIMono_DIU and  farmac_1anyfi.DIU_ALDOSTERONA=1 FxFIMono_DIU_ALDOS=1. 
variable label FxFIMono_DIU_ALDOS "Diuretics ALDOSTERONA mono" .
* Diuretics mono  ASA  .  
if FX_FI_NUM=1 AND FxFIMono_DIU and  farmac_1anyfi.DIU_ASA FxFIMono_DIU_ASA=1.
variable label FxFIMono_DIU_ASA "Diuretics ASA mono" .
**.
**.
**.
**************         BITERAPIA                *.
*ACEi+BB .
if FX_FI_NUM=2 AND farmac_1anyfi.IECA AND farmac_1anyfi.BBK FxFIBi_IECA_BBK=1.
variable label FxFIBi_IECA_BBK "ACEi+BB".
*ACEi+Diuretics.
if FX_FI_NUM=2 AND farmac_1anyfi.IECA=1 AND farmac_1anyfi.DIU FxFIBi_ACE_DIU=1.
variable label FxFIBi_ACE_DIU "ACEi+DIU".
* ARB+BB .
if FX_FI_NUM=2 AND farmac_1anyfi.ARA2=1 AND farmac_1anyfi.BBK FxFIBi_ARA2_BBK=1.
variable label FxFIBi_ARA2_BBK "ARB+BB".
* BB+Diuretics.
if FX_FI_NUM=2 AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU FxFIBi_DIU_BBK=1.
variable label FxFIBi_DIU_BBK "BB+Diuretics".
* ARB+Diuretics *.
if FX_FI_NUM=2 AND farmac_1anyfi.DIU AND  farmac_1anyfi.ARA2 FxFIBi_DIU_ARA2=1.
variable label FxFIBi_DIU_ARA2 "ARB+Diuretics".
*ACEi+ARA2 .
if FX_FI_NUM=2 AND farmac_1anyfi.IECA AND farmac_1anyfi.ARA2 FxFIBi_IECA_ARA2=1.
variable label FxFIBi_IECA_ARA2 "ACEi+ARA2".
****.
******************         Bi Diuretics ALDOS ( farmac_1anyfi.DIU_ALDOSTERONA)
*ACEi+Diuretics.
if FX_FI_NUM=2 AND farmac_1anyfi.IECA=1 AND farmac_1anyfi.DIU_ALDOSTERONA FxFIBi_ACE_DIUALDOS=1.
variable label FxFIBi_ACE_DIUALDOS "ACEi+DIU ALDOS".
* BB+Diuretics.
if FX_FI_NUM=2 AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU_ALDOSTERONA FxFIBi_BBK_DIUALDOS=1.
variable label FxFIBi_BBK_DIUALDOS "BB+Diuretics ALDOS".
* ARB+Diuretics *.
if FX_FI_NUM=2 AND farmac_1anyfi.DIU AND farmac_1anyfi.DIU_ALDOSTERONA FxFIBi_ARA2_DIUALDOS=1.
variable label FxFIBi_ARA2_DIUALDOS "ARB+Diuretics ALDOS".
*ACEi+ARA2 .
*.
*.
*.
**************         TRITERAPIA                                                                                       *.
*ACEi+BB+Diuretic.
if FX_FI_NUM=3 AND farmac_1anyfi.IECA AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU FxFITR_IECA_BBK_DIU=1.
variable label FxFITR_IECA_BBK_DIU "ACEi+BB+Diuretic".
*ARB+BB+Diuretic.
if FX_FI_NUM=3 AND farmac_1anyfi.ARA2 AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU FxFITR_ARA2_BBK_DIU=1.
variable label FxFITR_ARA2_BBK_DIU "ARB+BB+Diuretic".
*ACEi+ARB+BB.
if FX_FI_NUM=3 AND farmac_1anyfi.IECA AND farmac_1anyfi.BBK AND farmac_1anyfi.ARA2 FxFITR_IECA_BBK_ARA2=1.
variable label FxFITR_IECA_BBK_ARA2 "ACEi+ARB+BB".
*ACEi+ARB+Diuretic.
if FX_FI_NUM=3 AND farmac_1anyfi.IECA AND farmac_1anyfi.DIU AND farmac_1anyfi.ARA2 FxFITR_IECA_DIU_ARA2=1.
variable label FxFITR_IECA_DIU_ARA2 "ACEi+ARB+Diuretic".

**********************TRIPLE (DIURETIC)                                             ***************************..
*ACEi+BB+Diuretic ALDO (farmac_1anyfi.DIU_ALDOSTERONA ).
if FX_FI_NUM=3 AND farmac_1anyfi.IECA AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU_ALDOSTERONA FxFITR_IECA_BBK_DIUALDO=1.
variable label FxFITR_IECA_BBK_DIUALDO "ACEi+BB+Diuretic ALDO".
*ARB+BB+Diuretic ALDO.
if FX_FI_NUM=3 AND farmac_1anyfi.ARA2 AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU_ALDOSTERONA FxFITR_ARA2_BBK_DIUALDO=1.
variable label FxFITR_ARA2_BBK_DIUALDO "ARB+BB+Diuretic ALDO".
*ACEi+ARB+Diuretic ALDO.
if FX_FI_NUM=3 AND farmac_1anyfi.IECA AND  farmac_1anyfi.DIU_ALDOSTERONA AND farmac_1anyfi.ARA2 FxFITR_IECA_DIUALDO_ARA2=1.
variable label FxFITR_IECA_DIUALDO_ARA2 "ACEi+ARB+Diuretic ALDO".



****.
****.
*************      QUATETERAPIA             *.
* ACEi+BB+Diuretic+ivabradine                *.
if FX_FI_NUM=4 AND farmac_1anyfi.IECA AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU AND farmac_1anyfi.IVAB FxFIQT_IECA_BBK_DIU_IVAB=1.
variable label FxFIQT_IECA_BBK_DIU_IVAB "ACEi+BB+Diuretico+Ivabradine".
* ARB+BB+Diuretic+Ivabradine .
if FX_FI_NUM=4 AND farmac_1anyfi.ARA2 AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU AND farmac_1anyfi.IVAB FxFIQT_ARA2_BBK_DIU_IVAB=1.
variable label FxFIQT_ARA2_BBK_DIU_IVAB "ARB+BB+Diuretic+Ivabradine".
*.

*************      QUATETERAPIA  DIURETIC ALDO (farmac_1anyfi.DIU_ALDOSTERONA)          *.
* ACEi+BB+Diuretic+ivabradine                *.
if FX_FI_NUM=4 AND farmac_1anyfi.IECA AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU_ALDOSTERONA AND farmac_1anyfi.IVAB FxFIQT_IECA_BBK_DIUALDO_IVAB=1.
variable label FxFIQT_IECA_BBK_DIUALDO_IVAB "ACEi+BB+Diuretico ALDO+Ivabradine".
* ARB+BB+Diuretic+Ivabradine .
if FX_FI_NUM=4 AND farmac_1anyfi.ARA2 AND farmac_1anyfi.BBK AND farmac_1anyfi.DIU_ALDOSTERONA AND farmac_1anyfi.IVAB FxFIQT_ARA2_BBK_DIUALDO_IVAB=1.
variable label FxFIQT_ARA2_BBK_DIUALDO_IVAB "ARB+BB+Diuretic ALDO+Ivabradine".
*.


****************************.
recode  FxFIMono_IECA FxFIMono_ARA2 FxFIMono_BBK FxFIMono_DIU FxFIMono_IVAB FxFIBi_IECA_BBK 
    FxFIBi_ACE_DIU FxFIBi_ARA2_BBK FxFIBi_DIU_BBK FxFIBi_DIU_ARA2 FxFIBi_IECA_ARA2 
    FxFITR_IECA_BBK_DIU FxFITR_ARA2_BBK_DIU FxFITR_IECA_BBK_ARA2 FxFITR_IECA_DIU_ARA2 
    FxFIQT_IECA_BBK_DIU_IVAB FxFIQT_ARA2_BBK_DIU_IVAB (sysmis=0) (else=copy).


recode   FxINIMono_DIU_ALDOS FxINIMono_DIU_ASA FxFIMono_DIU_ALDOS FxFIMono_DIU_ASA FxIniBi_ACE_DIUALDO 
    FxIniBi_BBK_DIUALDO FxIniBi_ARA2_DIUALDO FxFIBi_ACE_DIUALDOS FxFIBi_BBK_DIUALDOS 
    FxFIBi_ARA2_DIUALDOS FxIniTR_IECA_BBK_DIUALDO FxIniTR_ARA2_BBK_DIUALDO FxIniTR_IECA_DIUALDO_ARA2 
    FxFITR_IECA_BBK_DIUALDO FxFITR_ARA2_BBK_DIUALDO FxFITR_IECA_DIUALDO_ARA2 
    FxIniQT_IECA_BBK_DIUALDO_IVAB FxIniQT_ARA2_BBK_DIUALDO_IVAB FxFIQT_IECA_BBK_DIUALDO_IVAB 
    FxFIQT_ARA2_BBK_DIUALDO_IVAB (sysmis=0) (else=copy).


*************************************************************************************************************************************.
*.
**************************************************      TAULES FARMACS           ***.
*.
freq var=farmac_ini.ARA2 farmac_ini.BBK  farmac_ini.ARA2 farmac_ini.BBK farmac_ini.BCCA farmac_ini.DIGOX farmac_ini.DIU farmac_ini.HYDRA 
    farmac_ini.IECA farmac_ini.IVAB farmac_ini.NITRAT  farmac_ini.DIU_ALDOSTERONA farmac_ini.DIU_ASA farmac_ini.DIU_HFEPCT
    farmac_1anyfi.ARA2 farmac_1anyfi.BBK farmac_1anyfi.BCCA farmac_1anyfi.DIGOX farmac_1anyfi.DIU farmac_1anyfi.HYDRA farmac_1anyfi.IECA 
    farmac_1anyfi.IVAB farmac_1anyfi.NITRAT  farmac_1anyfi.DIU_ALDOSTERONA farmac_1anyfi.DIU_ASA farmac_1anyfi.DIU_HFEPCT.
*.
*.
DATASET ACTIVATE Conjunto_de_datos1.
* Definir conjuntos de respuestas múltiples.
MRSETS
  /MDGROUP NAME=$TREATMENT CATEGORYLABELS=VARLABELS 
VARIABLES=farmac_ini.ARA2 farmac_ini.BBK  farmac_ini.BCCA farmac_ini.DIGOX farmac_ini.DIU farmac_ini.HYDRA farmac_ini.IECA farmac_ini.IVAB 
    farmac_ini.NITRAT  farmac_ini.DIU_ALDOSTERONA farmac_ini.DIU_ASA farmac_ini.DIU_HFEPCT
    farmac_1anyfi.ARA2 farmac_1anyfi.BBK farmac_1anyfi.BCCA farmac_1anyfi.DIGOX 
    farmac_1anyfi.DIU farmac_1anyfi.HYDRA farmac_1anyfi.IECA farmac_1anyfi.IVAB farmac_1anyfi.NITRAT  farmac_1anyfi.DIU_ALDOSTERONA farmac_1anyfi.DIU_ASA farmac_1anyfi.DIU_HFEPCT
    VALUE=1
  /DISPLAY NAME=[$TREATMENT].

****************************************************       TAULES DE FARMACS EN PACIENTS  (114.0000)                             **************************.
* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=$Treatment IC_BASAL DISPLAY=BOTH
  /TABLE $Treatment [COUNT F40.0] BY IC_BASAL
  /CATEGORIES VARIABLES=$Treatment  EMPTY=INCLUDE
  /CATEGORIES VARIABLES=IC_BASAL ORDER=A KEY=VALUE EMPTY=EXCLUDE.


**************************************************           TAULES FARMACS COMBINATS                ***.

 * FxIniMono_IECA FxIniMono_ARA2 FxIniMono_BBK FxIniMono_DIU FxIniMono_IVAB FxIniBi_IECA_BBK 
    FxIniBi_ACE_DIU FxIniBi_ARA2_BBK FxIniBi_DIU_BBK FxIniBi_DIU_ARA2 FxIniBi_IECA_ARA2 
    FxIniTR_IECA_BBK_DIU FxIniTR_ARA2_BBK_DIU FxIniTR_IECA_BBK_ARA2 FxIniTR_IECA_DIU_ARA2 
    FxIniQT_IECA_BBK_DIU_IVAB FxIniQT_ARA2_BBK_DIU_IVAB FxFIMono_IECA FxFIMono_ARA2 FxFIMono_BBK 
    FxFIMono_DIU FxFIMono_IVAB FxFIBi_IECA_BBK FxFIBi_ACE_DIU FxFIBi_ARA2_BBK FxFIBi_DIU_BBK 
    FxFIBi_DIU_ARA2 FxFIBi_IECA_ARA2 FxFITR_IECA_BBK_DIU FxFITR_ARA2_BBK_DIU FxFITR_IECA_BBK_ARA2 
    FxFITR_IECA_DIU_ARA2 FxFIQT_IECA_BBK_DIU_IVAB FxFIQT_ARA2_BBK_DIU_IVAB .



FxIniQT_IECA_BBK_DIUALDO_IVAB    FxIniQT_ARA2_BBK_DIUALDO_IVAB 
FxFIQT_IECA_BBK_DIUALDO_IVAB    FxFIQT_ARA2_BBK_DIUALDO_IVAB


* Definir conjuntos de respuestas múltiples.
MRSETS
  /MDGROUP NAME=$TREATMENTCOMBI CATEGORYLABELS=VARLABELS 
VARIABLES=FxIniMono_IECA FxIniMono_ARA2 FxIniMono_BBK FxIniMono_DIU FxIniMono_IVAB FxINIMono_DIU_ALDOS
FxIniBi_IECA_BBK FxIniBi_ACE_DIU FxIniBi_ARA2_BBK FxIniBi_DIU_BBK FxIniBi_DIU_ARA2 FxIniBi_IECA_ARA2  
FxIniBi_ACE_DIUALDO FxIniBi_BBK_DIUALDO FxIniBi_ARA2_DIUALDO
FxIniTR_IECA_BBK_DIU FxIniTR_ARA2_BBK_DIU FxIniTR_IECA_BBK_ARA2 FxIniTR_IECA_DIU_ARA2 
FxIniTR_IECA_BBK_DIUALDO FxIniTR_ARA2_BBK_DIUALDO  FxIniTR_IECA_DIUALDO_ARA2
FxIniQT_IECA_BBK_DIU_IVAB FxIniQT_ARA2_BBK_DIU_IVAB 
FxIniQT_IECA_BBK_DIUALDO_IVAB  FxIniQT_ARA2_BBK_DIUALDO_IVAB
FxFIMono_IECA FxFIMono_ARA2 FxFIMono_BBK FxFIMono_DIU FxFIMono_IVAB  FxFIMono_DIU_ALDOS
FxFIBi_IECA_BBK FxFIBi_ACE_DIU FxFIBi_ARA2_BBK FxFIBi_DIU_BBK FxFIBi_DIU_ARA2 FxFIBi_IECA_ARA2 
FxFIBi_ACE_DIUALDOS FxFIBi_BBK_DIUALDOS FxFIBi_ARA2_DIUALDOS
FxFITR_IECA_BBK_DIU FxFITR_ARA2_BBK_DIU FxFITR_IECA_BBK_ARA2 FxFITR_IECA_DIU_ARA2 
FxFITR_IECA_BBK_DIUALDO FxFITR_ARA2_BBK_DIUALDO FxFITR_IECA_DIUALDO_ARA2
FxFIQT_IECA_BBK_DIU_IVAB FxFIQT_ARA2_BBK_DIU_IVAB 
FxFIQT_IECA_BBK_DIUALDO_IVAB FxFIQT_ARA2_BBK_DIUALDO_IVAB
   VALUE=1
  /DISPLAY NAME=[$TREATMENTCOMBI].


****************************************************       TAULES DE FARMACS EN PACIENTS  (114.0000)                             **************************.
* Tablas personalizadas.
CTABLES
  /VLABELS VARIABLES=$TREATMENTCOMBI IC_BASAL DISPLAY=BOTH
  /TABLE $TREATMENTCOMBI [COUNT F40.0] BY IC_BASAL
  /CATEGORIES VARIABLES=$TREATMENTCOMBI  EMPTY=INCLUDE
  /CATEGORIES VARIABLES=IC_BASAL ORDER=A KEY=VALUE EMPTY=EXCLUDE.

********************************************************************************************************************************.
*.

FREQ IC_BASAL FxINIMono_DIU_ALDOS.
*.
value label switch 99 "" . 

***   Si switch=9 and FX_INI_NUM>0 
***   SI missing()
*.
FREQUENCIES VARIABLES=switch
  /ORDER=ANALYSIS.
*.
**************         TAULA DE DENOMINADORS UN ANY POSTERIOR  al seguiment  ***************.
****    Info que tinc    **.
******.
compute actiuany=1.
if (sit_2014="D" or sit_2014="T") and  dtsit_2014<DATESUM(dtinclusio, 12, "months", 'closest') actiuany=0. 
*.
variable label actiuany "Actiu al any de seguiment" .
freq var=actiuany.

CROSSTABS
  /TABLES=actiuany BY IC_BASAL
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

********************************************************************************************************************************************************
*.
*.



