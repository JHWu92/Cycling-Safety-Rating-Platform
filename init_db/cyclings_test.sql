-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: dbcyclesafety.c3pqizrexqbl.us-east-2.rds.amazonaws.com
-- Generation Time: Sep 11, 2018 at 12:39 AM
-- Server version: 5.7.16-log
-- PHP Version: 7.0.30-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cyclings_test`
--
CREATE DATABASE IF NOT EXISTS `cyclings_test` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `cyclings_test`;

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
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `loginLog`
--

INSERT INTO `loginLog` (`lid`, `user_id`, `UTCts`, `timezone`, `userAgent`, `isMobile`, `isTablet`, `isAndroid`, `isIOS`) VALUES
(1, 1, '2017-03-26 20:16:28', 'GMT -4', 'agent1', '', '', '', ''),
(2, 2, '2017-03-26 20:16:28', 'GMT -4', 'agent2', '', '', '', ''),
(3, 3, '2017-03-26 20:16:28', 'GMT -4', 'agent3', '', '', '', ''),
(4, 3, '2017-03-27 20:16:28', 'GMT -4', 'agent4', '', '', '', '');

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
  `tags` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `familiar` varchar(11) COLLATE utf8_unicode_ci NOT NULL,
  `UTCts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `timezone` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `watched` varchar(1) COLLATE utf8_unicode_ci NOT NULL,
  `interaction` text COLLATE utf8_unicode_ci NOT NULL,
  `lid` int(11) NOT NULL,
  PRIMARY KEY (`rid`),
  KEY `rid` (`rid`),
  KEY `uid` (`uid`),
  KEY `vid` (`vid`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `Rating`
--

INSERT INTO `Rating` (`rid`, `uid`, `email`, `vid`, `score`, `comment`, `tags`, `familiar`, `UTCts`, `timezone`, `watched`, `interaction`, `lid`) VALUES
(1, 1, '', 1, 5, '', '', '', '2017-03-27 20:13:36', 'GMT -4', '1', 'started,2017-04-17T18:08:22.623Z,256.395875;end,2017-04-17T18:08:40.000Z,260.223;', 1),
(2, 1, '', 2, 4, '', '', '', '2017-03-27 20:13:36', 'GMT -4', '1', 'started,2017-04-17T18:09:22.623Z,6.395875;end,2017-04-17T18:09:40.000Z,20.223;', 1),
(3, 1, '', 4, 5, '', '', '', '2017-03-27 20:13:36', 'GMT -4', '1', '', 2),
(4, 1, '', 5, 4, '', '', '', '2017-03-27 20:13:36', 'GMT -4', '1', '', 2),
(5, 1, '', 3, 3, '', '', '', '2017-03-27 20:13:36', 'GMT -4', '1', '', 2),
(6, 2, '', 4, 1, '', '', '', '2017-03-27 20:13:36', 'GMT -4', '1', '', 2),
(7, 2, '', 3, 2, '', '', '', '2017-03-27 20:13:36', 'GMT -4', '1', '', 2),
(8, 2, '', 2, 3, '', '', '', '2017-03-27 20:13:36', 'GMT -4', '1', '', 2),
(9, 2, '', 6, 5, '', '', '', '2017-03-27 20:13:36', 'GMT -4', '1', '', 2);

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
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `RoadSegment`
--

INSERT INTO `RoadSegment` (`sid`, `segmentid`, `index_seg`, `sumScore`, `sumRatio`, `sumCnt`, `geometry`) VALUES
(1, 1, 1, 2.5, 0.5, 1, 'LINESTRING (-77.01364744974134 38.95628407404581, -77.01364954534746 38.95638271430447, -77.01364989424467 38.95639721757051, -77.01365014578222 38.95650576713359, -77.01365027756435 38.95659143571616)'),
(2, 2, 2, 7.3, 2.2, 4, 'LINESTRING (-77.01357027112063 38.95449738339135, -77.01357467072947 38.95457899779149, -77.01358937341928 38.95484473998947, -77.01361730045228 38.9554869361089, -77.01361787949676 38.95549837654004, -77.01362123887805 38.95556954145447)'),
(3, 3, 3, 5.8, 1.4, 3, 'LINESTRING (-77.01362123887805 38.95556954145447, -77.01362436659224 38.95563584193096, -77.01364116244076 38.95598545077841, -77.0136450046077 38.95616759746044, -77.01364744974134 38.95628407404581)'),
(4, 4, 4, 9.4, 2.4, 4, 'LINESTRING (-77.01324339541158 38.95121574594209, -77.01341299691173 38.95130072642582, -77.01341369022012 38.95130667180713, -77.01341808234666 38.9513505415972, -77.01343405409706 38.95162313012426, -77.01345018694728 38.95213741057403, -77.01345516104712 38.95220812494055, -77.01346048293019 38.9522838844613)'),
(5, 5, 5, 1.5, 0.3, 1, 'LINESTRING (-77.01346048293019 38.9522838844613, -77.01346534072451 38.95235333768064, -77.01347355382521 38.95247008337707, -77.01349671347256 38.95292571908052, -77.01350854196875 38.95324758323242, -77.01351167268689 38.95333081929012)'),
(6, 6, 6, 0, 0, 0, 'LINESTRING (-77.01351167268689 38.95333081929012, -77.01351457168497 38.95340883057642, -77.01351596382683 38.95344954779709, -77.01354860933503 38.95403670303796, -77.01356274640149 38.95436253048512, -77.01356598764639 38.95441973261443, -77.01357027112063 38.95449738339135)'),
(7, 7, 7, 0, 0, 0, 'LINESTRING (-77.01239193659748 38.9508361022552, -77.01234856964504 38.95089366972041, -77.01223392367461 38.95104574145057, -77.01204153978975 38.95130682121423, -77.01194723815085 38.95143476470719, -77.01168237327896 38.9517941151788, -77.01153888919112 38.95198474448669, -77.01141178287865 38.95215366207694, -77.01134972955431 38.95223996736828, -77.01134442397441 38.9522479852457, -77.01134303993538 38.95225023744811, -77.01133704255646 38.95226077770855, -77.01133173741759 38.95227158814972, -77.01132735523778 38.95228257866661, -77.0113236652701 38.95229365919902, -77.01132066754346 38.95230500991239, -77.01131859274835 38.95231636053627, -77.01131721018066 38.95232789125856, -77.01131675053101 38.95233933180869, -77.01131698309513 38.95235086237454)');

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
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`user_id`, `email`, `experienceLevel`, `has_survey`, `bk_purpose`, `age`, `ethnicity`, `edu`, `marital`, `gender`, `driver`, `car`, `household_income`, `residence`, `bk_type`) VALUES
(1, 'no-exp@g.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'no-survey@g.com', 'Fearless', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'has-survey@g.com', 'Interested', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `Video`
--

INSERT INTO `Video` (`vid`, `clip_name`, `title`, `URL`) VALUES
(1, 'split/DCIM/105_VIRB/VIRB0022_000.MP4', '105_VIRB-VIRB0022_000', '4XTj21e3Jw0'),
(2, 'split/DCIM/105_VIRB/VIRB0020_022.MP4', '105_VIRB-VIRB0020_022', 'KRsyjLW8JS0'),
(3, 'clip3', 'title3', 'Ha3R3plrDVU'),
(4, 'clip4', 'title4', '2FWT4QGy8ho'),
(5, 'clip5', 'title5', '78nG0gGjddY'),
(6, 'clip6', 'title6', '_X1ZkiF5PPg'),
(7, 'clip7', 'title7', 'HefI1CyaumI');

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
  KEY `vid` (`vid`),
  KEY `sid` (`sid`),
  KEY `vrsid` (`vrsid`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `VideoRoadSeg`
--

INSERT INTO `VideoRoadSeg` (`vrsid`, `vid`, `sid`, `clip_name`, `index_seg`, `ratio`) VALUES
(1, 1, 1, 'clip1', 1, 0.5),
(2, 2, 2, 'clip2', 2, 0.9),
(3, 3, 2, 'clip3', 2, 0.2),
(4, 4, 3, 'clip4', 3, 0.3),
(5, 4, 4, 'clip4', 4, 0.4),
(6, 5, 4, 'clip5', 4, 1),
(7, 6, 3, 'clip6', 3, 0.8),
(8, 6, 4, 'clip6', 4, 0.6),
(9, 6, 5, 'clip6', 5, 0.3);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
