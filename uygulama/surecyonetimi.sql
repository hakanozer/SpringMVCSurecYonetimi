-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 14 Eki 2017, 12:35:10
-- Sunucu sürümü: 10.1.25-MariaDB
-- PHP Sürümü: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `surecyonetimi`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `isSurecKulPro` (IN `kid` INT)  BEGIN
	
	SET @kid = kid;
	
	select * from isSureci as isu left join kullanici as kl on kl.kid = isu.kid left join kullanici as pkl on pkl.kid = isu.pid where isu.pid = @kid;

	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `isSurecPro` ()  BEGIN

	select * from isSureci as isu left join kullanici as kl on kl.kid = isu.kid left join kullanici as pkl on pkl.kid = isu.pid where isu.sDurum = 0 or isu.sDurum = 2;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `istatistikKulPro` (IN `kid` INT)  BEGIN
	
	SET @kid = kid;
	
	SELECT COUNT(sid) as bitirilenisToplam, (SELECT COUNT(sid) FROM issureci WHERE sDurum = 0 and pid = @kid) as aktifisToplam, (SELECT COUNT(mid) FROM surecmesajlari WHERE pid = @kid ) as mesajToplam ,  (SELECT COUNT(sid) FROM issureci WHERE bitisTarihi < now() and pid = @kid) as gecenisToplam FROM issureci WHERE sDurum = 1 AND pid = @kid;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `istatistikPro` ()  BEGIN
	
	
	SELECT COUNT(sid) as bitirilenisToplam, (SELECT COUNT(sid) FROM issureci WHERE sDurum = 0) as aktifisToplam, (SELECT COUNT(mid) FROM surecmesajlari) as mesajToplam ,  (SELECT COUNT(sid) FROM issureci WHERE bitisTarihi < now()) as gecenisToplam FROM issureci WHERE sDurum = 1;
	
	
	
	
	
	
	
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `isgruplari`
--

