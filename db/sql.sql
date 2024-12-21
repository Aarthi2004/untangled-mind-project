-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 10, 2024 at 09:28 AM
-- Server version: 8.0.37
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `medproject`
--

-- --------------------------------------------------------

--
-- Table structure for table `add_caretakers`
--

CREATE TABLE `add_caretakers` (
  `id` int NOT NULL,
  `user_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone_no` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `gender` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `p_Name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `p_Age` int DEFAULT NULL,
  `p_Gender` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Diagnosis` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Relationship` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Caretaker_image` varchar(300) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `add_caretakers`
--

INSERT INTO `add_caretakers` (`id`, `user_id`, `password`, `Name`, `phone_no`, `Age`, `gender`, `p_Name`, `p_Age`, `p_Gender`, `Diagnosis`, `Relationship`, `Caretaker_image`) VALUES
(81, '1995', '1234', 'Aarthi', '7358732901', 21, 'Female', 'harini', 16, 'Female', 'bipolar disorder', 'Sister', 'caretaker_image/1995.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `add_ct`
--

CREATE TABLE `add_ct` (
  `id` int NOT NULL,
  `Doctor_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone_no` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `gender` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `p_Name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `p_Age` int DEFAULT NULL,
  `p_Gender` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Diagnosis` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Relationship` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Caretaker_image` varchar(300) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `ID` int NOT NULL,
  `user_id` varchar(11) COLLATE utf8mb4_general_ci NOT NULL,
  `Name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `email_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone_no` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `designation` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `institution` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`ID`, `user_id`, `Name`, `email_id`, `password`, `phone_no`, `designation`, `institution`) VALUES
(1, '123', 'n', 'aarthi32004@gmail.com', '1234', '7358732901', 'designation ', 'simats');

-- --------------------------------------------------------

--
-- Table structure for table `answers`
--

CREATE TABLE `answers` (
  `s.no` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `question_id` int DEFAULT NULL,
  `user_answer` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `answers`
--

INSERT INTO `answers` (`s.no`, `user_id`, `question_id`, `user_answer`, `date`) VALUES
(298, 19288, 1, 'Most days', '2024-02-23'),
(299, 19288, 1, 'Every day', '2024-02-26'),
(300, 19288, 2, 'Some days', '2024-02-26'),
(301, 19288, 5, 'Every day', '2024-02-26'),
(302, 19288, 4, 'Never', '2024-02-26'),
(303, 192, 1, 'Most days', '2024-02-28'),
(304, 192, 2, 'Some days', '2024-02-28'),
(305, 192, 3, 'Some days', '2024-02-28'),
(306, 192, 4, 'Most days', '2024-02-28'),
(307, 192, 5, 'Most days', '2024-02-28'),
(308, 192, 6, 'Very rarely', '2024-02-28'),
(309, 192, 7, 'Very rarely', '2024-02-28'),
(310, 192, 8, 'Most days', '2024-02-28'),
(311, 192, 9, 'Most days', '2024-02-28'),
(312, 192, 10, 'Most days', '2024-02-28'),
(313, 192, 11, 'Most days', '2024-02-28'),
(314, 192, 12, 'Never', '2024-02-28'),
(315, 192, 13, 'Some days', '2024-02-28'),
(316, 192, 14, 'Very rarely', '2024-02-28'),
(317, 192, 15, 'Very rarely', '2024-02-28'),
(318, 192, 16, 'Some days', '2024-02-28'),
(319, 0, 1, 'Some days', '2024-03-04'),
(320, 0, 2, 'Some days', '2024-03-04'),
(321, 0, 6, 'Most days', '2024-03-04'),
(322, 0, 9, 'Some days', '2024-03-04'),
(323, 0, 11, 'Some days', '2024-03-04'),
(324, 0, 13, 'Very rarely', '2024-03-04'),
(325, 192, 26, 'Every day', '2024-03-04'),
(326, 192, 29, 'Very rarely', '2024-03-04'),
(327, 192, 1, 'Never', '2024-03-04'),
(328, 192, 4, 'Most days', '2024-03-04'),
(329, 192, 6, 'Most days', '2024-03-04'),
(330, 192, 8, 'Very rarely', '2024-03-04'),
(331, 192, 19, 'Very rarely', '2024-03-07'),
(332, 192, 20, 'Most days', '2024-03-07'),
(333, 192, 21, 'Some days', '2024-03-07'),
(334, 192, 1, 'Never', '2024-03-28'),
(335, 192, 2, 'Never', '2024-03-28'),
(336, 192, 3, 'Some days', '2024-03-28'),
(337, 123, 2, 'not good', '2024-04-18'),
(338, 123, 2, 'Every day', '2024-04-18'),
(339, 123, 1, 'Every day', '2024-04-18'),
(340, 123, 2, 'Every day', '2024-04-18'),
(341, 123, 3, 'Every day', '2024-04-18'),
(342, 123, 4, 'Every day', '2024-04-18'),
(343, 123, 5, 'Every day', '2024-04-18'),
(344, 123, 6, 'Every day', '2024-04-18'),
(345, 123, 7, 'Every day', '2024-04-18'),
(346, 123, 8, 'Every day', '2024-04-18'),
(347, 123, 9, 'Every day', '2024-04-18'),
(348, 123, 10, 'Every day', '2024-04-18'),
(349, 123, 11, 'Every day', '2024-04-18'),
(350, 123, 12, 'Every day', '2024-04-18'),
(351, 123, 13, 'Every day', '2024-04-18'),
(352, 123, 14, 'Never', '2024-04-18'),
(353, 123, 15, 'Most days', '2024-04-18'),
(354, 123, 16, 'Some days', '2024-04-18'),
(355, 123, 17, 'Some days', '2024-04-18'),
(356, 123, 18, 'Never', '2024-04-18'),
(357, 123, 19, 'Some days', '2024-04-18'),
(358, 123, 20, 'Most days', '2024-04-18'),
(359, 123, 21, 'Never', '2024-04-18'),
(360, 123, 22, 'Never', '2024-04-18'),
(361, 123, 23, 'Most days', '2024-04-18'),
(362, 123, 24, 'Every day', '2024-04-18'),
(363, 123, 25, 'Every day', '2024-04-18'),
(364, 123, 26, 'Most days', '2024-04-18'),
(365, 123, 27, 'Never', '2024-04-18'),
(366, 123, 28, 'Very rarely', '2024-04-18'),
(367, 123, 29, 'Most days', '2024-04-18'),
(368, 123, 30, 'Every day', '2024-04-18'),
(369, 123, 1, 'Every day', '2024-04-22'),
(370, 123, 2, 'Every day', '2024-04-22'),
(371, 123, 3, 'Every day', '2024-04-22'),
(372, 123, 4, 'Every day', '2024-04-22'),
(373, 123, 5, 'Every day', '2024-04-22'),
(374, 123, 6, 'Every day', '2024-04-22'),
(375, 123, 7, 'Every day', '2024-04-22'),
(376, 123, 8, 'Every day', '2024-04-22'),
(377, 123, 9, 'Every day', '2024-04-22'),
(378, 123, 10, 'Every day', '2024-04-22'),
(379, 123, 11, 'Every day', '2024-04-22'),
(380, 123, 12, 'Every day', '2024-04-22'),
(381, 123, 13, 'Every day', '2024-04-22'),
(382, 123, 14, 'Every day', '2024-04-22'),
(383, 123, 15, 'Every day', '2024-04-22'),
(384, 123, 16, 'Every day', '2024-04-22'),
(385, 123, 17, 'Every day', '2024-04-22'),
(386, 123, 18, 'Every day', '2024-04-22'),
(387, 123, 19, 'Every day', '2024-04-22'),
(388, 123, 20, 'Every day', '2024-04-22'),
(389, 123, 21, 'Every day', '2024-04-22'),
(390, 123, 22, 'Every day', '2024-04-22'),
(391, 123, 23, 'Every day', '2024-04-22'),
(392, 123, 24, 'Every day', '2024-04-22'),
(393, 123, 25, 'Every day', '2024-04-22'),
(394, 123, 26, 'Every day', '2024-04-22'),
(395, 123, 27, 'Every day', '2024-04-22'),
(396, 123, 28, 'Every day', '2024-04-22'),
(397, 123, 29, 'Every day', '2024-04-22'),
(398, 123, 30, 'Every day', '2024-04-22'),
(399, 192, 1, 'Very rarely', '2024-06-07'),
(400, 192, 2, 'Every day', '2024-06-07'),
(401, 192, 3, 'Some days', '2024-06-07'),
(402, 192, 4, 'Some days', '2024-06-07'),
(403, 192, 5, 'Every day', '2024-06-07'),
(404, 192, 6, 'Every day', '2024-06-07'),
(405, 192, 7, 'Every day', '2024-06-07'),
(406, 192, 8, 'Every day', '2024-06-07'),
(407, 192, 9, 'Every day', '2024-06-07'),
(408, 192, 10, 'Every day', '2024-06-07'),
(409, 192, 11, 'Every day', '2024-06-07'),
(410, 192, 12, 'Every day', '2024-06-07'),
(411, 192, 13, 'Every day', '2024-06-07'),
(412, 192, 14, 'Some days', '2024-06-07'),
(413, 192, 15, 'Some days', '2024-06-07'),
(414, 192, 16, 'Some days', '2024-06-07'),
(415, 192, 17, 'Most days', '2024-06-07'),
(416, 192, 18, 'Every day', '2024-06-07'),
(417, 192, 19, 'Every day', '2024-06-07'),
(418, 192, 20, 'Every day', '2024-06-07'),
(419, 192, 21, 'Every day', '2024-06-07'),
(420, 192, 22, 'Every day', '2024-06-07'),
(421, 192, 23, 'Every day', '2024-06-07'),
(422, 192, 24, 'Every day', '2024-06-07'),
(423, 192, 25, 'Every day', '2024-06-07'),
(424, 192, 26, 'Every day', '2024-06-07'),
(425, 192, 27, 'Every day', '2024-06-07'),
(426, 192, 28, 'Every day', '2024-06-07'),
(427, 192, 29, 'Every day', '2024-06-07'),
(428, 192, 30, 'Every day', '2024-06-07'),
(429, 192, 1, 'Every day', '2024-07-19'),
(430, 192, 2, 'Every day', '2024-07-19'),
(431, 192, 3, 'Every day', '2024-07-19'),
(432, 192, 4, 'Most days', '2024-07-19'),
(433, 192, 5, 'Some days', '2024-07-19'),
(434, 192, 6, 'Every day', '2024-07-19'),
(435, 192, 7, 'Every day', '2024-07-19'),
(436, 192, 8, 'Every day', '2024-07-19'),
(437, 192, 9, 'Every day', '2024-07-19'),
(438, 192, 10, 'Every day', '2024-07-19'),
(439, 192, 11, 'Some days', '2024-07-19'),
(440, 192, 12, 'Most days', '2024-07-19'),
(441, 192, 13, 'Every day', '2024-07-19'),
(442, 192, 14, 'Some days', '2024-07-19'),
(443, 192, 15, 'Some days', '2024-07-19'),
(444, 192, 16, 'Every day', '2024-07-19'),
(445, 192, 17, 'Some days', '2024-07-19'),
(446, 192, 18, 'Most days', '2024-07-19'),
(447, 192, 19, 'Some days', '2024-07-19'),
(448, 192, 20, 'Most days', '2024-07-19'),
(449, 192, 21, 'Some days', '2024-07-19'),
(450, 192, 22, 'Every day', '2024-07-19'),
(451, 192, 23, 'Every day', '2024-07-19'),
(452, 192, 24, 'Most days', '2024-07-19'),
(453, 192, 25, 'Every day', '2024-07-19'),
(454, 192, 26, 'Some days', '2024-07-19'),
(455, 192, 27, 'Every day', '2024-07-19'),
(456, 192, 28, 'Every day', '2024-07-19'),
(457, 192, 29, 'Every day', '2024-07-19'),
(458, 192, 30, 'Every day', '2024-07-19'),
(459, 192, 1, 'Most days', '2024-07-22'),
(460, 192, 2, 'Every day', '2024-07-22'),
(461, 192, 3, 'Every day', '2024-07-22'),
(462, 192, 4, 'Every day', '2024-07-22'),
(463, 192, 5, 'Every day', '2024-07-22'),
(464, 192, 6, 'Every day', '2024-07-22'),
(465, 192, 7, 'Every day', '2024-07-22'),
(466, 192, 8, 'Every day', '2024-07-22'),
(467, 192, 9, 'Every day', '2024-07-22'),
(468, 192, 10, 'Every day', '2024-07-22'),
(469, 192, 11, 'Every day', '2024-07-22'),
(470, 192, 12, 'Every day', '2024-07-22'),
(471, 192, 13, 'Very rarely', '2024-07-22'),
(472, 192, 14, 'Every day', '2024-07-22'),
(473, 192, 15, 'Every day', '2024-07-22'),
(474, 192, 16, 'Every day', '2024-07-22'),
(475, 192, 17, 'Every day', '2024-07-22'),
(476, 192, 18, 'Most days', '2024-07-22'),
(477, 192, 19, 'Some days', '2024-07-22'),
(478, 192, 20, 'Never', '2024-07-22'),
(479, 192, 21, 'Never', '2024-07-22'),
(480, 192, 22, 'Very rarely', '2024-07-22'),
(481, 192, 23, 'Some days', '2024-07-22'),
(482, 192, 24, 'Very rarely', '2024-07-22'),
(483, 192, 25, 'Very rarely', '2024-07-22'),
(484, 192, 26, 'Some days', '2024-07-22'),
(485, 192, 27, 'Most days', '2024-07-22'),
(486, 192, 28, 'Every day', '2024-07-22'),
(487, 192, 29, 'Most days', '2024-07-22'),
(488, 192, 30, 'Most days', '2024-07-22'),
(489, 1995, 1, 'Every day', '2024-11-16'),
(490, 1995, 2, 'Every day', '2024-11-16'),
(491, 1995, 3, 'Most days', '2024-11-16'),
(492, 1995, 4, 'Most days', '2024-11-16'),
(493, 1995, 5, 'Some days', '2024-11-16'),
(494, 1995, 6, 'Some days', '2024-11-16'),
(495, 1995, 7, 'Very rarely', '2024-11-16'),
(496, 1995, 8, 'Some days', '2024-11-16'),
(497, 1995, 9, 'Very rarely', '2024-11-16'),
(498, 1995, 10, 'Very rarely', '2024-11-16'),
(499, 1995, 11, 'Every day', '2024-11-16'),
(500, 1995, 12, 'Most days', '2024-11-16'),
(501, 1995, 13, 'Most days', '2024-11-16'),
(502, 1995, 14, 'Most days', '2024-11-16'),
(503, 1995, 15, 'Every day', '2024-11-16'),
(504, 1995, 16, 'Every day', '2024-11-16'),
(505, 1995, 17, 'Every day', '2024-11-16'),
(506, 1995, 18, 'Every day', '2024-11-16'),
(507, 1995, 19, 'Most days', '2024-11-16'),
(508, 1995, 20, 'Most days', '2024-11-16'),
(509, 1995, 21, 'Most days', '2024-11-16'),
(510, 1995, 22, 'Never', '2024-11-16'),
(511, 1995, 23, 'Some days', '2024-11-16'),
(512, 1995, 24, 'Most days', '2024-11-16'),
(513, 1995, 25, 'Most days', '2024-11-16'),
(514, 1995, 26, 'Most days', '2024-11-16'),
(515, 1995, 27, 'Some days', '2024-11-16'),
(516, 1995, 28, 'Most days', '2024-11-16'),
(517, 1995, 29, 'Most days', '2024-11-16'),
(518, 1995, 30, 'Most days', '2024-11-16');

-- --------------------------------------------------------

--
-- Table structure for table `doctor`
--

CREATE TABLE `doctor` (
  `id` int NOT NULL,
  `user_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `Name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `email_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone_no` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Age` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Gender` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `designation` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `institution` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `doctorimage` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor`
--

INSERT INTO `doctor` (`id`, `user_id`, `Name`, `email_id`, `password`, `phone_no`, `Age`, `Gender`, `designation`, `institution`, `doctorimage`) VALUES
(14, '123', 'hema', 'hema@gmail.com', '1234', '8148407892', '25', 'Female', 'Doctor', 'Simats', 'doctor_image/123.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `qns`
--

CREATE TABLE `qns` (
  `question_id` int NOT NULL,
  `question_text` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `option_a` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `option_b` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `option_c` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `option_d` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `option_e` varchar(100) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `qns`
--

INSERT INTO `qns` (`question_id`, `question_text`, `option_a`, `option_b`, `option_c`, `option_d`, `option_e`) VALUES
(1, 'It is good to have him around', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(2, 'He makes me feel drained', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(3, 'He ignores my advice', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(4, 'He is really hard to take', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(5, 'I shout at him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(6, 'I wish he were not here', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(7, 'I feel that he is driving me crazy', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(8, 'I loose my temper with him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(9, 'He is easy to get along with', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(10, 'I am sick of having to look after him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(11, 'He deliberately causes me problems', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(12, 'I enjoy being with him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(13, 'He is a real burden', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(14, 'I argue with him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(15, 'I feel very close to him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(16, 'I can cope with him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(17, 'Living with him is too much for me', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(18, 'He is infuriating', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(19, 'I find my self saying nasty or sarcastic things to him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(20, 'He appreciates what I do for him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(21, 'I feel he is becoming easier to live with', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(22, 'I wish he would leave me alone', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(23, 'He takes me for granted', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(24, 'He can control himself', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(25, 'He is hard to get close to', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(26, 'I feel he is becoming harder to live with', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(27, 'I feel very frustated with him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(28, 'He makes a lot of sense', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(29, 'I feel disappointed with him', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never'),
(30, 'He tries to get along with me', 'Every day', 'Most days', 'Some days', 'Very rarely', 'Never');

-- --------------------------------------------------------

--
-- Table structure for table `questionarie_scorecard`
--

CREATE TABLE `questionarie_scorecard` (
  `id` int NOT NULL,
  `user_id` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `date` date DEFAULT NULL,
  `total_score` int DEFAULT NULL,
  `A` int DEFAULT NULL,
  `B` int DEFAULT NULL,
  `C` int DEFAULT NULL,
  `D` int DEFAULT NULL,
  `E` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questionarie_scorecard`
--

INSERT INTO `questionarie_scorecard` (`id`, `user_id`, `date`, `total_score`, `A`, `B`, `C`, `D`, `E`) VALUES
(80, '1995', '2024-11-16', 83, 7, 14, 5, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `subtopics`
--

CREATE TABLE `subtopics` (
  `Id` int NOT NULL,
  `topic_id` int DEFAULT NULL,
  `topic_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subtopic_id` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subtopic_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `video` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subtopics`
--

INSERT INTO `subtopics` (`Id`, `topic_id`, `topic_name`, `subtopic_id`, `subtopic_name`, `video`, `description`) VALUES
(74, 1, 'Psycho education ', '1.1', 'Introduction to Schizophrenia ', 'uploads/1000070366.mp4', 'In this video, we will provide an introduction to Schizophrenia aiming to help caregivers understand the nature of the disease, symptoms of the disease, and how to support their loved ones effectively. This educational content is designed to empower caregivers with knowledge and practical tips for taking care of their loved ones with schizophrenia.\n\nஇந்த வீடியோவில், மன சிதைவு நோய் பற்றிய ஒரு அறிமுகத்தை வழங்குவோம், இது பராமரிப்பாளர்கள் நோயின் தன்மை, நோயின் அறிகுறிகள் மற்றும் தங்கள் அன்புக்குரியவர்களை எவ்வாறு திறம்பட ஆதரிப்பது என்பதைப் புரிந்துகொள்ள உதவும். இந்த வீடியோ மன சிதைவு நோயால் பாதிக்கப்பட்ட தங்கள் அன்புக்குரியவர்களை கவனித்துக்கொள்வதற்கான அறிவு மற்றும் நடைமுறை உதவிக்குறிப்புகளைப் பராமரிப்பாளர்களுக்கு அளிக்க வடிவமைக்கப்பட்டுள்ளது.'),
(82, 1, 'Psycho education', '1.2', 'Introduction to Bipolar Affective Disorder', 'uploads/med work 2.mov', 'In this video, we will provide an introduction to Bipolar Affective Disorder aiming to help caregivers understand the nature of the disease, symptoms of the disease, and how to support their loved ones effectively. This educational content is designed to empower caregivers with knowledge and practical tips for taking care of their loved ones with Bipolar Affective Disorder. \r\n\r\nஇந்த வீடியோவில், இருமுனைய பிறழ்வு நோய் பற்றிய ஒரு அறிமுகத்தை வழங்குவோம், இது பராமரிப்பாளர்கள் நோயின் தன்மை, நோயின் அறிகுறிகள் மற்றும் தங்கள் அன்புக்குரியவர்களை எவ்வாறு திறம்பட ஆதரிப்பது என்பதைப் புரிந்துகொள்ள உதவும். இந்த வீடியோ இருமுனைய பிறழ்வு நோயால் பாதிக்கப்பட்ட தங்கள் அன்புக்குரியவர்களை கவனித்துக்கொள்வதற்கான அறிவு மற்றும் நடைமுறை உதவிக்குறிப்புகளைப் பராமரிப்பாளர்களுக்கு அளிக்க வடிவமைக்கப்பட்டுள்ளது.'),
(87, 1, 'Psycho education', '1.3', 'Introduction to Alcohol dependence syndrome', 'uploads/3done.mov', 'In this video, we will provide an introduction to alcohol dependence syndrome aiming to help caregivers understand the nature of the disease, symptoms of the disease, and how to support their loved ones effectively. This educational content is designed to empower caregivers with knowledge and practical tips for taking care of their loved ones with alcohol dependence syndrome.\n\nஇந்த வீடியோவில், மதுவை சார்ந்து இருக்கும் நிலை பற்றிய ஒரு அறிமுகத்தை வழங்குவோம், இது பராமரிப்பாளர்கள் நோயின் தன்மை, நோயின் அறிகுறிகள் மற்றும் தங்கள் அன்புக்குரியவர்களை எவ்வாறு திறம்பட ஆதரிப்பது என்பதைப் புரிந்துகொள்ள உதவும். இந்த வீடியோ  மதுவை சார்ந்து இருக்கும் நிலையால் பாதிக்கப்பட்ட தங்கள் அன்புக்குரியவர்களை கவனித்துக்கொள்வதற்கான அறிவு மற்றும் நடைமுறை உதவிக்குறிப்புகளைப் பராமரிப்பாளர்களுக்கு அளிக்க வடிவமைக்கப்பட்டுள்ளது');

-- --------------------------------------------------------

--
-- Table structure for table `suggestions`
--

CREATE TABLE `suggestions` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `suggestion` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suggestions`
--

INSERT INTO `suggestions` (`id`, `user_id`, `date`, `suggestion`) VALUES
(28, 1995, '2024-11-18', 'make sure make him feel welcomed');

-- --------------------------------------------------------

--
-- Table structure for table `topics`
--

CREATE TABLE `topics` (
  `id` int NOT NULL,
  `topic_id` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `topic_name` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `topics`
--

INSERT INTO `topics` (`id`, `topic_id`, `topic_name`) VALUES
(43, '1', 'Psycho education ');

-- --------------------------------------------------------

--
-- Table structure for table `topic_answer`
--

CREATE TABLE `topic_answer` (
  `id` int NOT NULL,
  `user_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `date` date NOT NULL,
  `subtopic_id` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subtopic_name` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `question1` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `answer1` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `question2` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `answer2` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `question3` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `answer3` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `question4` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `answer4` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `topic_answer`
--

INSERT INTO `topic_answer` (`id`, `user_id`, `date`, `subtopic_id`, `subtopic_name`, `question1`, `answer1`, `question2`, `answer2`, `question3`, `answer3`, `question4`, `answer4`) VALUES
(97, '1995', '2024-11-18', '1.2', 'Introduction to Bipolar Affective Disorder', '1', 'B) A mental health condition with extreme mood swings/ தீவிர மனநிலை மாற்றங்களை உடைய மனநோய்', '2', 'B) Decreased need for sleep / தூக்கத்தின் தேவை குறைதல்', '3', 'C) To prescribe medication / மருந்துகளை பரிந்துரைக்க', '4', 'B) Medication adherence / மருந்துகளைப் பின்பற்றுதல்'),
(98, '1995', '2024-11-18', '1.1', 'Introduction to Schizophrenia ', '1', 'A complex brain disorder affectingthoughts feelings and behaviours/எண்ணங்கள், உணர்வுகள் மற்றும் நடத்தைகளை பாதிக்கும் ஒரு சிக்கலான மூளை கோளாறு', '2', 'Seeing or hearing things that arent there/இல்லாத விஷயங்களைப் பார்ப்பது அல்லது கேட்பது', '3', 'Avoiding social interactions/சமூக தொடர்புகளைத் தவிர்ப்பது', '4', 'Remember to take care of yourself and ask for help when needed/தங்களை கவனித்துக் கொள்ள நினைவில் கொள்ளுதல் மற்றும் தேவைப்படும்போது உதவி கேட்பது'),
(99, '1995', '2024-12-05', '1.1', 'Introduction to Schizophrenia ', '1', 'A complex brain disorder affectingthoughts feelings and behaviours/எண்ணங்கள், உணர்வுகள் மற்றும் நடத்தைகளை பாதிக்கும் ஒரு சிக்கலான மூளை கோளாறு', '2', ' Excessive happiness/அதிகப்படியான மகிழ்ச்சி ', '3', 'Avoiding a balanced diet/சீரான உணவைத் தவிர்ப்பது', '4', 'Avoid seeking help/ உதவி கேட்பதைத் தவிர்க்கவும்');

-- --------------------------------------------------------

--
-- Table structure for table `video_questions`
--

CREATE TABLE `video_questions` (
  `id` int NOT NULL,
  `subtopic_id` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subtopic_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `question_id` int DEFAULT NULL,
  `question` text COLLATE utf8mb4_general_ci,
  `option_a` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `option_b` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `option_c` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `option_d` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `video_questions`
--

INSERT INTO `video_questions` (`id`, `subtopic_id`, `subtopic_name`, `question_id`, `question`, `option_a`, `option_b`, `option_c`, `option_d`) VALUES
(125, '1.1', 'Introduction to Schizophrenia ', 1, 'What is schizophrenia as described in the video?/வீடியோவில் விவரிக்கப்பட்டுள்ளபடி மன சிதைவு நோய் என்றால் என்ன?', 'A heart condition affecting blood pressure/இரத்த அழுத்தத்தை பாதிக்கும் இதய நிலை', 'A complex brain disorder affectingthoughts feelings and behaviours/எண்ணங்கள், உணர்வுகள் மற்றும் நடத்தைகளை பாதிக்கும் ஒரு சிக்கலான மூளை கோளாறு', 'A digestive disorder affecting nutrient absorption/ஊட்டச்சத்து உறிஞ்சுதலை பாதிக்கும் செரிமானக் கோளாறு', 'A skin condition causing raches and itching '),
(126, '1.1', 'Introduction to Schizophrenia ', 2, 'Which of the following is an important symptom of schizophrenia mentioned in the video?', ' Excessive happiness/அதிகப்படியான மகிழ்ச்சி ', 'Seeing or hearing things that arent there/இல்லாத விஷயங்களைப் பார்ப்பது அல்லது கேட்பது', 'Increased energy /அதிகரித்த ஆற்றல்', 'New Improved memory/ மேம்பட்ட நினைவாற்றல்'),
(127, '1.1', 'Introduction to Schizophrenia ', 3, 'According to the video, what is crucial for managing schizophrenia symptoms effectively?/ வீடியோவின்படி, மன சிதைவு நோயின் அறிகுறிகளை திறம்பட நிர்வகிக்க முக்கியமானது என்ன?', 'Regular exercise/வழக்கமான உடற்பயிற்சி', 'Medication adherence/மருந்துகளைப் பின்பற்றுதல்', 'Avoiding social interactions/சமூக தொடர்புகளைத் தவிர்ப்பது', 'Avoiding a balanced diet/சீரான உணவைத் தவிர்ப்பது'),
(128, '1.1', 'Introduction to Schizophrenia ', 4, 'What is one of the self-care tips for caregivers mentioned in the video?/வீடியோவில் குறிப்பிடப்பட்டுள்ள பராமரிப்பாளர்களுக்கான சுய கவனிப்பு உதவிக்குறிப்புகளில் ஒன்று என்ன?', 'Avoid seeking help/ உதவி கேட்பதைத் தவிர்க்கவும்', 'Never take breaks/ ஒருபோதும் ஓய்வு எடுக்க வேண்டாம்', 'Remember to take care of yourself and ask for help when needed/தங்களை கவனித்துக் கொள்ள நினைவில் கொள்ளுதல் மற்றும் தேவைப்படும்போது உதவி கேட்பது', 'Focus solely on the patient\'s needs/நோயாளியின் தேவைகளில் மட்டுமே கவனம் செலுத்துங்கள்'),
(141, '1.2', 'Introduction to Bipolar Affective Disorder', 1, 'What is bipolar affective disorder as described in the video? / வீடியோவில் விவரிக்கப்பட்டுள்ளபடி இருமுனைய பிறழ்வு நோய் என்றால் என்ன?', 'A) A condition characterized by memory loss/நினைவாற்றல் இழப்பு', 'B) A mental health condition with extreme mood swings/ தீவிர மனநிலை மாற்றங்களை உடைய மனநோய்', 'C) A respiratory disorder/ சுவாசக் கோளாறு', 'D) A digestive disorder / செரிமானக் கோளாறு'),
(142, '1.2', 'Introduction to Bipolar Affective Disorder', 2, 'Which of the following is a symptom of bipolar affective disorder mentioned in the video? / வீடியோவில் குறிப்பிடப்பட்டுள்ள இருமுனைய பிறழ்வு நோயின் அறிகுறி பின்வருவனவற்றில் எது?', 'A) Constant happiness / நிலையான மகிழ்ச்சி', 'B) Decreased need for sleep / தூக்கத்தின் தேவை குறைதல்', 'C) Increased tiredness / சோர்வு அதிகரித்தல்', 'D) Increased appetite / பசியின்மை அதிகரிப்பு'),
(143, '1.2', 'Introduction to Bipolar Affective Disorder', 3, 'What is the primary goal of understanding bipolar affective disorder as mentioned in the video? / வீடியோவில் குறிப்பிடப்பட்டுள்ளபடி இருமுனைய பிறழ்வு நோயைப் புரிந்துகொள்வதற்கான முதன்மை குறிக்கோள் என்ன?', 'A) To diagnose the condition / நோயைக் கண்டறிதல்', 'B) To provide compassionate care and support to the loved one / அன்புக்குரியவருக்கு பரிவுணர்வுள்ள கவனிப்பு மற்றும் ஆதரவை வழங்குதல்', 'C) To prescribe medication / மருந்துகளை பரிந்துரைக்க', 'D) To cure the disorder / நோயைக் குணப்படுத்த'),
(144, '1.2', 'Introduction to Bipolar Affective Disorder', 4, 'According to the video, what is essential for stabilizing mood swings in bipolar affective disorder? / வீடியோவின் படி, இருமுனைப் பிறழ்வு நோயில் மனநிலை மாற்றங்களை உறுதிப்படுத்துவதற்கு என்ன அவசியம்?', 'A) Isolation / தனிமை', 'B) Medication adherence / மருந்துகளைப் பின்பற்றுதல்', 'C) Avoiding physical activity / உடற்பயிற்சியைத் தவிர்ப்பது', 'D) Increased screen time / திரை நேரத்தை அதிகரிப்பது'),
(145, '1.3', 'Understanding Alcohol Dependence Syndrome', 1, 'Which of the following is a symptom of Alcohol Dependence Syndrome mentioned in the video? / வீடியோவில் குறிப்பிடப்பட்டுள்ள மதுவை சார்ந்து இருக்கும் நிலையின் அறிகுறி பின்வருவனவற்றில் எது?', 'A) Increased tolerance to alcohol / மதுவுக்கு சகிப்புத்தன்மை அதிகரித்தல்', 'B) Loss of appetite / பசியின்மை', 'C) Improved mood / மனநிலை மேம்பாடு', 'D) Increased energy / ஆற்றல் அதிகரிப்பு'),
(146, '1.3', 'Understanding Alcohol Dependence Syndrome', 2, 'What is one of the causes of Alcohol Dependence Syndrome as discussed in the video? / வீடியோவில் விவாதிக்கப்பட்டபடி மதுவை சார்ந்து இருக்கும் நிலையின் காரணங்களில் ஒன்று என்ன?', 'A) Lack of exercise / உடற்பயிற்சி இல்லாமை', 'B) Psychological factors / உளவியல் காரணிகள்', 'C) Overeating / அதிகப்படியான உணவு', 'D) Excessive sleep / அதிகப்படியான தூக்கம்'),
(147, '1.3', 'Understanding Alcohol Dependence Syndrome', 3, 'Which impact of Alcohol Dependence Syndrome on caregivers is mentioned in the video? / பராமரிப்பாளர்கள் மீது மதுவை சார்ந்து இருக்கும் நிலையின் என்ன தாக்கம் வீடியோவில் குறிப்பிடப்பட்டுள்ளது?', 'A) Reduced stress / மன அழுத்தத்தைக் குறைத்தல்', 'B) Financial challenges / நிதிச் சிக்கல்கள்', 'C) Enhanced social life / சமூக வாழ்க்கை மேம்பாடு', 'D) Better physical health / சிறந்த உடல் ஆரோக்கியம்'),
(148, '1.3', 'Understanding Alcohol Dependence Syndrome', 4, 'Why is understanding Alcohol Dependence Syndrome important for caregivers, according to the video? / வீடியோவின் படி, பராமரிப்பாளர்கள் மதுவை சார்ந்து இருக்கும் நிலையைப் புரிந்துகொள்வது ஏன் முக்கியம்?', 'A) To diagnose the condition / நோயைக் கண்டறிதல்', 'B) To provide empathetic support / பரிவுணர்வுடன் ஆதரவை வழங்குதல்', 'C) To prescribe medication / மருந்துகளை பரிந்துரைத்தல்', 'D) To reduce alcohol prices / மதுபான விலைகளைக் குறைத்தல்');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `add_caretakers`
--
ALTER TABLE `add_caretakers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `answers`
--
ALTER TABLE `answers`
  ADD PRIMARY KEY (`s.no`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `doctor`
--
ALTER TABLE `doctor`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `qns`
--
ALTER TABLE `qns`
  ADD PRIMARY KEY (`question_id`);

--
-- Indexes for table `questionarie_scorecard`
--
ALTER TABLE `questionarie_scorecard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subtopics`
--
ALTER TABLE `subtopics`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `suggestions`
--
ALTER TABLE `suggestions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `topic_answer`
--
ALTER TABLE `topic_answer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `video_questions`
--
ALTER TABLE `video_questions`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `add_caretakers`
--
ALTER TABLE `add_caretakers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `answers`
--
ALTER TABLE `answers`
  MODIFY `s.no` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=519;

--
-- AUTO_INCREMENT for table `doctor`
--
ALTER TABLE `doctor`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `qns`
--
ALTER TABLE `qns`
  MODIFY `question_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `questionarie_scorecard`
--
ALTER TABLE `questionarie_scorecard`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `subtopics`
--
ALTER TABLE `subtopics`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `suggestions`
--
ALTER TABLE `suggestions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `topics`
--
ALTER TABLE `topics`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `topic_answer`
--
ALTER TABLE `topic_answer`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT for table `video_questions`
--
ALTER TABLE `video_questions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=149;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `answers`
--
ALTER TABLE `answers`
  ADD CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `qns` (`question_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
