USE [SVA]
GO

CREATE TABLE [dbo].[tc_countedStatus](
	[countedStatus_id] [int] IDENTITY(1,1) NOT NULL,
	[countedStatus_value] [int] NOT NULL,
	[countedStatus_descrip] [varchar](30) NOT NULL,
	[countedStatus_status] [bit] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tc_countedStatus] ADD  CONSTRAINT [DF_tc_countedStatus_countedStatus_value]  DEFAULT ((0)) FOR [countedStatus_value]
GO

ALTER TABLE [dbo].[tc_countedStatus] ADD  CONSTRAINT [DF_tc_countedStatus_countedDescrip]  DEFAULT ('') FOR [countedStatus_descrip]
GO

ALTER TABLE [dbo].[tc_countedStatus] ADD  CONSTRAINT [DF_tc_countedStatus_countedStatus_status]  DEFAULT ((1)) FOR [countedStatus_status]
GO
