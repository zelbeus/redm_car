CREATE TABLE IF NOT EXISTS `redm_ford` (
  `id` int(7) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL DEFAULT "0",
  `charid` int(5) NOT NULL DEFAULT 0,
  `model` BIGINT NOT NULL DEFAULT 0,
  `engine` int(2) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 CHARSET=utf8mb4;
    