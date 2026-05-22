import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/litari_logo.dart';

// ════════════════════════════════════════════════════════════════
//  BANK SOAL — tambah item di sini untuk memperluas konten
// ════════════════════════════════════════════════════════════════

/// Satu pasangan kata Indonesia ↔ Sunda.
/// Tambah baris baru di [_bankPasangan] untuk memperluas bank.
class PasanganKata {
  final String indonesia;
  final String sunda;
  const PasanganKata(this.indonesia, this.sunda);
}

/// Satu soal pilih-gambar.
/// Tambah item baru di [_bankGambar] untuk memperluas bank.
class GambarSoal {
  final String kataKunci;           // kata Sunda yang ditampilkan
  final List<String> emoji;         // tepat 4 emoji pilihan
  final int indexBenar;             // index jawaban yang benar di [emoji]
  const GambarSoal({
    required this.kataKunci,
    required this.emoji,
    required this.indexBenar,
  });
}

// ─── Bank Pasangan Kata ───────────────────────────────────────
// Perlu minimal 4 pasangan agar setiap soal PilihPasangan bisa
// menampilkan 4 pilihan acak. Semakin banyak, semakin beragam.

const List<PasanganKata> _bankPasangan = [
  // Pertanyaan & sapaan
  PasanganKata('Dari mana',  'Timana'),
  PasanganKata('Kemana',     'Kamana'),
  PasanganKata('Kapan',      'Iraha'),
  PasanganKata('Permisi',    'Punten'),
  PasanganKata('Silahkan',   'Mangga'),
  PasanganKata('Terima kasih','Hatur nuhun'),
  PasanganKata('Sama-sama',  'Sami-sami'),
  // Kegiatan sehari-hari
  PasanganKata('Makan',      'Dahar'),
  PasanganKata('Minum',      'Nginum'),
  PasanganKata('Tidur',      'Sare'),
  PasanganKata('Berjalan',   'Leumpang'),
  PasanganKata('Duduk',      'Diuk'),
  PasanganKata('Berlari',    'Lumpat'),
  PasanganKata('Membaca',    'Maca'),
  PasanganKata('Menulis',    'Nulis'),
  // Benda & alam
  PasanganKata('Rumah',      'Imah'),
  PasanganKata('Air',        'Cai'),
  PasanganKata('Api',        'Seuneu'),
  PasanganKata('Batu',       'Batu'),
  PasanganKata('Pohon',      'Tangkal'),
  PasanganKata('Bulan',      'Bulan'),
  PasanganKata('Matahari',   'Panonpoe'),
  // Sifat
  PasanganKata('Bagus',      'Alus'),
  PasanganKata('Besar',      'Gede'),
  PasanganKata('Kecil',      'Leutik'),
  PasanganKata('Jauh',       'Jauh'),
  PasanganKata('Dekat',      'Deukeut'),
  // Angka
  PasanganKata('Satu',       'Hiji'),
  PasanganKata('Dua',        'Dua'),
  PasanganKata('Tiga',       'Tilu'),
  PasanganKata('Empat',      'Opat'),
  PasanganKata('Lima',       'Lima'),
];

// ─── Bank Gambar ──────────────────────────────────────────────
// Setiap item HARUS memiliki tepat 4 emoji.
// Pastikan indexBenar sesuai posisi jawaban di list emoji.

const List<GambarSoal> _bankGambar = [
  GambarSoal(kataKunci: 'Imah',     emoji: ['🍳','🏠','🔪','🐟'], indexBenar: 1),
  GambarSoal(kataKunci: 'Ucing',    emoji: ['🐶','🐱','🐸','🐦'], indexBenar: 1),
  GambarSoal(kataKunci: 'Cai',      emoji: ['💧','🔥','🌍','🍃'], indexBenar: 0),
  GambarSoal(kataKunci: 'Seuneu',   emoji: ['💧','🔥','🌳','⛄'], indexBenar: 1),
  GambarSoal(kataKunci: 'Hayam',    emoji: ['🐄','🐔','🐟','🐘'], indexBenar: 1),
  GambarSoal(kataKunci: 'Bulan',    emoji: ['☀️','⭐','🌙','🌈'], indexBenar: 2),
  GambarSoal(kataKunci: 'Buku',     emoji: ['📕','🖊️','📐','🎒'], indexBenar: 0),
  GambarSoal(kataKunci: 'Tangkal',  emoji: ['🌸','🌲','🍄','🌾'], indexBenar: 1),
  GambarSoal(kataKunci: 'Panonpoe', emoji: ['🌙','🌈','☀️','⭐'], indexBenar: 2),
  GambarSoal(kataKunci: 'Anjing',   emoji: ['🐱','🐶','🐰','🦊'], indexBenar: 1),
];

