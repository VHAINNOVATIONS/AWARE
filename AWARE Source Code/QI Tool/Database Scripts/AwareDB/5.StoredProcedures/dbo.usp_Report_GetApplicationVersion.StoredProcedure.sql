USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_Report_GetApplicationVersion]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Report_GetApplicationVersion]
AS	
	SELECT max(VERSION_NUMBER) as Application_Version FROM  APPLICATION_VERSION


GO
