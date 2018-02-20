USE [FORUM]
GO
SET IDENTITY_INSERT [dbo].[USERS_TYPE] ON 

INSERT [dbo].[USERS_TYPE] ([Users_Type_Id], [Users_Type_Description], [Users_Type_Status]) VALUES (1, N'Admin', 1)
INSERT [dbo].[USERS_TYPE] ([Users_Type_Id], [Users_Type_Description], [Users_Type_Status]) VALUES (2, N'Common', 1)
SET IDENTITY_INSERT [dbo].[USERS_TYPE] OFF
SET IDENTITY_INSERT [dbo].[USERS] ON 

INSERT [dbo].[USERS] ([Users_Id], [Users_Name], [Users_Type_Id], [Users_Login], [Users_Password], [Users_Status]) VALUES (1, N'Josh', 1, N'Josh', N'123456', 1)
INSERT [dbo].[USERS] ([Users_Id], [Users_Name], [Users_Type_Id], [Users_Login], [Users_Password], [Users_Status]) VALUES (2, N'Mike', 2, N'Mike', N'abcdef', 1)
INSERT [dbo].[USERS] ([Users_Id], [Users_Name], [Users_Type_Id], [Users_Login], [Users_Password], [Users_Status]) VALUES (3, N'Chester', 2, N'Chester_M', N'MyPassword', 1)
INSERT [dbo].[USERS] ([Users_Id], [Users_Name], [Users_Type_Id], [Users_Login], [Users_Password], [Users_Status]) VALUES (4, N'MyHouse', 2, N'house', N'qwerty', 1)
INSERT [dbo].[USERS] ([Users_Id], [Users_Name], [Users_Type_Id], [Users_Login], [Users_Password], [Users_Status]) VALUES (5, N'Anton', 2, N'antonUser', N'09876', 1)
SET IDENTITY_INSERT [dbo].[USERS] OFF
SET IDENTITY_INSERT [dbo].[POSTS_CATEGORY] ON 

INSERT [dbo].[POSTS_CATEGORY] ([Posts_Category_Id], [Posts_Category_Name], [Posts_Category_Description], [Posts_Category_Status], [Enable_Reply], [Enable_Selection]) VALUES (1, N'Rules', N'Forum Rules', 1, 0, 0)
INSERT [dbo].[POSTS_CATEGORY] ([Posts_Category_Id], [Posts_Category_Name], [Posts_Category_Description], [Posts_Category_Status], [Enable_Reply], [Enable_Selection]) VALUES (2, N'C#', N'Topics About C#', 1, 1, 1)
INSERT [dbo].[POSTS_CATEGORY] ([Posts_Category_Id], [Posts_Category_Name], [Posts_Category_Description], [Posts_Category_Status], [Enable_Reply], [Enable_Selection]) VALUES (3, N'Javascript', N'Topics About Javascript', 1, 1, 1)
SET IDENTITY_INSERT [dbo].[POSTS_CATEGORY] OFF
SET IDENTITY_INSERT [dbo].[POSTS] ON 

INSERT [dbo].[POSTS] ([Posts_Id], [Posts_Owner], [Creation_Date], [Posts_Title], [Posts_Description], [Posts_Category_Id], [Posts_Status]) VALUES (1, 1, CAST(N'2018-02-17T00:22:19.553' AS DateTime), N'Usage Rules', N'1. Don''t Panic! <br> 2. Do not curse the others. <br> 3. Help as much as you can.<br>', 1, 1)
INSERT [dbo].[POSTS] ([Posts_Id], [Posts_Owner], [Creation_Date], [Posts_Title], [Posts_Description], [Posts_Category_Id], [Posts_Status]) VALUES (2, 2, CAST(N'2018-02-17T00:31:08.837' AS DateTime), N'Can''t replace string', N'I am trying to replace the string "rice" for "beans" but the visual studio don''t let it. <br> My Code: <br> string text = "meat with rice"; <br> text = text.replace("rice", "beans");', 2, 1)
INSERT [dbo].[POSTS] ([Posts_Id], [Posts_Owner], [Creation_Date], [Posts_Title], [Posts_Description], [Posts_Category_Id], [Posts_Status]) VALUES (3, 2, CAST(N'2018-02-17T00:32:32.337' AS DateTime), N'Change css class', N'How can I change a specific css class with jQuery?', 3, 1)
SET IDENTITY_INSERT [dbo].[POSTS] OFF
SET IDENTITY_INSERT [dbo].[POSTS_COMMENTS] ON 

INSERT [dbo].[POSTS_COMMENTS] ([Posts_Comments_Id], [Posts_Description], [Posts_Comments_User], [Creation_Date], [Posts_Comments_Status], [Posts_Id]) VALUES (1, N'Can you delete all the others classes?', 4, CAST(N'2018-02-17T22:58:40.677' AS DateTime), 1, 3)
INSERT [dbo].[POSTS_COMMENTS] ([Posts_Comments_Id], [Posts_Description], [Posts_Comments_User], [Creation_Date], [Posts_Comments_Status], [Posts_Id]) VALUES (2, N'There is not a method for that, you have to remove the old class and add th other. <br><br> Like this: <br> $("div").removeClass("oldClass").addClass("newClass");', 3, CAST(N'2018-02-17T22:58:40.677' AS DateTime), 1, 3)
INSERT [dbo].[POSTS_COMMENTS] ([Posts_Comments_Id], [Posts_Description], [Posts_Comments_User], [Creation_Date], [Posts_Comments_Status], [Posts_Id]) VALUES (3, N'C# is case sensitive, change "replace" for "Replace" and it will work.', 3, CAST(N'2018-02-17T23:18:57.800' AS DateTime), 1, 2)
SET IDENTITY_INSERT [dbo].[POSTS_COMMENTS] OFF