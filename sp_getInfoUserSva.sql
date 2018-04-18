USE CATALOGOS
GO

ALTER PROCEDURE sp_getInfoUserSva(
	@usr VARCHAR(20) = ''
	, @pwd VARCHAR(35) = ''
)
AS
BEGIN
	DECLARE 
		@usr_id INT = 0
		, @msg VARCHAR(300) = ''

	SELECT 
		@usr_id = peusr_user_id
	FROM CATALOGOS.dbo.te_users_passw_encrypt
	WHERE peusr_passw_encrypt = @pwd

	IF @usr_id > 0 BEGIN
		SELECT
			cve_depto AS sucursal
			, cve_puesto AS perfil
		FROM CATALOGOS.dbo.tc_empleados
		WHERE id_empleados = @usr_id
	END
	ELSE BEGIN
		SET @msg = 'invalid User'
			RAISERROR(@msg, 16, 1)
			RETURN
	END 
END