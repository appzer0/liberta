--
-- data for table `domain`
--

LOCK TABLES `domain` WRITE;
INSERT INTO `domain` VALUES
(1,'liberta.email',''),
(1,'liberta.vip',''),
(4,'orange.fr','slow:'),
(5,'yahoo.fr','yahoo:'),
(6,'yahoo.com','yahoo:'),
(7,'wanadoo.fr','slow:'),
(8,'orange.com','slow:'),
(29,'gmail.com','slow:'),
(30,'gmail.fr','slow:'),
(31,'hotmail.com','slow:'),
(32,'hotmail.fr','slow:'),
(40,'outlook.com','slow:'),
(41,'outlook.fr','slow:'),
(50,'live.com','slow:'),
(51,'live.fr','slow:');
UNLOCK TABLES;

--
-- data for table `users`
--

LOCK TABLES `users` WRITE;
INSERT INTO `users` VALUES
(761,1,'mailadmin@liberta.email','{SHA512-CRYPT}$6$7.565Kf.QG0JvUAt$3UOgZzCWB8MhP896zB.oubFo1pimBfwQokKA7i6ye1RalBrcflleW6IX9dqWjdQrR5h2EOMLWmIKZ.9Y4yYe5.','10G','Mail Admin for liberta.email !!!M!!!',1);
UNLOCK TABLES;