CREATE TABLE `isgruplari` (
  `iid` int(11) NOT NULL,
  `iadi` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  `gTarih` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `isgruplari`
--

INSERT INTO `isgruplari` (`iid`, `iadi`, `gTarih`) VALUES
(2, 'Yazılım', '2017-09-10 14:19:51'),
(4, 'Dedikodu', '2017-09-10 14:26:09'),
(5, 'hyr', '2017-09-11 02:42:48'),
(6, 'Tasarım', '2017-09-16 12:06:18'),
(7, 'Suat', '2017-09-16 14:36:34');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `isgruplariatama`
--

CREATE TABLE `isgruplariatama` (
  `gid` int(11) NOT NULL,
  `iid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `iTarih` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `isgruplariatama`
--

INSERT INTO `isgruplariatama` (`gid`, `iid`, `pid`, `iTarih`) VALUES
(1, 2, 3, '2017-09-16 12:00:30'),
(4, 4, 3, '2017-09-16 12:04:12'),
(6, 2, 2, '2017-09-16 12:05:45'),
(7, 4, 2, '2017-09-16 12:05:45'),
(8, 6, 2, '2017-09-16 12:06:33');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `issureci`
--

CREATE TABLE `issureci` (
  `sid` int(11) NOT NULL,
  `kid` int(11) NOT NULL COMMENT 'Müdürün id''si',
  `pid` int(11) NOT NULL COMMENT 'Personel id''s',
  `sBaslik` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  `sAciklama` text COLLATE utf8_turkish_ci NOT NULL,
  `baslamaTarihi` datetime NOT NULL,
  `bitisTarihi` datetime NOT NULL,
  `sDurum` int(1) NOT NULL COMMENT '0 ise iş başladı, 1 ise bitti, 2 ise askıya alındı'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `issureci`
--

INSERT INTO `issureci` (`sid`, `kid`, `pid`, `sBaslik`, `sAciklama`, `baslamaTarihi`, `bitisTarihi`, `sDurum`) VALUES
(1, 1, 2, 'Garanti Tasarım-', '<p>Tasarım ayrıntılı a&ccedil;ıklama</p>\r\n\r\n<hr />\r\n<p><a href=\"http://google.com.tr\">Google A&ccedil;</a></p>\r\n', '2017-09-28 07:30:00', '2017-10-09 07:30:00', 1),
(3, 1, 3, 'Afiş etiketi', '<p>Afiş i&ccedil;in gerekli işlemleri yapınız</p>\r\n', '2017-09-27 12:00:00', '2017-09-29 11:00:00', 0),
(4, 1, 3, 'Etiklet çalışması', '<p>Etikete hemen ihtiyacımız var</p>\r\n', '2017-09-25 12:00:00', '2017-09-27 11:00:00', 0),
(5, 1, 3, 'Etiketci', '<p>etiket <span class=\"marker\">işleri</span>,&nbsp;</p>\r\n\r\n<hr />\r\n<p>ve diğer&nbsp;</p>\r\n', '2017-09-24 12:00:00', '2017-09-24 11:59:59', 2),
(6, 1, 2, 'Garanti Tasarım', '<p>Garanti bankası i&ccedil;in &ouml;rnek yapılacak tasarım ayrıntısı</p>\r\n', '2017-10-01 12:00:00', '2017-10-10 11:00:00', 1),
(7, 1, 4, 'Colombiye Orginazsonu', '<p>Colombiya i&ccedil;in k&uuml;lt&uuml;r ve &Uuml;lkemizi tanıtım org.</p>\r\n', '2017-10-08 12:00:00', '2017-10-09 11:00:00', 0),
(8, 1, 4, 'Suat Pardon ama böyle insanlarda var', '<p>bu sana umarım &ouml;rnek olur.</p>\r\n\r\n<table border=\"1\" cellpadding=\"1\" cellspacing=\"1\" style=\"width:500px\">\r\n	<tbody>\r\n		<tr>\r\n			<td>Bak g&ouml;r</td>\r\n			<td><img alt=\"\" src=\"http://i.hurimg.com/i/hurriyet/75/620x350/5677c9f367b0a95998cebdc4.jpg\" style=\"height:350px; width:620px\" /></td>\r\n		</tr>\r\n		<tr>\r\n			<td>Yukarı bak</td>\r\n			<td>&nbsp;</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p>&nbsp;</p>\r\n', '2017-10-08 12:00:00', '2017-10-08 11:59:59', 0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kullanici`
--

CREATE TABLE `kullanici` (
  `kid` int(11) NOT NULL,
  `kUnvan` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  `kSeviye` int(1) NOT NULL,
  `kAdi` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  `kSoyadi` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  `kMail` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  `kSifre` varchar(32) COLLATE utf8_turkish_ci NOT NULL,
  `kTelefon` varchar(15) COLLATE utf8_turkish_ci NOT NULL,
  `kAdres` text COLLATE utf8_turkish_ci NOT NULL,
  `kTarih` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `kullanici`
--

INSERT INTO `kullanici` (`kid`, `kUnvan`, `kSeviye`, `kAdi`, `kSoyadi`, `kMail`, `kSifre`, `kTelefon`, `kAdres`, `kTarih`) VALUES
(1, 'Java 11 Şirketi-', 0, 'Ali', 'Bilmem', 'ali@ali.com', '827ccb0eea8a706c4c34a16891f84e7b', '05435556688', 'Wissen', '2017-08-13 06:19:18'),
(2, 'Tasarımcı', 2, 'Hasan', 'Bilsin', 'hasan@has.com', '827ccb0eea8a706c4c34a16891f84e7b', '090086073', 'Sivas', '2017-08-27 06:24:29'),
(3, 'Etiket', 2, 'Ayşe', 'Bilir', 'ayse@mail.com', '827ccb0eea8a706c4c34a16891f84e7b', '876543', 'kljhgfd', '2017-09-16 11:14:19'),
(4, 'Suat Şirketi', 2, 'Suat', 'Cezik', 'suatcezik@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', '87654', 'kj', '2017-10-01 13:28:59');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `surecmesajlari`
--

CREATE TABLE `surecmesajlari` (
  `mid` int(11) NOT NULL,
  `sid` int(11) NOT NULL COMMENT 'Süreç id''si burada tutulacak',
  `gonderenID` int(11) NOT NULL,
  `aliciID` int(11) NOT NULL,
  `mesajText` text COLLATE utf8_turkish_ci NOT NULL,
  `mesajDosya` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  `okunduDurum` int(1) NOT NULL COMMENT '0 ise okunmadı, 1 ise okundu',
  `mTarih` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `surecmesajlari`
--

INSERT INTO `surecmesajlari` (`mid`, `sid`, `gonderenID`, `aliciID`, `mesajText`, `mesajDosya`, `okunduDurum`, `mTarih`) VALUES
(1, 6, 1, 2, 'merhaba suat sen nasıl olurda bu hatayı yaparsın :)))', '', 0, '2017-10-01 13:01:38'),
(2, 6, 2, 1, 'slm ben hasan, suat akıllı dur', '', 0, '2017-10-01 13:03:02'),
(3, 6, 4, 2, 'mesaj alınsın', '', 0, '2017-10-01 13:29:31'),
(4, 6, 2, 1, 'cevap verildi', '', 0, '2017-10-01 13:30:27'),
(5, 6, 1, 2, 'sen ve suat ne kadar ', '', 0, '2017-10-01 14:04:55'),
(6, 6, 1, 2, 'sevgili suat, bir gece ansızın gelebilir.', '', 0, '2017-10-01 14:08:25'),
(7, 6, 1, 2, 'oalal', '', 0, '2017-10-08 10:15:12');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `isgruplari`
--
ALTER TABLE `isgruplari`
  ADD PRIMARY KEY (`iid`);

--
-- Tablo için indeksler `isgruplariatama`
--
ALTER TABLE `isgruplariatama`
  ADD PRIMARY KEY (`gid`);

--
-- Tablo için indeksler `issureci`
--
ALTER TABLE `issureci`
  ADD PRIMARY KEY (`sid`);

--
-- Tablo için indeksler `kullanici`
--
ALTER TABLE `kullanici`
  ADD PRIMARY KEY (`kid`);

--
-- Tablo için indeksler `surecmesajlari`
--
ALTER TABLE `surecmesajlari`
  ADD PRIMARY KEY (`mid`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `isgruplari`
--
ALTER TABLE `isgruplari`
  MODIFY `iid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- Tablo için AUTO_INCREMENT değeri `isgruplariatama`
--
ALTER TABLE `isgruplariatama`
  MODIFY `gid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- Tablo için AUTO_INCREMENT değeri `issureci`
--
ALTER TABLE `issureci`
  MODIFY `sid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- Tablo için AUTO_INCREMENT değeri `kullanici`
--
ALTER TABLE `kullanici`
  MODIFY `kid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- Tablo için AUTO_INCREMENT değeri `surecmesajlari`
--
ALTER TABLE `surecmesajlari`
  MODIFY `mid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
