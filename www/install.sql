/*
This SQL Script will create the tables for you as well as upgrade the tables
if you have started with an earlier version of the CFSMS project. The script 
conditionally looks at what you have and don't have and changes the tables and
values in the database around to get you up to the latest and greatest. It is 
a non-descructive script so you can run it again and again without any harm.

This script was written and tested against MSSQL Server 2005
*/

IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sms_queue')
	BEGIN

		CREATE TABLE [dbo].[sms_queue](
			[sms_id] [int] IDENTITY(1,1) NOT NULL,
			[sms_type_code] [char](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
			[sms_from] [numeric](18, 0) NOT NULL,
			[sms_to] [numeric](18, 0) NOT NULL,
			[message] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
			[parent_id] [int] NULL,
			[child_id] [int] NULL,
			[from_date] [datetime] NOT NULL,
			[thru_date] [datetime] NOT NULL,
			[lock_date] [datetime] NULL,
			[locked] [bit] NOT NULL,
		 CONSTRAINT [PK_sms_queue] PRIMARY KEY CLUSTERED 
		(
			[sms_id] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]

	END

IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sms_types')
	BEGIN

		CREATE TABLE [dbo].[sms_types](
			[sms_type_code] [char](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
			[label] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
			[description] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[change_date] [datetime] NOT NULL CONSTRAINT [DF_sms_types_change_date]  DEFAULT (getdate()),
		 CONSTRAINT [PK_sms_types] PRIMARY KEY CLUSTERED 
		(
			[sms_type_code] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]


		ALTER TABLE [dbo].[sms_queue]  WITH CHECK ADD  CONSTRAINT [FK_sms_queue_sms_types] FOREIGN KEY([sms_type_code])
		REFERENCES [dbo].[sms_types] ([sms_type_code])

	END

IF NOT EXISTS(SELECT sms_type_code FROM sms_types WHERE sms_type_code = 'sms_in')
	BEGIN
		INSERT INTO [dbo].[sms_types] (
			sms_type_code,
			label,
			description,
			change_date
			)
		VALUES (
			'sms_in',
			'Incomming SMS',
			'Incomming SMS',
			getdate()
			);
	END

IF NOT EXISTS(SELECT sms_type_code FROM sms_types WHERE sms_type_code = 'sms_in')
	BEGIN
		INSERT INTO [dbo].[sms_types] (
			sms_type_code,
			label,
			description,
			change_date
			)
		VALUES (
			'sms_out',
			'Outgoing SMS',
			'Outgoing SMS',
			getdate()
			);	
	END	

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'sms_queue' AND COLUMN_NAME = 'provider_id')
	BEGIN
		ALTER TABLE dbo.sms_queue
			DROP CONSTRAINT FK_sms_queue_sms_types
		CREATE TABLE dbo.Tmp_sms_queue
			(
			sms_id int NOT NULL IDENTITY (1, 1),
			sms_type_code char(50) NOT NULL,
			sms_from numeric(18, 0) NOT NULL,
			sms_to numeric(18, 0) NOT NULL,
			message varchar(500) NOT NULL,
			parent_id int NULL,
			child_id int NULL,
			provider_id varchar(50) NULL,
			from_date datetime NOT NULL,
			thru_date datetime NOT NULL,
			lock_date datetime NULL,
			locked bit NOT NULL
			)  ON [PRIMARY]
		SET IDENTITY_INSERT dbo.Tmp_sms_queue ON
		IF EXISTS(SELECT * FROM dbo.sms_queue)
			 EXEC('INSERT INTO dbo.Tmp_sms_queue (sms_id, sms_type_code, sms_from, sms_to, message, parent_id, child_id, from_date, thru_date, lock_date, locked)
				SELECT sms_id, sms_type_code, sms_from, sms_to, message, parent_id, child_id, from_date, thru_date, lock_date, locked FROM dbo.sms_queue WITH (HOLDLOCK TABLOCKX)')
		SET IDENTITY_INSERT dbo.Tmp_sms_queue OFF
		DROP TABLE dbo.sms_queue
		EXECUTE sp_rename N'dbo.Tmp_sms_queue', N'sms_queue', 'OBJECT' 
		ALTER TABLE dbo.sms_queue ADD CONSTRAINT
			PK_sms_queue PRIMARY KEY CLUSTERED 
			(
			sms_id
			) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		CREATE NONCLUSTERED INDEX IX_sms_queue ON dbo.sms_queue
			(
			sms_id
			) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		ALTER TABLE dbo.sms_queue ADD CONSTRAINT
			FK_sms_queue_sms_types FOREIGN KEY
			(
			sms_type_code
			) REFERENCES dbo.sms_types
			(
			sms_type_code
			) ON UPDATE  NO ACTION 
			 ON DELETE  NO ACTION 	
		
	END