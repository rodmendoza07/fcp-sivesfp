SELECT DISTINCT(nCONTADO)
FROM SVA.dbo.T_GARANTIA

SELECT DISTINCT(nTipoPago)
FROM SVA.dbo.T_PAGOS

SELECT 
	sCODIGOBARRAS
	, nCONTADO
	, nSUCURSAL
	, *
FROM SVA.dbo.T_GARANTIA
WHERE sCREDITO IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75)
	AND nCONTADO = 1

update SVA.dbo.T_GARANTIA set
	nCONTADO = 10
where sCREDITO = 13

update SVA.dbo.T_GARANTIA set
	nCONTADO = 10
where sCREDITO = 16

update SVA.dbo.T_GARANTIA set
	nCONTADO = 2
where sCREDITO = 14

update SVA.dbo.T_GARANTIA set
	nCONTADO = 2
where sCREDITO = 72

SELECT
	*
FROM ISILOANSWEB.dbo.T_CRED

 SELECT *
 FROM ISILOANSWEB.dbo.T_CRED2 
 WHERE NUMERO IN (SELECT DISTINCT(CAST(sCREDITO AS int)) AS credito from SVA.dbo.T_GARANTIA )
 ORDER BY NUMERO

select *
from SVA.dbo.tc_countedStatus

insert into SVA.dbo.tc_countedStatus 
	(countedStatus_value,countedStatus_descrip)
values
	(0,'Apartado')
	, (1,'Vendido')
	, (2,'En venta')
	, (10,'Bloqueo por reestructura')
	, (20,'No disponible para venta')

SELECT *
FROM SVA.dbo.T_PAGOS
WHERE sCODIGOBARRAS IN ('0000010001'
, '0000020001'
, '0000030001'
, '0000040001'
, '0000050001'
, '0000060001'
, '0000070001'
, '0000080001'
, '0000090001'
, '0000100001'
, '0000110001'
, '0000120001'
, '0000170001'
, '0000180001'
, '0000190001'
, '0000200001'
, '0000210001'
, '0000220001'
, '0000230001'
, '0000240001'
, '0000250001'
, '0000260001'
, '0000270001'
, '0000280001'
, '0000290001'
, '0000300001'
, '0000310001'
, '0000320001'
, '0000330001'
, '0000340001'
, '0000350001'
, '0000360001'
, '0000370001'
, '0000380001'
, '0000390001'
, '0000400001'
, '0000410001'
, '0000420001'
, '0000430001'
, '0000440001'
, '0000450001'
, '0000460001'
, '0000470001'
, '0000480001'
, '0000490001'
, '0000500001'
, '0000510001'
, '0000520001'
, '0000530001'
, '0000540001'
, '0000550001'
, '0000560001'
, '0000570001'
, '0000580001'
, '0000590001'
, '0000600001'
, '0000610001'
, '0000620001'
, '0000630001'
, '0000640001'
, '0000650001'
, '0000660001'
, '0000670001'
, '0000680001'
, '0000690001'
, '0000700001'
, '0000710001'
, '0000730001'
, '0000740001'
, '0000750001')
ORDER BY sCODIGOBARRAS

USE SVA
GO 
sp_help T_PAGOS

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'

select * 
  from SVA.information_schema.routines 
 where routine_type = 'PROCEDURE'