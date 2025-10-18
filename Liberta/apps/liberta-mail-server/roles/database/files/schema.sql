DROP TABLE IF EXISTS `alias`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `domain`;

--
-- Table structure for table `domain`
--

CREATE TABLE `domain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(64) NOT NULL,
  `transport` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Table structure for table `alias`
--

CREATE TABLE `alias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `source` varchar(128) NOT NULL,
  `destination` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `source` (`source`,`destination`),
  KEY `domain_id` (`domain_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `email` varchar(128) NOT NULL UNIQUE DEFAULT '',
  `crypt` varchar(767) NOT NULL DEFAULT '',
  `quota` tinytext NOT NULL,
  `note` varchar(255) NOT NULL DEFAULT '',
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `domain_id` (`domain_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
