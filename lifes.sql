CREATE TABLE IF NOT EXISTS `player_lives` (
  `citizenid` varchar(50) NOT NULL DEFAULT 'none',
  `lives_spent` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;