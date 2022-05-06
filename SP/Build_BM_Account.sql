USE [MMA_DW_EHB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE OR ALTER  PROCEDURE [dbo].[Build_BM_Account]
AS
BEGIN

	INSERT INTO [MMA_DW_EHB].dbo.[BM Account]
	([Account Name], [BenefitPoint ID], [Region], 
	  [Employee Size], [Industry], [Location], 
	  [As Of Date], [Account Composite Key], [Is Client])
     
		SELECT 
		   C.[NAME]
		   ,C.[CLIENT_ID]
		   ,BR.[REGION_NAME]
		   ,C.[NUMBER_OF_FULL_TIME_EMPLOYEES]
		   ,C.[PRIMARY_INDUSTRY_DESC]
		   ,CA.[State]
		   ,CONVERT(VARCHAR(10),GETDATE(),23) as [As Of Date] -- lkp (3/15) corrected date formatting
		   ,CAST(C.[NAME] as nvarchar)+ ':' + BR.[REGION_NAME] + ':' + CAST(C.[CLIENT_ID] As nvarchar) + ':' + FORMAT(GETDATE(), 'M/d/yyyy') as [Account Composite Key]	-- lkp (3/15) corrected date formatting
		   ,1 as [Is Client]
       
  
	FROM [ACE].[dbo].[CLIENT] C
	  INNER JOIN [ACE].[dbo].[Client_Address] CA ON C.CLIENT_ID =  CA.CLIENT_ID
	  INNER JOIN [ACE].[dbo].[BROKER_OFFICE] BO  ON BO.OFFICE_ID = C.OWNER_OFFICE_ID
	  INNER JOIN [ACE].dbo.[Broker_Region]  BR  ON BR.REGION_ID = BO.REGION_ID

	Where ACTIVE_IND = 1
	  And BUSINESS_TYPE_ID <> 115
	  And CA.ADDRESS_TYPE_DESC = 'Main'
	  AND C.[CLIENT_CLASSIFICATION_DESC] = 'Group'  --This eliminates Individual.  The options are Individual or Group
	  AND C.CLIENT_ID NOT IN 
		(
			SELECT X.[BENEFITPOINT ID] 
			FROM [MMA_DW_EHB].DBO.[BM ACCOUNT] X);

END
GO


