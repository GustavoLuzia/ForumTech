CREATE DATABASE [FORUM]
GO
USE [FORUM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [dbo].[POSTS]    Script Date: 18/02/2018 18:58:52 ******/
CREATE TABLE [dbo].[POSTS](
	[Posts_Id] [int] IDENTITY(1,1) NOT NULL,
	[Posts_Owner] [int] NOT NULL,
	[Creation_Date] [datetime] NULL,
	[Posts_Title] [varchar](100) NOT NULL,
	[Posts_Description] [varchar](max) NOT NULL,
	[Posts_Category_Id] [int] NOT NULL,
	[Posts_Status] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Posts_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POSTS_CATEGORY]    Script Date: 18/02/2018 18:58:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POSTS_CATEGORY](
	[Posts_Category_Id] [int] IDENTITY(1,1) NOT NULL,
	[Posts_Category_Name] [varchar](100) NOT NULL,
	[Posts_Category_Description] [varchar](500) NULL,
	[Posts_Category_Status] [bit] NOT NULL,
	[Enable_Reply] [bit] NULL,
	[Enable_Selection] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Posts_Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POSTS_COMMENTS]    Script Date: 18/02/2018 18:58:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POSTS_COMMENTS](
	[Posts_Comments_Id] [int] IDENTITY(1,1) NOT NULL,
	[Posts_Description] [varchar](max) NOT NULL,
	[Posts_Comments_User] [int] NOT NULL,
	[Creation_Date] [datetime] NULL,
	[Posts_Comments_Status] [bit] NOT NULL,
	[Posts_Id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Posts_Comments_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USERS]    Script Date: 18/02/2018 18:58:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USERS](
	[Users_Id] [int] IDENTITY(1,1) NOT NULL,
	[Users_Name] [varchar](500) NOT NULL,
	[Users_Type_Id] [int] NOT NULL,
	[Users_Login] [varchar](20) NOT NULL,
	[Users_Password] [varchar](50) NOT NULL,
	[Users_Status] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Users_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USERS_TYPE]    Script Date: 18/02/2018 18:58:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USERS_TYPE](
	[Users_Type_Id] [int] IDENTITY(1,1) NOT NULL,
	[Users_Type_Description] [varchar](500) NOT NULL,
	[Users_Type_Status] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Users_Type_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[POSTS] ADD  DEFAULT (getdate()) FOR [Creation_Date]
GO
ALTER TABLE [dbo].[POSTS] ADD  DEFAULT ((1)) FOR [Posts_Status]
GO
ALTER TABLE [dbo].[POSTS_CATEGORY] ADD  DEFAULT ((1)) FOR [Posts_Category_Status]
GO
ALTER TABLE [dbo].[POSTS_CATEGORY] ADD  DEFAULT ((1)) FOR [Enable_Reply]
GO
ALTER TABLE [dbo].[POSTS_CATEGORY] ADD  DEFAULT ((1)) FOR [Enable_Selection]
GO
ALTER TABLE [dbo].[POSTS_COMMENTS] ADD  DEFAULT (getdate()) FOR [Creation_Date]
GO
ALTER TABLE [dbo].[POSTS_COMMENTS] ADD  DEFAULT ((1)) FOR [Posts_Comments_Status]
GO
ALTER TABLE [dbo].[USERS] ADD  DEFAULT ((1)) FOR [Users_Status]
GO
ALTER TABLE [dbo].[USERS_TYPE] ADD  DEFAULT ((1)) FOR [Users_Type_Status]
GO
ALTER TABLE [dbo].[POSTS]  WITH CHECK ADD FOREIGN KEY([Posts_Category_Id])
REFERENCES [dbo].[POSTS_CATEGORY] ([Posts_Category_Id])
GO
ALTER TABLE [dbo].[POSTS]  WITH CHECK ADD FOREIGN KEY([Posts_Owner])
REFERENCES [dbo].[USERS] ([Users_Id])
GO
ALTER TABLE [dbo].[POSTS_COMMENTS]  WITH CHECK ADD FOREIGN KEY([Posts_Id])
REFERENCES [dbo].[POSTS] ([Posts_Id])
GO
ALTER TABLE [dbo].[POSTS_COMMENTS]  WITH CHECK ADD FOREIGN KEY([Posts_Comments_User])
REFERENCES [dbo].[USERS] ([Users_Id])
GO
ALTER TABLE [dbo].[USERS]  WITH CHECK ADD FOREIGN KEY([Users_Type_Id])
REFERENCES [dbo].[USERS_TYPE] ([Users_Type_Id])
GO
USE [master]
GO
ALTER DATABASE [FORUM] SET  READ_WRITE 
GO