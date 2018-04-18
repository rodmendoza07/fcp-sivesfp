BEGIN
	UPDATE CATALOGOS.dbo.tc_aplicaciones SET
		estatus = 1	
	WHERE id_ap = 6

	SELECT * FROM CATALOGOS.dbo.tc_aplicaciones
END