// ════════════════════════════════════════════════════════════════
//  MODEL SOAL (runtime — dibuat oleh generator)
// ════════════════════════════════════════════════════════════════

enum TipeSoal { pilihPasangan, pilihGambar }

class Soal {
  final TipeSoal tipe;

  // PilihPasangan
  final List<String> opsiKiri;
  final List<String> opsiKanan;       // sudah diacak saat dibuat
  final Map<String, String> jawaban;  // kiri → kanan yang benar

  // PilihGambar
  final String? kataKunci;
  final List<String> gambarEmoji;     // sudah diacak saat dibuat
  final int? indexBenar;

  const Soal._({
    required this.tipe,
    this.opsiKiri = const [],
    this.opsiKanan = const [],
    this.jawaban = const {},
    this.kataKunci,
    this.gambarEmoji = const [],
    this.indexBenar,
  });
}

// ════════════════════════════════════════════════════════════════
//  GENERATOR SOAL
// ════════════════════════════════════════════════════════════════

/// Jumlah soal per sesi latihan.
const int _jumlahSoal = 10;

/// Jumlah pasangan per soal PilihPasangan.
const int _pasanganPerSoal = 4;

/// Buat daftar [_jumlahSoal] soal acak dari kedua bank.
/// Komposisi: 6 PilihPasangan + 4 PilihGambar, lalu dikocok.
List<Soal> _buatDaftarSoal(Random rand) {
  final soalList = <Soal>[];

  // ── 6 soal PilihPasangan ──────────────────────────────────
  // Kocok semua pasangan lalu ambil berurutan dengan jendela geser
  // sehingga antar soal tidak banyak mengulang pasangan yang sama.
  final semuaPasangan = List<PasanganKata>.from(_bankPasangan)..shuffle(rand);

  // Jika bank tidak cukup untuk 6×4 tanpa pengulangan, putar ulang.
  final diperlukan = 6 * _pasanganPerSoal;
  while (semuaPasangan.length < diperlukan) {
    final tambahan = List<PasanganKata>.from(_bankPasangan)..shuffle(rand);
    semuaPasangan.addAll(tambahan);
  }

  for (int i = 0; i < 6; i++) {
    final mulai = i * _pasanganPerSoal;
    final picked = semuaPasangan.sublist(mulai, mulai + _pasanganPerSoal);

    final opsiKiri = picked.map((p) => p.indonesia).toList();
    final opsiKanan = picked.map((p) => p.sunda).toList()..shuffle(rand);
    final jawaban = {for (final p in picked) p.indonesia: p.sunda};

    soalList.add(Soal._(
      tipe: TipeSoal.pilihPasangan,
      opsiKiri: opsiKiri,
      opsiKanan: opsiKanan,
      jawaban: jawaban,
    ));
  }

  // ── 4 soal PilihGambar ────────────────────────────────────
  final gambarAcak = List<GambarSoal>.from(_bankGambar)..shuffle(rand);
  final gambarDipilih = gambarAcak.take(4).toList();

  for (final g in gambarDipilih) {
    // Kocok emoji agar posisi jawaban tidak selalu sama
    final indexed = List.generate(g.emoji.length, (i) => i)..shuffle(rand);
    final emojiAcak = indexed.map((i) => g.emoji[i]).toList();
    final indexBaru = indexed.indexOf(g.indexBenar);

    soalList.add(Soal._(
      tipe: TipeSoal.pilihGambar,
      kataKunci: g.kataKunci,
      gambarEmoji: emojiAcak,
      indexBenar: indexBaru,
    ));
  }

  // Kocok 10 soal agar tipe tidak berurutan monoton
  soalList.shuffle(rand);
  return soalList;
}

// ════════════════════════════════════════════════════════════════
//  MAIN SCREEN
// ════════════════════════════════════════════════════════════════

