USE [MMA_DW_EHB]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER  PROCEDURE [dbo].[INS_Empl_Workday]
AS
BEGIN 
	DROP TABLE IF EXISTS  #New_Users
	SELECT EMPL_ID
		, Dpt_Region
		, StaffCode
		, Email_Addr
	INTO #New_Users
    FROM (
                select S.Rollup_ID_Validate as EMPL_ID, D.Dpt_Region, S.StaffCode, w.MMC_Bus_Email_Addr as Email_Addr
                        ,RN = ROW_NUMBER() OVER (PARTITION BY w.MMC_Bus_Email_Addr ORDER BY w.MMC_Bus_Email_Addr, S.Rollup_ID_Validate DESC, D.Region_no)
                FROM WD_89V.emmad_data.dbo.lk_Staff S
                INNER JOIN WD_89V.eMMAD_Data.dbo.LK_WORKDAY W ON S.Rollup_ID_Validate = W.EmplID
                INNER JOIN WD_89V.emmaD_Data.dbo.lk_Dept D ON S.[Dept ID] = D.DivDept_no 
                ) V
    WHERE RN = 1


	INSERT INTO Empl_Workday (EMPL_ID, Region, Email_Addr)
	SELECT  EMPL_ID  , R.Region_Name , N.Email_Addr
	FROM #New_Users N
	INNER JOIN ace..Broker B  ON N.Email_Addr   = B.Email_Addr
	INNER JOIN ace..Broker_Office O ON B.Office_ID = O.Office_ID
	INNER JOIN ace..Broker_Region R ON O.Region_ID = R.Region_ID
	WHERE NOT EXISTS (SELECT * FROM Empl_WorkDay E
						WHERE N.EMPL_ID = E.Empl_ID)

	Drop TABLE #NEW_USERS
END
GO


