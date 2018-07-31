SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Member Types.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-05-29> :
--	- Update code match new structure.
--
-- [== Example ==]
--
--exec InitMemberTypes
-- =============================================
CREATE PROCEDURE InitMemberTypes
AS
BEGIN
DECLARE @langId nvarchar(3);
	-- DELETE ALL EXISTS DATA.
	DELETE FROM MemberType;

	-- [ENGLISH]
	SET @langId = N'EN';
	INSERT INTO MemberType VALUES (100, @langId, N'Developer')
	INSERT INTO MemberType VALUES (200, @langId, N'EDL - Admin')
	INSERT INTO MemberType VALUES (210, @langId, N'EDL - Supervisor')
	INSERT INTO MemberType VALUES (280, @langId, N'EDL - Staff')
	INSERT INTO MemberType VALUES (300, @langId, N'Admin')
	INSERT INTO MemberType VALUES (310, @langId, N'Exclusive')
	INSERT INTO MemberType VALUES (380, @langId, N'Staff')
	-- [THAI]
	SET @langId = N'TH';
	INSERT INTO MemberType VALUES (100, @langId, N'นักพัฒนาระบบ')
	INSERT INTO MemberType VALUES (200, @langId, N'อีดีแอล - ผู้ดูแลระบบ')
	INSERT INTO MemberType VALUES (210, @langId, N'อีดีแอล - เจ้าหน้าที่ระดับควบคุม')
	INSERT INTO MemberType VALUES (280, @langId, N'อีดีแอล - เจ้าหน้าที่ปฏิบัติการ')
	INSERT INTO MemberType VALUES (300, @langId, N'ผู้ดูแลระบบ')
	INSERT INTO MemberType VALUES (310, @langId, N'ผู้บริหาร')
	INSERT INTO MemberType VALUES (380, @langId, N'เจ้าหน้าที่ปฏิบัติการ')
	-- [CHINESE]
	SET @langId = N'ZH';
	INSERT INTO MemberType VALUES (100, @langId, N'Developer')
	INSERT INTO MemberType VALUES (200, @langId, N'EDL - 管理员')
	INSERT INTO MemberType VALUES (210, @langId, N'EDL - 管理员')
	INSERT INTO MemberType VALUES (280, @langId, N'EDL - 员工')
	INSERT INTO MemberType VALUES (300, @langId, N'管理员')
	INSERT INTO MemberType VALUES (310, @langId, N'管理员')
	INSERT INTO MemberType VALUES (380, @langId, N'员工')
	-- [JAPANESE]
	SET @langId = N'JA';
	INSERT INTO MemberType VALUES (100, @langId, N'Developer')
	INSERT INTO MemberType VALUES (200, @langId, N'EDL - 支配人')
	INSERT INTO MemberType VALUES (210, @langId, N'EDL - 監督')
	INSERT INTO MemberType VALUES (280, @langId, N'EDL - 職員')
	INSERT INTO MemberType VALUES (300, @langId, N'支配人')
	INSERT INTO MemberType VALUES (310, @langId, N'監督')
	INSERT INTO MemberType VALUES (380, @langId, N'職員')
	-- [GERMAN]
	SET @langId = N'DE';
	INSERT INTO MemberType VALUES (100, @langId, N'Developer')
	INSERT INTO MemberType VALUES (200, @langId, N'EDL - Administrator')
	INSERT INTO MemberType VALUES (210, @langId, N'EDL - Aufsicht')
	INSERT INTO MemberType VALUES (280, @langId, N'EDL - Belegschaft')
	INSERT INTO MemberType VALUES (300, @langId, N'Administrator')
	INSERT INTO MemberType VALUES (310, @langId, N'Exklusiv')
	INSERT INTO MemberType VALUES (380, @langId, N'Belegschaft')
	-- [FRENCH]
	SET @langId = N'FR';
	INSERT INTO MemberType VALUES (100, @langId, N'Developer')
	INSERT INTO MemberType VALUES (200, @langId, N'EDL - Administrateur')
	INSERT INTO MemberType VALUES (210, @langId, N'EDL - Superviseur')
	INSERT INTO MemberType VALUES (280, @langId, N'EDL - Personnel')
	INSERT INTO MemberType VALUES (300, @langId, N'Administrateur')
	INSERT INTO MemberType VALUES (310, @langId, N'Exclusif')
	INSERT INTO MemberType VALUES (380, @langId, N'Personnel')
	-- [KOREAN]
	SET @langId = N'KO';
	INSERT INTO MemberType VALUES (100, @langId, N'Developer')
	INSERT INTO MemberType VALUES (200, @langId, N'EDL - 관리자 (Admin)')
	INSERT INTO MemberType VALUES (210, @langId, N'EDL - 관리자')
	INSERT INTO MemberType VALUES (280, @langId, N'EDL - 직원')
	INSERT INTO MemberType VALUES (300, @langId, N'관리자 (Admin)')
	INSERT INTO MemberType VALUES (310, @langId, N'감독자')
	INSERT INTO MemberType VALUES (380, @langId, N'직원')
END

GO

EXEC InitMemberTypes;

GO