class LatihanScreen extends StatefulWidget {
  final String bahasaKey;
  const LatihanScreen({super.key, required this.bahasaKey});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> {
  late final List<Soal> _soalList;
  int  _soalIndex = 0;
  int  _benar     = 0;
  int  _salah     = 0;
  bool _selesai   = false;

  // Timer
  late Stopwatch _stopwatch;
  late Timer     _timer;
  String _waktu = '0:00';

  @override
  void initState() {
    super.initState();
    _soalList = _buatDaftarSoal(Random());
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final m = _stopwatch.elapsed.inMinutes;
        final s = _stopwatch.elapsed.inSeconds % 60;
        _waktu = '$m:${s.toString().padLeft(2, '0')}';
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _onJawaban(bool benar) {
    setState(() => benar ? _benar++ : _salah++);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        if (_soalIndex < _soalList.length - 1) {
          _soalIndex++;
        } else {
          _selesai = true;
          _stopwatch.stop();
          _timer.cancel();
        }
      });
    });
  }

  double get _progress => (_soalIndex + 1) / _soalList.length;

  @override
  Widget build(BuildContext context) {
    if (_selesai) {
      return HasilScreen(benar: _benar, salah: _salah, waktu: _waktu);
    }

    final soal = _soalList[_soalIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header: tombol tutup + progress bar ──────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.white54, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 10,
                        backgroundColor: const Color(0xFF3D4560),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nomor soal
                  Text(
                    '${_soalIndex + 1}/${_soalList.length}',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),

            // ── Konten soal ───────────────────────────────────
            Expanded(
              // Key memastikan widget direset saat berpindah soal
              key: ValueKey(_soalIndex),
              child: soal.tipe == TipeSoal.pilihPasangan
                  ? _PilihPasanganWidget(soal: soal, onJawaban: _onJawaban)
                  : _PilihGambarWidget(soal: soal, onJawaban: _onJawaban),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  WIDGET: PILIH PASANGAN
// ════════════════════════════════════════════════════════════════

class _PilihPasanganWidget extends StatefulWidget {
  final Soal soal;
  final void Function(bool) onJawaban;
  const _PilihPasanganWidget({required this.soal, required this.onJawaban});

  @override
  State<_PilihPasanganWidget> createState() => _PilihPasanganWidgetState();
}

class _PilihPasanganWidgetState extends State<_PilihPasanganWidget> {
  String? _pilihanKiri;
  String? _pilihanKanan;
  final Map<String, _ItemState> _stateKiri  = {};
  final Map<String, _ItemState> _stateKanan = {};
  bool _periksaDone = false;

  void _pilihKiri(String val) {
    if (_stateKiri[val] == _ItemState.benar) return;
    setState(() => _pilihanKiri = val);
    _cekPasangan();
  }

  void _pilihKanan(String val) {
    if (_stateKanan[val] == _ItemState.benar) return;
    setState(() => _pilihanKanan = val);
    _cekPasangan();
  }

  void _cekPasangan() {
    if (_pilihanKiri == null || _pilihanKanan == null) return;
    final cocok = widget.soal.jawaban[_pilihanKiri] == _pilihanKanan;
    final kiri  = _pilihanKiri!;
    final kanan = _pilihanKanan!;
    setState(() {
      _pilihanKiri  = null;
      _pilihanKanan = null;
      if (cocok) {
        _stateKiri[kiri]   = _ItemState.benar;
        _stateKanan[kanan] = _ItemState.benar;
      } else {
        _stateKiri[kiri]   = _ItemState.salah;
        _stateKanan[kanan] = _ItemState.salah;
        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) return;
          setState(() {
            _stateKiri.remove(kiri);
            _stateKanan.remove(kanan);
          });
        });
      }
    });
  }

  void _periksa() {
    if (_periksaDone) return;
    final total = widget.soal.opsiKiri.length;
    final cocok = _stateKiri.values.where((s) => s == _ItemState.benar).length;
    setState(() => _periksaDone = true);
    widget.onJawaban(cocok == total);
  }

  bool get _semuaCocok =>
      _stateKiri.values.where((s) => s == _ItemState.benar).length ==
      widget.soal.opsiKiri.length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Pilih pasangan yang cocok',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cocokkan kata Indonesia dengan bahasa Sunda-nya',
            style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 14),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                // Kolom kiri (Indonesia)
                Expanded(
                  child: Column(
                    children: widget.soal.opsiKiri.map((kata) {
                      final state = _pilihanKiri == kata
                          ? _ItemState.dipilih
                          : (_stateKiri[kata] ?? _ItemState.normal);
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: _WordButton(
                            text: kata,
                            state: state,
                            onTap: () => _pilihKiri(kata),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 12),
                // Kolom kanan (Sunda)
                Expanded(
                  child: Column(
                    children: widget.soal.opsiKanan.map((kata) {
                      final state = _pilihanKanan == kata
                          ? _ItemState.dipilih
                          : (_stateKanan[kata] ?? _ItemState.normal);
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: _WordButton(
                            text: kata,
                            state: state,
                            onTap: () => _pilihKanan(kata),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _semuaCocok ? _periksa : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: const Color(0xFF3D4560),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Periksa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── State & tombol kata ──────────────────────────────────────

enum _ItemState { normal, dipilih, benar, salah }

class _WordButton extends StatelessWidget {
  final String text;
  final _ItemState state;
  final VoidCallback onTap;
  const _WordButton({
    required this.text,
    required this.state,
    required this.onTap,
  });

  Color get _borderColor {
    switch (state) {
      case _ItemState.dipilih: return const Color(0xFF5C6BC0);
      case _ItemState.benar:   return const Color(0xFF4CAF50);
      case _ItemState.salah:   return const Color(0xFFE53935);
      default:                 return AppColors.inputBorder;
    }
  }

  Color get _bgColor {
    switch (state) {
      case _ItemState.dipilih: return const Color(0xFF1A1F3A);
      case _ItemState.benar:   return const Color(0xFF1B3A1F);
      case _ItemState.salah:   return const Color(0xFF3A1B1B);
      default:                 return AppColors.surface;
    }
  }

  Color get _textColor {
    switch (state) {
      case _ItemState.benar: return const Color(0xFF4CAF50);
      case _ItemState.salah: return const Color(0xFFE53935);
      default:               return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state == _ItemState.benar ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor, width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: _textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  WIDGET: PILIH GAMBAR
// ════════════════════════════════════════════════════════════════

class _PilihGambarWidget extends StatefulWidget {
  final Soal soal;
  final void Function(bool) onJawaban;
  const _PilihGambarWidget({required this.soal, required this.onJawaban});

  @override
  State<_PilihGambarWidget> createState() => _PilihGambarWidgetState();
}

class _PilihGambarWidgetState extends State<_PilihGambarWidget> {
  int?  _dipilih;
  bool  _sudahJawab = false;

  void _pilih(int index) {
    if (_sudahJawab) return;
    final benar = index == widget.soal.indexBenar;
    setState(() {
      _dipilih    = index;
      _sudahJawab = true;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      widget.onJawaban(benar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Pilih gambar yang benar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gambar mana yang sesuai dengan kata di bawah?',
            style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 14),
          ),
          const SizedBox(height: 20),
          // Chip kata kunci
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inputBorder, width: 1.5),
            ),
            child: Text(
              widget.soal.kataKunci ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Grid 2×2
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(widget.soal.gambarEmoji.length, (i) {
                final isBenar   = i == widget.soal.indexBenar;
                final isDipilih = _dipilih == i;

                Color borderColor = AppColors.inputBorder;
                Color bgColor     = AppColors.surface;
                if (_sudahJawab && isDipilih) {
                  borderColor = isBenar ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
                  bgColor     = isBenar ? const Color(0xFF1B3A1F) : const Color(0xFF3A1B1B);
                }

                return GestureDetector(
                  onTap: () => _pilih(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          widget.soal.gambarEmoji[i],
                          style: const TextStyle(fontSize: 60),
                        ),
                        if (_sudahJawab && isDipilih)
                          Positioned(
                            bottom: 10,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isBenar
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFE53935),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isBenar ? Icons.check : Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  HASIL SCREEN
// ════════════════════════════════════════════════════════════════

class HasilScreen extends StatelessWidget {
  final int benar;
  final int salah;
  final String waktu;
  const HasilScreen({
    super.key,
    required this.benar,
    required this.salah,
    required this.waktu,
  });

  int get _bintang {
    final total = benar + salah;
    if (total == 0) return 3;
    final persen = benar / total;
    if (persen >= 0.9) return 5;
    if (persen >= 0.7) return 4;
    if (persen >= 0.5) return 3;
    if (persen >= 0.3) return 2;
    return 1;
  }

  String get _pesan {
    switch (_bintang) {
      case 5: return 'Luar biasa! 🎉';
      case 4: return 'Kerja bagus! 👏';
      case 3: return 'Cukup baik! 💪';
      case 2: return 'Terus berlatih! 📚';
      default: return 'Jangan menyerah! 🔥';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Maskot
            SizedBox(
              width: 120,
              height: 120,
              child: CustomPaint(painter: _SimpleMascotPainter()),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pembelajaran selesai!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _pesan,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            // Bintang
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  i < _bintang ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD700),
                  size: 36,
                ),
              )),
            ),
            const SizedBox(height: 28),
            // Statistik
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(child: _StatCard(
                    label: 'Benar',
                    value: '$benar',
                    icon: Icons.check_circle,
                    iconColor: const Color(0xFF4CAF50),
                    bgColor: const Color(0xFFCDFF90),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(
                    label: 'Salah',
                    value: '$salah',
                    icon: Icons.cancel,
                    iconColor: const Color(0xFFE53935),
                    bgColor: const Color(0xFFFF8A65),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(
                    label: 'Waktu',
                    value: waktu,
                    icon: Icons.timer,
                    iconColor: const Color(0xFF2196F3),
                    bgColor: const Color(0xFFFFE082),
                  )),
                ],
              ),
            ),
            const Spacer(flex: 2),
            // Tombol aksi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ulangi latihan dengan soal baru
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => LatihanScreen(
                              bahasaKey: 'sunda',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Coba Lagi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Selesai',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _BottomNavSimple(),
          ],
        ),
      ),
    );
  }
}

// ─── Kartu statistik ─────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              )),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 4),
                Text(value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom nav placeholder ───────────────────────────────────

class _BottomNavSimple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home,              color: Color(0xFFE05252), size: 28),
          Icon(Icons.emoji_events,      color: Color(0xFFD4A017), size: 28),
          Icon(Icons.play_circle_fill,  color: Color(0xFF8B2BE2), size: 28),
          Icon(Icons.calculate,         color: Color(0xFF4CAF50), size: 28),
          Icon(Icons.person,            color: Colors.white54,    size: 28),
        ],
      ),
    );
  }
}

// ─── Maskot ───────────────────────────────────────────────────

class _SimpleMascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final body = Paint()..color = const Color(0xFFE07B3A);
    canvas.drawCircle(Offset(cx, cy - 10), 38, body);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + 25), width: 65, height: 55),
        body);
    final belly = Paint()..color = const Color(0xFFF5DEB3);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy - 8), width: 42, height: 34),
        belly);
    final eye = Paint()..color = const Color(0xFF3D1A00);
    canvas.drawCircle(Offset(cx - 10, cy - 16), 5, eye);
    canvas.drawCircle(Offset(cx + 10, cy - 16), 5, eye);
    final shine = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - 7.5, cy - 18.5), 1.8, shine);
    canvas.drawCircle(Offset(cx + 12.5, cy - 18.5), 1.8, shine);
    final nose = Paint()..color = const Color(0xFF5C2A00);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy - 7), width: 9, height: 6),
        nose);
    final cape = Paint()..color = const Color(0xFFC0392B);
    final capePath = Path()
      ..moveTo(cx - 32, cy + 8)
      ..quadraticBezierTo(cx, cy + 60, cx + 32, cy + 8)
      ..quadraticBezierTo(cx + 20, cy + 55, cx, cy + 65)
      ..quadraticBezierTo(cx - 20, cy + 55, cx - 32, cy + 8)
      ..close();
    canvas.drawPath(capePath, cape);
    final tailPath = Path()
      ..moveTo(cx + 30, cy + 20)
      ..cubicTo(cx + 60, cy + 8, cx + 68, cy - 14, cx + 52, cy - 28);
    canvas.drawPath(
        tailPath,
        body
          ..style     = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap   = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}