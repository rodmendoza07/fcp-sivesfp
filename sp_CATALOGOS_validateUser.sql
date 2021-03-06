USE [CATALOGOS]
GO
/****** Object:  StoredProcedure [dbo].[sp_validateUser]    Script Date: 09/10/2017 04:41:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_validateUser](
	@userLogin varchar(45) = ''
	, @userPassW varchar(45) = ''	
	, @application int = 0
)
AS
BEGIN
	BEGIN TRY
		DECLARE 
			 @passwReset tinyint = 0
			, @passwLock tinyint = 0
			, @passResetDays tinyint = 0
			, @passResetPassEqual tinyint = 0
			, @passwValidate varchar(45) = ''
			, @iCountP tinyint = 0
			, @iCount tinyint = 0
			, @peusr_id int = 0
			, @departament int = 0
			, @profile int = 0
			, @iAccess int = 0

		SET @passwValidate = CATALOGOS.dbo.fnEncodePassword(@userLogin, @userLogin)

		SET @iCountP = (SELECT COUNT(*) 
						FROM CATALOGOS.dbo.te_users_passw_encrypt a WITH(NOLOCK)
							INNER JOIN CATALOGOS.dbo.tc_empleados b WITH(NOLOCK) ON (a.peusr_user_id = b.id_empleados)
						WHERE a.peusr_passw_encrypt = @userPassW
							AND b.estatus = 1 AND b.usuario = @userLogin)

		--SET @iCount = (SELECT COUNT(*) 
		--				FROM CATALOGOS.dbo.te_users_passw_encrypt a WITH(NOLOCK)
		--					INNER JOIN CATALOGOS.dbo.tc_empleados b WITH(NOLOCK) ON (a.peusr_user_id = b.id_empleados)
		--				WHERE b.usuario = @userLogin
		--					AND b.estatus = 1)

		SELECT 
			@iCount = COUNT(*) 
			, @departament = b.cve_depto
			, @profile = b.cve_puesto
		FROM CATALOGOS.dbo.te_users_passw_encrypt a WITH(NOLOCK)
			INNER JOIN CATALOGOS.dbo.tc_empleados b WITH(NOLOCK) ON (a.peusr_user_id = b.id_empleados)
		WHERE b.usuario = @userLogin
			AND b.estatus = 1
		GROUP BY b.cve_depto, b.cve_puesto

		SELECT
			@iAccess = COUNT(*)
		FROM CATALOGOS.dbo.tc_acceso_perfiles x
			INNER JOIN CATALOGOS.dbo.tc_menus y ON (x.pa_tcmenu_id = y.tcmenu_id)
		WHERE x.pa_ap_id = @application
			AND x.pa_cve_depto = @departament
			AND x.pa_cve_puesto = @profile
			AND x.pa_estatus = 1
			AND y.tcmenu_url <> '#'
						
		IF @iCountP > 0
			BEGIN
				SELECT 
					@passwReset = a.peusr_passw_encrypt_reset
					, @passwLock = a.peusr_passw_encrypt_lock
					, @passResetDays = CASE WHEN DATEDIFF(MONTH, CASE WHEN a.peusr_passw_date_change IS NULL THEN peusr_passw_date_create ELSE a.peusr_passw_date_change END, GETDATE()) >= 3 THEN 1 ELSE 0 END
					, @passResetPassEqual = CASE WHEN @userPassW = @passwValidate THEN 1 ELSE 0 END
					, @peusr_id = a.peusr_id
				FROM CATALOGOS.dbo.te_users_passw_encrypt a WITH(NOLOCK)
					INNER JOIN CATALOGOS.dbo.tc_empleados b WITH(NOLOCK) ON (a.peusr_user_id = b.id_empleados)
				WHERE a.peusr_passw_encrypt = @userPassW AND b.usuario = @userLogin
			END
		ELSE
			BEGIN
				SELECT 
					@passwReset = a.peusr_passw_encrypt_reset
					, @passwLock = a.peusr_passw_encrypt_lock
					, @passResetDays = CASE WHEN DATEDIFF(MONTH, CASE WHEN a.peusr_passw_date_change IS NULL THEN peusr_passw_date_create ELSE a.peusr_passw_date_change END, GETDATE()) >= 3 THEN 1 ELSE 0 END
					, @passResetPassEqual = CASE WHEN @userPassW = @passwValidate THEN 1 ELSE 0 END
					, @peusr_id = a.peusr_id
				FROM CATALOGOS.dbo.te_users_passw_encrypt a WITH(NOLOCK)
					INNER JOIN CATALOGOS.dbo.tc_empleados b WITH(NOLOCK) ON (a.peusr_user_id = b.id_empleados)
				WHERE b.usuario = @userLogin AND b.usuario = @userLogin
			END

		SELECT
			@iCount AS [userExist]
			, @iCountP AS [passwOk]
			, @passwReset AS [passwReset]
			, @passwLock AS [passwLock]
			, @passResetDays AS [passwResetDays]
			, @passResetPassEqual AS [passwResetPassEqual]
			, @peusr_id AS [passw_id]
			, @iAccess AS [iAccessApp]
	END TRY
	BEGIN CATCH
		DECLARE
			@message varchar(1500) = ' ' + ISNULL(CAST(ERROR_MESSAGE() AS varchar), '')+ ' / Proc.: ' + ISNULL(CAST(ERROR_PROCEDURE() AS varchar), '') + '/Línea: ' + ISNULL(CAST(ERROR_LINE() AS varchar), '')

		RAISERROR (@message, 16, 1)
	END CATCH
END