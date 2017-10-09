USE SVA
GO

CREATE PROCEDURE [dbo].[sp_setWarrantySale]
AS
BEGIN

	SELECT 
		DISTINCT(CAST(a.sCREDITO AS int)) AS credit
		, SUBSTRING(b.REG_CREDIT,23,2) AS usgaap
		--, *
	INTO #tmpCredit
	FROM SVA.dbo.T_GARANTIA a WITH(NOLOCK)
		INNER JOIN ISILOANSWEB.dbo.T_CRED2 b WITH(NOLOCK) ON (a.sCREDITO = b.NUMERO)
	WHERE a.nCONTADO <> 1
		AND a.nCONTADO <> 10
		AND a.nCONTADO <> 0

	UPDATE SVA.dbo.T_GARANTIA SET
		nCONTADO = 2
	WHERE sCREDITO IN (
		SELECT
			a.credit
		FROM #tmpCredit a
		WHERE a.usgaap = 01)

	UPDATE SVA.dbo.T_GARANTIA SET
		nCONTADO = 15
	WHERE sCREDITO IN (
		SELECT 
			a.credit
		FROM #tmpCredit a
		WHERE a.usgaap = 00)

	DROP TABLE #tmpCredit

END