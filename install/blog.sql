/****** Object:  User [PC201311202048\Administrator]    Script Date: 06/03/2014 13:45:18 ******/
IF NOT EXISTS (SELECT * FROM dbo.sysusers WHERE name = N'PC201311202048\Administrator')
EXEC dbo.sp_grantdbaccess @loginame = N'PC201311202048\Administrator', @name_in_db = N'PC201311202048\Administrator'
GO
/****** Object:  Table [dbo].[blog_tags]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_tags]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_tags](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tag_name] [varchar](255) NULL,
	[tag_count] [int] NULL,
 CONSTRAINT [PK_blog_tags] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[blog_plugins]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_plugins]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_plugins](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[plu_mark] [varchar](255) NULL,
	[plu_name] [varchar](255) NULL,
	[plu_des] [ntext] NULL,
	[plu_author] [varchar](255) NULL,
	[plu_mail] [varchar](255) NULL,
	[plu_web] [ntext] NULL,
	[plu_version] [int] NULL,
	[plu_folder] [varchar](255) NULL,
 CONSTRAINT [PK_blog_plugins] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[blog_messages]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_messages]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_messages](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[msg_member_id] [int] NULL,
	[msg_content] [ntext] NULL,
	[msg_parent] [int] NULL,
	[msg_postdate] [datetime] NULL,
 CONSTRAINT [PK_blog_messages] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[blog_members]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_members]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_members](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[member_mark] [varchar](255) NULL,
	[member_nick] [varchar](255) NULL,
	[member_hashkey] [varchar](40) NULL,
	[member_salt] [varchar](10) NULL,
	[member_mail] [varchar](255) NULL,
	[member_group] [varchar](50) NULL,
	[member_comments] [int] NULL,
	[member_messages] [int] NULL,
	[member_forbit] [bit] NULL,
 CONSTRAINT [PK_blog_members] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[blog_groups]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_groups]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[group_mark] [varchar](50) NULL,
	[group_name] [varchar](255) NULL,
	[group_des] [ntext] NULL,
	[group_code] [ntext] NULL,
 CONSTRAINT [PK_blog_groups] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[blog_global]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_global]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_global](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[blog_name] [varchar](255) NULL,
	[blog_title] [varchar](255) NULL,
	[blog_des] [ntext] NULL,
	[blog_mail] [varchar](255) NULL,
	[blog_copyright] [varchar](50) NULL,
	[blog_keywords] [ntext] NULL,
	[blog_description] [ntext] NULL,
	[blog_theme] [varchar](255) NULL,
	[blog_themename] [varchar](255) NULL,
	[blog_thememail] [varchar](255) NULL,
	[blog_themeweb] [ntext] NULL,
	[blog_themeversion] [varchar](255) NULL,
	[blog_status] [int] NULL,
	[blog_close] [bit] NULL,
 CONSTRAINT [PK_blog_global] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[blog_comments]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_comments]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_comments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[com_article_id] [int] NULL,
	[com_member_id] [int] NULL,
	[com_content] [ntext] NULL,
	[com_parent] [int] NULL,
	[com_postdate] [datetime] NULL,
 CONSTRAINT [PK_blog_comments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[blog_code]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_code]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_code](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code_name] [varchar](255) NULL,
	[code_des] [ntext] NULL,
	[code_status] [bit] NULL,
 CONSTRAINT [PK_blog_code] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[blog_categorys]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_categorys]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_categorys](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cate_name] [varchar](255) NULL,
	[cate_des] [ntext] NULL,
	[cate_count] [int] NULL,
	[cate_parent] [int] NULL,
	[cate_src] [ntext] NULL,
	[cate_outlink] [bit] NULL,
 CONSTRAINT [PK_blog_categorys] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[blog_attments]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_attments]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_attments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[att_des] [ntext] NULL,
	[att_type] [varchar](50) NULL,
	[att_src] [ntext] NULL,
 CONSTRAINT [PK_blog_attments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[blog_articles]    Script Date: 06/03/2014 13:45:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[blog_articles]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[blog_articles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[art_title] [varchar](255) NULL,
	[art_des] [ntext] NULL,
	[art_category] [int] NULL,
	[art_content] [ntext] NULL,
	[art_tags] [ntext] NULL,
	[art_draft] [bit] NULL,
	[art_tname] [varchar](255) NULL,
	[art_postdate] [datetime] NULL,
	[art_modifydate] [datetime] NULL,
	[art_author] [int] NULL,
	[art_comment_count] [int] NULL,
 CONSTRAINT [PK_blog_articles] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Default [DF_blog_tags_tag_count]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_tags_tag_count]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_tags_tag_count]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_tags] ADD  CONSTRAINT [DF_blog_tags_tag_count]  DEFAULT ((0)) FOR [tag_count]
END


END
GO
/****** Object:  Default [DF_blog_plugins_plu_version]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_plugins_plu_version]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_plugins_plu_version]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_plugins] ADD  CONSTRAINT [DF_blog_plugins_plu_version]  DEFAULT ((1)) FOR [plu_version]
END


END
GO
/****** Object:  Default [DF_blog_members_member_comments_1]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_members_member_comments_1]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_members_member_comments_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_members] ADD  CONSTRAINT [DF_blog_members_member_comments_1]  DEFAULT ((0)) FOR [member_comments]
END


END
GO
/****** Object:  Default [DF_blog_members_member_messages_1]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_members_member_messages_1]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_members_member_messages_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_members] ADD  CONSTRAINT [DF_blog_members_member_messages_1]  DEFAULT ((0)) FOR [member_messages]
END


END
GO
/****** Object:  Default [DF_blog_members_member_forbit_1]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_members_member_forbit_1]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_members_member_forbit_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_members] ADD  CONSTRAINT [DF_blog_members_member_forbit_1]  DEFAULT ((0)) FOR [member_forbit]
END


END
GO
/****** Object:  Default [DF_blog_global_blog_status]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_global_blog_status]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_global_blog_status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_global] ADD  CONSTRAINT [DF_blog_global_blog_status]  DEFAULT ((0)) FOR [blog_status]
END


END
GO
/****** Object:  Default [DF_blog_global_blog_close]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_global_blog_close]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_global_blog_close]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_global] ADD  CONSTRAINT [DF_blog_global_blog_close]  DEFAULT ((0)) FOR [blog_close]
END


END
GO
/****** Object:  Default [DF_blog_comments_com_article_id]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_comments_com_article_id]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_comments_com_article_id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_comments] ADD  CONSTRAINT [DF_blog_comments_com_article_id]  DEFAULT ((0)) FOR [com_article_id]
END


END
GO
/****** Object:  Default [DF_blog_comments_com_member_id]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_comments_com_member_id]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_comments_com_member_id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_comments] ADD  CONSTRAINT [DF_blog_comments_com_member_id]  DEFAULT ((0)) FOR [com_member_id]
END


END
GO
/****** Object:  Default [DF_blog_comments_com_parent]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_comments_com_parent]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_comments_com_parent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_comments] ADD  CONSTRAINT [DF_blog_comments_com_parent]  DEFAULT ((0)) FOR [com_parent]
END


END
GO
/****** Object:  Default [DF_blog_code_code_status]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_code_code_status]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_code_code_status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_code] ADD  CONSTRAINT [DF_blog_code_code_status]  DEFAULT ((0)) FOR [code_status]
END


END
GO
/****** Object:  Default [DF_blog_categorys_cate_count]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_categorys_cate_count]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_categorys_cate_count]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_categorys] ADD  CONSTRAINT [DF_blog_categorys_cate_count]  DEFAULT ((0)) FOR [cate_count]
END


END
GO
/****** Object:  Default [DF_blog_categorys_cate_parent]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_categorys_cate_parent]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_categorys_cate_parent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_categorys] ADD  CONSTRAINT [DF_blog_categorys_cate_parent]  DEFAULT ((0)) FOR [cate_parent]
END


END
GO
/****** Object:  Default [DF_blog_categorys_cate_outlink]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_categorys_cate_outlink]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_categorys_cate_outlink]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_categorys] ADD  CONSTRAINT [DF_blog_categorys_cate_outlink]  DEFAULT ((0)) FOR [cate_outlink]
END


END
GO
/****** Object:  Default [DF_blog_articles_art_category]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_articles_art_category]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_articles_art_category]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_articles] ADD  CONSTRAINT [DF_blog_articles_art_category]  DEFAULT ((0)) FOR [art_category]
END


END
GO
/****** Object:  Default [DF_blog_articles_art_draft]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_articles_art_draft]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_articles_art_draft]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_articles] ADD  CONSTRAINT [DF_blog_articles_art_draft]  DEFAULT ((0)) FOR [art_draft]
END


END
GO
/****** Object:  Default [DF_blog_articles_art_author]    Script Date: 06/03/2014 13:45:19 ******/
IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_blog_articles_art_author]') AND type = 'D')
BEGIN
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_blog_articles_art_author]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[blog_articles] ADD  CONSTRAINT [DF_blog_articles_art_author]  DEFAULT ((0)) FOR [art_author]
END


END
GO
