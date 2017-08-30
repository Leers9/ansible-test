-- MySQL dump 10.13  Distrib 5.1.73, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: tcmsq
-- ------------------------------------------------------
-- Server version	5.5.42-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `yjy_user_login`
--

DROP TABLE IF EXISTS `yjy_user_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yjy_user_login` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id及用户id',
  `mobile` char(15) NOT NULL DEFAULT '' COMMENT '手机号',
  `mobile_desc` varchar(32) NOT NULL DEFAULT '' COMMENT '加密',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '昵称唯一',
  `password` char(32) NOT NULL DEFAULT '' COMMENT '密码',
  `password_salt` int(4) unsigned NOT NULL DEFAULT '0' COMMENT '随机获取对密码二次加密',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱 将来可以作为第二个登陆验证',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '用户状态 0:禁止登录 1:允许登录',
  `ctime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登陆时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `mobile` (`mobile`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COMMENT='用户登录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yjy_user_login`
--
-- WHERE:  1=1 limit 100

LOCK TABLES `yjy_user_login` WRITE;
/*!40000 ALTER TABLE `yjy_user_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `yjy_user_login` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-06-20 16:13:57
