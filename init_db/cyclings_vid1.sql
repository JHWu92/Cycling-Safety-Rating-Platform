SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cyclings_vid1`
--
CREATE DATABASE IF NOT EXISTS `cyclings_vid1` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `cyclings_vid1`;

-- --------------------------------------------------------

--
-- Table structure for table `loginLog`
--

DROP TABLE IF EXISTS `loginLog`;
CREATE TABLE IF NOT EXISTS `loginLog` (
  `lid` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `UTCts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `timezone` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `userAgent` text COLLATE utf8_unicode_ci NOT NULL,
  `isMobile` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `isTablet` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `isAndroid` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `isIOS` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`lid`),
  KEY `lid` (`lid`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Rating`
--

DROP TABLE IF EXISTS `Rating`;
CREATE TABLE IF NOT EXISTS `Rating` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `vid` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `comment` text COLLATE utf8_unicode_ci NOT NULL,
  `tags` text COLLATE utf8_unicode_ci NOT NULL,
  `familiar` varchar(11) COLLATE utf8_unicode_ci DEFAULT NULL,
  `UTCts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `timezone` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `watched` varchar(1) COLLATE utf8_unicode_ci NOT NULL,
  `interaction` text COLLATE utf8_unicode_ci NOT NULL,
  `lid` int(11) NOT NULL,
  PRIMARY KEY (`rid`),
  KEY `rid` (`rid`),
  KEY `uid` (`uid`),
  KEY `email` (`email`),
  KEY `vid` (`vid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `Rating`
--
DROP TRIGGER IF EXISTS `dec_SegScore`;
DELIMITER $$
CREATE TRIGGER `dec_SegScore` AFTER DELETE ON `Rating` FOR EACH ROW UPDATE 
    RoadSegment s,
    VideoRoadSeg vs
  SET 
    sumCnt = sumCnt - 1, 
    sumRatio = sumRatio - vs.ratio,
    sumScore = sumScore - OLD.score * vs.ratio
  where s.sid=vs.sid and vs.vid=OLD.vid
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `inc_SegScore`;
DELIMITER $$
CREATE TRIGGER `inc_SegScore` AFTER INSERT ON `Rating` FOR EACH ROW UPDATE 
    RoadSegment s,
    VideoRoadSeg vs
  SET 
    sumCnt = sumCnt + 1, 
    sumRatio = sumRatio + vs.ratio,
    sumScore = sumScore + NEW.score * vs.ratio
  where s.sid=vs.sid and vs.vid=NEW.vid
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `RoadSegment`
--

DROP TABLE IF EXISTS `RoadSegment`;
CREATE TABLE IF NOT EXISTS `RoadSegment` (
  `sid` int(11) NOT NULL AUTO_INCREMENT,
  `segmentid` int(11) NOT NULL,
  `index_seg` int(11) NOT NULL,
  `sumScore` float NOT NULL,
  `sumRatio` float NOT NULL,
  `sumCnt` int(11) NOT NULL,
  `geometry` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`sid`),
  KEY `sid` (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
CREATE TABLE IF NOT EXISTS `Users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `experienceLevel` text COLLATE utf8_unicode_ci,
  `has_survey` tinyint(1) DEFAULT NULL,
  `bk_purpose` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `ethnicity` int(11) DEFAULT NULL,
  `edu` int(11) DEFAULT NULL,
  `marital` int(11) DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `driver` int(11) DEFAULT NULL,
  `car` int(11) DEFAULT NULL,
  `household_income` int(11) DEFAULT NULL,
  `residence` int(11) DEFAULT NULL,
  `bk_type` int(11) DEFAULT NULL,
  `bk_type_other` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `user_id` (`user_id`),
  KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Video`
--

DROP TABLE IF EXISTS `Video`;
CREATE TABLE IF NOT EXISTS `Video` (
  `vid` int(11) NOT NULL AUTO_INCREMENT,
  `clip_name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `title` text COLLATE utf8_unicode_ci NOT NULL,
  `URL` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`vid`),
  UNIQUE KEY `clip_name` (`clip_name`),
  UNIQUE KEY `URL` (`URL`),
  KEY `vid` (`vid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `video2seg_temp`
--

DROP TABLE IF EXISTS `video2seg_temp`;
CREATE TABLE IF NOT EXISTS `video2seg_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clip_name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `index_seg` int(11) NOT NULL,
  `ratio` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `VideoRoadSeg`
--

DROP TABLE IF EXISTS `VideoRoadSeg`;
CREATE TABLE IF NOT EXISTS `VideoRoadSeg` (
  `vrsid` int(11) NOT NULL AUTO_INCREMENT,
  `vid` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `clip_name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `index_seg` int(11) NOT NULL,
  `ratio` float NOT NULL,
  PRIMARY KEY (`vrsid`),
  KEY `vrsid` (`vrsid`),
  KEY `vid` (`vid`),
  KEY `sid` (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
