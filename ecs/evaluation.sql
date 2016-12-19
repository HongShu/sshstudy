-- MySQL dump 10.13  Distrib 5.7.16, for osx10.11 (x86_64)
--
-- Host: localhost    Database: evaluation
-- ------------------------------------------------------
-- Server version	5.7.16

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
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course` (
  `Course_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Class_name` varchar(45) NOT NULL,
  `Course_name` varchar(45) NOT NULL,
  `Teacher_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES (18,'电商1501','推广基础','罗改龙'),(19,'电商1501','商务英语','李倩'),(20,'电商1501','电子商务平台装修','张亚伟'),(21,'电商1501','摄影与修图','谭志鹏'),(22,'电商1501','免费搜索流量','李倩'),(23,'电商1501','付费推广','刘朋娇'),(24,'电商1501','大学英语','杨玲华'),(25,'电商1502','推广基础','罗改龙'),(26,'电商1502','商务英语','李倩'),(27,'电商1502','电子商务平台装修','张亚伟'),(28,'电商1502','摄影与修图','谭志鹏'),(29,'电商1502','免费搜索流量','李倩'),(30,'电商1502','付费推广','刘朋娇'),(31,'电商1502','大学英语','韩旭'),(32,'网络1501','Jquery','刘朋娇'),(33,'网络1501','消费者心理学','江丽'),(34,'网络1501','网络推广','罗改龙'),(35,'网络1501','PHP','田文浪'),(36,'网络1501','大学英语','杨玲华'),(37,'安卓1501','JAVA数据结构','朱丹丹'),(38,'安卓1501','XML','刘明'),(39,'安卓1501','android应用开发','刘明'),(40,'安卓1501','数据库高级','周哲韫'),(41,'安卓1501','javaweb项目实战','刘明'),(42,'安卓1501','大学英语','杨玲华'),(43,'安卓1502','JAVA数据结构','朱丹丹'),(44,'安卓1502','XML','刘明'),(45,'安卓1502','android应用开发','刘明'),(46,'安卓1502','数据库高级','周哲韫'),(47,'安卓1502','javaweb项目实战','刘明'),(48,'安卓1502','大学英语','赵伟'),(49,'楼宇1501','网络组建与管理','张国亮'),(50,'楼宇1501','安装工程预算','王振'),(51,'楼宇1501','CAD电气设计','王浩然'),(52,'楼宇1501','大学英语','杨玲华'),(53,'楼宇1501','数字安防系统','张志璇'),(54,'楼宇1501','Linux','胡钊勇'),(55,'楼宇1502','网络组建与管理','张国亮'),(56,'楼宇1502','安装工程预算','王振'),(57,'楼宇1502','CAD电气设计','王浩然'),(58,'楼宇1502','大学英语','刘明军'),(59,'楼宇1502','数字安防系统','张志璇'),(60,'楼宇1502','Linux','胡钊勇'),(61,'楼宇1503','网络组建与管理','蔡振刚'),(62,'楼宇1503','安装工程预算','王振'),(63,'楼宇1503','CAD电气设计','王浩然'),(64,'楼宇1503','大学英语','郭琼'),(65,'楼宇1503','数字安防系统','张志璇'),(66,'楼宇1503','Linux','胡钊勇'),(67,'楼宇1504','网络组建与管理','蔡振刚'),(68,'楼宇1504','安装工程预算','王振'),(69,'楼宇1504','CAD电气设计','王浩然'),(70,'楼宇1504','大学英语','郭琼'),(71,'楼宇1504','数字安防系统','张志璇'),(72,'楼宇1504','Linux','胡钊勇'),(73,'电商1601','平面基础','代会芬'),(74,'电商1601','计算机组装','罗鹏'),(75,'电商1601','计算机基础','张波'),(76,'电商1601','大学英语','陈文'),(77,'电商1601','思想道德修养','孙思'),(78,'电商1601','电子商务平台开店','代会芬'),(79,'电商1601','客服基础','江丽'),(80,'电商1601','大学体育','肖祎'),(81,'电商1602','平面基础','代会芬'),(82,'电商1602','计算机组装','罗鹏'),(83,'电商1602','计算机基础','张波'),(84,'电商1602','大学英语','陈文'),(85,'电商1602','思想道德修养','孙思'),(86,'电商1602','电子商务平台开店','代会芬'),(87,'电商1602','客服基础','江丽'),(88,'电商1602','大学体育','肖祎'),(89,'楼宇1601','计算机组装','罗鹏'),(90,'楼宇1601','计算机基础','张波'),(91,'楼宇1601','思想道德修养','孙思'),(92,'楼宇1601','大学英语','杨秀华'),(93,'楼宇1601','电工技术','张波'),(94,'楼宇1601','建筑识图','胡淑娟'),(95,'楼宇1601','大学体育','肖祎'),(96,'网络1601','计算机基础','郭萍'),(97,'网络1601','计算机组装','罗鹏'),(98,'网络1601','思想道德修养','刘香君'),(99,'网络1601','网络营销','刘朋娇'),(100,'网络1601','界面设计','彭军波'),(101,'网络1601','大学体育','肖祎'),(102,'网络1601','大学英语','陈文'),(103,'软件1601','HTML','胡雯'),(104,'软件1601','计算机基础','胡雯'),(105,'软件1601','Java编程基础','王娟'),(106,'软件1601','大学英语','杨秀华'),(107,'软件1601','大学体育','肖祎'),(108,'软件1601','思想道德修养','许少华'),(109,'安卓1601','PS','张亚伟'),(110,'安卓1601','计算机基础','张国亮'),(111,'安卓1601','大学英语','韩旭'),(112,'安卓1601','JAVA','史幸幸'),(113,'安卓1601','网页设计','史幸幸'),(114,'安卓1601','思修','刘香君'),(115,'安卓1601','大学体育','肖祎'),(116,'安卓1602','PS','张亚伟'),(117,'安卓1602','计算机基础','周哲韫'),(118,'安卓1602','大学英语','周朋英'),(119,'安卓1602','JAVA','史幸幸'),(120,'安卓1602','网页设计','史幸幸'),(121,'安卓1602','思修','许少华'),(122,'安卓1602','大学体育','肖祎'),(123,'安卓1603','PS','张亚伟'),(124,'安卓1603','计算机基础','周哲韫'),(125,'安卓1603','大学英语','刘明军'),(126,'安卓1603','JAVA','史幸幸'),(127,'安卓1603','网页设计','史幸幸'),(128,'安卓1603','思修','许少华'),(129,'安卓1603','大学体育','肖祎');
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluation`
--

DROP TABLE IF EXISTS `evaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `evaluation` (
  `EVA_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `FK_COURSE_ID` int(10) unsigned NOT NULL COMMENT '外键关联到course的id',
  `SCORE` int(11) DEFAULT NULL COMMENT '0 不合格 1 合格 2 优秀',
  PRIMARY KEY (`EVA_ID`),
  KEY `FK_COURSE_ID` (`FK_COURSE_ID`),
  CONSTRAINT `evaluation_ibfk_1` FOREIGN KEY (`FK_COURSE_ID`) REFERENCES `course` (`Course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluation`
--

LOCK TABLES `evaluation` WRITE;
/*!40000 ALTER TABLE `evaluation` DISABLE KEYS */;
INSERT INTO `evaluation` VALUES (22,25,2),(23,26,2),(24,27,0),(25,28,2),(26,29,2),(27,30,2),(28,31,2),(29,18,2),(30,18,2),(31,18,2),(32,18,2),(33,18,2),(34,18,2),(35,18,2),(36,18,2),(37,18,2),(38,18,2),(39,18,2),(40,18,2);
/*!40000 ALTER TABLE `evaluation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-07  8:39:59
