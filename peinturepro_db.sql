
DROP TABLE IF EXISTS `avis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `avis_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `utilisateurs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `avis_chk_1` CHECK ((`note` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `avis` VALUES (1,6,'biennnn',5,'2026-04-19 15:09:08');
/*!40000 ALTER TABLE `avis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chantiers`
--

DROP TABLE IF EXISTS `chantiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chantiers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `adresse` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ville` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gouvernorat` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `chantiers_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `utilisateurs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chantiers`
--

LOCK TABLES `chantiers` WRITE;
/*!40000 ALTER TABLE `chantiers` DISABLE KEYS */;
INSERT INTO `chantiers` VALUES (1,4,'Rue de la République 12','Tunis',NULL,36.8065000,10.1815000,'2026-04-16 21:11:17'),(2,4,'Avenue Habib Bourguiba','Sousse',NULL,35.8256000,10.6369000,'2026-04-16 21:11:17'),(3,4,'Rue Ibn Khaldoun 5','Sfax',NULL,34.7406000,10.7603000,'2026-04-16 21:11:17'),(4,6,'Avenue de Carthage 8','Ariana',NULL,36.8676000,10.1956000,'2026-04-16 21:11:17'),(5,4,'tyfvug','monastir','Sfax',NULL,NULL,'2026-04-17 12:19:11'),(6,4,'tyfvug','monastir','Sfax',NULL,NULL,'2026-04-17 12:19:17'),(7,4,'ugv','monastir','Mahdia',NULL,NULL,'2026-04-17 12:28:11'),(8,4,'luyl','monastir','Monastir',NULL,NULL,'2026-04-17 12:29:22'),(9,4,'jgv','monastir','Sfax',NULL,NULL,'2026-04-17 12:39:20'),(10,4,'fgg','monastir','Sfax',NULL,NULL,'2026-04-17 13:22:45'),(11,4,'monastir','monastir','Monastir',NULL,NULL,'2026-04-18 15:05:06'),(12,4,'monastir','monastir','Monastir',NULL,NULL,'2026-04-20 20:13:03'),(13,4,'monastir','monastir','Monastir',NULL,NULL,'2026-04-21 20:36:18');
/*!40000 ALTER TABLE `chantiers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commande_details`
--

DROP TABLE IF EXISTS `commande_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commande_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `commande_id` int NOT NULL,
  `produit_id` int NOT NULL,
  `quantite_litres` decimal(10,2) NOT NULL,
  `prix_litre` decimal(10,3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `commande_id` (`commande_id`),
  KEY `produit_id` (`produit_id`),
  CONSTRAINT `commande_details_ibfk_1` FOREIGN KEY (`commande_id`) REFERENCES `commandes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `commande_details_ibfk_2` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commande_details`
--

LOCK TABLES `commande_details` WRITE;
/*!40000 ALTER TABLE `commande_details` DISABLE KEYS */;
INSERT INTO `commande_details` VALUES (1,1,1,6.25,8.500),(2,2,3,39.27,10.500),(3,3,3,15.45,10.500),(4,4,4,12.50,18.000),(5,5,1,8.33,8.500),(6,9,3,9.09,10.500),(7,11,2,39.60,12.000),(8,12,62,36.00,33.500),(9,13,62,22.00,33.500);
/*!40000 ALTER TABLE `commande_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commandes`
--

DROP TABLE IF EXISTS `commandes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commandes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `chantier_id` int DEFAULT NULL,
  `surface_m2` decimal(10,2) DEFAULT NULL,
  `litres_calcules` decimal(10,2) NOT NULL,
  `montant_total` decimal(10,3) NOT NULL,
  `statut` enum('en_attente','confirmee','en_cours','livree','annulee') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en_attente',
  `date_livraison_souhaitee` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `chantier_id` (`chantier_id`),
  CONSTRAINT `commandes_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `utilisateurs` (`id`),
  CONSTRAINT `commandes_ibfk_2` FOREIGN KEY (`chantier_id`) REFERENCES `chantiers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commandes`
--

LOCK TABLES `commandes` WRITE;
/*!40000 ALTER TABLE `commandes` DISABLE KEYS */;
INSERT INTO `commandes` VALUES (1,4,1,25.00,6.25,53.125,'livree','2026-04-15','2026-04-11 13:46:03','2026-04-16 21:19:42'),(2,4,2,240.00,39.27,412.335,'confirmee','2026-04-15','2026-04-11 13:47:07','2026-04-17 13:59:52'),(3,4,3,85.00,15.45,162.225,'confirmee','2026-04-16','2026-04-12 18:27:30','2026-04-17 13:59:56'),(4,4,1,50.00,12.50,225.000,'confirmee','2026-04-20','2026-04-16 20:31:41','2026-04-17 13:59:58'),(5,4,4,50.00,8.33,70.805,'confirmee','2026-04-20','2026-04-16 21:02:50','2026-04-17 14:00:01'),(6,4,7,50.00,9.09,0.000,'confirmee','2026-04-21','2026-04-17 12:28:11','2026-04-17 14:00:04'),(7,4,8,50.00,12.50,0.000,'confirmee','2026-04-21','2026-04-17 12:29:22','2026-04-17 14:00:07'),(8,4,9,50.00,10.00,299.000,'confirmee','2026-04-21','2026-04-17 12:39:20','2026-04-17 14:00:09'),(9,4,10,50.00,9.09,95.445,'confirmee','2026-04-21','2026-04-17 13:22:45','2026-04-17 13:58:41'),(10,4,11,50.00,8.33,154.105,'confirmee','2026-04-22','2026-04-18 15:05:06','2026-04-18 15:09:59'),(11,4,12,180.00,39.60,475.200,'en_attente','2026-04-24','2026-04-20 20:13:03',NULL),(12,4,13,160.00,36.00,1206.000,'en_attente','2026-04-27','2026-04-21 20:36:18',NULL),(13,4,13,80.00,22.00,737.000,'confirmee','2026-04-27','2026-04-21 20:36:18','2026-04-21 20:40:47');
/*!40000 ALTER TABLE `commandes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devis`
--

DROP TABLE IF EXISTS `devis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `surface_m2` decimal(10,2) DEFAULT NULL,
  `montant_total` decimal(10,3) NOT NULL,
  `statut` enum('brouillon','envoye','accepte','refuse','expire') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'brouillon',
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `devis_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `utilisateurs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devis`
--

LOCK TABLES `devis` WRITE;
/*!40000 ALTER TABLE `devis` DISABLE KEYS */;
INSERT INTO `devis` VALUES (1,6,5.00,115.000,'accepte','2026-05-17 19:55:35','2026-04-17 19:55:35');
/*!40000 ALTER TABLE `devis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formulation_lot`
--

DROP TABLE IF EXISTS `formulation_lot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formulation_lot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lot_id` int NOT NULL,
  `matiere_id` int NOT NULL,
  `quantite_utilisee` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lot_id` (`lot_id`),
  KEY `matiere_id` (`matiere_id`),
  CONSTRAINT `formulation_lot_ibfk_1` FOREIGN KEY (`lot_id`) REFERENCES `lots_production` (`id`) ON DELETE CASCADE,
  CONSTRAINT `formulation_lot_ibfk_2` FOREIGN KEY (`matiere_id`) REFERENCES `matieres_premieres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formulation_lot`
--

LOCK TABLES `formulation_lot` WRITE;
/*!40000 ALTER TABLE `formulation_lot` DISABLE KEYS */;
/*!40000 ALTER TABLE `formulation_lot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `livraisons`
--

DROP TABLE IF EXISTS `livraisons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `livraisons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `commande_id` int NOT NULL,
  `chantier_id` int DEFAULT NULL,
  `livreur_id` int DEFAULT NULL,
  `statut` enum('planifiee','en_cours','livree') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planifiee',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `commande_id` (`commande_id`),
  KEY `chantier_id` (`chantier_id`),
  KEY `livreur_id` (`livreur_id`),
  CONSTRAINT `livraisons_ibfk_1` FOREIGN KEY (`commande_id`) REFERENCES `commandes` (`id`),
  CONSTRAINT `livraisons_ibfk_2` FOREIGN KEY (`chantier_id`) REFERENCES `chantiers` (`id`),
  CONSTRAINT `livraisons_ibfk_3` FOREIGN KEY (`livreur_id`) REFERENCES `utilisateurs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `livraisons`
--

LOCK TABLES `livraisons` WRITE;
/*!40000 ALTER TABLE `livraisons` DISABLE KEYS */;
INSERT INTO `livraisons` VALUES (1,1,1,NULL,'livree',NULL,'2026-04-16 21:11:17','2026-04-16 21:19:42'),(2,2,2,NULL,'en_cours',NULL,'2026-04-16 21:11:17','2026-04-16 21:19:59'),(3,3,3,NULL,'planifiee',NULL,'2026-04-16 21:11:17',NULL),(4,4,1,NULL,'planifiee',NULL,'2026-04-16 21:11:17',NULL),(5,5,4,NULL,'planifiee',NULL,'2026-04-16 21:11:17',NULL),(6,9,10,NULL,'planifiee',NULL,'2026-04-17 13:58:41',NULL),(7,2,2,3,'en_cours',NULL,'2026-04-17 13:59:52','2026-04-21 20:43:27'),(8,3,3,NULL,'planifiee',NULL,'2026-04-17 13:59:56',NULL),(9,4,1,NULL,'planifiee',NULL,'2026-04-17 13:59:58',NULL),(10,5,4,NULL,'planifiee',NULL,'2026-04-17 14:00:01',NULL),(11,6,7,NULL,'planifiee',NULL,'2026-04-17 14:00:04',NULL),(12,7,8,NULL,'planifiee',NULL,'2026-04-17 14:00:07',NULL),(13,8,9,NULL,'planifiee',NULL,'2026-04-17 14:00:09',NULL),(14,10,11,NULL,'planifiee',NULL,'2026-04-18 15:09:59',NULL),(15,13,13,NULL,'planifiee',NULL,'2026-04-21 20:40:47',NULL);
/*!40000 ALTER TABLE `livraisons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lots_production`
--

DROP TABLE IF EXISTS `lots_production`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lots_production` (
  `id` int NOT NULL AUTO_INCREMENT,
  `produit_id` int NOT NULL,
  `numero_lot` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantite_litres` decimal(10,2) NOT NULL,
  `date_expiration` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_lot` (`numero_lot`),
  KEY `produit_id` (`produit_id`),
  CONSTRAINT `lots_production_ibfk_1` FOREIGN KEY (`produit_id`) REFERENCES `produits` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lots_production`
--

LOCK TABLES `lots_production` WRITE;
/*!40000 ALTER TABLE `lots_production` DISABLE KEYS */;
INSERT INTO `lots_production` VALUES (1,3,'PEINT-20260415-001',20.00,'2026-05-15','2026-04-15 19:38:12'),(2,1,'PEINT-20260416-001',400.00,'2026-06-19','2026-04-16 21:51:49');
/*!40000 ALTER TABLE `lots_production` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matieres_premieres`
--

DROP TABLE IF EXISTS `matieres_premieres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matieres_premieres` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unite` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stock_actuel` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock_minimum` decimal(10,2) NOT NULL DEFAULT '10.00',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matieres_premieres`
--

LOCK TABLES `matieres_premieres` WRITE;
/*!40000 ALTER TABLE `matieres_premieres` DISABLE KEYS */;
INSERT INTO `matieres_premieres` VALUES (1,'Pigment blanc titane','kg',500.00,100.00,'2026-04-07 16:51:26'),(2,'R├®sine acrylique','L',800.00,150.00,'2026-04-07 16:51:26'),(3,'Solvant','L',400.00,80.00,'2026-04-07 16:51:26'),(4,'Pigment ocre rouge','kg',200.00,50.00,'2026-04-07 16:51:26'),(5,'Pigment blanc','kg',45.00,50.00,'2026-04-17 21:56:55'),(6,'Résine acrylique','L',120.00,80.00,'2026-04-17 21:56:55'),(7,'Solvant','L',15.00,20.00,'2026-04-17 21:56:55'),(8,'Additif anti-mousse','kg',8.00,10.00,'2026-04-17 21:56:55');
/*!40000 ALTER TABLE `matieres_premieres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `utilisateurs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (1,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwiaWF0IjoxNzc2MjY2NTcyLCJleHAiOjE3NzYyNzAxNzJ9.GC9lelJVZojW_PM-Px4eNkImIJiPcu1f3_mUeF6PDtM','2026-04-15 17:22:53',0,'2026-04-15 17:22:52'),(2,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwiaWF0IjoxNzc2MjY2NjQ4LCJleHAiOjE3NzYyNzAyNDh9.iwhfj7a0Eeft5e94mkFO_Yjt2yogajVYagtYwviFvdE','2026-04-15 17:24:08',0,'2026-04-15 17:24:08'),(3,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwiaWF0IjoxNzc2MjY3MDc1LCJleHAiOjE3NzYyNzA2NzV9.aELEeLr4vDHv03OIuGedMFb80Z0qDWyZ65Q-_Exy-V4','2026-04-15 17:31:16',0,'2026-04-15 17:31:15'),(4,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwiaWF0IjoxNzc2Mjc0NTM0LCJleHAiOjE3NzYyNzgxMzR9.c_C5p8UZZjFagcIQ5LXUujWpQPcHR12zGm4CSZ58lMQ','2026-04-15 19:35:35',0,'2026-04-15 19:35:34'),(5,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwiaWF0IjoxNzc2Mjc4MTExLCJleHAiOjE3NzYyODE3MTF9.ulG5Np65KZlHR2X83jfeQfkt-J0ZwrzQCbp-jJD3ebQ','2026-04-15 20:35:11',0,'2026-04-15 20:35:11'),(6,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwiaWF0IjoxNzc2NTIyNjA1LCJleHAiOjE3NzY1MjYyMDV9.Cs2pgpP3SkKTg1fNfmolNoug93oi9LtuGx-gOk8UIag','2026-04-18 16:30:06',0,'2026-04-18 16:30:05'),(7,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwiaWF0IjoxNzc2NTIzNjA3LCJleHAiOjE3NzY1MjcyMDd9.uDdql_JBHu53nH_39Kyvtj1m2_UwCPMoGcHKsey_tRk','2026-04-18 16:46:47',0,'2026-04-18 16:46:47'),(8,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwiaWF0IjoxNzc2NTIzNjE2LCJleHAiOjE3NzY1MjcyMTZ9.hgDHGft63d3t5-hAlkPtv35ZkS2ICQsH3_W71UZj7AM','2026-04-18 16:46:57',0,'2026-04-18 16:46:56'),(9,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwiaWF0IjoxNzc2NTI0NDQ4LCJleHAiOjE3NzY1MjgwNDh9.s-8w7VXRqX0BYKBvOSZs21D9YLPlHgKVQmdAVXUvnd8','2026-04-18 17:00:49',0,'2026-04-18 17:00:48'),(10,7,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NywiaWF0IjoxNzc2NTI1MjIwLCJleHAiOjE3NzY1Mjg4MjB9.Ceovad-h2-a_sisNud9Qj2M7USuK2hzd3iHFU8ZzjYM','2026-04-18 17:13:40',0,'2026-04-18 17:13:42');
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produits`
--

DROP TABLE IF EXISTS `produits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finition` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `couleur_code` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rendement_m2_L` decimal(5,2) NOT NULL DEFAULT '10.00',
  `prix_litre` decimal(10,3) NOT NULL,
  `stock_litres` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock_minimum` decimal(10,2) NOT NULL DEFAULT '50.00',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `image` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produits`
--

LOCK TABLES `produits` WRITE;
/*!40000 ALTER TABLE `produits` DISABLE KEYS */;
INSERT INTO `produits` VALUES (1,'Blanc Jasmin','interieure','mate','#F5F5F0',12.00,8.500,891.67,100.00,'2026-04-07 16:51:26','2026-04-17 14:00:01',NULL,NULL),(2,'Terre de Carthage','exterieure','satinee','#C4622D',10.00,12.000,300.00,80.00,'2026-04-07 16:51:26',NULL,NULL,NULL),(3,'Bleu Sidi Bou Said','interieure','brillante','#1E90FF',11.00,10.500,156.19,50.00,'2026-04-07 16:51:26','2026-04-17 13:59:56',NULL,NULL),(4,'Imperm├®a Pro','impermeabilisante','mate','#808080',8.00,18.000,137.50,40.00,'2026-04-07 16:51:26','2026-04-17 13:59:58',NULL,NULL),(53,'Prestige Velours Intérieur','interieure','Velours','#F5F0E8',12.00,18.500,850.00,100.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2021/03/prestige-catalog-page53-600x600.jpg','Peinture décorative veloutée à l\'eau, opacité parfaite, lavabilité renforcée.'),(54,'Prestige Satiné Luxe','interieure','Satiné','#EAE4D8',11.00,21.800,620.00,80.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2021/03/prestige-catalog-page73-600x600.jpg','Finition satinée brillante, haute résistance aux taches.'),(55,'Prestige Effet Béton','interieure','Effet béton','#B8B0A5',8.00,27.500,390.00,50.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2021/03/prestige-catalog-page135-600x600.jpg','Revêtement décoratif effet béton ciré, rendu authentique industriel.'),(56,'Prestige Stuc Minéral','interieure','Stuc','#D4C5A9',6.00,34.200,280.00,40.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2021/03/prestige-catalog-page93-600x600.jpg','Enduit stuc à base de minéraux naturels, finition à l\'ancienne.'),(57,'Prestige Effet Soie','interieure','Effet soie','#F2E8D5',10.00,29.900,450.00,60.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2021/03/prestige-catalog-page19-600x600.jpg','Peinture décorative nacré avec reflets soyeux changeants selon la lumière.'),(58,'Prestige Façade Elite','exterieure','Mat','#E8E0D0',10.00,22.500,1200.00,150.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2021/03/prestige-catalog-page117-600x600.jpg','Peinture façade haute protection UV. Anti-algues, anti-champignons. Garantie 10 ans.'),(59,'Prestige Silicone Façade','exterieure','Silicone mat','#D6CFC3',9.00,31.000,750.00,100.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2017/12/cat01620.jpg','Peinture façade à base silicone, hydrofuge naturelle et respirante.'),(60,'Prestige Décor Extérieur','exterieure','Grainé','#C8B9A2',7.00,26.700,580.00,80.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2017/12/cat016100.jpg','Revêtement extérieur grainé haute épaisseur, couvre les fissures superficielles.'),(61,'Prestige Hydrofuge Toiture','impermeabilisante','Élastomérique','#8B7355',5.00,38.900,920.00,100.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2017/12/cat016121.jpg','Membrane imperméabilisante élastomérique pour toitures terrasses et tuiles.'),(62,'Prestige Anti-Humidité','impermeabilisante','Mat','#A0C4FF',8.00,33.500,388.00,50.00,'2026-04-20 20:02:34','2026-04-21 20:40:47','https://prestigepeinture.com/blog/wp-content/uploads/2017/12/cat016106.jpg','Traitement anti-humidité et anti-remontées capillaires pour murs enterrés.'),(63,'Prestige Piscine & Terrasse','impermeabilisante','Brillant','#00B4D8',6.00,42.000,310.00,40.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2021/03/prestige-catalog-page41-600x600.jpg','Résine imperméabilisante colorée pour bassins, piscines et terrasses.'),(64,'Prestige Multi-Couleurs','exterieure','Multi-textures','#D4956A',4.00,48.500,240.00,30.00,'2026-04-20 20:02:34',NULL,'https://prestigepeinture.com/blog/wp-content/uploads/2017/12/cat016101.jpg','Peinture décorative multi-couleurs à effet granité naturel.');
/*!40000 ALTER TABLE `produits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refresh_tokens`
--

DROP TABLE IF EXISTS `refresh_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refresh_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  `revoked` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `refresh_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `utilisateurs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refresh_tokens`
--

LOCK TABLES `refresh_tokens` WRITE;
/*!40000 ALTER TABLE `refresh_tokens` DISABLE KEYS */;
INSERT INTO `refresh_tokens` VALUES (1,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzU2MDUzMzIsImV4cCI6MTc3NjIxMDEzMn0.cwS2yas0MXeS0v6MR0OCGhWc7i-5qS8QlGBnHo72xmU','2026-04-15 01:42:12',0,'2026-04-08 01:42:12'),(2,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzU4MTg3NjcsImV4cCI6MTc3NjQyMzU2N30.UgW9-aryAoaU8o_iFVDq2XDKwsbu0xpo9Oy-3P6hAr0','2026-04-17 12:59:27',0,'2026-04-10 12:59:27'),(3,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NTgxODgyNSwiZXhwIjoxNzc2NDIzNjI1fQ.f6H6jqg9ECXP51E1Ltre2rI3iGhYVzbulxQFM-sFIAE','2026-04-17 13:00:25',0,'2026-04-10 13:00:25'),(4,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NTgyMDQyMCwiZXhwIjoxNzc2NDI1MjIwfQ.fBIdRHRlcEkCWGMBGcrb7SgXSvC-fo8eDxa5-yTZp5A','2026-04-17 13:27:00',0,'2026-04-10 13:27:00'),(5,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NTgyMTMyMiwiZXhwIjoxNzc2NDI2MTIyfQ.jTR0BrA2VpJvMUMp_fihgVpIYR6RSZJNr7FVrcTHrJo','2026-04-17 13:42:02',1,'2026-04-10 13:42:02'),(6,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NTkwNjcyMSwiZXhwIjoxNzc2NTExNTIxfQ.1b6xO0tjuIbZgZ9mXzTnfnJneiGUQZpCFPQLWfGCc_Y','2026-04-18 13:25:21',1,'2026-04-11 13:25:21'),(7,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzU5MDgxNTgsImV4cCI6MTc3NjUxMjk1OH0.-UWgEPNWulQp6rXPMFlNeBQ-2opmnaHtJmAEri2mPYM','2026-04-18 13:49:18',0,'2026-04-11 13:49:18'),(8,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjAxMTE1MCwiZXhwIjoxNzc2NjE1OTUwfQ.gktNoT6ikodzk5hxAqG8P1gShPR7vFlpeIW9pulkixo','2026-04-19 18:25:50',1,'2026-04-12 18:25:50'),(9,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYwMTE0NzcsImV4cCI6MTc3NjYxNjI3N30.jtA5Cp09CX1jZ18btSGNwxoNlsLknKKek0kkA0oS_7k','2026-04-19 18:31:17',0,'2026-04-12 18:31:17'),(10,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjA2NzQxMSwiZXhwIjoxNzc2NjcyMjExfQ.NXZygoS-vwo3Nk7tgdh5C-SUb5aLycgfHPRxW1epieI','2026-04-20 10:03:31',1,'2026-04-13 10:03:31'),(11,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYwNjc0NDIsImV4cCI6MTc3NjY3MjI0Mn0.d5SRJL4AG3jMiotyIWamlQaIcszNWBvSFEVCYElMzMM','2026-04-20 10:04:02',1,'2026-04-13 10:04:02'),(12,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2MDY3NTY1LCJleHAiOjE3NzY2NzIzNjV9.BIHVHvXUUrB2Y-ENfEViZj3L5hFJuYvyaOZqSaNVVQk','2026-04-20 10:06:05',1,'2026-04-13 10:06:05'),(13,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYwNjc2MTAsImV4cCI6MTc3NjY3MjQxMH0.DnZ_-t7iMFkpNWLpGpfcRihOXOpXNjLIUT9PDHV7zR8','2026-04-20 10:06:50',0,'2026-04-13 10:06:50'),(14,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYwODI0ODAsImV4cCI6MTc3NjY4NzI4MH0._8DSHdhzYwisJeKvrfYbVQ-7SXYuxx71Mu-hs2pyMv0','2026-04-20 14:14:40',0,'2026-04-13 14:14:40'),(15,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjE2MzAyNiwiZXhwIjoxNzc2NzY3ODI2fQ.BSLGq5RvdgT8IJBnnpKrh1hDG09WDhZcqWv7vDQX_Ms','2026-04-21 12:37:06',1,'2026-04-14 12:37:06'),(16,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYxNjMxMTEsImV4cCI6MTc3Njc2NzkxMX0.M-X4byjSTdvjGISVpM8ElpC0_swabtAx4x0oeAKcxBs','2026-04-21 12:38:31',1,'2026-04-14 12:38:31'),(17,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYxNjMxNzQsImV4cCI6MTc3Njc2Nzk3NH0.oD30_d0nVqc0T8AAtJXYvre1DNLO78egwNMWM-EUd2I','2026-04-21 12:39:34',1,'2026-04-14 12:39:34'),(18,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2MTYzMjcxLCJleHAiOjE3NzY3NjgwNzF9.KPMOuGX-ZbH-kgXL7hTG8HHO6DwNoVBjAyF1IFCxaYI','2026-04-21 12:41:11',1,'2026-04-14 12:41:11'),(19,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjI2NzM3MywiZXhwIjoxNzc2ODcyMTczfQ.a4A8Jpi0Z9LiE_9aOYEp_wsaOhKt0D6fVaax3IpE_zs','2026-04-22 17:36:13',0,'2026-04-15 17:36:13'),(20,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2MjcxMTE2LCJleHAiOjE3NzY4NzU5MTZ9.DrLTfn41ssMx6ezEYtoSDt9zggs4aXpwV1ZvpzAJ0-s','2026-04-22 18:38:36',0,'2026-04-15 18:38:36'),(21,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYyNzIwMDksImV4cCI6MTc3Njg3NjgwOX0.QJ_ez6TOotV6h8iF-nsf5-vjD86QuyIxqoz0Z_y4Yko','2026-04-22 18:53:29',0,'2026-04-15 18:53:29'),(22,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjI3MzQ0OCwiZXhwIjoxNzc2ODc4MjQ4fQ.TeVL0s_0zi_HEJC7cVqvGbIjX_H3AMcy4qBdYqsO28k','2026-04-22 19:17:28',0,'2026-04-15 19:17:28'),(23,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjI3NDEzMywiZXhwIjoxNzc2ODc4OTMzfQ.uftEVUB1gvfgV4xfAD3TD3iwMZ57D6z4f7acC0gDRl4','2026-04-22 19:28:53',0,'2026-04-15 19:28:53'),(24,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYyNzQ1ODEsImV4cCI6MTc3Njg3OTM4MX0.2n8h31vR0ZZYzvUT-NjvvQ01lxNUimFUHEITeccxfts','2026-04-22 19:36:21',0,'2026-04-15 19:36:21'),(25,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYyNzQ3MTIsImV4cCI6MTc3Njg3OTUxMn0.uHx14FCtYMKU77tUf5Kyx9OCXtJRm9jiggNtbirvPzw','2026-04-22 19:38:32',0,'2026-04-15 19:38:32'),(26,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2Mjc0ODMxLCJleHAiOjE3NzY4Nzk2MzF9.embj9XpuV_G1vAISbyQboHT4GkpPJfG_5r01s3TV61w','2026-04-22 19:40:31',0,'2026-04-15 19:40:31'),(27,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYyNzQ4NzEsImV4cCI6MTc3Njg3OTY3MX0.rrsQOf2PUruRCrSarD2XQeo4YBaOXggoP6WAK0jO9hk','2026-04-22 19:41:11',0,'2026-04-15 19:41:11'),(28,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2Mjc4MDkyLCJleHAiOjE3NzY4ODI4OTJ9.GfAF7CRMNdopE_L0RT52Y3r420MM9I-i9y0M7K2AveU','2026-04-22 20:34:52',0,'2026-04-15 20:34:52'),(29,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2Mjc4MTM0LCJleHAiOjE3NzY4ODI5MzR9.ENd7tPAlw7j4SgX59SLfWW-A7oltxlYxBZo7eiO9Y0Y','2026-04-22 20:35:34',0,'2026-04-15 20:35:34'),(30,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjI3ODE5MSwiZXhwIjoxNzc2ODgyOTkxfQ.ZwbFvtYQ45HlxFSailjOoiRs2OTGxFim5iixgb0HTXU','2026-04-22 20:36:31',0,'2026-04-15 20:36:31'),(31,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYyNzgzNDUsImV4cCI6MTc3Njg4MzE0NX0.Z9cbnkZHKGT_IRLaVHnwbQ0OMrRUXBqRDgSDi5X18tc','2026-04-22 20:39:05',0,'2026-04-15 20:39:05'),(32,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2Mjc4NDE4LCJleHAiOjE3NzY4ODMyMTh9.wSzk-Zd-HOBjyKdzZojSs1ZmHXDGbGJuJuNPUmh9d7k','2026-04-22 20:40:18',0,'2026-04-15 20:40:18'),(33,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYyNzg0NjEsImV4cCI6MTc3Njg4MzI2MX0.cSSPlAAqlWRQXwhmm8xeKleljgjI0pevMsZOTcCsNjs','2026-04-22 20:41:01',0,'2026-04-15 20:41:01'),(34,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjI3OTEwMywiZXhwIjoxNzc2ODgzOTAzfQ.JNo5p9jjPbvqTHq_6WyJwGYbrEjlCX9_H-RWUxz4Pdk','2026-04-22 20:51:43',0,'2026-04-15 20:51:43'),(35,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYzNjE4NTAsImV4cCI6MTc3Njk2NjY1MH0.CQoGS1seSLfVgwBH-lDDchW0K9CfUg3w1ZyicyBL35g','2026-04-23 19:50:50',0,'2026-04-16 19:50:50'),(36,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYzNjE5OTcsImV4cCI6MTc3Njk2Njc5N30.fMfpuXPbEmJlfVfc1Nq20jtJ-y_cJzY8toBrJhLcg_g','2026-04-23 19:53:17',0,'2026-04-16 19:53:17'),(37,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYzNjMxNTQsImV4cCI6MTc3Njk2Nzk1NH0.S5StvMIJsHlXGl4TIcgfC_u781hdw-81Abjmi0RwRVE','2026-04-23 20:12:34',0,'2026-04-16 20:12:34'),(38,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYzNjMxOTUsImV4cCI6MTc3Njk2Nzk5NX0.UUS_T7jrUHaIVHcXv4F0Oad32yMkx90dPMZxrZHmciY','2026-04-23 20:13:15',0,'2026-04-16 20:13:15'),(39,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjM2MzIxOCwiZXhwIjoxNzc2OTY4MDE4fQ.-HilRHkU65J5qJef9oYIgMxCdqFX8z4WacqZ0SoYMCI','2026-04-23 20:13:38',0,'2026-04-16 20:13:38'),(40,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYzNjQzMTgsImV4cCI6MTc3Njk2OTExOH0.n_2uk6VZyxoXqllX_f1IFoYxUdg_iptW31hPcmHCO9M','2026-04-23 20:31:58',0,'2026-04-16 20:31:58'),(41,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYzNjQzNTUsImV4cCI6MTc3Njk2OTE1NX0.LwAfC2smbBN0qezI6IVal2J5NV7DOKOedsMzarAPsYM','2026-04-23 20:32:35',0,'2026-04-16 20:32:35'),(42,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYzNjQ4OTMsImV4cCI6MTc3Njk2OTY5M30.K6tnw-97NO3n-dQvt3ql6GL0NHDYWqzuVgMztNuJ8hM','2026-04-23 20:41:33',0,'2026-04-16 20:41:33'),(43,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYzNjU3NDcsImV4cCI6MTc3Njk3MDU0N30.a0mZ0KePTsrCl1RG3Tq0gQ1GvDpzLnJRcJ3oRrlho4k','2026-04-23 20:55:47',0,'2026-04-16 20:55:47'),(44,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjM2NjE0MiwiZXhwIjoxNzc2OTcwOTQyfQ.yXEJoxOLKXiGH3CSHCGeA4kimALT38NaPjBrcFxMy7I','2026-04-23 21:02:22',0,'2026-04-16 21:02:22'),(45,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYzNjYyMDEsImV4cCI6MTc3Njk3MTAwMX0.9ICvINWjXuZXqYBHnAVJI4CdOmpsSvOMWsImFAjFg1k','2026-04-23 21:03:21',0,'2026-04-16 21:03:21'),(46,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYzNjYyMTIsImV4cCI6MTc3Njk3MTAxMn0.CRyQMe9nHV8lpqicr1nc7FleD1YNqw5x23KQujT4Lmg','2026-04-23 21:03:32',0,'2026-04-16 21:03:32'),(47,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYzNjcxMjQsImV4cCI6MTc3Njk3MTkyNH0.FgepCMyIulT9Q56iA5ZXOr20wape1oPsV4At-g7hi-A','2026-04-23 21:18:44',0,'2026-04-16 21:18:44'),(48,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYzNjcxNjMsImV4cCI6MTc3Njk3MTk2M30.xOG7PdxARhCELkioBAnf71GxM4WQA3EgGsbKoLiiQQ8','2026-04-23 21:19:23',0,'2026-04-16 21:19:23'),(49,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYzNjcyNzcsImV4cCI6MTc3Njk3MjA3N30.rw-kEkTQr4BSd6utlqgAaAnzS2RNIInKzb5ymnvZ4VE','2026-04-23 21:21:17',0,'2026-04-16 21:21:17'),(50,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzYzNjkwNTEsImV4cCI6MTc3Njk3Mzg1MX0.rMwWwoZDKDn9RUYlw659d_Nd2FWi0nJJu9RFWLobSFk','2026-04-23 21:50:51',0,'2026-04-16 21:50:51'),(51,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjM2OTI3OCwiZXhwIjoxNzc2OTc0MDc4fQ.pfRBGSRrnvMaRfNBNGGzJ7ViITyjmHN0rxAfXZuABRU','2026-04-23 21:54:38',0,'2026-04-16 21:54:38'),(53,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2MzczMzYxLCJleHAiOjE3NzY5NzgxNjF9.HTM5WDWSRUAR9C2uPkxSuewBkvwd-jdNAzwSZ11WFSk','2026-04-23 23:02:41',0,'2026-04-16 23:02:41'),(54,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzYzNzMzODgsImV4cCI6MTc3Njk3ODE4OH0.O01KfJkG19KcNsqST9ocxzbYKpfNtezVI4B90BSRYlM','2026-04-23 23:03:08',0,'2026-04-16 23:03:08'),(55,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjM3MzQyNSwiZXhwIjoxNzc2OTc4MjI1fQ.BOonScq-I4qgmYIM0exsJsuOMgdN96Sw7hdhszyipx4','2026-04-23 23:03:45',0,'2026-04-16 23:03:45'),(56,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0MjE3OTUsImV4cCI6MTc3NzAyNjU5NX0.Zw69pKJEeR_kHv2rsyQ9w7yOFJBzDb2xmLPI1_mpJ6U','2026-04-24 12:29:55',0,'2026-04-17 12:29:55'),(57,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjQyMTgzMCwiZXhwIjoxNzc3MDI2NjMwfQ.dikpzx4jI8gtD0pWaUO8EKkD1F3MrjBE2z5gzL8zNFg','2026-04-24 12:30:30',0,'2026-04-17 12:30:30'),(58,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY0MjQ4NTQsImV4cCI6MTc3NzAyOTY1NH0.g9EX6yfuqqvRR_g6VJhYVXPqhZhBA1ns3avEFfspc-w','2026-04-24 13:20:54',0,'2026-04-17 13:20:54'),(59,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjQyNDkyMSwiZXhwIjoxNzc3MDI5NzIxfQ.xQfN_Ji-WO4dJKuOTOOAdwtQvXYrZxzDXhcILNGyZBY','2026-04-24 13:22:01',0,'2026-04-17 13:22:01'),(60,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY0MjQ5ODEsImV4cCI6MTc3NzAyOTc4MX0.DdUnBdYo78Wwuos7NFfsKrWOqIRmOvpJrRiJKFgb8xc','2026-04-24 13:23:01',0,'2026-04-17 13:23:01'),(61,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjQyNTEyOCwiZXhwIjoxNzc3MDI5OTI4fQ.tEHXbzToDmJ0K54GkPTTJFprKTw1C6JpBLaPgo4Bk5A','2026-04-24 13:25:28',0,'2026-04-17 13:25:28'),(62,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0MjUxOTQsImV4cCI6MTc3NzAyOTk5NH0.RomEIJuh5YDzT3DFEnLojNQZnSsRCvUr-TXJHWvLaPk','2026-04-24 13:26:34',0,'2026-04-17 13:26:34'),(63,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY0MjYwNDYsImV4cCI6MTc3NzAzMDg0Nn0.SehnFL4YhvL8BkfzuXvrDCvlhJlkc77luVZj0aareuM','2026-04-24 13:40:46',0,'2026-04-17 13:40:46'),(64,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjQyNjA2NSwiZXhwIjoxNzc3MDMwODY1fQ.1pD5ign1lACDdf8clmCZ3gLGxEgi5SK6IC538tQ0kKc','2026-04-24 13:41:05',0,'2026-04-17 13:41:05'),(65,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDI2NDUwLCJleHAiOjE3NzcwMzEyNTB9.Lf9yUZMnNUikZ2hoq1TVIcCL2ZWFEEOppzXrqaN0nT4','2026-04-24 13:47:30',0,'2026-04-17 13:47:30'),(66,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY0MjcxNTEsImV4cCI6MTc3NzAzMTk1MX0.Tw5JivLTFN1rFocQ_XshgeVC0VSzcCsvmD6Vcb6q1mg','2026-04-24 13:59:11',0,'2026-04-17 13:59:11'),(67,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDI3MTgzLCJleHAiOjE3NzcwMzE5ODN9.QnyUEuLGjZkfXqbVClcI9LPO_MWyd08dsPbxHEb1TCM','2026-04-24 13:59:43',0,'2026-04-17 13:59:43'),(68,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY0MjcyMzAsImV4cCI6MTc3NzAzMjAzMH0.2ZFP9eHB3pnOEYmep_xZP-zdx_T6XhqHEH-b9m9dThI','2026-04-24 14:00:30',0,'2026-04-17 14:00:30'),(69,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0MjcyOTEsImV4cCI6MTc3NzAzMjA5MX0.45p9zpL8Ofcy3NBcsClC4YBnwVF3JLd5jBWa4VNrDpY','2026-04-24 14:01:31',0,'2026-04-17 14:01:31'),(70,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0MzY2ODAsImV4cCI6MTc3NzA0MTQ4MH0.vQerN3sNNeml1F5qZLpDy0Z82MdB6NIvyUrOMR8Akoc','2026-04-24 16:38:00',0,'2026-04-17 16:38:00'),(71,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDQwMTAxLCJleHAiOjE3NzcwNDQ5MDF9.I7esH3XEKlTyBoi5ddd0Rt7FOHw7Ga0qaiqTgqwfsv4','2026-04-24 17:35:01',0,'2026-04-17 17:35:01'),(72,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDQ0NTkwLCJleHAiOjE3NzcwNDkzOTB9.etCltRIPOu1N9Edmt3Qn3Tq3R9mT5OXCJLxDYnzR7FE','2026-04-24 18:49:50',0,'2026-04-17 18:49:50'),(73,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDQ2NTcxLCJleHAiOjE3NzcwNTEzNzF9.16H7YnE36jfL9Slp5J4sHiF1Gojsuj_7pt91owSX87o','2026-04-24 19:22:51',0,'2026-04-17 19:22:51'),(74,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDQ2ODM2LCJleHAiOjE3NzcwNTE2MzZ9.QTWiI8IefuLfJLkR5WJiVsJphb4bredHMPUeVORiTlk','2026-04-24 19:27:16',0,'2026-04-17 19:27:16'),(75,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDQ2OTU3LCJleHAiOjE3NzcwNTE3NTd9.1Q_L1cN8AqpFJHCffUyijcfrQC2DzFQFi1r3_ogD6bY','2026-04-24 19:29:17',0,'2026-04-17 19:29:17'),(76,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDQ4MjcxLCJleHAiOjE3NzcwNTMwNzF9.IDMqKg-L5Rbn23Tx_z5dH_SB7plK3pH8xiM24HS8om8','2026-04-24 19:51:11',0,'2026-04-17 19:51:11'),(77,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY0NDg1NjksImV4cCI6MTc3NzA1MzM2OX0.URfEZfgOxrCkYEdi9dyv-Uom_hXxvoVsnw09k6txa_8','2026-04-24 19:56:09',0,'2026-04-17 19:56:09'),(78,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDQ4NjAyLCJleHAiOjE3NzcwNTM0MDJ9.P3Jz5wbITvYMHYuk2Y-lp3NMQd3IEaAyzeMEIDs65wU','2026-04-24 19:56:42',0,'2026-04-17 19:56:42'),(79,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0NDg3MTAsImV4cCI6MTc3NzA1MzUxMH0.eDtJor68qqNhwx6d6VSIYwLp268KCEmQW8IBSYEH1NE','2026-04-24 19:58:30',0,'2026-04-17 19:58:30'),(80,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDQ5NDU3LCJleHAiOjE3NzcwNTQyNTd9.8i6pMh6ogTHEpMj8R6LuXQtRhbDM3BE2k1XDaGyrrJI','2026-04-24 20:10:57',0,'2026-04-17 20:10:57'),(81,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0NDk4MzgsImV4cCI6MTc3NzA1NDYzOH0.luwL75Ogj7yBNS2zNTtTRREecrRTTEjrM6gOzBwTG5M','2026-04-24 20:17:18',0,'2026-04-17 20:17:18'),(82,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0NTE0NzEsImV4cCI6MTc3NzA1NjI3MX0.O1vrvWRFHuXH4w4hdhY5gQ5iLGqUh1ITdnVt6Lj6pWY','2026-04-24 20:44:31',0,'2026-04-17 20:44:31'),(83,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDUxNDgxLCJleHAiOjE3NzcwNTYyODF9.zA4oUXlTnYS24qdkHHrFghM6ecG3Win5kpIhwS6RdOw','2026-04-24 20:44:41',0,'2026-04-17 20:44:41'),(84,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDUzNjEwLCJleHAiOjE3NzcwNTg0MTB9.3TNBsGbB2yJNEWBJ5tp21LhJOeVMp7jyNdYsvRzAtz0','2026-04-24 21:20:10',0,'2026-04-17 21:20:10'),(85,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0NTM2MjYsImV4cCI6MTc3NzA1ODQyNn0.8y2--d8otbyvr_kATa4gSi0jU_gZBpHYPML051yOmNU','2026-04-24 21:20:26',0,'2026-04-17 21:20:26'),(86,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDUzNzcxLCJleHAiOjE3NzcwNTg1NzF9.dyStsPOW1lzhPaB4xH9i3XM6JJNwGQcCzN1pOdZN-yQ','2026-04-24 21:22:51',0,'2026-04-17 21:22:51'),(87,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0NTM4NjksImV4cCI6MTc3NzA1ODY2OX0.PzzO6YY4jm8VZJnuYo3ib_OhInuQxb0nnb82K71qYQI','2026-04-24 21:24:29',0,'2026-04-17 21:24:29'),(88,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjQ1NDg1NCwiZXhwIjoxNzc3MDU5NjU0fQ.hO5uDg1Erq8534zJCvLmuOGZABLdN2SNikxMZ5QcwM0','2026-04-24 21:40:54',0,'2026-04-17 21:40:54'),(89,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0NTUxNDYsImV4cCI6MTc3NzA1OTk0Nn0.ss3mZaO8uOgmBHIhfOg-8KTHWzV2_8GXjgspVOBRpvU','2026-04-24 21:45:46',0,'2026-04-17 21:45:46'),(90,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDU1MzY0LCJleHAiOjE3NzcwNjAxNjR9.xVXlj-2oSJNwbEoQY_Os7REKKvRWSgmw_5U8QxYMmPo','2026-04-24 21:49:24',0,'2026-04-17 21:49:24'),(91,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDU1ODY1LCJleHAiOjE3NzcwNjA2NjV9._FKCoz3KJI3iJmlA1VEYDinb4avogr1wkSkp__7Kx6k','2026-04-24 21:57:45',0,'2026-04-17 21:57:45'),(92,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDU2OTM3LCJleHAiOjE3NzcwNjE3Mzd9.2nYb3W1NPXXRDO-RIIHpaUQIPXhgg3f_qrF4pVh5ru4','2026-04-24 22:15:37',0,'2026-04-17 22:15:37'),(93,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDk3MTA2LCJleHAiOjE3NzcxMDE5MDZ9.1C-TSv_ENmRjp5PKbTdi4NmnMOxV50M8gwui9JsCKx0','2026-04-25 09:25:06',0,'2026-04-18 09:25:06'),(94,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDk3NDIzLCJleHAiOjE3NzkwODk0MjN9.OfOCtMg0v7ZygfWC2mT3IC-Hle8EAeV4l6ahsIRAJ6I','2026-04-25 09:30:23',0,'2026-04-18 09:30:23'),(95,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0OTgxMzcsImV4cCI6MTc3OTA5MDEzN30.qR0iTpFFb7LHbxrWWWrxU3eDwaQqXOwMzdqpBD1klgM','2026-04-25 09:42:17',0,'2026-04-18 09:42:17'),(96,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDk4MTU3LCJleHAiOjE3NzkwOTAxNTd9.8dFGHLkhT5PpuAKj-MCR2cT8eyF7chFnvHtz9Dzpl54','2026-04-25 09:42:37',0,'2026-04-18 09:42:37'),(97,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NDk4Njg3LCJleHAiOjE3NzkwOTA2ODd9.5H6exW1suirbRJz8VJao3bt_N8n12_4AlQx4X38zkAU','2026-04-25 09:51:27',0,'2026-04-18 09:51:27'),(98,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY0OTg3NzAsImV4cCI6MTc3OTA5MDc3MH0.sTQccA17iW-cmqPFafY8mpScDyOU0guGVNUW8sKIoyE','2026-04-25 09:52:50',0,'2026-04-18 09:52:50'),(99,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY0OTg3OTksImV4cCI6MTc3OTA5MDc5OX0.yz1_4D6UlmSVkVsljSJctr0eDOdK2ObtpC9z8wfPb6U','2026-04-25 09:53:19',0,'2026-04-18 09:53:19'),(100,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY1MTYxNzcsImV4cCI6MTc3OTEwODE3N30.7RHHqT-lUhhE0v0B6lJZXF2Mt8aPpwvk95d6_oZlqec','2026-04-25 14:42:57',0,'2026-04-18 14:42:57'),(101,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY1MTYxODgsImV4cCI6MTc3OTEwODE4OH0.FMkTZNyh6Mz-EA9JiojoAVXmwPP1gcg1U8KaUQ6n80k','2026-04-25 14:43:08',0,'2026-04-18 14:43:08'),(102,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjUxNzI5OSwiZXhwIjoxNzc5MTA5Mjk5fQ.oSX_o98HrsdnTv-NHt2XHIK4N8jWISteiyw2vdtnhbk','2026-04-25 15:01:39',0,'2026-04-18 15:01:39'),(103,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY1MTc1NDYsImV4cCI6MTc3OTEwOTU0Nn0.MQT4y1Z7htHNYVV2aPsMu8uIKM97ku37oXhxLCbD5ng','2026-04-25 15:05:46',0,'2026-04-18 15:05:46'),(104,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NTE3NjU2LCJleHAiOjE3NzkxMDk2NTZ9.wJMaTdKnyF-0E1OZuyAQG0WMBqdZw5tmDBK1PF696eM','2026-04-25 15:07:36',0,'2026-04-18 15:07:36'),(105,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY1MTc4MTQsImV4cCI6MTc3OTEwOTgxNH0.JDhrr8Ns231k4blAtKI2UddCFtHJNvw-cpisj0XDaUg','2026-04-25 15:10:14',0,'2026-04-18 15:10:14'),(106,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY1MjE1MDEsImV4cCI6MTc3OTExMzUwMX0.MKPvwb7AbfGqAXmvzcZUiy86jjF5yG8ol5raUUyecBA','2026-04-25 16:11:41',0,'2026-04-18 16:11:41'),(107,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY1MjE4MTcsImV4cCI6MTc3OTExMzgxN30.Hb2q-aHrxeByI3llBv4RRJYe1ku2HerCvN8HvJVocPs','2026-04-25 16:16:57',0,'2026-04-18 16:16:57'),(108,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY1MjE5NDgsImV4cCI6MTc3OTExMzk0OH0.TvNHWYonh1iYRuj3vKkZA3pDnUyJvO5iddPEenlrjec','2026-04-25 16:19:08',0,'2026-04-18 16:19:08'),(109,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY1MjI0ODIsImV4cCI6MTc3OTExNDQ4Mn0.-ZEFZTM3KXgEl9ISvls_tEjFZ4Aw8hCVCZTH-IIHCro','2026-04-25 16:28:02',0,'2026-04-18 16:28:02'),(110,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NTIyNTg5LCJleHAiOjE3NzkxMTQ1ODl9.qGb8xC_VdZTyaINaLyq0emmPaRTcDcEQTGnLkaVkr4o','2026-04-25 16:29:49',0,'2026-04-18 16:29:49'),(111,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NjA4NTU2LCJleHAiOjE3NzkyMDA1NTZ9.4vBpPYQj8OkI93TCC4EXmuydvtKm_ksxFsvAKE5wWXE','2026-04-26 16:22:36',0,'2026-04-19 16:22:36'),(112,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NjA5ODMwLCJleHAiOjE3NzkyMDE4MzB9.iHm4VRWZJIQVvQo0_4y79e8UFCPjlC5ZBU0aksUhwpY','2026-04-26 16:43:50',0,'2026-04-19 16:43:50'),(113,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NjExMzI4LCJleHAiOjE3NzkyMDMzMjh9.W1b2pKBvN8PdMnZNEGXuEXB0X0DxlNoj2vwQ8h-ysPc','2026-04-26 17:08:48',0,'2026-04-19 17:08:48'),(114,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NjEyMjkyLCJleHAiOjE3NzkyMDQyOTJ9.TFLLYHcwFk1QIcMRGFx3NWF3wx2uI67oOTva3AvuG0Q','2026-04-26 17:24:52',0,'2026-04-19 17:24:52'),(115,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NjE3MDU3LCJleHAiOjE3NzkyMDkwNTd9.q35ovCl55BFJF0R6F1Ax75K-A7J0AKyB30juorvjkqs','2026-04-26 18:44:17',0,'2026-04-19 18:44:17'),(116,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY2MTcxNDIsImV4cCI6MTc3OTIwOTE0Mn0.Ys_0fszR-pHgDd_S8kWtrMprVoDdQEbeD3zTzdzJXJA','2026-04-26 18:45:42',0,'2026-04-19 18:45:42'),(117,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY2MTc2NTksImV4cCI6MTc3OTIwOTY1OX0.ZhzVLxwcT1CkFGGBxtDdvGUDiV9YyCre1drz1DZypBg','2026-04-26 18:54:19',0,'2026-04-19 18:54:19'),(118,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NjE3NjkxLCJleHAiOjE3NzkyMDk2OTF9.bOEK3j3Te7COLvs7gz83KCsIOjKp36U0biXMhLwFc_4','2026-04-26 18:54:51',0,'2026-04-19 18:54:51'),(119,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NjE5NjE0LCJleHAiOjE3NzkyMTE2MTR9.no-hEwI8rmEqGOpXMvxnlZTIWnKssGRnkbl2Ef7xhCA','2026-04-26 19:26:54',0,'2026-04-19 19:26:54'),(120,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NjIwNDE2LCJleHAiOjE3NzkyMTI0MTZ9.Z0bMqf73_-s1Kf-RU3ftoTMmPprypyQf3SdEHgewzQw','2026-04-26 19:40:16',0,'2026-04-19 19:40:16'),(121,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NjIwNTgyLCJleHAiOjE3NzkyMTI1ODJ9.7jTiCo4gpeyuDdp5Bot14YdwHo0ySuwgqhJaiKKoAn4','2026-04-26 19:43:02',0,'2026-04-19 19:43:02'),(122,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY2MjA2MzAsImV4cCI6MTc3OTIxMjYzMH0.wz7p3jQGDys2PUy9y6anH_glMQIzTkAEW9pTYjs9vhQ','2026-04-26 19:43:50',0,'2026-04-19 19:43:50'),(123,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NjIwNjg1LCJleHAiOjE3NzkyMTI2ODV9.QhzS_a2eRkgCfmAiZ6pK8i6A13w0mbDJvbTF7IvsP8w','2026-04-26 19:44:45',0,'2026-04-19 19:44:45'),(124,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NjIxNDE0LCJleHAiOjE3NzkyMTM0MTR9.UNTPZiJ_Zza-ChQ-zq7FvWtmhEdPKunbIUXW2sSaXDI','2026-04-26 19:56:54',0,'2026-04-19 19:56:54'),(125,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NjIxNTg2LCJleHAiOjE3NzkyMTM1ODZ9.481VGAWqpLX_fEgKN-fcNbRhzfjUyXoTn4szxvbHN0A','2026-04-26 19:59:46',0,'2026-04-19 19:59:46'),(126,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NjIxNjU4LCJleHAiOjE3NzkyMTM2NTh9.EFz3qCHPqtL1ptNIsElHkNZLqrvO-8V6rn9fiEtELI4','2026-04-26 20:00:58',0,'2026-04-19 20:00:58'),(127,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NjIyNTE0LCJleHAiOjE3NzkyMTQ1MTR9.Yy-O_2nS3sDXboJEfzyWrH4FstVagwEj5_ugu8F94kU','2026-04-26 20:15:14',0,'2026-04-19 20:15:14'),(128,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NjI0MDc3LCJleHAiOjE3NzkyMTYwNzd9.8l1Fk9CXJoPfCRFafXxXTlk1qthIvlAI-VLKL_PTpOg','2026-04-26 20:41:17',0,'2026-04-19 20:41:17'),(129,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY2MjQzMTMsImV4cCI6MTc3OTIxNjMxM30.19eg39UvPl59gADw2w7Rc-371vpFTn4DaOnykpmRwn8','2026-04-26 20:45:13',0,'2026-04-19 20:45:13'),(130,6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6ImNsaWVudCIsIm5vbSI6ImluZXMgemFvdWFtIiwiaWF0IjoxNzc2NzA1MzkzLCJleHAiOjE3NzkyOTczOTN9.RjaUbTdYsz5V5rXU0CmnCCyNbl5X98tKQQlDll8Wz54','2026-04-27 19:16:33',0,'2026-04-20 19:16:33'),(131,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjcwNTY1NCwiZXhwIjoxNzc5Mjk3NjU0fQ.00BiJkbDwaxw62PGGDKop0JTE0n_X7tPTLirX4Do70g','2026-04-27 19:20:54',0,'2026-04-20 19:20:54'),(132,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY3MDU2ODgsImV4cCI6MTc3OTI5NzY4OH0.rnf-4YhRQsOzG4byl9LvJ-IpQa9WJqqbiXFRbAN9JC0','2026-04-27 19:21:28',0,'2026-04-20 19:21:28'),(133,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NzA1NzIwLCJleHAiOjE3NzkyOTc3MjB9.l-mbs0Wf0gq-wYCp31gv7mIPb9Nxixe0e_f-O7bgD_w','2026-04-27 19:22:00',0,'2026-04-20 19:22:00'),(134,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY3MDYyNDAsImV4cCI6MTc3OTI5ODI0MH0.uE9NXlOln2oOTgGymWW0PJv1DA7IqzIISo6ry9i4bMg','2026-04-27 19:30:40',0,'2026-04-20 19:30:40'),(135,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY3MDY2NjUsImV4cCI6MTc3OTI5ODY2NX0.RVh2i-dbLJcIPVnsW5mbZjYRrW7-6agjui2JNZXrc3s','2026-04-27 19:37:45',0,'2026-04-20 19:37:45'),(136,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjcwODY5MCwiZXhwIjoxNzc5MzAwNjkwfQ.5OZi1fU_TnbAOaVoNKUutUN9ZLADG548p7r2SW4v2TE','2026-04-27 20:11:30',0,'2026-04-20 20:11:30'),(137,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY3MDg4NzAsImV4cCI6MTc3OTMwMDg3MH0.z8ys5wcEbvdl_MvTUVobOI7d-Slu_G1ZoKsyiS5CMBg','2026-04-27 20:14:30',0,'2026-04-20 20:14:30'),(138,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY3MDkyNDYsImV4cCI6MTc3OTMwMTI0Nn0.bIhiTenu-EBDmDALhSl48KqO1WQpntC1lpPgbbUPI7M','2026-04-27 20:20:46',0,'2026-04-20 20:20:46'),(139,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY3MDk2MDMsImV4cCI6MTc3OTMwMTYwM30.AwFNMRC8zcSP0JMMrzTGhUclAbjCV-7S0G8qs5bJKf8','2026-04-27 20:26:43',0,'2026-04-20 20:26:43'),(140,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2NzA5NjMzLCJleHAiOjE3NzkzMDE2MzN9.Z5WVejc8LjHu7873g4xPkPqFQYE0RQxSz0kDvRY2FPk','2026-04-27 20:27:13',0,'2026-04-20 20:27:13'),(141,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjcwOTY3NCwiZXhwIjoxNzc5MzAxNjc0fQ.l58C7V1R0GxAZPwLpFs9UtzFOBSkGaRvorJJ9BrEj8E','2026-04-27 20:27:54',0,'2026-04-20 20:27:54'),(142,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3NjcxMjE4MCwiZXhwIjoxNzc5MzA0MTgwfQ.r5WTT8o6EDtnE1NvEA3AdFbXEhE4vZ2QtPKSaTI3v7s','2026-04-27 21:09:40',0,'2026-04-20 21:09:40'),(143,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2Nzg5MzAxLCJleHAiOjE3NzkzODEzMDF9.1G8nNrYwAV-VXhopK6R17KD0jsU-KceCWU9pxDZI0PM','2026-04-28 18:35:01',0,'2026-04-21 18:35:01'),(144,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2Nzg5ODE5LCJleHAiOjE3NzkzODE4MTl9.f4tGp9bxX4IKXdDha6fmAWUv0g2NLBpeWeiS5dKpWCI','2026-04-28 18:43:39',0,'2026-04-21 18:43:39'),(145,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY3ODk4NTUsImV4cCI6MTc3OTM4MTg1NX0.GwyeuUKnd7HWxkXGq0Zdw_jcTZ-7ifLrVC5cLLiQ22k','2026-04-28 18:44:15',0,'2026-04-21 18:44:15'),(146,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY3ODk4OTMsImV4cCI6MTc3OTM4MTg5M30.L9UOwkPxIv7nzYJF5sVPWzX2JH50FUKfx59sa6ZhUzI','2026-04-28 18:44:53',0,'2026-04-21 18:44:53'),(147,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3Njc5MTk3NCwiZXhwIjoxNzc5MzgzOTc0fQ.A63LPzgflz3czxO6caC-eQqZ4EP6QGunbBeTafKieuo','2026-04-28 19:19:34',0,'2026-04-21 19:19:34'),(148,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY3OTI0MTMsImV4cCI6MTc3OTM4NDQxM30.sPxhfZ6bVIja3WyqHqRtPv3koWx_TeyXwMiF2Btqhno','2026-04-28 19:26:53',0,'2026-04-21 19:26:53'),(149,4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImNsaWVudCIsIm5vbSI6Ik1vaGFtZWQgQmVuIEFsaSIsImlhdCI6MTc3Njc5NjQ3MywiZXhwIjoxNzc5Mzg4NDczfQ._1qFTnwBylf0cEMTHVhx7iQKRjM4Lb5k3jI3KrkTKAk','2026-04-28 20:34:33',0,'2026-04-21 20:34:33'),(150,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6ImNvbW1lcmNpYWwiLCJub20iOiJTYW1pIFRyYWJlbHNpIiwiaWF0IjoxNzc2Nzk2ODIzLCJleHAiOjE3NzkzODg4MjN9.uOHu7pv2lhyULbXRaJtZ1iV11jHWNYXWWaM2BiA__l8','2026-04-28 20:40:23',0,'2026-04-21 20:40:23'),(151,3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6ImxpdnJldXIiLCJub20iOiJLYXJpbSBCZWxoYWoiLCJpYXQiOjE3NzY3OTY5MjUsImV4cCI6MTc3OTM4ODkyNX0.u_FxMzwXsJPP19yMiyF6ATK3PY2dbBuKNhKKuKdOfoo','2026-04-28 20:42:05',0,'2026-04-21 20:42:05'),(152,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6ImFkbWluIiwibm9tIjoiQWRtaW5pc3RyYXRldXIiLCJpYXQiOjE3NzY3OTcwMzgsImV4cCI6MTc3OTM4OTAzOH0.0C8JwRVhRPi39Tplj1CPxD79Oh4OkzBklshK8lP_GhU','2026-04-28 20:43:58',0,'2026-04-21 20:43:58');
/*!40000 ALTER TABLE `refresh_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilisateurs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','commercial','livreur','client') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'client',
  `telephone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adresse` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actif` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilisateurs`
--

LOCK TABLES `utilisateurs` WRITE;
/*!40000 ALTER TABLE `utilisateurs` DISABLE KEYS */;
INSERT INTO `utilisateurs` VALUES (1,'Administrateur','admin@peinturepro.tn','$2b$12$D0m7kVyskYiHw0LtbniX7OXvkDYmDtwE8.ni8q0nM3VH/ugCEP22y','admin',NULL,NULL,1,'2026-04-07 16:51:26','2026-04-08 01:41:43'),(2,'Sami Trabelsi','commercial@peinturepro.tn','$2b$12$D0m7kVyskYiHw0LtbniX7OXvkDYmDtwE8.ni8q0nM3VH/ugCEP22y','commercial',NULL,NULL,1,'2026-04-07 16:51:26','2026-04-08 01:41:43'),(3,'Karim Belhaj','livreur@peinturepro.tn','$2b$12$D0m7kVyskYiHw0LtbniX7OXvkDYmDtwE8.ni8q0nM3VH/ugCEP22y','livreur',NULL,NULL,1,'2026-04-07 16:51:26','2026-04-08 01:41:43'),(4,'Mohamed Ben Ali','client@peinturepro.tn','$2b$12$D0m7kVyskYiHw0LtbniX7OXvkDYmDtwE8.ni8q0nM3VH/ugCEP22y','client','22 345 678',NULL,1,'2026-04-07 16:51:26','2026-04-21 19:41:06'),(6,'ines zaouam','ineszawam20@gmail.com','$2b$12$ocFPc/fDQVjCUkk9EO04X.RBkmNc83btvCsDdV.lcwL9lvWox7G8G','client','+21622966796','monastir',1,'2026-04-15 17:23:39',NULL),(7,'mhenni ayoub','mfayoubmhenni93@gmail.com','$2b$12$05DYpqNiLHYua0krJqGabOsqosABuuc2NuBT76nnys2PjiZNn6SQG','client','+21699143933','sayada city',1,'2026-04-18 17:12:59',NULL);
/*!40000 ALTER TABLE `utilisateurs` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-22 14:22:28
