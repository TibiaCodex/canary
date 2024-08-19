function onUpdateDatabase()
	logger.info("Updating database to version 47 (multiworld system)")

	db.query([[
		CREATE TABLE IF NOT EXISTS `worlds` (
			`id` int(3) UNSIGNED NOT NULL AUTO_INCREMENT,
			`name` varchar(255) NOT NULL,
			`worldType` varchar(12) NOT NULL,
			`ip` varchar(15) NOT NULL,
			`port` int(5) UNSIGNED NOT NULL,
			PRIMARY KEY (`id`),
			CONSTRAINT `worlds_unique` UNIQUE (`name`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

	db.query("ALTER TABLE `server_config` ADD `worldId` INT(3) UNSIGNED NOT NULL DEFAULT '1';")
	db.query("ALTER TABLE `players_online` ADD `worldId` INT(3) UNSIGNED NOT NULL DEFAULT '1';")
	db.query("ALTER TABLE `players` ADD `worldId` INT(3) UNSIGNED NOT NULL DEFAULT '1';")
	db.query("ALTER TABLE `houses` ADD `worldId` INT(3) UNSIGNED NOT NULL DEFAULT '1';")
	db.query("ALTER TABLE `house_lists` ADD `worldId` INT(3) UNSIGNED NOT NULL DEFAULT '1';")
	db.query("ALTER TABLE `account_viplist` ADD `worldId` INT(3) UNSIGNED NOT NULL DEFAULT '1';")
	db.query("ALTER TABLE `tile_store` ADD `worldId` INT(3) UNSIGNED NOT NULL DEFAULT '1';")
	db.query("ALTER TABLE `market_offers` ADD `worldId` INT(3) UNSIGNED NOT NULL DEFAULT '1';")
	db.query("ALTER TABLE `market_history` ADD `worldId` INT(3) UNSIGNED NOT NULL DEFAULT '1';")

	db.query("ALTER TABLE `server_config` DROP PRIMARY KEY `server_config_pk`;")
	db.query("ALTER TABLE `server_config` ADD CONSTRAINT `server_config_pk` PRIMARY KEY (`worldId`, `config`);")

	db.query("ALTER TABLE `houses` DROP PRIMARY KEY `houses_pk`;")
	db.query("ALTER TABLE `houses` ADD CONSTRAINT `houses_pk` PRIMARY KEY (`id`, `worldId`);")

	db.query("DROP TRIGGER `ondelete_players`")
	db.query([[
		CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
    		UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id` AND `worldId` = OLD.`worldId`;
		END;
	]])

	return true
end
