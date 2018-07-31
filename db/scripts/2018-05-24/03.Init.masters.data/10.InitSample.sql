SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Sample
-- [== History ==]
-- <2018-05-24> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC InitSample N'Company 1 Co., Ltd.', N'บริษัท ทดสอบ 1 จำกัด', N'admin@company1.co.th', N'1234'
--EXEC InitSample N'Company 2 Co., Ltd.', N'บริษัท ทดสอบ 2 จำกัด', N'admin@company1.co.th', N'1234'
-- =============================================
CREATE PROCEDURE [dbo].[InitSample]
(
  @customerNameEN nvarchar(50)
, @customerNameTH nvarchar(50)
, @userName nvarchar(50)
, @passWord nvarchar(50)
)
AS
BEGIN
DECLARE @errNum int;
DECLARE @errMsg nvarchar(MAX);
DECLARE @customerId nvarchar(30);
DECLARE @memberId nvarchar(30);
DECLARE @branchId1 nvarchar(30);
DECLARE @branchId2 nvarchar(30);
DECLARE @branchId3 nvarchar(30);

DECLARE @rootId nvarchar(30);
DECLARE @subOrg1x1 nvarchar(30);
DECLARE @subOrg1x1x1 nvarchar(30);
DECLARE @subOrg1x1x2 nvarchar(30);

DECLARE @subOrg1x2 nvarchar(30);
DECLARE @subOrg1x3 nvarchar(30);
DECLARE @subOrg1x3x1 nvarchar(30);
DECLARE @subOrg1x3x2 nvarchar(30);
DECLARE @subOrg1x3x3 nvarchar(30);

