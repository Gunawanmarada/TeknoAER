-- Tekno-AER database reconstruction.
-- Reconstructed from the application source; this script has NOT been executed.
-- Review the target name before running. CREATE DATABASE intentionally has no IF NOT EXISTS.

CREATE DATABASE teknoaer
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE teknoaer;

CREATE TABLE `user` (
  user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama_lengkap VARCHAR(255) NOT NULL,
  username VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  foto_profil VARCHAR(255) NOT NULL DEFAULT 'default.jpg',
  PRIMARY KEY (user_id),
  UNIQUE KEY uq_user_username (username),
  UNIQUE KEY uq_user_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE admin (
  admin_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama_lengkap VARCHAR(255) NOT NULL,
  username VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL DEFAULT 'admin',
  foto_profil VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (admin_id),
  UNIQUE KEY uq_admin_username (username),
  UNIQUE KEY uq_admin_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pengantar (
  pengantar_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama VARCHAR(255) NOT NULL,
  username VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL,
  foto_profil VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (pengantar_id),
  UNIQUE KEY uq_pengantar_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE barang (
  barang_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama_barang VARCHAR(255) NOT NULL,
  kategori VARCHAR(100) NOT NULL,
  kondisi VARCHAR(100) NOT NULL,
  keterangan TEXT NOT NULL,
  harga DECIMAL(14,2) UNSIGNED NOT NULL DEFAULT 0.00,
  gambar VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (barang_id),
  KEY idx_barang_nama (nama_barang),
  KEY idx_barang_kategori (kategori)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE keranjang (
  keranjang_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  barang_id INT UNSIGNED NOT NULL,
  nama_barang VARCHAR(255) NOT NULL,
  harga DECIMAL(14,2) UNSIGNED NOT NULL DEFAULT 0.00,
  jumlah INT UNSIGNED NOT NULL DEFAULT 1,
  alamat VARCHAR(500) NOT NULL DEFAULT '',
  PRIMARY KEY (keranjang_id),
  UNIQUE KEY uq_keranjang_user_barang (user_id, barang_id),
  KEY idx_keranjang_barang (barang_id),
  CONSTRAINT fk_keranjang_user
    FOREIGN KEY (user_id) REFERENCES `user` (user_id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_keranjang_barang
    FOREIGN KEY (barang_id) REFERENCES barang (barang_id)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pesanan_pelanggan (
  id_pesanan INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  nama_pelanggan VARCHAR(255) NOT NULL,
  barang_id INT UNSIGNED NOT NULL,
  nama_barang VARCHAR(255) NOT NULL,
  jumlah INT UNSIGNED NOT NULL DEFAULT 1,
  harga DECIMAL(14,2) UNSIGNED NOT NULL DEFAULT 0.00,
  total DECIMAL(14,2) UNSIGNED NOT NULL DEFAULT 0.00,
  alamat_pengiriman TEXT NOT NULL,
  alamat VARCHAR(500) NOT NULL DEFAULT '',
  tanggal_pesanan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  harga_total DECIMAL(14,2) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (id_pesanan, user_id, barang_id),
  KEY idx_pesanan_pelanggan_user (user_id, id_pesanan),
  KEY idx_pesanan_pelanggan_barang (barang_id),
  CONSTRAINT fk_pesanan_pelanggan_user
    FOREIGN KEY (user_id) REFERENCES `user` (user_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pesanan_pelanggan_barang
    FOREIGN KEY (barang_id) REFERENCES barang (barang_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pesanan_saya (
  id_pesanan INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  barang_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (id_pesanan, user_id, barang_id),
  KEY idx_pesanan_saya_user (user_id),
  KEY idx_pesanan_saya_barang (barang_id),
  CONSTRAINT fk_pesanan_saya_user
    FOREIGN KEY (user_id) REFERENCES `user` (user_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pesanan_saya_barang
    FOREIGN KEY (barang_id) REFERENCES barang (barang_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pesanan_dikirim (
  id_kirim INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_pesanan INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  barang_id INT UNSIGNED NOT NULL,
  nama_barang VARCHAR(255) NOT NULL,
  jumlah INT UNSIGNED NOT NULL DEFAULT 1,
  harga DECIMAL(14,2) UNSIGNED NULL DEFAULT NULL,
  harga_total DECIMAL(14,2) UNSIGNED NOT NULL DEFAULT 0.00,
  total DECIMAL(14,2) UNSIGNED NULL DEFAULT NULL,
  alamat_pengiriman TEXT NOT NULL,
  pengantar_id INT UNSIGNED NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'dikirim',
  waktu DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_kirim),
  KEY idx_pesanan_dikirim_group (id_pesanan),
  KEY idx_pesanan_dikirim_user (user_id, id_kirim),
  KEY idx_pesanan_dikirim_barang (barang_id),
  KEY idx_pesanan_dikirim_pengantar_status (pengantar_id, status),
  CONSTRAINT fk_pesanan_dikirim_user
    FOREIGN KEY (user_id) REFERENCES `user` (user_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pesanan_dikirim_barang
    FOREIGN KEY (barang_id) REFERENCES barang (barang_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pesanan_dikirim_pengantar
    FOREIGN KEY (pengantar_id) REFERENCES pengantar (pengantar_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pesanan_selesai (
  id_selesai INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  barang_id INT UNSIGNED NOT NULL,
  nama_barang VARCHAR(255) NOT NULL,
  jumlah INT UNSIGNED NOT NULL DEFAULT 1,
  harga_total DECIMAL(14,2) UNSIGNED NOT NULL DEFAULT 0.00,
  PRIMARY KEY (id_selesai),
  KEY idx_pesanan_selesai_user_barang (user_id, barang_id),
  KEY idx_pesanan_selesai_barang (barang_id),
  CONSTRAINT fk_pesanan_selesai_user
    FOREIGN KEY (user_id) REFERENCES `user` (user_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_pesanan_selesai_barang
    FOREIGN KEY (barang_id) REFERENCES barang (barang_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE review (
  id_review INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  barang_id INT UNSIGNED NOT NULL,
  rating TINYINT UNSIGNED NULL DEFAULT NULL,
  komentar TEXT NOT NULL,
  tanggal DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  balasan_admin TEXT NULL DEFAULT NULL,
  admin_id INT UNSIGNED NULL DEFAULT NULL,
  waktu_balas DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (id_review),
  UNIQUE KEY uq_review_user_barang (user_id, barang_id),
  KEY idx_review_barang_tanggal (barang_id, tanggal),
  KEY idx_review_admin (admin_id),
  CONSTRAINT fk_review_user
    FOREIGN KEY (user_id) REFERENCES `user` (user_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_review_barang
    FOREIGN KEY (barang_id) REFERENCES barang (barang_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_review_admin
    FOREIGN KEY (admin_id) REFERENCES admin (admin_id)
    ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notifikasi_user (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  pesan TEXT NOT NULL,
  status_baca TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_notifikasi_user_date (user_id, created_at),
  CONSTRAINT fk_notifikasi_user
    FOREIGN KEY (user_id) REFERENCES `user` (user_id)
    ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE data_keuangan (
  id_keuangan INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  nama_pelanggan VARCHAR(255) NOT NULL,
  nama_barang VARCHAR(255) NOT NULL,
  total DECIMAL(14,2) UNSIGNED NOT NULL DEFAULT 0.00,
  PRIMARY KEY (id_keuangan),
  KEY idx_data_keuangan_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE penjelasan_pengiriman (
  id_penjelasan INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  nama_pelanggan VARCHAR(255) NOT NULL,
  nama_barang VARCHAR(255) NOT NULL,
  alasan TEXT NOT NULL,
  PRIMARY KEY (id_penjelasan),
  KEY idx_penjelasan_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE riwayat_pengiriman (
  id_riwayat INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_kirim INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  barang_id INT UNSIGNED NOT NULL,
  nama_barang VARCHAR(255) NOT NULL,
  jumlah INT UNSIGNED NOT NULL DEFAULT 1,
  harga DECIMAL(14,2) UNSIGNED NOT NULL DEFAULT 0.00,
  total DECIMAL(14,2) UNSIGNED NOT NULL DEFAULT 0.00,
  alamat_pengiriman TEXT NOT NULL,
  pengantar_id INT UNSIGNED NOT NULL,
  status VARCHAR(50) NOT NULL,
  waktu_selesai DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  catatan TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id_riwayat),
  KEY idx_riwayat_user_kirim (user_id, id_kirim),
  KEY idx_riwayat_kirim (id_kirim),
  KEY idx_riwayat_pengantar (pengantar_id),
  KEY idx_riwayat_selesai (waktu_selesai),
  KEY idx_riwayat_barang (barang_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Role/account types are represented by separate tables: admin, pengantar, and user.
-- No login accounts are seeded because the current source stores/compares passwords insecurely.

-- Illustrative product catalog; product photographs are credited in DATABASE_ANALYSIS.md.
-- Product names, descriptions, condition, and prices are sample data, not verified inventory.
INSERT INTO barang (nama_barang, kategori, kondisi, keterangan, harga, gambar) VALUES
('Laptop Produktivitas 14 Inch', 'Komputer', 'Baru', 'Laptop untuk pekerjaan harian, belajar, dan produktivitas.', 12999000.00, 'produk-laptop.webp'),
('Smartphone Layar Sentuh', 'Ponsel', 'Baru', 'Ponsel pintar untuk komunikasi, aplikasi, dan hiburan.', 4999000.00, 'produk-smartphone.jpg'),
('Tablet Serbaguna 10 Inch', 'Komputer', 'Baru', 'Tablet untuk membaca, belajar, dan menikmati konten digital.', 3499000.00, 'produk-tablet.jpg'),
('Headphone Nirkabel', 'Audio', 'Baru', 'Headphone nirkabel untuk mendengarkan musik dan rapat daring.', 599000.00, 'produk-headphone-wireless.jpg'),
('Keyboard USB', 'Aksesori Komputer', 'Baru', 'Keyboard USB untuk komputer desktop dan laptop.', 450000.00, 'produk-keyboard.jpg'),
('Mouse Optik USB', 'Aksesori Komputer', 'Baru', 'Mouse optik untuk navigasi komputer sehari-hari.', 275000.00, 'produk-mouse.jpg'),
('Monitor LED 24 Inch', 'Komputer', 'Baru', 'Monitor LED untuk ruang kerja dan penggunaan komputer.', 2799000.00, 'produk-monitor.png'),
('Webcam HD', 'Aksesori Komputer', 'Baru', 'Webcam untuk panggilan video dan konferensi daring.', 425000.00, 'produk-webcam.jpg'),
('Router Wi-Fi Dual Band', 'Jaringan', 'Baru', 'Router nirkabel untuk berbagi koneksi internet di rumah.', 650000.00, 'produk-router-wifi.jpg'),
('Printer Multifungsi', 'Perangkat Kantor', 'Baru', 'Printer untuk kebutuhan cetak dokumen rumahan atau kantor.', 1799000.00, 'produk-printer.jpg'),
('SSD Eksternal 1 TB', 'Penyimpanan', 'Baru', 'Penyimpanan SSD eksternal untuk mencadangkan dan membawa berkas.', 899000.00, 'produk-ssd.jpg'),
('Flashdisk USB 128 GB', 'Penyimpanan', 'Baru', 'Media penyimpanan USB portabel untuk memindahkan berkas.', 155000.00, 'produk-flashdisk.jpg'),
('Powerbank 20000 mAh', 'Aksesori Ponsel', 'Baru', 'Baterai portabel untuk mengisi daya perangkat saat bepergian.', 399000.00, 'produk-powerbank.jpg'),
('Speaker Bluetooth Portabel', 'Audio', 'Baru', 'Speaker portabel untuk memutar audio melalui koneksi Bluetooth.', 525000.00, 'produk-speaker-bluetooth.jpg'),
('Smartwatch Digital', 'Perangkat Pintar', 'Baru', 'Jam tangan pintar untuk melihat waktu dan notifikasi perangkat.', 1299000.00, 'produk-smartwatch.jpg');
