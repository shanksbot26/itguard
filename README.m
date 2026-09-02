<p align="center">
  <img src="client_v2/public/assets/logo.png" width="140" alt="ITGUARD Logo" />
</p>

<h1 align="center">ITGUARD</h1>

<p align="center">
  <strong>Solusi Server DNS Proteksi Jaringan, Pemblokir Iklan, Pelacak & Kontrol Akses Mandiri</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Docker-Ready-blue?logo=docker" alt="Docker Ready" />
  <img src="https://img.shields.io/badge/Frontend-SolidJS-4f88c6?logo=solid" alt="SolidJS" />
  <img src="https://img.shields.io/badge/Backend-Go_1.26-00ADD8?logo=go" alt="Go" />
  <img src="https://img.shields.io/badge/Theme-Red_%26_Slate-E53935" alt="Theme" />
  <img src="https://img.shields.io/badge/License-GPL--3.0-green.svg" alt="License" />
</p>

---

## 📖 Tentang ITGUARD

**ITGUARD** adalah server DNS tingkat jaringan yang dirancang untuk melindungi seluruh perangkat di rumah atau kantor Anda dari iklan yang mengganggu, pelacak privasi (*trackers*), malware, dan phishing tanpa memerlukan instalasi aplikasi tambahan di perangkat klien.

Dengan antarmuka web modern berbasis **SolidJS** yang telah dikustomisasi secara khusus, ITGUARD memberikan kendali penuh terhadap lalu lintas jaringan Anda.

---

## ✨ Fitur Unggulan

- 🛡️ **Pemblokiran Tingkat Jaringan**: Memblokir iklan, pelacak, dan domain berbahaya untuk seluruh perangkat (HP, Laptop, Smart TV, IoT) yang terhubung ke jaringan.
- 🔒 **Protokol DNS Terenkripsi Modern**: Mendukung penuh protokol *DNS-over-HTTPS (DoH)*, *DNS-over-TLS (DoT)*, *DNS-over-QUIC (DoQ)*, dan *DNSCrypt*.
- 👨‍👩‍👧 **Parental Control & SafeSearch**: Memfilter konten dewasa dan memaksa mode pencarian aman di Google, Bing, YouTube, dan DuckDuckGo.
- 🌐 **Server DHCP Terintegrasi**: Mengatur alokasi IP dinamis dan statis untuk perangkat di jaringan lokal Anda.
- 🎨 **Dashboard Web Modern**: Antarmuka responsif dengan skema tema khusus **Red & Slate**, statistik real-time, dan log kueri interaktif.
- ⚡ **Ringan & Cepat**: Dibangun dengan performa tinggi menggunakan bahasa Go dan konsumsi sumber daya (RAM/CPU) yang sangat hemat.

---

## 🚀 Panduan Cepat Memulai (Docker)

Cara termudah dan paling direkomendasikan untuk menjalankan ITGUARD adalah menggunakan **Docker Compose**.

### 1. Prasyarat
- [Docker](https://docs.docker.com/get-docker/) (v20+ atau Docker Desktop)
- [Docker Compose](https://docs.docker.com/compose/) (v2+)

### 2. Jalankan ITGUARD
Clone repository ini dan jalankan perintah:

```bash
# Jalankan container di latar belakang
docker compose up -d --build
```

### 3. Akses Web UI
Buka browser Anda dan kunjungi:
* **Setup Pertama Kali (Wizard)**: [http://localhost:3000](http://localhost:3000) *(atau `http://IP_SERVER:3000`)*
* **Dashboard Admin**: [http://localhost:80](http://localhost:80) atau [http://localhost:3000](http://localhost:3000)

---

## 🛠️ Pengembangan Lokal (Development)

Jika Anda ingin memodifikasi tampilan frontend atau mengompilasi backend secara manual:

### Frontend (SolidJS UI)
```bash
# Masuk ke folder client_v2
cd client_v2

# Pasang dependensi
npm install

# Jalankan server pengembangan (Hot Reload)
npm start

# Kompilasi untuk produksi
npm run build-prod
```

### Backend (Go)
```bash
# Build binary ITGUARD
go build -ldflags="-s -w" -o itguard main.go

# Jalankan binary
./itguard -v
```

---

## 🔄 Otomatisasi Deployment (CI/CD)

Repository ini telah dilengkapi alur **CI/CD GitHub Actions** pada [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) menggunakan **Self-Hosted Runner**:

```
[Laptop Developer]                  [GitHub Actions]                  [Server VPS Anda]
   git push main    ───►   Triggers Workflow (.github)   ───►   docker compose up -d --build
```

Setiap kali ada perubahan yang di-*push* ke branch `main` atau `master`, server akan secara otomatis memperbarui kode, mengompilasi, dan me-restart container ITGUARD tanpa *downtime* manual.

---

## 🔌 Daftar Port Jaringan

| Port | Protokol | Fungsi |
| :--- | :--- | :--- |
| **53** | `TCP/UDP` | Layanan DNS Server Utama |
| **3000** | `TCP` | Halaman Setup Awal / Alternatif Web UI |
| **80** | `TCP` | Web Dashboard Admin (HTTP) |
| **443** | `TCP/UDP` | Web Dashboard Admin (HTTPS) & DNS-over-HTTPS (DoH) |
| **853** | `TCP/UDP` | DNS-over-TLS (DoT) & DNS-over-QUIC (DoQ) |
| **67, 68** | `UDP` | Layanan Server DHCP (Opsional) |

---

## 📁 Struktur Direktori Utama

```text
├── client_v2/             # Frontend Web UI (SolidJS, TypeScript, PostCSS)
│   ├── public/assets/     # Logo, Favicon, & Aset Grafis ITGUARD
│   └── src/
│       ├── common/styles/ # Palet Warna Khusus (adg.css, light.css, dark.css)
│       └── __locales/     # File Terjemahan Bahasa (70+ bahasa)
├── internal/              # Core DNS Engine, Logging, dan Backend Logic (Go)
├── build/static/          # Bundle Frontend Hasil Kompilasi
├── Dockerfile             # Multi-stage build image ITGUARD
├── docker-compose.yml     # Konfigurasi container service
└── .github/workflows/     # Script Pipeline CI/CD Otomatis
```

---

## 📄 Lisensi

ITGUARD didistribusikan di bawah lisensi open-source **GPL-3.0**. Lihat file [LICENSE.txt](LICENSE.txt) untuk informasi lisensi selengkapnya.