DECLARE @orgName as nvarchar(80);
	EXEC SaveCustomer @customerNameEN
					, N'TAX-001'
					, N'address 1', N'address 2', N'city', N'bangkok', N'12345'
					, N'02-888-9999, 02-888-8888', N'081-666-6666' , N'02-899-9888'
					, @userName
					, @customerId out
					, @errNum out, @errMsg out;
	IF (@errNum <> 0)
	BEGIN
		RETURN;
	END
	-- Add Customer TH Name.
	EXEC SaveCustomerML @customerId, N'TH', @customerNameTH;

	-- Admin User
	SET @memberId = NULL;
	EXEC SaveMemberInfo @customerId, N'', N'Administrator', N'', @userName, @passWord, 200, NULL, NULL, NULL, @memberId out;
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นาย', N'แอดมิน', N'ระบบ';

	-- Exclusive User 1
	SET @memberId = NULL;
	EXEC SaveMemberInfo @customerId, N'Mr.', N'Somchai', N'Sawadee', N'somchai@yahoo.co.th', N'1234', 210, NULL, NULL, NULL, @memberId out;
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นาย', N'สมชัย', N'สวัสดิ';
	-- Exclusive User 2
	SET @memberId = NULL;
	EXEC SaveMemberInfo @customerId, N'Ms.', N'Somying', N'Laksamee', N'somying@yahoo.com', N'1234', 210, NULL, NULL, NULL, @memberId out;
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'น.ส.', N'สมหญิง', N'รัศมี';

	-- Staff User 1
	SET @memberId = NULL;
	EXEC SaveMemberInfo @customerId, N'Mr.', N'Kayan', N'Manpien', N'kayan@gmail.com', N'1234', 280, NULL, NULL, NULL, @memberId out;
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นาย', N'ขยัน', N'หมั่นเพียร';
	-- Staff User 2
	SET @memberId = NULL;
	EXEC SaveMemberInfo @customerId, N'Mr.', N'Pordee', N'Meechai', N'prodee@hotmail.com', N'1234', 280, NULL, NULL, NULL, @memberId out;
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นาย', N'พอดี', N'มีชัย';

	-- Branch(s)
	EXEC SaveBranch @customerId, N'Bangkok', @branchId1 out;
	EXEC SaveBranchML @customerId, @branchId1, N'TH', N'กรุงเทพฯ';
	EXEC SaveBranch @customerId, N'Nontaburi', @branchId2 out;
	EXEC SaveBranchML @customerId, @branchId2, N'TH', N'นนทบุรี';
	EXEC SaveBranch @customerId, N'Samutprakarn', @branchId3 out;
	EXEC SaveBranchML @customerId, @branchId3, N'TH', N'สมุทรปราการ';

	--Org(s) BKK
	SET @rootId = NULL;
	-- ROOT
	SET @orgName = @customerNameEN + N' (HQ)';
	EXEC SaveOrg @customerId, NULL, @branchId1, @orgName, @rootId out;
	SET @orgName = @customerNameTH + N' (สำนักงานใหญ่)';
	EXEC SaveOrgML @customerId, @rootId, N'TH', @orgName;

	-- 1st Lvl Org(s)	
	SET @subOrg1x1 = NULL;
	EXEC SaveOrg @customerId, @rootId, @branchId1, N'Marketing', @subOrg1x1 out;	
	EXEC SaveOrgML @customerId, @subOrg1x1, N'TH', N'ฝ่ายการตลาด';
	-- 2st Lvl Org(s) No. 1
	SET @subOrg1x1x1 = NULL;
	EXEC SaveOrg @customerId, @subOrg1x1, @branchId1, N'PR.', @subOrg1x1x1 out;	
	EXEC SaveOrgML @customerId, @subOrg1x1x1, N'TH', N'ฝ่ายประชาสัมพันธ์';
	-- 2st Lvl Org(s) No. 2
	SET @subOrg1x1x2 = NULL;
	EXEC SaveOrg @customerId, @subOrg1x1, @branchId1, N'International', @subOrg1x1x2 out;	
	EXEC SaveOrgML @customerId, @subOrg1x1x1, N'TH', N'ฝ่ายการตลาดต่างประเทศ';

	SET @subOrg1x2 = NULL;
	EXEC SaveOrg @customerId, @rootId, @branchId1, N'Accounting', @subOrg1x2 out;	
	EXEC SaveOrgML @customerId, @subOrg1x2, N'TH', N'ฝ่ายบัญชี';

	SET @subOrg1x3 = NULL;
	EXEC SaveOrg @customerId, @rootId, @branchId1, N'Engineering', @subOrg1x3 out;	
	EXEC SaveOrgML @customerId, @subOrg1x3, N'TH', N'ฝ่ายวิศวกรรม';

	-- 2st Lvl Org(s) No. 1
	SET @subOrg1x3x1 = NULL;
	EXEC SaveOrg @customerId, @subOrg1x3, @branchId1, N'Assembly', @subOrg1x3x1 out;	
	EXEC SaveOrgML @customerId, @subOrg1x1x1, N'TH', N'ฝ่ายผลิต';
	-- 2st Lvl Org(s) No. 2
	SET @subOrg1x3x2 = NULL;
	EXEC SaveOrg @customerId, @subOrg1x3, @branchId1, N'R&D', @subOrg1x3x2 out;	
	EXEC SaveOrgML @customerId, @subOrg1x3x2, N'TH', N'ฝ่ายวิจัยและพัฒนาฯ';
	SET @subOrg1x3x3 = NULL;
	EXEC SaveOrg @customerId, @subOrg1x3, @branchId1, N'Service', @subOrg1x3x3 out;	
	EXEC SaveOrgML @customerId, @subOrg1x3x3, N'TH', N'ฝ่ายบริการ';

	-- Org Branch Nontaburi
	-- 1st Lvl Org(s)	
	SET @subOrg1x1 = NULL;
	EXEC SaveOrg @customerId, @rootId, @branchId2, N'Marketing', @subOrg1x1 out;	
	EXEC SaveOrgML @customerId, @subOrg1x1, N'TH', N'ฝ่ายการตลาด';

	-- Org Branch Samutprakarn
	-- 1st Lvl Org(s)	
	SET @subOrg1x1 = NULL;
	EXEC SaveOrg @customerId, @rootId, @branchId3, N'Marketing', @subOrg1x1 out;	
	EXEC SaveOrgML @customerId, @subOrg1x1, N'TH', N'ฝ่ายการตลาด';
END

GO
