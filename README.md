# ITGuard — AdGuard Home rebrand for Docker

ITGuard adalah **rebrand UI saja** dari AdGuard Home. Backend DNS/filtering tetap dibangun dari source resmi `AdguardTeam/AdGuardHome`, sedangkan nama produk, logo sidebar/header, favicon, string browser-facing `AdGuard Home`, dan **warna aksen frontend** diubah menjadi **ITGuard**.

Default paket ini dipin ke **AdGuard Home v0.107.79**.

## Arsitektur build

1. Docker meng-clone tag resmi `AdguardTeam/AdGuardHome` sesuai `AGH_VERSION`.
2. `branding/patch_branding.py` memodifikasi **frontend `client_v2`** saja.
3. `make` upstream membangun frontend + binary AdGuard Home.
4. Stage runtime memakai **image resmi `adguard/adguardhome:<versi>`**, lalu binary hasil build dengan frontend ITGuard menggantikan binary di image tersebut.
5. Entrypoint, CMD, direktori konfigurasi, runtime packages, dan layout image tetap diwarisi dari image resmi.

## File penting

- `Dockerfile` — multi-stage build + official AdGuard Home runtime image.
- `docker-compose.yml` — menjalankan container `itguard`.
- `branding/original-logo.png` — logo yang diberikan untuk project ini.
- `branding/itguard-mark.png` — simbol yang dipakai sebagai favicon.
- `branding/itguard-header.png` — lockup logo + tulisan ITGuard.
- `branding/patch_branding.py` — patch frontend + tema ITGuard (merah/abu-abu).
- `data/conf` — konfigurasi persisten.
- `data/work` — work data persisten.

## 1. Persyaratan server

Debian/Ubuntu dengan Docker Engine dan Docker Compose plugin.

Cek:

```bash
docker --version
docker compose version
```

Jika Docker belum ada, paket menyertakan convenience script. **Review dahulu** lalu jalankan:

```bash
sudo ./install-docker-ubuntu.sh
```

## 2. Cek port 53 sebelum start

DNS membutuhkan TCP/UDP port 53. Cek apakah sudah dipakai:

```bash
sudo ss -lntup | grep ':53 ' || true
```

Pada sebagian Ubuntu, `systemd-resolved` memakai port 53 lokal. Jangan mematikan resolver secara sembarang pada server remote. Selesaikan konflik port 53 sesuai rancangan DNS server Anda terlebih dahulu.

## 3. Build ITGuard

```bash
chmod +x *.sh
./build.sh
```

Build pertama mengunduh source upstream, Go/Node dependencies, dan image Docker sehingga membutuhkan internet dan dapat memakan waktu beberapa menit.

## 4. Jalankan

```bash
./start.sh
```

Kemudian buka:

```text
http://IP-SERVER:3000
```

Selesaikan setup awal. Port utama yang dipublish oleh Compose:

- `53/tcp` dan `53/udp` — DNS
- `3000/tcp` — initial setup / alternate web UI
- `80/tcp` — HTTP admin UI jika dikonfigurasi
- `443/tcp` + `443/udp` — HTTPS/DoH/HTTP3 bila dikonfigurasi
- `853/tcp` + `853/udp` — DoT/DoQ bila dikonfigurasi

## 5. Status dan log

```bash
./status.sh
# atau
docker compose logs -f itguard
```

## 6. Stop

```bash
./stop.sh
```

Data konfigurasi tidak hilang karena tersimpan di `./data/conf` dan `./data/work`.

## 7. Update versi upstream

Paket sengaja tidak auto-update source. Untuk berpindah ke tag upstream tertentu:

```bash
./update.sh v0.107.80
```

Sebelum update, script membuat backup `data/conf`, `data/work`, dan `.env` ke folder `backups/`.

**Penting:** struktur frontend AdGuard Home dapat berubah. Patch akan **fail closed** jika komponen logo `client_v2` yang diharapkan tidak ditemukan, agar image baru tidak diam-diam kembali menampilkan logo upstream.

## DHCP

Port DHCP 67/68 tidak dipublish secara default. Jika Anda ingin memakai DHCP server AdGuard Home, Docker host networking biasanya lebih sesuai karena DHCP menggunakan broadcast. Rancang network mode secara terpisah sebelum mengaktifkannya.

## Scope rebranding

Yang diubah:

- Logo header/sidebar/public header menjadi ITGuard.
- Favicon/touch icon menjadi simbol ITGuard.
- Teks browser-facing `AdGuard Home` di frontend menjadi `ITGuard`.
- Aksen hijau utama AdGuard diubah menjadi merah ITGuard `#ED1C24`.
- Aksen sekunder/tersier ungu/biru produk diubah menjadi abu-abu netral agar sesuai logo.
- Warna semantik seperti peringatan/error tetap dipertahankan agar status keamanan tetap mudah dibedakan.

Yang **tidak** diubah:

- DNS engine.
- Filtering engine.
- API/backend behavior.
- Format `AdGuardHome.yaml`.
- Path runtime resmi `/opt/adguardhome/...`.
- Nama internal binary/API yang diperlukan kompatibilitas.

Karena itu beberapa nama teknis/internal (misalnya file `AdGuardHome.yaml` atau output versi binary) tetap memakai nama upstream. Itu disengaja agar kompatibilitas tidak rusak.

## Keamanan

Jangan expose dashboard admin langsung ke internet tanpa kontrol akses yang sesuai. Untuk jaringan internal, batasi firewall hanya ke subnet yang perlu memakai DNS/admin UI. Gunakan HTTPS jika dashboard diakses melewati jaringan yang tidak sepenuhnya dipercaya.

## Lisensi

Lihat `LICENSE-NOTICE.md`. AdGuard Home adalah GPL-3.0. Paket ini berisi patch/branding dan mengambil source upstream saat build; jika Anda mendistribusikan image/binary hasil modifikasi, pastikan kewajiban GPL-3.0 dipenuhi.


## ITGuard RBAC

Paket ini juga menambahkan dua role login: **Administrator** dan **Viewer**.
Akun lama tanpa field `role` otomatis diperlakukan sebagai Administrator.
Lihat `ITGUARD-RBAC.md` untuk migrasi, keamanan, pengujian, dan rollback.

> Catatan: versi RBAC bukan lagi rebrand frontend murni. DNS/filtering engine tetap
> upstream AdGuard Home, tetapi lapisan autentikasi/otorisasi mendapat ekstensi ITGuard.
