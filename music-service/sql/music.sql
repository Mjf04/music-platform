/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80035 (8.0.35)
 Source Host           : localhost:3306
 Source Schema         : music

 Target Server Type    : MySQL
 Target Server Version : 80035 (8.0.35)
 File Encoding         : 65001

 Date: 17/04/2026 10:05:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_admin
-- ----------------------------
DROP TABLE IF EXISTS `tb_admin`;
CREATE TABLE `tb_admin`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '管理员 id',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员用户名',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员密码',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '管理员邮箱',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '管理员手机号',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '管理员头像 URL',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_admin
-- ----------------------------
INSERT INTO `tb_admin` VALUES (1, 'admin', 'e41951335dd09b45182a141fe62b4941', NULL, NULL, NULL);
INSERT INTO `tb_admin` VALUES (2, 'admin_1', '14c4c5e6ded24fe1f22671c5f66e2521', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for tb_artist
-- ----------------------------
DROP TABLE IF EXISTS `tb_artist`;
CREATE TABLE `tb_artist`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '歌手 id',
  `name` varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '歌手姓名',
  `gender` int NULL DEFAULT NULL COMMENT '歌手性别：0-男，1-女，2-组合/乐队',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '歌手头像',
  `birth` date NULL DEFAULT NULL COMMENT '歌手出生日期',
  `area` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '歌手国籍',
  `introduction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '歌手简介',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_artist
-- ----------------------------
INSERT INTO `tb_artist` VALUES (2, '孝敏 (효민)', 1, 'http://localhost:9000/vibe-music-data/artists/ee425603-fa15-454f-925e-b8fdf4a19add-blob', '1989-05-30', '韩国', '孝敏(효민)，本名为朴宣映，韩国人气女歌手、演员。韩国女子组合T-ara第三任队长，在队内司职主唱、主领舞、Rapper ，是队中的时尚担当、性感担当、形象担当。');
INSERT INTO `tb_artist` VALUES (3, '智妍 (지연)', 1, 'http://localhost:9000/vibe-music-data/artists/10838e3a-5887-42bd-99e2-da8d66c76611-blob', '1993-06-07', '韩国', '芝妍(지연)，本名为朴芝妍，韩国女歌手、演员、主持人、模特，女子演唱团体T-ara成员之一。');
INSERT INTO `tb_artist` VALUES (4, 'Bandari', 0, 'http://localhost:9000/vibe-music-data/artists/793eebd7-cef1-4d81-839c-dee662dcb050-blob', NULL, '瑞士', '班得瑞（Bandari），这个来自瑞士音乐公司Audio Video Communications AG的新纪元音乐项目，以其独特的音乐魅力在亚洲地区，特别是中国台湾和中国大陆，赢得了无数乐迷的喜爱。尽管常被媒体和唱片公司描绘成一个低调的音乐团体，但他们的作品却以其深邃的环境音乐和冥想音乐风格，成为了许多人寻求睡眠与减压的良伴。');
INSERT INTO `tb_artist` VALUES (5, 'Daoko', 1, 'http://localhost:9000/vibe-music-data/artists/2819f722-62c2-4637-988c-f7712b41c112-blob', '1997-03-04', '日本', 'DAOKO，1997年出生于日本东京都，是一位备受瞩目的日本女性MC和歌手。她的音乐之路始于2012年，当时她发布了专辑《HYPER GIRL- 向こう侧の女の子 -》，展现了她独特的音乐才华。2013年，DAOKO与m-flo合作推出了歌曲《IRONY》，将她的音乐风格推向了一个新的高度。');
INSERT INTO `tb_artist` VALUES (6, 'IU (아이유)', 1, 'http://localhost:9000/vibe-music-data/artists/cd398aad-f0fa-4e31-a256-35d3b78b7391-blob', NULL, '韩国', 'IU（아이유），本名李知恩，韩国女歌手、演员、主持人。自2007年加入Loen Entertainment 成为练习生以来，她的音乐之路便一发不可收拾。15岁那年，IU发行首张迷你专辑《Lost and Found》，正式踏入歌坛。然而，真正让她崭露头角的是2010年的神曲《好日子》，那惊艳的三段高音不仅展示了她卓越的唱功，更让她在各大榜单上屡获殊荣，荣获MMA年度歌曲奖。');
INSERT INTO `tb_artist` VALUES (7, 'G.E.M.邓紫棋', 1, 'http://localhost:9000/vibe-music-data/artists/71bff6e1-e4cf-41ca-bfce-29a1c8439651-blob', '1991-08-16', '中国', '邓紫棋（Gloria Tang Tsz-Kei），又名G.E.M.，是中国香港的创作型女歌手、词曲创作人。2008年，年仅16岁的邓紫棋出道，并于同年10月发行首张EP《G.E.M.》，凭借这张作品迅速在香港乐坛崭露头角，获得各大颁奖礼新人金奖。');
INSERT INTO `tb_artist` VALUES (8, 'RADWIMPS (ラッドウィンプス)', 0, 'http://localhost:9000/vibe-music-data/artists/2f832e3e-1169-4bc5-9519-b5f7e0b743a3-blob', NULL, '日本', '乐队以其不拘泥于既存风格的音乐性，以及从恋爱观到生死观充满哲理又不乏感性的歌词，得到了以青春期人群为中心的广大受众群体的支持。');
INSERT INTO `tb_artist` VALUES (9, '李荣浩', 0, 'http://localhost:9000/vibe-music-data/artists/f43cd77b-3343-4143-95cb-714606f25198-blob', '1985-07-11', '中国', '李荣浩，中国流行乐男歌手、音乐制作人、演员、吉他手。');
INSERT INTO `tb_artist` VALUES (10, 'AniFace', NULL, 'http://localhost:9000/vibe-music-data/artists/a14ce140-e6ee-47c3-8910-a59629741fcd-blob', NULL, '', '独立音乐人');
INSERT INTO `tb_artist` VALUES (11, 'Khalid', 0, 'http://localhost:9000/vibe-music-data/artists/598ea48e-d359-4819-9519-744826f92b92-blob', '1998-02-11', '美国', '哈立德（Khalid），原名哈立德·唐纳尔·罗宾逊（Khalid Donnel Robinson），是一位才华横溢的美国创作型歌手，隶属于Right Hand和RCA唱片公司。2016年7月，他的首支单曲《Location》一经发布便迅速崭露头角，攀升至美国公告牌百强单曲榜第16位，并荣获美国唱片业协会的四白金单曲认证。');
INSERT INTO `tb_artist` VALUES (12, '张杰', 0, 'http://localhost:9000/vibe-music-data/artists/715b1fc6-e310-4fef-91e0-5d4f029a4b6d-blob', '1982-12-20', '中国', '杰（Jason Zhang），1982年12月20日出生于四川省成都市，是中国流行男歌手。2004年，他通过歌唱类选秀节目《我型我秀》获得全国总冠军正式出道。2007年，参加《快乐男生》并获得总决赛第四名，随后发行的EP《最美的太阳》拿下亚马逊年度唱片销量冠军。');
INSERT INTO `tb_artist` VALUES (13, '郎朗', 0, 'http://localhost:9000/vibe-music-data/artists/e2f1cc12-28b3-4e91-aeae-b26b51ed7e78-blob', '1982-06-14', '中国', '郎朗，1982年6月14日出生于辽宁省沈阳市沈河区，国际著名钢琴家。他是第一位受聘于世界顶级的柏林爱乐乐团和美国五大交响乐团的中国钢琴家，获得古典音乐类多项权威奖项，包括德国古典回声大奖，全英古典音乐奖，伯恩斯坦艺术成就大奖，国际门德尔松大奖等。');
INSERT INTO `tb_artist` VALUES (14, 'Gewandhausorchester Leipzig', 2, 'http://localhost:9000/vibe-music-data/artists/855c8bb6-1e8e-4732-8bd2-e5bcb7a92dad-blob', NULL, '德国', '莱比锡布商大厦管弦乐团（德语：Gewandhausorchester Leipzig，又译莱比锡布业大厅管弦乐团或音译为莱比锡格万豪斯管弦乐团）是以德国莱比锡为基地的世界知名管弦乐团，现有175名全职乐手，是当今全世界人数最多的专业管弦乐团之一。');
INSERT INTO `tb_artist` VALUES (15, 'Dan Gibson\'s Solitudes', 0, 'http://localhost:9000/vibe-music-data/artists/0c428376-ecd0-434d-9ab3-57135bacd422-blob', '1922-01-19', '加拿大', 'Dan Gibson，这位1922年1月19日在加拿大蒙特利尔诞生的自然录音大师，他的生命轨迹如同一首悠扬的旋律，与大自然紧密相连。自幼在尼加拉瀑布附近的农庄成长，那片被自然之美环绕的土地，仿佛为他播下了一颗热爱自然的种子。');
INSERT INTO `tb_artist` VALUES (17, 'Wiener Philharmoniker', 2, 'http://localhost:9000/vibe-music-data/artists/177c656f-1781-4c05-a7c4-941ae9cb4ef1-blob', '1842-01-01', '奥地利', '维也纳爱乐乐团，自1842年起便以其卓越的音乐才能和独特的维也纳音色征服了世界。这个由维也纳国家歌剧院精英组成的私人乐团，在音乐会舞台上华丽转身，展现出无与伦比的魅力。作为全球最顶尖的乐团之一，维也纳爱乐乐团不仅在国际乐坛享有盛誉，更是以其高贵的艺术气质和自主管理的经营模式独树一帜。');
INSERT INTO `tb_artist` VALUES (18, 'Beyond', 2, 'http://localhost:9000/vibe-music-data/artists/132d45db-3425-484c-97c4-ac6828d98394-blob', NULL, '中国', 'Beyond，中国香港摇滚乐队，由黄家驹、黄贯中、黄家强、叶世荣组成。');
INSERT INTO `tb_artist` VALUES (19, '林俊杰', 0, 'http://localhost:9000/vibe-music-data/artists/556a8890-3b18-455c-b222-8b615cf347c1-blob', '1981-03-27', '新加坡', '林俊杰（JJ Lin），1981年3月27日出生于新加坡，祖籍中国福建省厦门市同安区，是华语流行乐男歌手、音乐人及潮牌主理人。2003年，他发行首张创作专辑《乐行者》，凭借该专辑获得第15届台湾金曲奖最佳新人奖。2004年，凭借专辑《第二天堂》中的主打歌《江南》获得广泛关注，正式开启音乐事业新篇章。');
INSERT INTO `tb_artist` VALUES (20, 'Jonas Brothers', 2, 'http://localhost:9000/vibe-music-data/artists/e5c80b82-b84b-4baf-af43-391249c8acaa-blob', NULL, '美国', '乔纳斯兄弟（Jonas Brothers），这支享誉美国的流行摇滚乐队，由三位才华横溢的兄弟——凯文·乔纳斯、乔·乔纳斯和尼克·乔纳斯携手组建。他们的音乐旅程，如同一部充满转折与辉煌的乐章，引人入胜。');
INSERT INTO `tb_artist` VALUES (21, 'Christopher', 0, 'http://localhost:9000/vibe-music-data/artists/c7d6521a-bd35-43d3-9243-59c5f3dfe6e9-blob', '1992-01-31', '丹麦', '克里斯托弗·尼森（Christopher Nissen），丹麦男歌手兼作曲家。');
INSERT INTO `tb_artist` VALUES (22, 'Motohiko Hirami', NULL, 'http://localhost:9000/vibe-music-data/artists/c8d24e4d-296d-401b-a5c1-c586b61506af-blob', NULL, '日本', 'Motohiko Hirami是来自日本的独立音乐制作人。');
INSERT INTO `tb_artist` VALUES (23, 'Halsey', 1, 'http://localhost:9000/vibe-music-data/artists/39557f38-5016-4300-a63a-684ae95e3496-blob', '1994-09-29', '美国', '海尔希（Halsey），1994年9月29日出生于美国新泽西州华盛顿市，是一位才华横溢的美国创作型歌手。2014年7月，她与Astralwerks唱片签约后，迅速崭露头角，发布首支个人单曲《Ghost》。紧接着，她发行了首张迷你专辑《Room 93》，为乐坛注入了一股新势力。');
INSERT INTO `tb_artist` VALUES (24, 'Vladimir Ashkenazy', 0, 'http://localhost:9000/vibe-music-data/artists/b17db203-b7ac-421d-988e-e6e74d41f68f-blob', '1937-07-06', '冰岛', '弗拉基米尔·阿什肯纳齐，这位英籍前苏联的钢琴演奏巨匠，自幼便与音乐结下了不解之缘。在莫斯科那座充满艺术氛围的城市中，他踏入了中心音乐学校的大门，从此，一颗音乐的种子在他心中悄然萌芽。在莫斯科音乐学院的深造，更是为他日后的辉煌奠定了坚实的基础。');
INSERT INTO `tb_artist` VALUES (25, 'Imagine Dragons', 2, 'http://localhost:9000/vibe-music-data/artists/73d719f5-ea4e-4125-821b-5d0c0b276111-blob', NULL, '美国', 'Imagine Dragons，这支被誉为“梦龙”的美国独立摇滚乐队，自2008年于犹他州普洛佛成立以来，便以其独特的音乐风格吸引了无数乐迷。他们的音乐之旅始于拉斯维加斯，并在2012年凭借专辑《Night Visions》一举成名。');
INSERT INTO `tb_artist` VALUES (26, '陈奕迅', 0, 'http://localhost:9000/vibe-music-data/artists/39ff395f-e4b1-4de5-beba-627278a00121-blob', '1974-07-27', '中国', '陈奕迅（Eason Chan），1974年7月27日出生于中国香港，是中国香港男歌手、演员，毕业于英国金斯顿大学。1995年，凭借第14届新秀歌唱大赛冠军正式出道。1996年发行首张个人专辑《陈奕迅》，1997年主演个人首部电影《旺角大家姐》。1998年，凭借歌曲《天下无双》在乐坛崭露头角，2000年，歌曲《K歌之王》奠定了他在歌坛的地位。');
INSERT INTO `tb_artist` VALUES (27, '薛之谦', 0, 'http://localhost:9000/vibe-music-data/artists/bbbce46a-a80c-41c3-8f93-a575b78a5c02-blob', '1983-07-17', '中国', '薛之谦，1983年7月17日出生于上海市，中国内地流行乐男歌手、音乐制作人、影视演员，毕业于格里昂酒店管理学院。');
INSERT INTO `tb_artist` VALUES (28, 'Michael Cramtu', NULL, 'http://localhost:9000/vibe-music-data/artists/6b75860a-ae46-4122-a11c-b0a7e2aa984e-blob', NULL, NULL, 'Michael Cramtu，排箫演奏家。班得瑞的成员之一。代表作《Big Big World》。');
INSERT INTO `tb_artist` VALUES (29, 'T-ara', 2, 'http://localhost:9000/vibe-music-data/artists/39d3c7c9-d22c-4e94-8b43-58f1b1106c9e-blob', NULL, '韩国', 'T-ara（티아라），这支充满魅力的韩国女子音乐组合，自MBK娱乐旗下脱颖而出，以“Tiara”为名，寓意着她们歌谣界的女王之梦。她们的首次亮相并非在音乐节目，而是在MBC综艺节目《Radio Star》中，这一独特的出道方式让她们迅速吸引了外界的目光。');
INSERT INTO `tb_artist` VALUES (30, '王力宏', 0, 'http://localhost:9000/vibe-music-data/artists/ad8ffed3-a1bc-4565-932c-83c55194a95c-blob', '1976-05-17', '美国', '王力宏（Wang Leehom），1976年5月17日出生于美国纽约罗切斯特，祖籍中国浙江义乌，华语流行乐男歌手、音乐制作人、演员、导演，拥有威廉姆斯大学和伯克利音乐学院双荣誉博士的学历。');
INSERT INTO `tb_artist` VALUES (31, 'Justin Bieber', 0, 'http://localhost:9000/vibe-music-data/artists/756bc859-cf54-486d-b2a0-c9a7b534d5b2-blob', '1994-03-01', '加拿大', '贾斯汀·比伯，这位1994年3月1日出生的加拿大歌手，早在YouTube上翻唱他人歌曲时就展现出了非凡的音乐才华，吸引了Usher的注意并签约小岛唱片。2009年，他的首张专辑《MY WORLDS》的第一部分《MY WORLD》一经发行，便在美国售出百万张，迅速成为白金唱片。');
INSERT INTO `tb_artist` VALUES (33, '南征北战NZBZ', 0, 'http://localhost:9000/vibe-music-data/artists/18b9c620-c1b7-4300-a3e7-3bf9e8bcdb85-blob', NULL, '中国', '南征北战（NZBZ），中国内地组合，其名寓意为：年轻人要为自己的梦想和爱去努力征战拼搏。其成员来自于祖国的大江南北，由此得名南征北战，由汀洋、赵辰龙、尼成三人组成。南征北战创造出V-Pop（Various Pop Music），即多元化流行音乐，制作出“南征北战”式的流行表达，重新定位新一代的流行音乐。');
INSERT INTO `tb_artist` VALUES (34, 'MrLi小哥', 0, 'http://localhost:9000/vibe-music-data/artists/5deb5bc8-c3da-44f0-b82e-78b80b7f24e7-blob', NULL, NULL, NULL);
INSERT INTO `tb_artist` VALUES (35, '五月天', 2, 'http://localhost:9000/vibe-music-data/artists/f65a1fe0-588b-415d-9d80-ed56f4049cf5-blob', '1997-03-29', '中国', '五月天，台湾摇滚乐团，由乐队团长兼吉他手怪兽（温尚翊）、主唱阿信（陈信宏）、吉他手石头（石锦航）、贝斯玛莎（蔡升晏）和鼓手冠佑（刘谚明）组成，前身为“So Band”乐团，在1997年3月29日更名为“五月天”。至2016年，四次拿下\"台湾金曲奖\"和“最佳乐团奖”。');
INSERT INTO `tb_artist` VALUES (36, 'Taylor Swift', 1, 'http://localhost:9000/vibe-music-data/artists/ae0a613c-0430-478f-b6e8-1d35747fe9a2-blob', '1989-12-13', '美国', 'Taylor Swift（泰勒·斯威夫特），1989年12月13日出生于美国宾夕法尼亚州，是美国著名的女歌手、词曲作者、音乐制作人及演员。自2006年发行首张专辑《Taylor Swift》起，她就以其出色的音乐才华和独特的创作风格吸引了无数粉丝。');
INSERT INTO `tb_artist` VALUES (37, 'Bruno Mars', 0, 'http://localhost:9000/vibe-music-data/artists/ad626971-a528-4913-a34c-9b21f8fc6717-blob', '1985-10-08', '美国', 'Bruno Mars（布鲁诺·马尔斯），原名彼得·基恩·埃尔南德斯，是一位多才多艺的美国创作型歌手兼音乐制作人。他的音乐风格独具匠心，舞台表演丰富多彩，复古风格魅力四溢。这位才华横溢的艺人共获得18项格莱美奖提名，并成功斩获两座大奖，全球专辑销量高达60白金，单曲销量更是突破1.3亿，成为继“猫王”之后，五首Billboard Hot 100单曲榜冠军速度最快的男歌手。');
INSERT INTO `tb_artist` VALUES (38, '逃跑计划', 2, 'http://localhost:9000/vibe-music-data/artists/3a9fe545-d03d-4417-8825-e79919a8dc9b-blob', NULL, '中国', '逃跑计划乐队（EscapePlan），中国内地流行摇滚乐队，由主唱毛川、吉他手马晓东、贝斯手刚昂、鼓手王非凡组成。');
INSERT INTO `tb_artist` VALUES (39, '徐嘉良', 0, 'http://localhost:9000/vibe-music-data/artists/e0bfbb0d-d893-441b-a345-c7b0187b0e6c-blob', NULL, '中国', '徐嘉良，台湾著名唱片制作、编曲、配乐、作曲创作人。曾担任无数台湾、香港艺人的唱片制作编曲人。');
INSERT INTO `tb_artist` VALUES (40, '张震岳', 0, 'http://localhost:9000/vibe-music-data/artists/00f14885-300a-476e-98ff-f9afa08d34dd-blob', '1974-05-02', '中国', '张震岳（Chenyue Chang），1974年5月2日出生于台湾省宜兰县苏澳镇，中国台湾音乐人。');
INSERT INTO `tb_artist` VALUES (41, '张艺兴', 0, 'http://localhost:9000/vibe-music-data/artists/ea0c9a54-6979-42e3-9aae-cf1272cf372d-blob', '1991-10-07', '中国', '张艺兴（LAY），中国内地流行男歌手、影视演员，男子演唱组合EXO/EXO-M中国籍成员。2005年，张艺兴参加湖南经视《明星学院》比赛并获得总决赛季军。2008年，通过S.M. Casting System在中国的选拔成为韩国SM公司旗下练习生。2012年4月，以EXO团体和其子队EXO-M成员身份正式出道。');
INSERT INTO `tb_artist` VALUES (42, 'Rihanna', 1, 'http://localhost:9000/vibe-music-data/artists/a2cf1ad0-9402-4f7f-86c6-bf5591e10749-blob', '1988-02-20', '巴巴多斯', '蕾哈娜（Rihanna），原名罗比恩·蕾哈娜·芬缇，1988年2月20日生于巴巴多斯圣迈克尔区，是一位在美国崭露头角的巴巴多斯籍流行乐女歌手、影视演员及时尚模特。2005年，她凭借首张音乐专辑《Music of the Sun》正式开启歌唱生涯。紧接着，2006年的《A Girl Like Me》和2007年的《Good Girl Gone Bad》相继问世，展现了她日益成熟的音乐风格。');
INSERT INTO `tb_artist` VALUES (43, '周杰伦', 0, 'http://127.0.0.1:9000/vibe-music-data/artists/ebe81ebe-dc69-4be8-9362-0cc819673640-blob', '1979-01-18', '中国台湾', '周杰伦（Jay Chou），1979年1月18日出生于台湾省新北市，祖籍福建省永春县，华语流行乐男歌手、音乐人、演员、导演，毕业于淡江中学 [1]。\n2000年，发行个人首张音乐专辑《Jay》 [2]，并在华语乐坛获得广泛关注 [3]。2001年，凭借音乐专辑《范特西》奠定其乐坛地位 [4-5]，因此获得三座台湾金曲奖 [38]。2003年，登上美国《时代》杂志封面 [6]，此后相继推出《叶惠美》《七里香》《11月的萧邦》《依然范特西》等商业与口碑兼具的');

-- ----------------------------
-- Table structure for tb_banner
-- ----------------------------
DROP TABLE IF EXISTS `tb_banner`;
CREATE TABLE `tb_banner`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '轮播图 id',
  `banner_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '轮播图 url',
  `status` tinyint NOT NULL COMMENT '轮播图状态：0-启用，1-禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_banner
-- ----------------------------
INSERT INTO `tb_banner` VALUES (1, 'http://localhost:9000/vibe-music-data/banners/c5174745-763c-482f-8ba2-2d5ed715cd12-banner_1743606119458.png', 0);
INSERT INTO `tb_banner` VALUES (2, 'http://localhost:9000/vibe-music-data/banners/a11b799d-07b1-4536-a44f-1aa022527cc4-banner_1743606509944.png', 0);
INSERT INTO `tb_banner` VALUES (3, 'http://localhost:9000/vibe-music-data/banners/49546c6e-f323-41f7-b378-a246d79bfdc0-banner_1743606538969.png', 0);
INSERT INTO `tb_banner` VALUES (4, 'http://localhost:9000/vibe-music-data/banners/c9e034da-da51-43a1-a2e8-cc61947d2caf-banner_1743606551324.png', 0);
INSERT INTO `tb_banner` VALUES (5, 'http://localhost:9000/vibe-music-data/banners/edf8a95e-243a-4489-8f21-d6645a07b3af-banner_1743606574495.png', 1);
INSERT INTO `tb_banner` VALUES (6, 'http://localhost:9000/vibe-music-data/banners/4d9c633b-9ccf-4b2a-9282-76d88dcfef75-banner_1743606587507.png', 0);
INSERT INTO `tb_banner` VALUES (7, 'http://localhost:9000/vibe-music-data/banners/5fcb6754-1851-41c8-b939-c1e3073cdcd5-banner_1743606598489.png', 1);
INSERT INTO `tb_banner` VALUES (8, 'http://localhost:9000/vibe-music-data/banners/db3de2a0-8339-4fe7-896e-3b78c2944091-banner_1743606615526.png', 1);
INSERT INTO `tb_banner` VALUES (9, 'http://localhost:9000/vibe-music-data/banners/f3a8c0d0-9e51-4a84-a59f-57a4a87ee7d1-banner_1743606626078.png', 1);
INSERT INTO `tb_banner` VALUES (10, 'http://localhost:9000/vibe-music-data/banners/a8cb5a2f-79ea-4e94-ad2a-697164056295-banner_1743606638688.png', 1);
INSERT INTO `tb_banner` VALUES (31, 'http://127.0.0.1:9000/vibe-music-data/banners/097d2bff-aa69-42e2-bdd2-f9ecc9720654-banner_1773029866311.png', 0);
INSERT INTO `tb_banner` VALUES (32, 'http://127.0.0.1:9000/vibe-music-data/banners/95dcd30a-5eb5-4c09-aa90-3b967ed3507f-banner_1773029890829.png', 0);
INSERT INTO `tb_banner` VALUES (33, 'http://127.0.0.1:9000/vibe-music-data/banners/973b8aad-98dc-4556-8aec-8177b6688f47-banner_1773030448606.png', 0);
INSERT INTO `tb_banner` VALUES (34, 'http://127.0.0.1:9000/vibe-music-data/banners/a1f40a6e-bb6f-4105-bae3-c3dd9021d3b5-banner_1773030458887.png', 0);
INSERT INTO `tb_banner` VALUES (35, 'http://127.0.0.1:9000/vibe-music-data/banners/c3f557af-d054-4712-8e3c-833b809d5075-banner_1773030481607.png', 0);
INSERT INTO `tb_banner` VALUES (36, 'http://127.0.0.1:9000/vibe-music-data/banners/4ef3cbf8-e406-493b-9222-bdc5bbbae8b6-banner_1776079052471.png', 1);

-- ----------------------------
-- Table structure for tb_comment
-- ----------------------------
DROP TABLE IF EXISTS `tb_comment`;
CREATE TABLE `tb_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论 id',
  `user_id` bigint NOT NULL COMMENT '用户 id',
  `song_id` bigint NULL DEFAULT NULL COMMENT '歌曲 id',
  `playlist_id` bigint NULL DEFAULT NULL COMMENT '歌单 id',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `create_time` datetime NOT NULL COMMENT '评论时间',
  `type` tinyint NOT NULL COMMENT '评论类型：0-歌曲评论，1-歌单评论',
  `like_count` bigint NULL DEFAULT NULL COMMENT '点赞数量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_comment_song_id`(`song_id` ASC) USING BTREE,
  INDEX `fk_comment_user_id`(`user_id` ASC) USING BTREE,
  INDEX `fk_comment_playlist_id`(`playlist_id` ASC) USING BTREE,
  CONSTRAINT `fk_comment_playlist_id` FOREIGN KEY (`playlist_id`) REFERENCES `tb_playlist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_song_id` FOREIGN KEY (`song_id`) REFERENCES `tb_song` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_user_id` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_comment
-- ----------------------------
INSERT INTO `tb_comment` VALUES (1, 3, 67, NULL, '好听。', '2026-04-16 09:56:09', 0, 0);

-- ----------------------------
-- Table structure for tb_feedback
-- ----------------------------
DROP TABLE IF EXISTS `tb_feedback`;
CREATE TABLE `tb_feedback`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '反馈 id',
  `user_id` bigint NOT NULL COMMENT '用户 id',
  `feedback` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '反馈内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_feedback_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_feedback_user_id` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_feedback
-- ----------------------------
INSERT INTO `tb_feedback` VALUES (9, 3, '好听啊，大家快来听听吧。', '2026-04-15 18:05:44');

-- ----------------------------
-- Table structure for tb_genre
-- ----------------------------
DROP TABLE IF EXISTS `tb_genre`;
CREATE TABLE `tb_genre`  (
  `song_id` bigint NOT NULL COMMENT '歌曲 id',
  `style_id` bigint NOT NULL COMMENT '风格 id',
  PRIMARY KEY (`song_id`, `style_id`) USING BTREE,
  INDEX `fk_genre_style_id`(`style_id` ASC) USING BTREE,
  CONSTRAINT `fk_genre_song_id` FOREIGN KEY (`song_id`) REFERENCES `tb_song` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_genre_style_id` FOREIGN KEY (`style_id`) REFERENCES `tb_style` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_genre
-- ----------------------------
INSERT INTO `tb_genre` VALUES (57, 2);
INSERT INTO `tb_genre` VALUES (65, 2);
INSERT INTO `tb_genre` VALUES (66, 2);
INSERT INTO `tb_genre` VALUES (67, 11);
INSERT INTO `tb_genre` VALUES (78, 11);
INSERT INTO `tb_genre` VALUES (79, 11);

-- ----------------------------
-- Table structure for tb_playlist
-- ----------------------------
DROP TABLE IF EXISTS `tb_playlist`;
CREATE TABLE `tb_playlist`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '歌单 id',
  `title` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '歌单标题',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '歌单封面',
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '歌单简介',
  `style` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '歌单风格',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_playlist
-- ----------------------------
INSERT INTO `tb_playlist` VALUES (1, '华语回响・人间旋律', 'http://127.0.0.1:9000/vibe-music-data/playlists/21737192-1eb3-4741-8dbf-ae799b441c6d-blob', '最动人的故事，都藏在华语歌里。收录华语流行经典与新歌，旋律温柔，歌词走心，情绪真挚。一首歌，一段时光，一份共鸣。\n', '华语流行');
INSERT INTO `tb_playlist` VALUES (2, '乡谣与自由', 'http://127.0.0.1:9000/vibe-music-data/playlists/f5a47ae0-1583-4c0f-a090-4da78bad0467-blob', '阳光、原野、公路、木吉他与温柔嗓音。乡村音乐里藏着最纯粹的自由与治愈，舒缓、温暖、真诚、治愈。闭上眼，仿佛置身美式乡村的落日晚风里。', '乡村');
INSERT INTO `tb_playlist` VALUES (3, '一曲国风，半生诗意', 'http://127.0.0.1:9000/vibe-music-data/playlists/3c5b1662-4324-428b-9a84-db223b267998-blob', '东方之韵，婉转悠扬。琴箫和鸣，词曲温柔。藏尽山河风月、人间烟火、千古情长。在国风旋律里，遇见最美中式浪漫。', '国风流行');
INSERT INTO `tb_playlist` VALUES (4, '把情绪藏进低音，把故事写进旋律', 'http://127.0.0.1:9000/vibe-music-data/playlists/2229d906-0030-43cf-954b-7b19a5bb2066-blob', '温柔又有力量，治愈且清醒。适合深夜、独行、发呆、自愈。一首说唱，一段人生。', '嘻哈说唱');
INSERT INTO `tb_playlist` VALUES (5, '霓虹旋律・日系回响', 'http://127.0.0.1:9000/vibe-music-data/playlists/3179bf42-4735-4f7b-96c1-35f97ab1c94c-blob', '穿梭在城市的霓虹与晚风之间，日系 JPOP 独有的细腻与温柔。每一首歌，都是一段情绪、一段故事，治愈日常，温柔时光。', '日本流行');
INSERT INTO `tb_playlist` VALUES (6, '旋律未眠・原声集', 'http://127.0.0.1:9000/vibe-music-data/playlists/ee854d6c-ad25-4890-a328-5484aec305ce-blob', '音乐响起，画面重现。这里收藏所有打动过你的影视、动漫、游戏原声。每一段旋律，都是一段故事、一帧回忆、一场情绪。闭上眼，重回那些被音乐治愈的瞬间。', '原声带');
INSERT INTO `tb_playlist` VALUES (7, '情字难写，歌里尽是', 'http://127.0.0.1:9000/vibe-music-data/playlists/010de019-b71e-459e-8fe5-e0f69be9b4c5-blob', '世间所有心事，都能在一首粤语歌里找到答案。慢品旋律，细味歌词，这是独属于我们的听觉浪漫。', '粤语流行');
INSERT INTO `tb_playlist` VALUES (8, '节奏至上・欧美流行', 'http://127.0.0.1:9000/vibe-music-data/playlists/78c9b820-fb9c-401f-8e54-37f7197c5b0c-blob', '慵懒、自由、治愈、上头。精选欧美流行优质作品，适合通勤、开车、熬夜、放松。每一首都是刻在 DNA 里的欧美旋律。', '欧美流行');
INSERT INTO `tb_playlist` VALUES (9, '星光与韩流情歌', 'http://127.0.0.1:9000/vibe-music-data/playlists/740dd1e3-7e99-4a00-8427-80a791d107f2-blob', '汇聚韩国最顶尖流行旋律。旋律一响，即刻坠入 K-Pop 世界。', '韩国流行');
INSERT INTO `tb_playlist` VALUES (10, '夜色节奏布鲁斯', 'http://127.0.0.1:9000/vibe-music-data/playlists/eb2cfd97-476b-486e-b135-9e9d282bec75-blob', 'Night vibe, smooth rhythm, deep soul.不赶时间，只享受旋律。这是耳朵与灵魂都上瘾的节奏布鲁斯。', '节奏布鲁斯');
INSERT INTO `tb_playlist` VALUES (11, '热带鼓点・非洲脉搏', 'http://127.0.0.1:9000/vibe-music-data/playlists/bb21e61f-574c-4f96-8514-89c2638a64c5-blob', '热带晚风、深邃贝斯、自由灵魂。不分国界的非洲节拍，慵懒、松弛、上头、治愈。戴上耳机，即刻坠入非洲律动世界。', '非洲节拍');
INSERT INTO `tb_playlist` VALUES (12, '无声诗・轻音乐集', 'http://127.0.0.1:9000/vibe-music-data/playlists/ff65c9f6-f50b-4fd7-8802-b2b03cd19460-blob', '以乐为语，以静为境。世间纷扰皆暂放，只留一段轻音，伴你独处时光。', '轻音乐');
INSERT INTO `tb_playlist` VALUES (13, '灵魂与失真吉他', 'http://127.0.0.1:9000/vibe-music-data/playlists/cb4e7a5d-dcbb-4f2e-9969-fab15ee9815b-blob', '不是只有嘶吼，还有温柔与孤独。旋律藏着叛逆，歌词写尽人生。在喧嚣世界里，做最清醒的自己。一曲摇滚，一场救赎。', '摇滚');

-- ----------------------------
-- Table structure for tb_playlist_binding
-- ----------------------------
DROP TABLE IF EXISTS `tb_playlist_binding`;
CREATE TABLE `tb_playlist_binding`  (
  `playlist_id` bigint NOT NULL COMMENT '歌单 id',
  `song_id` bigint NOT NULL COMMENT '歌曲 id',
  PRIMARY KEY (`playlist_id`, `song_id`) USING BTREE,
  INDEX `fk_playlist_binding_song_id`(`song_id` ASC) USING BTREE,
  CONSTRAINT `fk_playlist_binding_playlist_id` FOREIGN KEY (`playlist_id`) REFERENCES `tb_playlist` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_playlist_binding_song_id` FOREIGN KEY (`song_id`) REFERENCES `tb_song` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_playlist_binding
-- ----------------------------
INSERT INTO `tb_playlist_binding` VALUES (2, 45);
INSERT INTO `tb_playlist_binding` VALUES (13, 50);
INSERT INTO `tb_playlist_binding` VALUES (1, 51);
INSERT INTO `tb_playlist_binding` VALUES (3, 51);
INSERT INTO `tb_playlist_binding` VALUES (1, 52);
INSERT INTO `tb_playlist_binding` VALUES (3, 52);
INSERT INTO `tb_playlist_binding` VALUES (1, 53);
INSERT INTO `tb_playlist_binding` VALUES (1, 57);
INSERT INTO `tb_playlist_binding` VALUES (1, 58);

-- ----------------------------
-- Table structure for tb_song
-- ----------------------------
DROP TABLE IF EXISTS `tb_song`;
CREATE TABLE `tb_song`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '歌曲 id',
  `artist_id` bigint NOT NULL COMMENT '歌手 id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '歌名',
  `album` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '专辑',
  `lyric` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '歌词',
  `duration` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '歌曲时长',
  `style` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '歌曲风格',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '歌曲封面 url',
  `audio_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '歌曲 url',
  `release_time` date NOT NULL COMMENT '歌曲发行时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_song_artist_id`(`artist_id` ASC) USING BTREE,
  CONSTRAINT `fk_song_artist_id` FOREIGN KEY (`artist_id`) REFERENCES `tb_artist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 80 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_song
-- ----------------------------
INSERT INTO `tb_song` VALUES (1, 10, '晴天的周末在去学校补课的路上遇见了喜欢的人', '致青春的你', NULL, '211.35', '轻音乐', 'http://localhost:9000/vibe-music-data/songCovers/e34d43df-1b6b-4f77-b2cc-9983a9af7d27-blob', 'http://localhost:9000/vibe-music-data/songs/6dfcad85-7ca3-43c1-8584-d12fd9f63e50-AniFace - 晴天的周末在去学校补课的路上遇见了喜欢的人.mp3', '2017-05-08');
INSERT INTO `tb_song` VALUES (2, 4, 'A Woodland Night', 'Sunny Bay', NULL, '258.56', '轻音乐', 'http://localhost:9000/vibe-music-data/songCovers/af2c43f2-b393-4e13-bf36-88630a171f05-blob', 'http://localhost:9000/vibe-music-data/songs/1acae1a0-775a-4b55-a6ec-9f981fb7b1d6-Bandari - A Woodland Night.mp3', '2000-08-01');
INSERT INTO `tb_song` VALUES (3, 18, '光辉岁月', 'Beyond 怀旧经典金曲 Vol. 1', NULL, '297.56', '粤语流行,摇滚', 'http://localhost:9000/vibe-music-data/songCovers/634d65e4-2035-4f73-9075-3dfe484f20cb-blob', 'http://localhost:9000/vibe-music-data/songs/64ae48fd-7115-4eca-85d5-075a749d87db-Beyond - 光辉岁月.mp3', '2021-06-21');
INSERT INTO `tb_song` VALUES (4, 18, '再见理想', 'Beyond 怀旧经典金曲 Vol. 1', NULL, '293.46', '粤语流行,摇滚', 'http://localhost:9000/vibe-music-data/songCovers/634d65e4-2035-4f73-9075-3dfe484f20cb-blob', 'http://localhost:9000/vibe-music-data/songs/442a496d-45f4-48bd-9107-a92a52b9c680-Beyond - 再见理想.mp3', '2021-06-21');
INSERT INTO `tb_song` VALUES (5, 18, '喜欢你', 'Beyond 怀旧经典金曲 Vol. 2', NULL, '272.93', '粤语流行,摇滚', 'http://localhost:9000/vibe-music-data/songCovers/b08d2e0b-7a78-4847-b633-2bf334849f22-blob', 'http://localhost:9000/vibe-music-data/songs/f7980cae-9463-4667-b202-2898312a35f0-Beyond - 喜欢你.mp3', '2021-06-30');
INSERT INTO `tb_song` VALUES (6, 18, '真的爱你', 'Beyond 怀旧经典金曲 Vol. 2', NULL, '274.98', '粤语流行,摇滚', 'http://localhost:9000/vibe-music-data/songCovers/b08d2e0b-7a78-4847-b633-2bf334849f22-blob', 'http://localhost:9000/vibe-music-data/songs/067b13a2-a7c7-404e-b6e3-d5aac80910bf-Beyond - 真的爱你.mp3', '2021-06-30');
INSERT INTO `tb_song` VALUES (7, 37, 'The Lazy Song', 'Doo-Wops & Hooligans', NULL, '195.93', '欧美流行', 'http://localhost:9000/vibe-music-data/songCovers/07cdcfa8-643e-4eea-bb8b-52d1a9313d28-blob', 'http://localhost:9000/vibe-music-data/songs/1ff9a0e5-0bed-40ea-b05b-800b016866e4-Bruno Mars - The Lazy Song.mp3', '2010-05-11');
INSERT INTO `tb_song` VALUES (8, 21, 'I Won\'t Let You Down', 'Closer', NULL, '219.56', '欧美流行', 'http://localhost:9000/vibe-music-data/songCovers/b95de704-e06d-425d-987f-bfcee15f6506-blob', 'http://localhost:9000/vibe-music-data/songs/056c2faa-5939-40d4-a45a-07ddd115bf9f-Christopher,Bekuh Boom - I Won\'t Let You Down.mp3', '2016-04-15');
INSERT INTO `tb_song` VALUES (9, 31, '10,000 Hours', '10,000 Hours', NULL, '165.81', '欧美流行,乡村', 'http://localhost:9000/vibe-music-data/songCovers/c6ec2e01-e321-42ee-b0fa-1162aac2074c-blob', 'http://localhost:9000/vibe-music-data/songs/02419e06-4e94-4d90-beb2-7d415e65e10d-Dan + Shay,Justin Bieber - 10,000 Hours.mp3', '2019-10-04');
INSERT INTO `tb_song` VALUES (10, 15, 'Seaside Retreat', 'Seaside Retreat', NULL, '449.46', '轻音乐', 'http://localhost:9000/vibe-music-data/songCovers/18fcfcf1-379f-425d-870f-e165405444f5-blob', 'http://localhost:9000/vibe-music-data/songs/b30d40d1-b948-4c8b-b7fc-9713cd3ddf86-Dan Gibson - Seaside Retreat.mp3', '2013-11-21');
INSERT INTO `tb_song` VALUES (11, 5, '打上花火', '打上花火', NULL, '282.94', '日本流行,原声带', 'http://localhost:9000/vibe-music-data/songCovers/d4612954-4151-455e-8c36-55c27c66dabd-blob', 'http://localhost:9000/vibe-music-data/songs/76f858d5-bb71-454f-a58f-47ef32743ab5-Daoko,米津玄師 - 打上花火.mp3', '2017-08-16');
INSERT INTO `tb_song` VALUES (12, 7, '倒数', '另一个童话', '[00:00.00]倒数 - G.E.M. 邓紫棋\n[00:03.00]词：G.E.M. 邓紫棋\n[00:04.00]曲：G.E.M. 邓紫棋/Lupo Groinig\n[00:06.00]编曲：Lupo Groinig\n[00:07.00]监制：Lupo Groinig\n[00:08.00]OP：蜂鸟音乐\n[00:09.00]SP：百纳娱乐\n[00:12.00]还没到的樱花季\n[00:15.00]还没用的照相机\n[00:17.00]还没光临的餐厅\n[00:20.00]还在期待\n[00:21.00]有着你的旅行\n[00:23.00]等待日落的巴黎\n[00:26.00]铁塔之下牵着你\n[00:29.00]等待说着我愿意\n[00:32.00]等待未来\n[00:33.00]每天身边有你\n[00:35.00]一点一滴每一天珍惜\n[00:39.00]怕突然来不及\n[00:42.00]好好的爱你\n[00:44.00]时针一直倒数着\n[00:47.00]我们剩下的快乐\n[00:50.00]此刻相拥的狂热\n[00:53.00]却永远都深刻\n[00:56.00]心跳一直倒数着\n[00:59.00]生命剩下的温热\n[01:02.00]至少用力地爱着\n[01:05.00]还乌黑的头发\n[01:08.00]有你就不怕白了\n[01:10.00]漆黑过后是旭日\n[01:13.00]泪流以后是坚持\n[01:16.00]真的爱是日复日\n[01:19.00]从不放弃\n[01:20.00]重复说你愿意\n[01:22.00]还没退化的眼睛\n[01:25.00]抓紧时间看看你\n[01:28.00]爱是从来不止息\n[01:30.00]一个风景\n[01:31.00]每天新的生命\n[01:33.00]一点一滴每一天珍惜\n[01:37.00]用尽每一口气\n[01:40.00]好好的爱你\n[01:43.00]时针一直倒数着\n[01:46.00]我们剩下的快乐\n[01:49.00]此刻相拥的狂热\n[01:52.00]却永远都深刻\n[01:55.00]心跳一直倒数着\n[01:58.00]生命剩下的温热\n[02:01.00]至少用力地爱着\n[02:04.00]还乌黑的头发\n[02:06.00]有你就不怕白了\n[02:09.00]咖啡再不喝就酸了\n[02:12.00]晚餐再不吃就冷了\n[02:15.00]爱着为什么不说呢\n[02:17.00]难道错过了才来后悔着\n[02:21.00]谁梦未实现就醒了\n[02:24.00]谁心没开过就灰了\n[02:27.00]追逐爱的旅途曲折\n[02:29.00]就算再曲折为你都值得\n[02:32.00]一点一滴每一天珍惜\n[02:36.00]用尽每一口气\n[02:39.00]好好的爱你\n[02:41.00]时针一直倒数着\n[02:45.00]我们剩下的快乐\n[02:47.00]此刻相拥的狂热\n[02:50.00]却永远都深刻\n[02:53.00]心跳一直倒数着\n[02:56.00]生命剩下的温热\n[02:59.00]至少痛并快乐着\n[03:02.00]爱过才算活着\n[03:05.00]有你别无所求了\n[03:11.00]有你别无所求了\n[03:17.00]有你别无所求了\n[03:22.00]有你别无所求了\n[03:28.00]有你别无所求了\n[03:34.00]有你别无所求了', '229.6', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/cfbd3eac-3b4c-4af5-bc61-38ee52d72e89-blob', 'http://localhost:9000/vibe-music-data/songs/2bb762a1-1d14-4c18-bd70-357d650754ee-G.E.M.邓紫棋 - 倒数.mp3', '2018-08-16');
INSERT INTO `tb_song` VALUES (13, 7, '光年之外', '光年之外', NULL, '235.77', '华语流行,原声带', 'http://localhost:9000/vibe-music-data/songCovers/8f20dd0c-f102-4d19-8192-35f6600893a5-blob', 'http://localhost:9000/vibe-music-data/songs/22fe07c2-52f2-4581-aed0-2eb6856120fa-G.E.M.邓紫棋 - 光年之外.mp3', '2016-12-30');
INSERT INTO `tb_song` VALUES (14, 7, '句号', '摩天动物园', NULL, '235.98', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/ed7f43af-44a9-448e-be04-fd41da8b7986-blob', 'http://localhost:9000/vibe-music-data/songs/92fdb8b5-8161-4000-9d30-4bcd344c74f4-G.E.M.邓紫棋 - 句号.mp3', '2019-12-14');
INSERT INTO `tb_song` VALUES (15, 7, '喜欢你', '喜欢你', NULL, '238.04', '粤语流行', 'http://localhost:9000/vibe-music-data/songCovers/fa76d9f1-08c7-4e3f-a6a1-79a32971d391-blob', 'http://localhost:9000/vibe-music-data/songs/86953551-5cf8-431b-9f86-c149edcdb9b1-G.E.M.邓紫棋 - 喜欢你.mp3', '2014-08-15');
INSERT INTO `tb_song` VALUES (16, 7, '多远都要在一起', '新的心跳', NULL, '215.46', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/23232633-92dc-4831-9025-64dd9bc7382b-blob', 'http://localhost:9000/vibe-music-data/songs/dae6088c-2e3d-46ad-a2dc-6dd5db5cd774-G.E.M.邓紫棋 - 多远都要在一起.mp3', '2015-11-06');
INSERT INTO `tb_song` VALUES (17, 7, '天空没有极限', '启示录', NULL, '278.45', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/62199b04-4ba7-4149-82a3-bf1498a302f3-blob', 'http://localhost:9000/vibe-music-data/songs/090a7e16-4cd4-4d3a-b7c3-b9fa3f66e21d-G.E.M.邓紫棋 - 天空没有极限.mp3', '2022-09-23');
INSERT INTO `tb_song` VALUES (18, 7, '新的心跳', '新的心跳', NULL, '215.46', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/23232633-92dc-4831-9025-64dd9bc7382b-blob', 'http://localhost:9000/vibe-music-data/songs/35dbd04d-293b-44b8-b93c-efb8b23b2413-G.E.M.邓紫棋 - 新的心跳.mp3', '2015-11-06');
INSERT INTO `tb_song` VALUES (19, 7, '来自天堂的魔鬼', '新的心跳', NULL, '245.76', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/23232633-92dc-4831-9025-64dd9bc7382b-blob', 'http://localhost:9000/vibe-music-data/songs/bd1ce54c-857f-4790-bd9d-e4093c17e65b-G.E.M.邓紫棋 - 来自天堂的魔鬼.mp3', '2015-11-06');
INSERT INTO `tb_song` VALUES (20, 7, '泡沫', 'Xposed', NULL, '258.56', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/4a06bd1b-ccd5-4b84-b029-a457c83c7b4c-blob', 'http://localhost:9000/vibe-music-data/songs/626b8a80-642d-475c-81b0-9994d275adab-G.E.M.邓紫棋 - 泡沫.mp3', '2012-07-05');
INSERT INTO `tb_song` VALUES (21, 14, 'D小调托卡塔与赋格 作品565', 'Swinging Bach', NULL, '358.89', '古典', 'http://localhost:9000/vibe-music-data/songCovers/f48f6e07-bbd0-47dd-9883-cfb90502a9d5-blob', 'http://localhost:9000/vibe-music-data/songs/c37699f3-baa6-48d6-8493-55a78cbc327d-Gewandhausorchester Leipzig - D小调托卡塔与赋格 作品565.mp3', '2003-01-01');
INSERT INTO `tb_song` VALUES (22, 23, 'New Americana', 'BADLANDS (Deluxe Edition)', NULL, '182.61', '欧美流行', 'http://localhost:9000/vibe-music-data/songCovers/257bc6e0-a97e-4825-b798-b4d8976c3ecb-blob', 'http://localhost:9000/vibe-music-data/songs/566b4e94-8699-40c3-ac64-0ef2d843454b-Halsey - New Americana.mp3', '2015-08-28');
INSERT INTO `tb_song` VALUES (23, 23, 'Roman Holiday', 'BADLANDS (Deluxe Edition)', NULL, '201.08', '欧美流行', 'http://localhost:9000/vibe-music-data/songCovers/257bc6e0-a97e-4825-b798-b4d8976c3ecb-blob', 'http://localhost:9000/vibe-music-data/songs/00d618bd-0358-445d-872c-3fcc4a10dd3b-Halsey - Roman Holiday.mp3', '2015-08-28');
INSERT INTO `tb_song` VALUES (24, 23, 'Strange Love', 'BADLANDS (Deluxe Edition)', NULL, '246.24', '欧美流行', 'http://localhost:9000/vibe-music-data/songCovers/257bc6e0-a97e-4825-b798-b4d8976c3ecb-blob', 'http://localhost:9000/vibe-music-data/songs/01871da1-8976-43e6-a5b7-d79d382c0632-Halsey - Strange Love.mp3', '2015-08-28');
INSERT INTO `tb_song` VALUES (25, 23, 'Young God', 'BADLANDS (Deluxe Edition)', NULL, '180.56', '欧美流行', 'http://localhost:9000/vibe-music-data/songCovers/257bc6e0-a97e-4825-b798-b4d8976c3ecb-blob', 'http://localhost:9000/vibe-music-data/songs/874f21bf-162b-4a0b-89cc-34d12dd6dfc2-Halsey - Young God.mp3', '2015-08-28');
INSERT INTO `tb_song` VALUES (26, 25, 'Believer', 'Believer', NULL, '204.04', '摇滚', 'http://localhost:9000/vibe-music-data/songCovers/ae2b59b1-8e5e-4412-8676-467a5db74a76-blob', 'http://localhost:9000/vibe-music-data/songs/1acf0805-1542-4bb2-91ed-b785fa04b8c6-Imagine Dragons - Believer.mp3', '2017-06-23');
INSERT INTO `tb_song` VALUES (27, 25, 'Demons', 'Continued Silence', NULL, '175.88', '摇滚', 'http://localhost:9000/vibe-music-data/songCovers/80495089-236b-4a8b-8ffd-4f8d45568084-blob', 'http://localhost:9000/vibe-music-data/songs/fc6e23ae-9fd2-48c8-accd-1d9e1f579bb9-Imagine Dragons - Demons.mp3', '2012-03-06');
INSERT INTO `tb_song` VALUES (28, 25, 'It\'s Time', 'It\'s Time EP', NULL, '240.09', '摇滚', 'http://localhost:9000/vibe-music-data/songCovers/368dd4d5-c4e8-4161-b250-7355cb785bb0-blob', 'http://localhost:9000/vibe-music-data/songs/2f4b5252-2080-4a11-9f9e-e4b8d81d065e-Imagine Dragons - It\'s Time.mp3', '2011-03-12');
INSERT INTO `tb_song` VALUES (29, 6, 'Blueming', 'Love poem', NULL, '217.01', '韩国流行', 'http://localhost:9000/vibe-music-data/songCovers/9ffe18f1-d130-4fec-9179-582c6abfa71e-blob', 'http://localhost:9000/vibe-music-data/songs/d83d479f-9bb8-4ecd-ae3c-bab7564d9ec1-IU - Blueming.mp3', '2019-11-18');
INSERT INTO `tb_song` VALUES (30, 6, 'twenty three', 'Covers & Unreleased Songs', NULL, '209.99', '韩国流行', 'http://localhost:9000/vibe-music-data/songCovers/9f79d2a8-eb02-4dae-b4e3-eac7b7e9f8fb-blob', 'http://localhost:9000/vibe-music-data/songs/20f18edf-2323-49d6-a5c1-ffce3257b823-IU - twenty three.mp3', '2011-01-01');
INSERT INTO `tb_song` VALUES (31, 20, 'Only Human', 'Happiness Begins', NULL, '182.61', '欧美流行,电子', 'http://localhost:9000/vibe-music-data/songCovers/dd4bca5e-a684-4efa-9084-3f1a730324f7-blob', 'http://localhost:9000/vibe-music-data/songs/f3711491-5adc-4871-9819-6cd7d35ccde3-Jonas Brothers - Only Human.mp3', '2019-06-07');
INSERT INTO `tb_song` VALUES (33, 11, 'Young Dumb & Broke', 'American Teen', NULL, '199.03', '欧美流行,节奏布鲁斯', 'http://localhost:9000/vibe-music-data/songCovers/6e588608-cbc3-4b89-8568-9518ca71970f-blob', 'http://localhost:9000/vibe-music-data/songs/fff07baa-34c4-4485-97f1-3fa2e6029982-Khalid - Young Dumb & Broke.mp3', '2017-03-03');
INSERT INTO `tb_song` VALUES (39, 28, 'Big Big World', 'Relaxation - Fortune', NULL, '207.81', '轻音乐', 'http://localhost:9000/vibe-music-data/songCovers/c982f910-58b3-4d46-9634-2eca7311468d-blob', 'http://localhost:9000/vibe-music-data/songs/64c30047-8a11-4d99-b249-0010311daf57-Michael Cramtu,Bandari - Big Big World.mp3', '2004-02-28');
INSERT INTO `tb_song` VALUES (40, 22, 'Prelude (Motohiko Hirami & Yann)', 'Tree Sings, And Wind Surrounded Tree (2013 Version)', NULL, '90.86', '轻音乐', 'http://localhost:9000/vibe-music-data/songCovers/05ee6ea4-2e82-45da-b15c-89114b4f37da-blob', 'http://localhost:9000/vibe-music-data/songs/b81e0b52-1094-400e-a739-20a014c9e53d-Motohiko Hirami - Prelude (Motohiko Hirami & Yann).mp3', '2013-11-25');
INSERT INTO `tb_song` VALUES (41, 34, '倾心恋曲 恋与制作人', 'MrLi小哥个人演奏全收录', NULL, '110.77', '古典', 'http://localhost:9000/vibe-music-data/songCovers/1cade29e-08f4-4493-acea-504c3d6dce2c-blob', 'http://localhost:9000/vibe-music-data/songs/cefe0c1c-672f-460d-88dc-926ad9c945e2-MrLi小哥 - 倾心恋曲 恋与制作人.mp3', '2018-08-03');
INSERT INTO `tb_song` VALUES (42, 8, 'なんでもないや (没什么大不了 (Movie ver.)', '君の名は。 (《你的名字。》动画电影原声带)', NULL, '344.41', '日本流行,原声带', 'http://localhost:9000/vibe-music-data/songCovers/01d20804-d35b-4744-aea9-f10fb1a74174-blob', 'http://localhost:9000/vibe-music-data/songs/2b5f1542-f79c-4c7c-b7aa-a27f1f10b9f3-RADWIMPS - なんでもないや (movie ver.).mp3', '2016-08-24');
INSERT INTO `tb_song` VALUES (43, 29, '20090729', 'What\'s my name?', NULL, '235.98', '韩国流行', 'http://localhost:9000/vibe-music-data/songCovers/c68e6fec-0976-4603-8541-b8059772c99b-blob', 'http://localhost:9000/vibe-music-data/songs/b227212e-ab65-4af3-ad53-14e0c1664d6c-T-ara - 20090729.mp3', '2017-06-14');
INSERT INTO `tb_song` VALUES (44, 29, 'Reload', 'What\'s my name?', NULL, '180.56', '韩国流行', 'http://localhost:9000/vibe-music-data/songCovers/c68e6fec-0976-4603-8541-b8059772c99b-blob', 'http://localhost:9000/vibe-music-data/songs/3880343c-0bde-4df3-b586-4f373d48eb72-T-ara - Reload.mp3', '2017-06-14');
INSERT INTO `tb_song` VALUES (45, 36, 'How You Get The Girl', '1989 (Deluxe)', NULL, '246.24', '乡村', NULL, 'http://localhost:9000/vibe-music-data/songs/30694b82-ada5-4450-9851-29288077acbe-Taylor Swift - How You Get The Girl.mp3', '2014-10-27');
INSERT INTO `tb_song` VALUES (46, 26, '富士山下', 'What\'s Going On…?', NULL, '259.44', '粤语流行', 'http://localhost:9000/vibe-music-data/songCovers/824380a2-d641-455c-94c1-79fd81f90fdb-blob', 'http://localhost:9000/vibe-music-data/songs/590a57d7-8786-4de8-9e3f-2e5bc2305b25-陈奕迅 - 富士山下.mp3', '2006-11-23');
INSERT INTO `tb_song` VALUES (47, 26, '爱情转移', '认了吧', NULL, '260.62', '华语流行,原声带', 'http://localhost:9000/vibe-music-data/songCovers/00fe29c7-f0f9-44ce-98f9-87d761aaa1c3-blob', 'http://localhost:9000/vibe-music-data/songs/ebd1dce6-09eb-42a8-9f4b-ce4cf6120abb-陈奕迅 - 爱情转移.mp3', '2007-01-01');
INSERT INTO `tb_song` VALUES (48, 26, '白玫瑰', 'What\'s Going On…?', NULL, '240.09', '粤语流行', 'http://localhost:9000/vibe-music-data/songCovers/824380a2-d641-455c-94c1-79fd81f90fdb-blob', 'http://localhost:9000/vibe-music-data/songs/01726077-6b40-492f-8721-26509bc2483d-陈奕迅 - 白玫瑰.mp3', '2006-11-23');
INSERT INTO `tb_song` VALUES (49, 26, '红玫瑰', '认了吧', NULL, '240.25', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/00fe29c7-f0f9-44ce-98f9-87d761aaa1c3-blob', 'http://localhost:9000/vibe-music-data/songs/46d31335-36db-4660-9c47-5fc75c03c67d-陈奕迅 - 红玫瑰.mp3', '2007-01-01');
INSERT INTO `tb_song` VALUES (50, 42, 'Diamonds', 'Diamonds', NULL, NULL, '节奏布鲁斯,欧美流行', 'http://localhost:9000/vibe-music-data/songCovers/f21dcd37-df64-45f1-94e2-9cb7de94baa7-blob', 'http://localhost:9000/vibe-music-data/songs/b95c5d9a-6f3d-449d-bdce-2ee25da241b8-Rihanna - Diamonds.mp3', '2012-01-01');
INSERT INTO `tb_song` VALUES (51, 43, '青花瓷', '我很忙', '[00:00.00]青花瓷 - 周杰伦 (Jay Chou)\n[00:05.00]词：方文山\n[00:10.00]曲：周杰伦\n[00:16.00]编曲：钟兴民\n[00:21.00]素胚勾勒出青花笔锋浓转淡\n[00:26.00]瓶身描绘的牡丹一如你初妆\n[00:30.00]冉冉檀香透过窗心事我了然\n[00:35.00]宣纸上走笔至此搁一半\n[00:39.00]釉色渲染仕女图韵味被私藏\n[00:44.00]而你嫣然的一笑如含苞待放\n[00:48.00]你的美一缕飘散\n[00:50.00]去到我去不了的地方\n[00:57.00]天青色等烟雨 而我在等你\n[01:01.00]炊烟袅袅升起 隔江千万里\n[01:06.00]在瓶底书汉隶仿前朝的飘逸\n[01:10.00]就当我为遇见你伏笔\n[01:15.00]天青色等烟雨 而我在等你\n[01:19.00]月色被打捞起 晕开了结局\n[01:24.00]如传世的青花瓷自顾自美丽\n[01:27.00]你眼带笑意\n[01:50.00]色白花青的锦鲤跃然于碗底\n[01:55.00]临摹宋体落款时却惦记着你\n[01:59.00]你隐藏在窑烧里千年的秘密\n[02:04.00]极细腻犹如绣花针落地\n[02:08.00]帘外芭蕉惹骤雨门环惹铜绿\n[02:12.00]而我路过那江南小镇惹了你\n[02:17.00]在泼墨山水画里\n[02:19.00]你从墨色深处被隐去\n[02:26.00]天青色等烟雨 而我在等你\n[02:30.00]炊烟袅袅升起 隔江千万里\n[02:35.00]在瓶底书汉隶仿前朝的飘逸\n[02:39.00]就当我为遇见你伏笔\n[02:44.00]天青色等烟雨 而我在等你\n[02:48.00]月色被打捞起 晕开了结局\n[02:52.00]如传世的青花瓷自顾自美丽\n[02:56.00]你眼带笑意\n[03:01.00]天青色等烟雨 而我在等你\n[03:06.00]炊烟袅袅升起 隔江千万里\n[03:10.00]在瓶底书汉隶仿前朝的飘逸\n[03:15.00]就当我为遇见你伏笔\n[03:19.00]天青色等烟雨 而我在等你\n[03:24.00]月色被打捞起 晕开了结局\n[03:28.00]如传世的青花瓷自顾自美丽\n[03:32.00]你眼带笑意', '239.35', '国风流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/f11ea070-7c85-4f8c-b229-4e4d87a6465c-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/71f498e7-118c-4543-a3ba-77894da418a8-M500002qU5aY3Qu24y.mp3', '2007-11-02');
INSERT INTO `tb_song` VALUES (52, 43, '七里香', '叶惠美', '[00:00.00]七里香 - 周杰伦 (Jay Chou)\n[00:06.00]词：方文山\n[00:13.00]曲：周杰伦\n[00:20.00]编曲：钟兴民\n[00:27.00]窗外的麻雀在电线杆上多嘴\n[00:34.00]你说这一句很有夏天的感觉\n[00:41.00]手中的铅笔在纸上来来回回\n[00:47.00]我用几行字形容你是我的谁\n[00:54.00]秋刀鱼的滋味猫跟你都想了解\n[01:01.00]初恋的香味就这样被我们寻回\n[01:07.00]那温暖的阳光像刚摘的鲜艳草莓\n[01:14.00]你说你舍不得吃掉这一种感觉\n[01:20.00]雨下整夜我的爱溢出就像雨水\n[01:27.00]院子落叶跟我的思念厚厚一叠\n[01:34.00]几句是非也无法将我的热情冷却\n[01:41.00]你出现在我诗的每一页\n[01:47.00]雨下整夜我的爱溢出就像雨水\n[01:54.00]窗台蝴蝶像诗里纷飞的美丽章节\n[02:01.00]我接着写\n[02:03.00]把永远爱你写进诗的结尾\n[02:08.00]你是我唯一想要的了解\n[02:42.00]雨下整夜我的爱溢出就像雨水\n[02:48.00]院子落叶跟我的思念厚厚一叠\n[02:55.00]几句是非也无法将我的热情冷却\n[03:02.00]你出现在我诗的每一页\n[03:09.00]那饱满的稻穗幸福了这个季节\n[03:16.00]而你的脸颊像田里熟透的番茄\n[03:22.00]你突然对我说七里香的名字很美\n[03:29.00]我此刻却只想亲吻你倔强的嘴\n[03:35.00]雨下整夜我的爱溢出就像雨水\n[03:42.00]院子落叶跟我的思念厚厚一叠\n[03:49.00]几句是非也无法将我的热情冷却\n[03:56.00]你出现在我诗的每一页\n[04:03.00]整夜我的爱溢出就像雨水\n[04:09.00]窗台蝴蝶像诗里纷飞的美丽章节\n[04:16.00]我接着写\n[04:18.00]把永远爱你写进诗的结尾\n[04:24.00]你是我唯一想要的了解', '299.20', '华语流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/78022f89-0bdb-4d9b-a3a7-582969e49a37-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/f3410791-67fb-4b4a-a973-dcf2fe69771c-M500004Z8Ihr0JIu5s.mp3', '2010-03-02');
INSERT INTO `tb_song` VALUES (53, 43, '反方向的钟', '我很忙', '[00:00.00]反方向的钟 - 周杰伦 (Jay Chou)\n[00:00.00]词：方文山\n[00:00.00]曲：周杰伦\n[00:01.00]编曲：周杰伦\n[00:01.00]合声：周杰伦\n[00:01.00]合声编写：周杰伦\n[00:25.00]ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏ\n[00:30.00]ㄅㄆㄇㄈㄉ㊋ㄌㄍㄎㄏㄐ\n[00:35.00]ㄅㄆㄇㄈㄉ㊋ㄌㄍㄎㄏ\n[00:40.00]ㄅㄆㄇㄈㄉ㊋ㄌ\n[00:45.00]迷迷蒙蒙 你给的梦\n[00:47.00]出现裂缝 隐隐作痛\n[00:50.00]怎么沟通你都没空\n[00:52.00]说我不懂 说了没用\n[00:55.00]他的笑容 有何不同\n[00:57.00]在你心中 我不再受宠\n[01:00.00]我的天空 是雨是风 还是彩虹\n[01:04.00]你在操纵\n[01:06.00]恨自己真的没用情绪激动\n[01:11.00]一颗心到现在还在抽痛\n[01:16.00]还为分手前那句抱歉在感动\n[01:26.00]穿梭时间的画面的钟\n[01:31.00]从反方向 开始移动\n[01:36.00]回到当初爱你的时空\n[01:41.00]停格内容 不忠\n[01:46.00]所有回忆对着我进攻\n[01:51.00]我的伤口 被你拆封\n[01:56.00]誓言太沉重泪被纵容\n[02:01.00]脸上汹涌 失控\n[02:17.00]城市霓虹 不安跳动\n[02:18.00]染红夜空 过去种种\n[02:19.00]像一场梦 不敢去碰\n[02:21.00]一想就痛 心碎内容\n[02:22.00]每一秒钟 都有不同\n[02:23.00]你不懂 连一句珍重\n[02:25.00]也有苦衷 也不想送\n[02:26.00]寒风中 废墟烟囱\n[02:27.00]停止转动 一切落空\n[02:29.00]在人海中盲目跟从\n[02:30.00]别人的梦 全面放纵\n[02:31.00]恨没有用 疗伤止痛\n[02:33.00]不再感动 没有梦\n[02:34.00]痛不知轻重\n[02:35.00]泪水鲜红 全面放纵\n[02:48.00]恨自己真的没用情绪激动\n[02:52.00]一颗心到现在还在抽痛\n[02:57.00]还为分手前那句抱歉在感动\n[03:07.00]穿梭时间的画面的钟\n[03:12.00]从反方向 开始移动\n[03:17.00]回到当初爱你的时空\n[03:22.00]停格内容 不忠\n[03:27.00]所有回忆对着我进攻\n[03:32.00]我的伤口 被你拆封\n[03:38.00]誓言太沉重泪被纵容\n[03:43.00]脸上汹涌 失控\n[03:48.00]穿梭时间的画面的钟\n[03:53.00]从反方向 开始移动\n[03:58.00]回到当初爱你的时空\n[04:03.00]停格内容 不忠\n[04:08.00]所有回忆对着我进攻', '258.11', '华语流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/67ec349b-448f-447e-ba5d-46d828ca5f4b-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/8866a6e3-a47d-4ecb-9984-664893a200de-M5000017K7gL4WYnw2.mp3', '2011-03-07');
INSERT INTO `tb_song` VALUES (57, 43, '七月的极光', '太阳之子', '[00:00.00]七月的极光 - 周杰伦\n[00:05.00]   \n[00:05.00]词：方文山\n[00:08.00]   \n[00:08.00]曲：周杰伦\n[00:12.00]   \n[00:12.00]夕阳落在加油站的玻璃上\n[00:15.00]   \n[00:15.00]我们把冒险的地图都带上\n[00:18.00]   \n[00:18.00]引擎声跟勇气都朝向前方\n[00:21.00]   \n[00:21.00]那说好的永远一起去闯\n[00:24.00]   \n[00:24.00]风从车窗进来 幸福来得太快\n[00:27.00]   \n[00:27.00]没有任何阻碍 世界等我们精彩\n[00:31.00]   \n[00:31.00]你紧抱的侧脸 被晚霞都晕开\n[00:34.00]   \n[00:34.00]那一种美让时间不存在\n[00:37.00]   \n[00:37.00]喔此刻的速度 傍晚的风替 我们指路\n[00:40.00]   \n[00:40.00]喔愿望向夜空 闪烁着幸福 明亮清楚\n[00:43.00]   \n[00:43.00]喔极光洒满天 在我们面前 将爱描述\n[00:47.00]   \n[00:47.00]喔相互依赖着 共渡这一场 浪漫旅途\n[00:49.00]   \n[00:49.00]Aurora in July\n[00:52.00]七月的极光\n[00:52.00]在我怀里发呆\n[00:55.00]   \n[00:55.00]Aurora in July\n[00:59.00]七月的极光\n[00:59.00]我想你应该明白\n[01:02.00]   \n[01:02.00]Aurora in July\n[01:05.00]七月的极光\n[01:05.00]爱上你不意外\n[01:08.00]   \n[01:08.00]Aurora in July\n[01:11.00]七月的极光\n[01:11.00]像我对你的依赖\n[01:27.00]   \n[01:27.00]粉色的极光浪漫在夜空里\n[01:31.00]   \n[01:31.00]流星滑过天际我静静看你\n[01:34.00]   \n[01:34.00]所有的愿望我都留给你许\n[01:37.00]   \n[01:37.00]我知道我会在你愿望里\n[01:40.00]   \n[01:40.00]风从车窗进来 幸福来得太快\n[01:43.00]   \n[01:43.00]没有任何阻碍 世界等我们精彩\n[01:46.00]   \n[01:46.00]你紧抱的侧脸 被晚霞都晕开\n[01:50.00]   \n[01:50.00]那一种美让时间不存在\n[01:53.00]   \n[01:53.00]喔此刻的速度 傍晚的风替 我们指路\n[01:56.00]   \n[01:56.00]喔愿望向夜空 闪烁着幸福 明亮清楚\n[01:59.00]   \n[01:59.00]喔极光洒满天 在我们面前 将爱描述\n[02:02.00]   \n[02:02.00]喔相互依赖着 共渡这一场 浪漫旅途\n[02:05.00]   \n[02:05.00]Aurora in July\n[02:08.00]七月的极光\n[02:08.00]在我怀里发呆\n[02:11.00]   \n[02:11.00]Aurora in July\n[02:14.00]七月的极光\n[02:14.00]我想你应该明白\n[02:18.00]   \n[02:18.00]Aurora in July\n[02:21.00]七月的极光\n[02:21.00]爱上你不意外\n[02:24.00]   \n[02:24.00]Aurora in July\n[02:27.00]七月的极光\n[02:27.00]像我对你的依赖\n[02:32.00]   ', '193.36', '华语流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/7c24636c-599b-45ba-84bc-7fd430ef8e30-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/df579e8a-6611-471c-9867-03c8afc1828b-M5000035Dina4H1xaN.mp3', '2026-03-28');
INSERT INTO `tb_song` VALUES (58, 43, 'i do', '太阳之子', '[00:01.00]I Do - 周杰伦\n[00:06.00]词：方文山\n[00:11.00]曲：周杰伦\n[00:19.00]看着你 迎着风 坐在海边\n[00:23.00]那瞬间 像认识 你好多年\n[00:28.00]Baby 想象你在未来的画面\n[00:33.00]早遇见 我们一定提早相恋\n[00:37.00]我告白 红着脸 的那一天\n[00:42.00]多年后 变成了 相恋的纪念\n[00:46.00]在我的生命中 感谢有你的出现\n[00:51.00]你的无名指上有我承诺的永远\n[00:56.00]这一刻最美 的时光\n[01:01.00]是你穿婚纱 的模样\n[01:05.00]婚礼前将我 领带系上\n[01:10.00]穿上你挑的 白西装\n[01:15.00]这一刻最美 的时光\n[01:19.00]是你走在我 的身旁\n[01:24.00]红毯上誓言 浪漫绽放\n[01:29.00]在幸福停靠 的地方\n[01:35.00]爱的模样 我们遇上 最美的那时光\n[01:56.00]看着你 迎着风 坐在海边\n[02:00.00]那瞬间 像认识 你好多年\n[02:05.00]Baby 想象你在未来的画面\n[02:10.00]早遇见 我们一定提早相恋\n[02:14.00]我告白 红着脸 的那一天\n[02:19.00]多年后 变成了 相恋的纪念\n[02:23.00]在我的生命中 感谢有你的出现\n[02:28.00]你的无名指上有我承诺的永远\n[02:33.00]这一刻最美 的时光\n[02:38.00]是你穿婚纱 的模样\n[02:42.00]婚礼前将我 领带系上\n[02:47.00]穿上你挑的 白西装\n[02:51.00]这一刻最美 的时光\n[02:56.00]是你走在我 的身旁\n[03:01.00]红毯上誓言 浪漫绽放\n[03:05.00]在幸福停靠 的地方\n[03:12.00]爱的模样 我们遇上 最美的那时光', '216.33', '华语流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/dd41cec2-26b7-4012-a8e8-9bf3757e786d-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/e9dd692e-9156-43fb-b3b7-57d1622e00cc-M5000037XgDZ4ZbKI1.mp3', '2026-03-28');
INSERT INTO `tb_song` VALUES (59, 27, '你还要我怎样', '意外', NULL, '311.28', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/8b20f881-e7cb-4a7d-aa14-85d8df8e93f0-blob', 'http://localhost:9000/vibe-music-data/songs/572f00e3-9128-4cd3-94c2-86b62984245a-薛之谦 - 你还要我怎样.mp3', '2013-10-16');
INSERT INTO `tb_song` VALUES (60, 27, '像风一样', '像风一样', NULL, '255.39', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/49fc7926-835a-49a7-b283-ed6f18c4cc34-blob', 'http://localhost:9000/vibe-music-data/songs/65ed2dec-9ed3-444c-94bc-544290c37b45-薛之谦 - 像风一样.mp3', '2017-11-03');
INSERT INTO `tb_song` VALUES (61, 27, '刚刚好', '初学者', NULL, '250.76', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/ea8e2242-98b7-4adf-af79-c76c3dd08d0d-blob', 'http://localhost:9000/vibe-music-data/songs/9eadeb26-f007-4bdf-ba35-6767e62ecc8d-薛之谦 - 刚刚好.mp3', '2016-06-07');
INSERT INTO `tb_song` VALUES (62, 27, '天外来物', '天外来物', NULL, '688.01', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/d20c3540-86dc-43c9-a0e4-8677f9f2785a-blob', 'http://localhost:9000/vibe-music-data/songs/dd0b516b-2e0d-4e34-bdd7-81c856b5a798-薛之谦 - 天外来物.mp3', '2020-07-17');
INSERT INTO `tb_song` VALUES (63, 27, '演员', '绅士', NULL, '261.53', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/4eab89a1-9d5e-47cc-9fd6-aca673335313-blob', 'http://localhost:9000/vibe-music-data/songs/c88dd81b-f84b-451c-8a8b-a41fabec3c71-薛之谦 - 演员.mp3', '2015-06-05');
INSERT INTO `tb_song` VALUES (64, 30, '爱的就是你', '音乐进化论', NULL, '289.63', '华语流行,原声带', 'http://localhost:9000/vibe-music-data/songCovers/8311b82b-c1df-4530-a4c4-63967ec95c3e-blob', 'http://localhost:9000/vibe-music-data/songs/5d4b7e76-3b66-4a7a-8ce2-728005ea0f00-王力宏 - 爱的就是你.mp3', '2002-09-23');
INSERT INTO `tb_song` VALUES (65, 9, '恋人', '1', '[00:00.00]恋人 - 李荣浩\n[00:03.00]词 Lyricist：刘嘉星 Jiaxing Liu\n[00:06.00]曲 Composer：刘嘉星 Jiaxing Liu\n[00:07.00]编曲 Arrangement：李荣浩 Ronghao Li\n[00:09.00]制作人 Producer：李荣浩 Ronghao Li\n[00:11.00]吉他 Guitars：李荣浩 Ronghao Li\n[00:13.00]贝斯 BASS：李荣浩 Ronghao Li\n[00:13.00]弦乐 String：国际首席爱乐乐团 International Master Philharmonic Orchestra\n[00:15.00]和音 Backing Vocal：李荣浩 Ronghao Li\n[00:16.00]录音师 Recording Engineer：李荣浩 Ronghao Li\n[00:18.00]混音师 Mixing Engineer：李荣浩 Ronghao Li\n[00:19.00]音乐制作助理 Production Assistant：青格乐 Chingel\n[00:20.00]录音工作室 Recording Studio：北京一样音乐录音室 Beijing Young Music Studio\n[00:21.00]混音工作室 Mixing Studio：北京一样音乐录音室 Beijing Young Music Studio\n[00:23.00]母带后期制作人Mastering Producer：李荣浩 Ronghao Li\n[00:23.00]母带后期处理工程师 Mastering Engineer：周天澈 TC Z.\n[00:24.00]母带后期处理录音室 Mastering Studio：Studio 21A\n[00:25.00]爱像是一场小雨\n[00:31.00]淅沥沥淅沥沥\n[00:33.00]滴入我回忆\n[00:39.00]爱又像一场旅行\n[00:44.00]走停停走停停\n[00:46.00]忽然遇见你\n[00:50.00]停下了足迹\n[00:54.00]是否还是不太喜欢吃香菜\n[00:58.00]到现在都没改\n[01:01.00]那双原来最喜欢的匡威鞋带\n[01:05.00]现在却解不开\n[01:07.00]那张磁带一再一再\n[01:10.00]它又再一次的卡带\n[01:14.00]却还会再一遍一遍\n[01:17.00]一遍又一遍听下来\n[01:21.00]昨天的爱 已回不来\n[01:27.00]却依然在心里徘徊\n[01:31.00]却依然在心底徘徊\n[02:01.00]爱又像一场旅行\n[02:07.00]走停停走停停\n[02:09.00]忽然遇见你\n[02:12.00]停下了足迹\n[02:16.00]是否还是不太喜欢吃香菜\n[02:20.00]到现在都没改\n[02:23.00]那双原来最喜欢的匡威鞋带\n[02:27.00]现在却解不开\n[02:29.00]那张磁带一再一再\n[02:33.00]它又再一次的卡带\n[02:36.00]却还会再一遍一遍\n[02:40.00]一遍又一遍听下来\n[02:43.00]昨天的爱 已回不来\n[02:50.00]却依然在心里徘徊\n[02:53.00]却依然在心底徘徊\n[02:59.00]凶手和恋人都喜欢事后回现场\n[03:06.00]看一看自己从前到底有多疯狂\n[03:13.00]回忆里充满着罗曼蒂克的幻想\n[03:19.00]那张磁带里藏着过往\n[03:22.00]播放了就会回到现场\n[03:26.00]再一再它又再一次的卡带\n[03:31.00]却还会再一遍一遍\n[03:34.00]一遍又一遍听下来\n[03:38.00]昨天的爱 已回不来\n[03:45.00]却依然在心里徘徊\n[03:48.00]却依然在心底徘徊', '275.91', '华语流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/edbbab96-14c0-4534-8794-84932994dd27-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/65d33194-0f91-490c-9655-dd163b9ae24a-M500001HWlth1My6bT.mp3', '2026-04-07');
INSERT INTO `tb_song` VALUES (66, 19, 'Always Oline', '1', '[00:00.00]Always Online - 林俊杰 (JJ Lin)\n[00:03.00]词：林怡凤\n[00:06.00]曲：林俊杰\n[00:10.00]编曲：陈建玮/蔡政勋\n[00:13.00]制作人：林俊杰\n[00:17.00]变色的生活 任性的挑拨\n[00:21.00]疯狂的冒出了头\n[00:25.00]单方的守候 试探的温柔\n[00:29.00]还是少了点什么\n[00:32.00]遥远两端 爱挂在天空飞\n[00:37.00]风停了也无所谓 只因为你总说\n[00:43.00]Everything will be okay\n[00:48.00]准备好了three two one\n[00:50.00]I\'m always online\n[00:52.00]和你one to one 爱开始扩散\n[00:56.00]我们连结了 穿越\n[00:59.00]天空 银河 oh\n[01:04.00]开始倒数three two one\n[01:06.00]删除我的孤单\n[01:08.00]More and more尽是深刻\n[01:13.00]爱亮了 爱笑了\n[01:15.00]I\'m always online\n[01:21.00]变色的生活 任性的挑拨\n[01:25.00]疯狂的冒出了头\n[01:29.00]单方的守候 试探的温柔\n[01:32.00]却还是少了点什么\n[01:37.00]遥远两端 爱挂在天空飞\n[01:41.00]风停了也无所谓 只因为你总说\n[01:47.00]Everything will be okay\n[01:51.00]我准备好了three two one\n[01:54.00]I\'m always online\n[01:56.00]和你one to one 爱开始扩散\n[02:00.00]我们连结了 穿越\n[02:03.00]天空 银河 oh\n[02:08.00]开始倒数three two one\n[02:10.00]删除我的孤单\n[02:12.00]More and more尽是深刻\n[02:17.00]爱亮了 爱笑了\n[02:19.00]I\'m always online\n[02:42.00]准备好了three two one\n[02:44.00]I\'m always online\n[02:46.00]和你one to one 爱开始扩散\n[02:50.00]我们连结了 穿越\n[02:53.00]天空 银河\n[02:58.00]开始倒数three two one\n[03:00.00]删除我的孤单\n[03:02.00]More and more尽是深刻\n[03:07.00]爱亮了 爱笑了\n[03:09.00]I\'m always online\n[03:15.00]爱亮了 爱笑了\n[03:17.00]I\'m always online', '225.01', '华语流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/e189c004-48c9-42e5-8d02-a36a9d2ff482-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/0327a6fe-a356-4ad6-8b5e-8cd600ef1abe-M500000vGB6S4H8ze9.mp3', '2026-04-07');
INSERT INTO `tb_song` VALUES (67, 31, 'stay', 'stay', '[00:00.00]STAY (Clean) - The Kid LAROI/Justin Bieber\n[00:02.00]   \n[00:02.00]Lyrics by：Justin Bieber/Charlton Howard/Omer Fedi/Blake Slatkin/Charlie Puth/Magnus Høiberg\n[00:05.00]   \n[00:05.00]Composed by：Justin Bieber/Charlton Howard/Omer Fedi/Blake Slatkin/Charlie Puth/Magnus Høiberg\n[00:08.00]   \n[00:08.00]Justin Bieber：\n[00:10.00]   \n[00:10.00]Woah-oh woah-oh\n[00:11.00]   \n[00:11.00]The Kid LAROI：\n[00:11.00]   \n[00:11.00]I do the same thing I told you that I never would\n[00:14.00]我向你许诺永不会做的事 都背着你做了\n[00:14.00]I told you I\'d change even when I knew I never could\n[00:17.00]我答应你会改过自新 即使我心里清楚自己不会照做\n[00:17.00]I know that I can\'t find nobody else as good as you\n[00:19.00]我知道我再找不到像你这么好的爱人\n[00:19.00]I need you to stay need you to stay hey\n[00:22.00]我需要你留下 需要你留在我身边\n[00:22.00]Oh\n[00:23.00]   \n[00:23.00]I get drunk wake up I\'m wasted still\n[00:26.00]我喝得烂醉 睡了一觉 依然没有清醒\n[00:26.00]I realize the time that I wasted here\n[00:28.00]我意识到这样浑浑噩噩浪费了自己多少时间\n[00:28.00]I feel like you can\'t feel the way I feel\n[00:31.00]我感觉到你无法与我感同身受\n[00:31.00]Oh I\'ll be f**ked up if you can\'t be right here\n[00:34.00]如果你不在我身边 我会变得一团糟\n[00:34.00]Oh ooh-woah\n[00:35.00]   \n[00:35.00]Oh ooh-woah ooh-woah\n[00:37.00]   \n[00:37.00]Oh ooh-woah\n[00:38.00]   \n[00:38.00]Oh ooh-woah ooh-woah\n[00:40.00]   \n[00:40.00]Oh ooh-woah\n[00:41.00]   \n[00:41.00]Oh ooh-woah ooh-woah\n[00:42.00]   \n[00:42.00]Oh I\'ll be f**ked up if you can\'t be right here\n[00:45.00]如果你不在我身边 我会变得一团糟\n[00:45.00]I do the same thing I told you that I never would\n[00:48.00]我向你许诺永不会做的事 都背着你做了\n[00:48.00]I told you I\'d change even when I knew I never could\n[00:51.00]我答应你会改过自新 即使我心里清楚自己不会照做\n[00:51.00]I know that I can\'t find nobody else as good as you\n[00:53.00]我知道我再找不到像你这么好的爱人\n[00:53.00]I need you to stay need you to stay hey\n[00:56.00]我需要你留下 需要你留在我身边\n[00:56.00]I do the same thing I told you that I never would\n[00:59.00]我向你许诺永不会做的事 都背着你做了\n[00:59.00]I told you I\'d change even when I knew I never could\n[01:02.00]我答应你会改过自新 即使我心里清楚自己不会照做\n[01:02.00]I know that I can\'t find nobody else as good as you\n[01:05.00]我知道我再找不到像你这么好的爱人\n[01:05.00]I need you to stay need you to stay hey\n[01:07.00]我需要你留下 需要你留在我身边\n[01:07.00]Justin Bieber：\n[01:08.00]   \n[01:08.00]When I\'m away from you I miss your touch\n[01:10.00]分别之时 你的爱抚令我魂牵梦萦\n[01:10.00]Ooh\n[01:11.00]   \n[01:11.00]You\'re the reason I believe in love\n[01:13.00]你的存在让我对爱树立起信仰\n[01:13.00]Ooh\n[01:13.00]   \n[01:13.00]It\'s been difficult for me to trust\n[01:16.00]我很难鼓起勇气托付信任\n[01:16.00]Ooh\n[01:16.00]   \n[01:16.00]And I\'m afraid that I\'ma f**k it up\n[01:18.00]害怕自己会搞砸所有\n[01:18.00]Ooh\n[01:19.00]   \n[01:19.00]Ain\'t no way that I can leave you stranded\n[01:22.00]无论如何我都不能让你身陷桎梏\n[01:22.00]\'Cause you ain\'t ever left me empty-handed\n[01:25.00]因为你从不曾让我两手空空\n[01:25.00]And you know that I know that I can\'t live without you\n[01:28.00]你知道我心里清楚 离开你我难以独活\n[01:28.00]So baby stay\n[01:29.00]所以 宝贝 留下吧\n[01:29.00]The Kid LAROI/Justin Bieber：\n[01:30.00]   \n[01:30.00]Oh ooh-woah\n[01:32.00]   \n[01:32.00]Oh ooh-woah ooh-woah\n[01:33.00]   \n[01:33.00]Oh ooh-woah\n[01:34.00]   \n[01:34.00]Oh ooh-woah ooh-woah\n[01:36.00]   \n[01:36.00]Oh ooh-woah\n[01:37.00]   \n[01:37.00]Oh ooh-woah ooh-woah\n[01:39.00]   \n[01:39.00]I\'ll be f**ked up if you can\'t be right here\n[01:41.00]如果你不在我身边 我会变得一团糟\n[01:41.00]I do the same thing I told you that I never would\n[01:44.00]我向你许诺永不会做的事 都背着你做了\n[01:44.00]I told you I\'d change even when I knew I never could\n[01:47.00]我答应你会改过自新 即使我心里清楚自己不会照做\n[01:47.00]I know that I can\'t find nobody else as good as you\n[01:50.00]我知道我再找不到像你这么好的爱人\n[01:50.00]I need you to stay need you to stay hey\n[01:53.00]我需要你留下 需要你留在我身边\n[01:53.00]I do the same thing I told you that I never would\n[01:55.00]我向你许诺永不会做的事 都背着你做了\n[01:55.00]I told you I\'d change even when I knew I never could\n[01:58.00]我答应你会改过自新 即使我心里清楚自己不会照做\n[01:58.00]I know that I can\'t find nobody else as good as you\n[02:01.00]我知道我再找不到像你这么好的爱人\n[02:01.00]I need you to stay need you to stay hey\n[02:12.00]我需要你留下 需要你留在我身边\n[02:12.00]I need you to stay need you to stay hey\n[02:17.00]我需要你留下 需要你留在我身边', '141.87', '欧美流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/5fd8a6bb-44f7-4980-8a90-abd04b1f7240-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/2cde20f0-f0ac-4813-bb10-b46021df28cb-M500002o5Tzz2ua6XI.mp3', '2026-04-15');
INSERT INTO `tb_song` VALUES (68, 12, '他不懂', '爱，不解释', NULL, '231.35', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/0e1f0d37-b5da-4f1a-9c30-38dae6725cb0-blob', 'http://localhost:9000/vibe-music-data/songs/bd3881be-7854-41db-9d99-96e31a5119b9-张杰 - 他不懂.mp3', '2013-12-20');
INSERT INTO `tb_song` VALUES (69, 12, '这，就是爱', '这，就是爱', NULL, '293.46', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/db070323-cad6-47bb-8745-21bc53a83d69-blob', 'http://localhost:9000/vibe-music-data/songs/d67ccbbb-8dda-42b1-b935-5aca8f3ec673-张杰 - 这，就是爱.mp3', '2010-11-22');
INSERT INTO `tb_song` VALUES (70, 41, '会好的', '会好的', NULL, '210.86', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/8ed65622-8aa3-4fa0-b838-0f273a058628-blob', 'http://localhost:9000/vibe-music-data/songs/f82906ee-d7cc-4128-b38f-17527a632e63-张艺兴 - 会好的.mp3', '2020-02-20');
INSERT INTO `tb_song` VALUES (71, 41, '我不好', '我不好', NULL, '232.09', '华语流行,节奏布鲁斯', 'http://localhost:9000/vibe-music-data/songCovers/85b8c1ab-8610-4d7d-ab95-730a9ff35e56-blob', 'http://localhost:9000/vibe-music-data/songs/393d7223-7e77-42a6-a116-75a21b983456-张艺兴 - 我不好.mp3', '2019-09-09');
INSERT INTO `tb_song` VALUES (72, 41, '晚安', '晚安', NULL, '258.75', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/16909ec0-6c48-4e65-bfeb-ea5e387977de-blob', 'http://localhost:9000/vibe-music-data/songs/950bab08-4477-4394-8c53-13769fb1ec49-张艺兴 - 晚安.mp3', '2019-11-15');
INSERT INTO `tb_song` VALUES (73, 40, '再见', '再见', NULL, '182.61', '华语流行', 'http://localhost:9000/vibe-music-data/songCovers/073124e3-0bdc-487f-94e5-68ae9df27816-blob', 'http://localhost:9000/vibe-music-data/songs/263fa503-27d8-4b16-882c-3f7396973434-张震岳 - 再见.mp3', '2005-07-01');
INSERT INTO `tb_song` VALUES (74, 40, '迷途羔羊', '天兵', NULL, '270.88', '嘻哈说唱', 'http://localhost:9000/vibe-music-data/songCovers/764499ac-7ae7-4935-9201-3cb81d286c0d-blob', 'http://localhost:9000/vibe-music-data/songs/6c8dca3e-f630-4e85-aaee-2fac1ea0be14-张震岳 - 迷途羔羊.mp3', '2016-01-28');
INSERT INTO `tb_song` VALUES (75, 39, '殇', '武侠音乐系列之黯然消魂', NULL, '170.69', '轻音乐,国风,原声带', 'http://localhost:9000/vibe-music-data/songCovers/7c48334c-3446-4a55-8c53-8b9f2d076b07-blob', 'http://localhost:9000/vibe-music-data/songs/1180f7f7-51ed-48e5-9093-ace9f4efece9-徐嘉良 - 殇.mp3', '2013-03-08');
INSERT INTO `tb_song` VALUES (76, 38, '再飞行', '再飞行', NULL, '90.31', '华语流行,原声带', 'http://localhost:9000/vibe-music-data/songCovers/453da2c6-4e96-485e-a246-9c2366b8930c-blob', 'http://localhost:9000/vibe-music-data/songs/88602b4d-a70e-454c-9512-a5c9d03b1076-逃跑计划 - 再飞行.mp3', '2014-01-01');
INSERT INTO `tb_song` VALUES (77, 38, '夜空中最亮的星', '世界', NULL, '252.51', '摇滚', 'http://localhost:9000/vibe-music-data/songCovers/2beedf34-d75f-432c-a188-825bfc262a84-blob', 'http://localhost:9000/vibe-music-data/songs/6ff45591-b976-4998-86f8-7db17920cb04-逃跑计划 - 夜空中最亮的星.mp3', '2012-01-01');
INSERT INTO `tb_song` VALUES (78, 37, '24K Magic', '1', '[00:00.00]24K Magic - Bruno Mars (布鲁诺·马尔斯)\n[00:00.00]   \n[00:00.00]Lyrics by：Bruno Mars/Philip Lawrence/Christopher Brody Brown\n[00:00.00]   \n[00:00.00]Composed by：Bruno Mars/Philip Lawrence/Christopher Brody Brown\n[00:00.00]   \n[00:00.00]Tonight\n[00:05.00]今夜\n[00:05.00]I just want to take you higher\n[00:09.00]我要带你飞得更高\n[00:09.00]Throw your hands up in the sky\n[00:13.00]将你的手甩向空中\n[00:13.00]Let\'s set this party off right\n[00:22.00]就让我们开始狂欢派对吧\n[00:22.00]Players\n[00:23.00]玩咖们\n[00:23.00]Put yo\' pinky rings up to the moon\n[00:28.00]将你的戒指甩向月球\n[00:28.00]Girls\n[00:29.00]女孩们\n[00:29.00]What y\'all trying to do\n[00:32.00]你们想做什么\n[00:32.00]24 karat magic in the air\n[00:38.00]24K纯正魔法即将上演\n[00:38.00]Head to toe so player\n[00:40.00]从头到脚 激情引燃\n[00:40.00]Uh look out\n[00:43.00]小心\n[00:43.00]Pop pop it\'s show time\n[00:44.00]砰 砰表演时间 火力全开\n[00:44.00]Show time\n[00:45.00]表演时间\n[00:45.00]Show time\n[00:45.00]表演时间\n[00:45.00]Show time\n[00:46.00]表演时间\n[00:46.00]Guess who\'s back again\n[00:48.00]猜猜是谁重返舞台\n[00:48.00]Oh they don\'t know\n[00:48.00]他们还不知道？\n[00:48.00]Go on tell \'em\n[00:49.00]那就去告诉他们吧\n[00:49.00]Oh they don\'t know\n[00:49.00]他们还不知道？\n[00:49.00]Go on tell \'em\n[00:50.00]那就去告诉他们吧\n[00:50.00]I bet they know soon as we walk in\n[00:52.00]相信我现身的那一刻他们就会明白\n[00:52.00]Showing up\n[00:52.00]瞧瞧我的厉害\n[00:52.00]Wearing Cuban links\n[00:53.00]戴着古巴大金链\n[00:53.00]Ya\n[00:54.00]   \n[00:54.00]Designer minks\n[00:54.00]穿着贵气大貂皮\n[00:54.00]Ya\n[00:55.00]   \n[00:55.00]Inglewood\'s finest shoes\n[00:56.00]脚踩最潮的鞋儿\n[00:56.00]Whoop whoop\n[00:57.00]   \n[00:57.00]Don\'t look too hard\n[00:58.00]可别盯得太使劲儿\n[00:58.00]Might hurt ya\'self\n[00:59.00]怕闪瞎你的眼睛\n[00:59.00]Known to give the color red the blues\n[01:01.00]你知道会让自己挂彩\n[01:01.00]Ooh sh*t\n[01:04.00]噢糟了\n[01:04.00]I\'m a dangerous man with some money in my pocket\n[01:06.00]我可是个超有钱的危险男人\n[01:06.00]Keep up\n[01:08.00]嗨起来\n[01:08.00]So many pretty girls around me and they waking up the rocket\n[01:10.00]那么多的漂亮美眉围在我身边 她们唤醒了我的小宇宙\n[01:10.00]Keep up\n[01:13.00]嗨起来\n[01:13.00]Why you mad\n[01:13.00]为何你还是一脸不爽\n[01:13.00]Fix ya face\n[01:14.00]化一下妆吧\n[01:14.00]Ain\'t my fault y\'all be jocking\n[01:15.00]这不是我的错 你们一定都喜欢这样\n[01:15.00]Keep up\n[01:16.00]嗨起来\n[01:16.00]Players only\n[01:17.00]只有玩咖\n[01:17.00]Come on\n[01:17.00]来吧\n[01:17.00]Put your pinky rings up to the moon\n[01:22.00]将你的戒指甩向月球\n[01:22.00]Girls\n[01:23.00]女孩们\n[01:23.00]What y\'all trying to do\n[01:26.00]你们想做什么\n[01:26.00]24 karat magic in the air\n[01:32.00]24K纯正魔法即将上演\n[01:32.00]Head to toe so player\n[01:34.00]从头到脚 激情引燃\n[01:34.00]Uh look out\n[01:36.00]小心\n[01:36.00]Second verse for the hustlas gangstas\n[01:40.00]这一节献给那些撩妹好手 痞子们\n[01:40.00]Bad b**ches and ya ugly a** friends\n[01:41.00]性感辣妹和你们这些丑男朋友\n[01:41.00]Ha ha\n[01:42.00]   \n[01:42.00]Can I preach\n[01:42.00]我能开始说唱吗\n[01:42.00]Uh oh\n[01:43.00]   \n[01:43.00]Can I preach\n[01:43.00]我能开始说唱吗\n[01:43.00]Uh oh\n[01:44.00]   \n[01:44.00]I gotta show \'em how a pimp get it in\n[01:46.00]我会让你们看看骚气的我如何耍帅\n[01:46.00]First\n[01:46.00]首先\n[01:46.00]Take your sip\n[01:47.00]先来一口酒\n[01:47.00]Sip\n[01:47.00]喝口酒\n[01:47.00]Do your dip\n[01:48.00]躁起来\n[01:48.00]Dip\n[01:49.00]躁起来\n[01:49.00]Spend your money like money ain\'t sh*t\n[01:51.00]尽情挥霍吧 不用担心钞票\n[01:51.00]Ooh ooh\n[01:51.00]   \n[01:51.00]We too fresh\n[01:52.00]我们耀眼夺目\n[01:52.00]Got to blame it on Jesus\n[01:54.00]只怪上帝把我们生得太好\n[01:54.00]Hashtag blessed\n[01:55.00]那些头版头条最好祈祷\n[01:55.00]They ain\'t ready for me\n[01:55.00]别遇上了我\n[01:55.00]Uh\n[01:57.00]   \n[01:57.00]I\'m a dangerous man with some money in my pocket\n[02:00.00]我可是个超有钱的危险男人\n[02:00.00]Keep up\n[02:01.00]嗨起来\n[02:01.00]So many pretty girls around me and they waking up the rocket\n[02:04.00]那么多的漂亮美眉围在我身边 她们唤醒了我的小宇宙\n[02:04.00]Keep up\n[02:06.00]嗨起来\n[02:06.00]Why you mad fix ya face\n[02:07.00]为何你还是一脸不爽 化一下妆吧\n[02:07.00]Ain\'t my fault y\'all be jocking\n[02:09.00]这不是我的错 你们一定都喜欢这样\n[02:09.00]Keep up\n[02:10.00]嗨起来\n[02:10.00]Players only\n[02:10.00]只有玩咖\n[02:10.00]Come on\n[02:11.00]来吧\n[02:11.00]Put your pinky rings up to the moon\n[02:15.00]将你的戒指甩向月球\n[02:15.00]Hey girls\n[02:17.00]女孩们\n[02:17.00]What y\'all trying to do\n[02:18.00]你们想做什么\n[02:18.00]What y\'all trying to do\n[02:20.00]你们想做什么\n[02:20.00]24 karat magic in the air\n[02:26.00]24K纯正魔法即将上演\n[02:26.00]Head to toe so player\n[02:28.00]从头到脚 激情引燃\n[02:28.00]Uh look out\n[02:31.00]小心\n[02:31.00]Woooh\n[02:32.00]   \n[02:32.00]Everywhere I go they be like\n[02:34.00]无论我去哪里 他们像是\n[02:34.00]Ooh so player\n[02:36.00]大玩家\n[02:36.00]Woooh\n[02:37.00]   \n[02:37.00]Everywhere I go they be like\n[02:38.00]无论我去哪里 他们像是\n[02:38.00]Ooh so player\n[02:40.00]大玩家\n[02:40.00]Wooh\n[02:41.00]   \n[02:41.00]Everywhere I go they be like\n[02:43.00]无论我去哪里 他们像是\n[02:43.00]Ooh so player ooh\n[02:45.00]大玩家\n[02:45.00]Now now now now\n[02:47.00]此刻 此刻\n[02:47.00]Watch me break it down like\n[02:49.00]就看我嗨翻现场\n[02:49.00]Uh\n[02:50.00]   \n[02:50.00]24 karat 24 karat magic\n[02:53.00]24K纯正魔法\n[02:53.00]What\'s that sound\n[02:54.00]什么声音\n[02:54.00]24 karat 24 karat magic\n[02:58.00]24K纯正魔法\n[02:58.00]Come on now\n[02:59.00]一起来吧\n[02:59.00]24 karat 24 karat magic\n[03:03.00]24K纯正魔法\n[03:03.00]Don\'t fight the feeling\n[03:04.00]无法抗拒这声音\n[03:04.00]Invite the feeling\n[03:05.00]就加入吧\n[03:05.00]Just put your pinky rings up to the moon\n[03:10.00]将你的戒指甩向月球\n[03:10.00]Girls what y\'all trying to do\n[03:12.00]女孩们 你们想做什么\n[03:12.00]Honey what y\'all trying to do\n[03:14.00]亲爱的 你们想做什么\n[03:14.00]24 karat magic in the air\n[03:20.00]24K纯正魔法即将上演\n[03:20.00]Head to toe so player\n[03:22.00]从头到脚 激情引燃\n[03:22.00]Hands up\n[03:23.00]甩起手\n[03:23.00]Put your pinky rings up to the moon\n[03:28.00]将你的戒指甩向月球\n[03:28.00]Girls\n[03:28.00]女孩们\n[03:28.00]What y\'all tryin\' to do\n[03:32.00]你们想做什么\n[03:32.00]24 karat magic in the air\n[03:37.00]24K纯正魔法即将上演\n[03:37.00]Head to toe so player\n[03:40.00]从头到脚 激情引燃\n[03:40.00]Look out\n[03:41.00]小心\n[03:41.00]24 karat magic\n[03:42.00]24K纯正魔法\n[03:42.00]Magic\n[03:43.00]魔法\n[03:43.00]Magic\n[03:44.00]魔法\n[03:44.00]Magic\n[03:44.00]魔法\n[03:44.00]Magic\n[03:45.00]魔法\n[03:45.00]Magic\n[03:50.00]魔法', '225.98', '欧美流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/ced2608c-04be-43fc-8b67-81540cb76fc9-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/289bfbd1-320e-44d7-819f-30dffa50c605-M500001TypgH4PbmYw.mp3', '2026-04-07');
INSERT INTO `tb_song` VALUES (79, 37, 'Thats what i talk', '1', '[00:00.00]That\'s What I Like - Bruno Mars\n[00:00.00]   \n[00:00.00]Lyrics by：Bruno Mars/Christopher Brody Brown/James Fauntleroy/Jeremy Reeves/Jonathan Yip/Philip Lawrence/Ray Charles McCullough II/Ray Romulus\n[00:00.00]   \n[00:00.00]Produced by：Shampoo Press & Curl/The Stereotypes\n[00:00.00]   \n[00:00.00]Hey hey hey\n[00:03.00]   \n[00:03.00]I got a condo in Manhattan\n[00:05.00]哥在曼哈顿有栋豪宅\n[00:05.00]Baby girl what\'s happenin\'\n[00:07.00]宝贝 你要来吗\n[00:07.00]You and your a*s invited\n[00:09.00]这里永远欢迎你们这些身材火辣的美女\n[00:09.00]So go on and get to clappin\'\n[00:10.00]所以来吧 鼓掌欢呼 释放激情\n[00:10.00]So pop it for a player\n[00:12.00]看是谁帅得这么骚气\n[00:12.00]Pop pop it for me\n[00:14.00]是我无疑\n[00:14.00]Turn around and drop it for a player\n[00:16.00]快转过身来鼓掌欢迎\n[00:16.00]Drop drop it for me\n[00:17.00]释放 为我激情释放\n[00:17.00]I\'ll rent a beach house in Miami\n[00:19.00]我租下迈阿密的沙滩豪宅\n[00:19.00]Ami\n[00:20.00]迈阿密\n[00:20.00]Wake up with no jammies\n[00:21.00]一夜激情过后 早晨醒来 一丝不挂\n[00:21.00]Nope\n[00:21.00]没有\n[00:21.00]Lobster tail for dinner\n[00:23.00]晚餐享受美味的龙虾\n[00:23.00]Julio serve that scampi\n[00:24.00]这都得感谢胡里奥\n[00:24.00]Julio\n[00:25.00]胡里奥\n[00:25.00]You got it if you want it\n[00:26.00]如果你想要 你就可以拥有这一切\n[00:26.00]Got got it if you want it\n[00:28.00]如果你想要 你就可以拥有这一切\n[00:28.00]Said you got it if you want it\n[00:30.00]没错 如果你想要 你就可以拥有这一切\n[00:30.00]Take my wallet if you want it now\n[00:32.00]只要你想 我的钱任你挥霍\n[00:32.00]Jump in the Cadillac girl let\'s put some miles on it\n[00:36.00]开着凯迪拉克 女孩 让我们飞速行驶\n[00:36.00]Anything you want just to put a smile on it\n[00:39.00]只要你微微一笑 你要什么都随你\n[00:39.00]You deserve it baby you deserve it all\n[00:43.00]你值得拥有 宝贝 你值得拥有这一切\n[00:43.00]And I\'m gonna give it to you\n[00:45.00]我会给你想要的一切\n[00:45.00]Gold jewelry shining so bright\n[00:49.00]黄金珠宝 闪耀夺目\n[00:49.00]Strawberry champagne on ice\n[00:52.00]草莓香槟 冰爽可口\n[00:52.00]Lucky for you that\'s what I like that\'s what I like\n[00:56.00]你真走运 哥就喜欢这样 哥就喜欢你\n[00:56.00]Lucky for you that\'s what I like that\'s what I like\n[00:59.00]你真走运 哥就喜欢这样 哥就喜欢你\n[00:59.00]S*x by the fire at night\n[01:03.00]点燃爱火 纵情缠绵\n[01:03.00]Silk sheets and diamonds all white\n[01:06.00]丝滑的床单 钻石铺满 雪白浪漫\n[01:06.00]Lucky for you that\'s what I like that\'s what I like\n[01:10.00]你真走运 哥就喜欢这样 哥就喜欢你\n[01:10.00]Lucky for you that\'s what I like that\'s what I like\n[01:15.00]你真走运 哥就喜欢这样 哥就喜欢你\n[01:15.00]I\'m talkin\' trips to Puerto Rico\n[01:16.00]我正在说前往波多黎各的甜蜜之旅\n[01:16.00]Bih\n[01:17.00]碧池\n[01:17.00]Say the word and we go\n[01:18.00]让我们来个说走就说的旅行\n[01:18.00]Say it\n[01:19.00]说吧\n[01:19.00]You can be my fleeka\n[01:20.00]你就是我创作的源泉\n[01:20.00]Brrrt\n[01:20.00]   \n[01:20.00]Girl I\'ll be a fleeko\n[01:22.00]女孩 我可是魅力难挡的大帅哥\n[01:22.00]Mamacita\n[01:23.00]美女\n[01:23.00]I will never make a promise that I can\'t keep\n[01:26.00]无法兑现的诺言 我从不轻易说出口\n[01:26.00]I promise that your smile ain\'t gon\' never leave\n[01:29.00]我保证 只要能看到你的微笑我绝不离弃\n[01:29.00]Shopping sprees in Paris\n[01:31.00]在巴黎购物大狂欢\n[01:31.00]Everything 24 karats\n[01:33.00]放心一切都是24k纯金般的正品\n[01:33.00]Take a look in that mirror\n[01:35.00]站在镜子前\n[01:35.00]Now tell me who\'s the fairest\n[01:36.00]现在告诉我 谁更正 谁更美\n[01:36.00]Is it you\n[01:37.00]是你\n[01:37.00]Is it you\n[01:38.00]是你\n[01:38.00]Is it me\n[01:39.00]还是我\n[01:39.00]Is it me\n[01:40.00]还是我\n[01:40.00]Say it\'s us\n[01:41.00]你说我们都是最有魅力的人\n[01:41.00]Say it\'s us\n[01:41.00]你说我们都是最有魅力的人\n[01:41.00]And I\'ll agree baby\n[01:44.00]我完全同意 宝贝\n[01:44.00]Jump in the Cadillac girl let\'s put some miles on it\n[01:48.00]开着凯迪拉克 女孩 让我们飞速行驶\n[01:48.00]Anything you want just to put a smile on it\n[01:51.00]只要你微微一笑 你要什么都随你\n[01:51.00]You deserve it baby you deserve it all\n[01:54.00]你值得拥有 宝贝 你值得拥有这一切\n[01:54.00]And I\'m gonna give it to you\n[01:57.00]我会给你想要的一切\n[01:57.00]Gold jewellery shining so bright\n[02:00.00]黄金珠宝 你光芒四射\n[02:00.00]Strawberry champagne on ice\n[02:04.00]草莓香槟 冰爽可口\n[02:04.00]Lucky for you that\'s what I like that\'s what I like\n[02:07.00]你真走运 哥就喜欢这样 哥就喜欢你\n[02:07.00]Lucky for you that\'s what I like that\'s what I like\n[02:11.00]你真走运 哥就喜欢这样 哥就喜欢你\n[02:11.00]S*x by the fire at night\n[02:15.00]点燃爱火 纵情缠绵\n[02:15.00]Silk sheets and diamonds all white\n[02:18.00]丝滑的床单 钻石铺满 雪白浪漫\n[02:18.00]Lucky for you that\'s what I like that\'s what I like\n[02:22.00]你真走运 哥就喜欢这样 哥就喜欢你\n[02:22.00]Lucky for you that\'s what I like that\'s what I like\n[02:26.00]你真走运 哥就喜欢这样 哥就喜欢你\n[02:26.00]If you say you want a good time\n[02:30.00]如果你说你想要寻欢作乐\n[02:30.00]Well here I am baby here I am baby\n[02:34.00]来找我吧 我就在这里 宝贝 我就在这里 宝贝\n[02:34.00]Talk to me talk to me talk to me\n[02:37.00]告诉我 告诉我 快点告诉我吧\n[02:37.00]Tell me what\'s on your mind\n[02:40.00]告诉我你在想什么\n[02:40.00]What\'s on your mind\n[02:41.00]你在想什么\n[02:41.00]If you want it girl come and get it\n[02:45.00]如果你想要 女孩 来吧 你就会拥有\n[02:45.00]All this is here for you\n[02:49.00]这里的一切都是为你准备的\n[02:49.00]Tell me baby tell me tell me baby\n[02:52.00]告诉我 宝贝 告诉我 告诉我吧 宝贝\n[02:52.00]What you tryna do\n[02:54.00]你究竟想做什么\n[02:54.00]Gold jewellery shining so bright\n[02:58.00]黄金珠宝 你光芒四射\n[02:58.00]Strawberry champagne on ice\n[03:01.00]草莓香槟 冰爽可口\n[03:01.00]Lucky for you that\'s what I like that\'s what I like\n[03:05.00]你真走运 哥就喜欢这样 哥就喜欢你\n[03:05.00]Lucky for you that\'s what I like that\'s what I like\n[03:08.00]你真走运 哥就喜欢这样 哥就喜欢你\n[03:08.00]S*x by the fire at night\n[03:12.00]点燃爱火 纵情缠绵\n[03:12.00]Silk sheets and diamonds all white\n[03:15.00]丝滑的床单 钻石铺满 雪白浪漫\n[03:15.00]Lucky for you that\'s what I like that\'s what I like\n[03:19.00]你真走运 哥就喜欢这样 哥就喜欢你\n[03:19.00]Lucky for you that\'s what I like that\'s what I like\n[03:24.00]你真走运 哥就喜欢这样 哥就喜欢你', '206.69', '欧美流行', 'http://127.0.0.1:9000/vibe-music-data/songCovers/8b8aa3bf-9728-41c4-9bc4-67afdc3a6983-blob', 'http://127.0.0.1:9000/vibe-music-data/songs/5d0895bd-1281-4245-bf8e-e8dbb5266274-M500004IwdnW3Ae6Jz.mp3', '2026-04-15');

-- ----------------------------
-- Table structure for tb_style
-- ----------------------------
DROP TABLE IF EXISTS `tb_style`;
CREATE TABLE `tb_style`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '风格 id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '风格名称',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_style
-- ----------------------------
INSERT INTO `tb_style` VALUES (1, '乡村');
INSERT INTO `tb_style` VALUES (2, '华语流行');
INSERT INTO `tb_style` VALUES (3, '原声带');
INSERT INTO `tb_style` VALUES (4, '古典');
INSERT INTO `tb_style` VALUES (5, '嘻哈说唱');
INSERT INTO `tb_style` VALUES (6, '国风');
INSERT INTO `tb_style` VALUES (7, '国风流行');
INSERT INTO `tb_style` VALUES (8, '摇滚');
INSERT INTO `tb_style` VALUES (9, '日本流行');
INSERT INTO `tb_style` VALUES (10, '朋克');
INSERT INTO `tb_style` VALUES (11, '欧美流行');
INSERT INTO `tb_style` VALUES (12, '电子');
INSERT INTO `tb_style` VALUES (13, '粤语流行');
INSERT INTO `tb_style` VALUES (14, '节奏布鲁斯');
INSERT INTO `tb_style` VALUES (15, '轻音乐');
INSERT INTO `tb_style` VALUES (16, '非洲节拍');
INSERT INTO `tb_style` VALUES (17, '韩国流行');

-- ----------------------------
-- Table structure for tb_user
-- ----------------------------
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户 id',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户密码',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户手机号',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户邮箱',
  `user_avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户头像',
  `introduction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户简介',
  `create_time` datetime NOT NULL COMMENT '用户创建时间',
  `update_time` datetime NOT NULL COMMENT '用户修改时间',
  `status` tinyint NOT NULL COMMENT '用户状态：0-启用，1-禁用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_user
-- ----------------------------
INSERT INTO `tb_user` VALUES (3, 'mjf_1', 'e41951335dd09b45182a141fe62b4941', NULL, '3438166896@qq.com', NULL, NULL, '2026-04-15 18:05:00', '2026-04-15 18:05:00', 0);

-- ----------------------------
-- Table structure for tb_user_favorite
-- ----------------------------
DROP TABLE IF EXISTS `tb_user_favorite`;
CREATE TABLE `tb_user_favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint NOT NULL COMMENT '用户 id',
  `type` tinyint NOT NULL COMMENT '收藏类型：0-歌曲，1-歌单',
  `song_id` bigint NULL DEFAULT NULL COMMENT '收藏歌曲 id',
  `playlist_id` bigint NULL DEFAULT NULL COMMENT '收藏歌单 id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_favorite_user_id`(`user_id` ASC) USING BTREE,
  INDEX `fk_user_favorite_song_id`(`song_id` ASC) USING BTREE,
  INDEX `fk_user_favorite_playlist_id`(`playlist_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_favorite_playlist_id` FOREIGN KEY (`playlist_id`) REFERENCES `tb_playlist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_favorite_song_id` FOREIGN KEY (`song_id`) REFERENCES `tb_song` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_favorite_user_id` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_user_favorite
-- ----------------------------
INSERT INTO `tb_user_favorite` VALUES (8, 3, 0, 12, NULL, '2026-04-15 18:06:07');
INSERT INTO `tb_user_favorite` VALUES (9, 3, 1, NULL, 1, '2026-04-15 18:07:42');
INSERT INTO `tb_user_favorite` VALUES (10, 3, 1, NULL, 2, '2026-04-15 18:07:45');
INSERT INTO `tb_user_favorite` VALUES (11, 3, 1, NULL, 3, '2026-04-15 18:07:48');
INSERT INTO `tb_user_favorite` VALUES (12, 3, 0, 58, NULL, '2026-04-15 18:23:39');
INSERT INTO `tb_user_favorite` VALUES (13, 3, 0, 65, NULL, '2026-04-15 19:30:03');

SET FOREIGN_KEY_CHECKS = 1;
