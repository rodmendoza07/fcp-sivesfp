USE SVA
GO

CREATE PROCEDURE [dbo].[sp_setWarrantypayment](
	@credit INT = 0
	, @codeSVA VARCHAR(30) = ''
	, @paymentType INT = 0
)
AS
BEGIN
	IF @paymentType = 0 BEGIN
		UPDATE SVA.dbo.T_GARANTIA SET
			nCONTADO = 1
		WHERE sCODIGOBARRAS = @codeSVA
	END

	IF @paymentType = 1 BEGIN
		UPDATE SVA.dbo.T_GARANTIA SET
			nCONTADO = 1
		WHERE sCREDITO = @credit
	END
END