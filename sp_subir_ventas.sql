USE [SVA]
GO
/****** Object:  StoredProcedure [dbo].[subir_ventas]    Script Date: 30/01/2017 05:02:38 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[subir_ventas]
AS
BEGIN
--drop table #T_GARANTIA
--drop table #tmpBuscaFiles

	DECLARE 
		@Path   varchar(50),    
		@Wildcard varchar(5),    
		@Cmd varchar(150),
		@archivo varchar(50),
		@archivoini varchar(50),
		@dia varchar(2),
		@mes varchar(2),
		@anio varchar(4),
		@mesvar varchar(2),
		@diavar varchar(2), 
		@diasem int,
		@varFechaini char(8),
		@varFechafin char(8),
		@varfechaayer char(8),
		@varhoraini char(2),
		@varhorafin char(2),
		@varminini char(2),
		@varminfin char(2), 
		@porcapart float,
		@rutalog char(100),
		@dias int,
		@porcinc float,
		@cadena char(1024)

	--aqui porcentaje de incremento
	set @porcinc = .4

	set @diasem=cast(datepart(dw, getdate()) as int)

	--//recupera el dia ctual  
	set @dia=cast(day(getdate()) as varchar)
	--//recupera el mes actual  
	set @mes=cast(month(getdate())  as varchar)
	--//recupera el año actual  
	set @anio=cast(year(getdate()) as varchar)

	set @varhoraini=cast(datepart(hh, getdate()) as int)
	set @varminini=cast(datepart(MI, getdate()) as int)

	if @dia<=9 
		begin
			set @diavar='0'+cast(@dia as char(2))
		end
	else
		begin
			set @diavar=''+cast(@dia as char(2))
		end 

	if @mes<=9 
		begin
			set @mesvar='0'+cast(@mes as char(2))
		end
	else
		begin
			set @mesvar=''+cast(@mes as char(2))
		end 
	set @varFechaini=@anio+ltrim(rtrim(@mesvar))+ltrim(rtrim(@diavar)) 

	set @diasem=cast(datepart(dw, getdate()) as int)

	if @diasem<>2 
		begin
			--//recupera el dia ctual  
			set @dia=cast(day(getdate()-1) as varchar)
			--//recupera el mes actual  
			set @mes=cast(month(getdate()-1)  as varchar)
			--//recupera el año actual  
			set @anio=cast(year(getdate()-1) as varchar)

			set @varhoraini=cast(datepart(hh, getdate()) as int)
			set @varminini=cast(datepart(MI, getdate()) as int)
		end
	else
		begin
			--//recupera el dia ctual  
			set @dia=cast(day(getdate()-2) as varchar)
			--//recupera el mes actual  
			set @mes=cast(month(getdate()-2)  as varchar)
			--//recupera el año actual  
			set @anio=cast(year(getdate()-2) as varchar)

			set @varhoraini=cast(datepart(hh, getdate()) as int)
			set @varminini=cast(datepart(MI, getdate()) as int)
		end
	
	if @dia<=9 
		begin
			set @diavar='0'+cast(@dia as char(2))
		end
	else
		begin
			set @diavar=''+cast(@dia as char(2))
		end 

	if @mes<=9 
		begin
			set @mesvar='0'+cast(@mes as char(2))
		end
	else
		begin
			set @mesvar=''+cast(@mes as char(2))
		end 
	set @varfechaayer=@anio+ltrim(rtrim(@mesvar))+ltrim(rtrim(@diavar)) 

	print @varfechaayer
	print @varhoraini+':'+@varminini

	CREATE TABLE #T_GARANTIA(
		[sCREDITO] [nvarchar](8) NOT NULL,
		[nCLIENTE] [int] NOT NULL,
		[sNOMBRE] [nvarchar](100) NOT NULL,
		[sNUMGARANTIA] [nvarchar](8) NOT NULL,
		[sTIPOGARANTIA] [nvarchar](20) NOT NULL,
		[sDESCGARANTIA] [nvarchar](255) NULL,
		[nAVALUOGARANTIA] [decimal](18, 2) NOT NULL,
		[nCAPGARANTIA] [decimal](18, 2) NOT NULL,
		[nACCGARANTIA] [decimal](18, 2) NOT NULL,
		[nCOMISIONGARANTIA] [decimal](18, 2) NOT NULL,
		[nCOSTOGARANTIA] [decimal](18, 2) NOT NULL,
		[nPRECIOVENTAGARANTIAORIGINAL] [decimal](18, 2) NOT NULL,
		[sCODIGOGARANTIA] [varchar](30) NOT NULL,
		[nSUCURSAL] varchar(30) NOT NULL,
		[sUSUARIO] [nvarchar](10) NOT NULL,
		[nIMPORTEGARANTIA] [decimal](18, 2) NOT NULL,
		[nFECHAVENGARANTIA] [int] NOT NULL,
		[nDIASVENC] int NOT NULL,
		campo varchar(1024))

	SET @Path       ='\\gcpporvenir\archivos\'
	SET @Wildcard ='*.txt'--+@vTda
	SET @Cmd = 'DIR "' + @Path + CASE WHEN RIGHT(@Path, 1) = '\' THEN ''
	ELSE '\' END + @WildCard + '"'
	print @Cmd

	CREATE TABLE #tmpBuscaFiles(id int Identity, line varchar(255))
	INSERT INTO #tmpBuscaFiles
	EXEC master..xp_CmdShell @Cmd
	select top 1 @archivoini=substring(line,CHARINDEX('GARVTA', line, 1),26) 
	from #tmpBuscaFiles where line like '%GARVTA%' order by 1 desc
	print @archivo

	set @archivo='\\gcpporvenir\archivos\'+@archivoini
	print @archivo

	exec ('BULK INSERT #T_GARANTIA 
	   FROM '''+@archivo+'''
	   WITH 
		  (
			firstrow=2,
			 FIELDTERMINATOR =''@'',
			 ROWTERMINATOR =''\n''
		  )')
      
	select @porcapart=svalorinicial from sva.dbo.T_SVA where sParametro='PORC_APARTA_MIN'
	select @rutalog=svalorinicial from sva.dbo.T_SVA where sParametro='RUTA_LOG_GARVTA'
	select @dias=svalorinicial from sva.dbo.T_SVA where sParametro='DIAS_APARTADO_MAX'
	--//recupera el dia ctual  
	set @dia=cast(day(getdate()) as varchar)
	--//recupera el mes actual  
	set @mes=cast(month(getdate())  as varchar)
	--//recupera el año actual  
	set @anio=cast(year(getdate()) as varchar)

	set @varhorafin=cast(datepart(hh, getdate()) as int)
	set @varminfin=cast(datepart(MI, getdate()) as int)

	if @dia<=9 
		begin
			set @diavar='0'+cast(@dia as char(2))
		end
	else
		begin
			set @diavar=''+cast(@dia as char(2))
		end 

	if @mes<=9 
		begin
			set @mesvar='0'+cast(@mes as char(2))
		end
	else
		begin
			set @mesvar=''+cast(@mes as char(2))
		end 
	set @varFechafin=@anio+ltrim(rtrim(@mesvar))+ltrim(rtrim(@diavar)) 
	print @varhorafin+':'+@varminfin

	exec ('insert into sva.dbo.T_GARANTIA (scredito, ncliente, snombre, snumgarantia, stipogarantia, sdescgarantia, navaluogarantia, 
	ncapgarantia, naccgarantia, ncomisiongarantia, ncostogarantia, nprecioventagarantiaoriginal, nprecioventagarantia, scodigogarantia, 
	nsucursal, susuario, nimportegarantia, nfechavengarantia, ndiasvenc, nfechavencapartado, ncontado, nmontoapartado, nporcminapartado, 
	nporcdescuento, scodigobarras, nfechasalidaventa, nnumcomprador, svobo, sarchivo, scomentario, smodifusuario, slugar, nfechaalmacen, 
	nfechavitrina, nsucursalvende, nfechamodificacion, nporcaumento, nreventa, nfechatienda, nprorroga, scomentarioventa, nstatus, 
	ndiasapartado, nsucvitrina, nfechaultmovvit, susuarioultmovvit, nstatusvit, nstatusrep, folio_ctc, precio_ctc_vta, margen_ctc, 
	reestruc)  select scredito, nCLIENTE, sNOMBRE, snumgarantia, sTIPOGARANTIA, sDESCGARANTIA, 
	nAVALUOGARANTIA, nCAPGARANTIA, nACCGARANTIA, nCOMISIONGARANTIA, nCOSTOGARANTIA, nPRECIOVENTAGARANTIAORIGINAL, 
	nPRECIOVENTAGARANTIAORIGINAL*(1+0.4), sCODIGOGARANTIA, b.nsucursal, sUSUARIO, nIMPORTEGARANTIA, 
	nFECHAVENGARANTIA, nDIASVENC, NULL, 2, 0, 10, 0,  
	CASE 
		WHEN sNUMGARANTIA<10 then cast(cast(sCREDITO as int) as varchar)+''000''+cast(CAST(sNUMGARANTIA AS int) as varchar)  
		WHEN sNUMGARANTIA>=10 and snumgarantia<100 then cast(cast(sCREDITO as int) as varchar)+''00''+cast(CAST(sNUMGARANTIA AS int) as varchar)  
		WHEN sNUMGARANTIA>=100 and snumgarantia<1000 then cast(cast(sCREDITO as int) as varchar)+''0''+cast(CAST(sNUMGARANTIA AS int) as varchar)   
		WHEN sNUMGARANTIA>=1000 then cast(cast(sCREDITO as int) as varchar)+''''+cast(CAST(sNUMGARANTIA AS int) as varchar) end, 
	'+@varfechaayer+', null, null, '''+@varfechaayer+''', NULL, NULL, ''ALMACEN'', '+@varFechaini+', NULL, 
	b.nsucursal, NULL, NULL, NULL, NULL, NULL, NULL, 0, 30, NULL, NULL, NULL, NULL, NULL, c.folio_ctc, NULL, NULL, NULL
	from (#T_GARANTIA a inner join sva.dbo.c_sucursales b on a.nSUCURSAL=b.ssucursal) inner join 
	ISILOANSWEB.dbo.T_GARANTIAS c on CAST(a.sCREDITO as int)=c.numero and CAST(a.snumgarantia as int)=c.numgaran
	where sCODIGOGARANTIA not in (select scodigogarantia from sva.dbo.t_garantia)')

	exec ('insert into sva.dbo.T_ARCHIVOSIMPORTADOS (sArchivo, nFechaInicioImportar, sHoraInicioImportar, nFechaFinImportar,
	sHoraFinImportar, sDetalles, sUsuario) values ('''+@archivoini+''', '+@varFechaini+','''+@varhoraini+':'+@varminini+''',  
	'+@varfechafin+','''+@varhorafin+':'+@varminfin+''', '''', ''AUTOM'') ')

end



