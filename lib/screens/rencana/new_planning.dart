import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/models/akomodasi_preview_model.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/models/kamar_model.dart';
import 'package:tripmate_mobile/models/pesawat_model.dart';
import 'package:tripmate_mobile/models/mobil_model.dart';
import 'package:tripmate_mobile/widgets/preview_akomodasi_card.dart';
import 'package:tripmate_mobile/widgets/preview_transportasi_card.dart';
import 'package:tripmate_mobile/widgets/detail_perjalanan.dart';
import 'package:tripmate_mobile/shared/location_state.dart';
import 'package:tripmate_mobile/screens/rencana/konfirmasi_rencana.dart';

class BarReserve extends StatelessWidget {
  final int total;
  final VoidCallback? onKonfirmasi;

  const BarReserve({super.key, required this.total, this.onKonfirmasi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, -0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [const Color(0x00D9D9D9), const Color(0xFF737373)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 27,
            right: 0,
            child: Container(
              height: 63,
              color: Colors.white,
            ),
          ),
          Positioned(
            right: 16,
            top: 39,
            child: GestureDetector(
              onTap: onKonfirmasi,
              child: Container(
                width: 159,
                height: 42,
                decoration: ShapeDecoration(
                  color: const Color(0xFFDC2626),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Konfirmasi Rencana',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 51,
            child: Text(
              'Rp ${NumberFormat.decimalPattern('id').format(total)}',
              style: const TextStyle(
                color: Color(0xFFDC2626),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewPlanningPageBody extends StatefulWidget {
  final UserModel currentUser;
  final void Function(String category)? onCategoryTap;
  final VoidCallback? onCancel;
  final bool isNewPlanMode;
  final RencanaModel? selectedPlan;
  final RencanaModel? previewPlan;
  final int? previewPlanIndex;
  final void Function(RencanaModel? plan, int? index, {bool editMode})? afterSaveOrUpdate;

  const NewPlanningPageBody({
    Key? key,
    required this.currentUser,
    this.onCategoryTap,
    this.onCancel,
    this.isNewPlanMode = true,
    this.selectedPlan,
    this.previewPlan,
    this.previewPlanIndex,
    this.afterSaveOrUpdate,
  }) : super(key: key);

  @override
  State<NewPlanningPageBody> createState() => _NewPlanningPageBodyState();
}

class _NewPlanningPageBodyState extends State<NewPlanningPageBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _sumDateController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();

  Box<RencanaModel>? _rencanaBox;
  String? _selectedOrigin;
  String? _selectedDestination;

  late final List<String> _cities;

  String? _imageBase64;
  RencanaModel? _previewPlan;
  int? _previewPlanIndex;
  bool _isEditMode = false;

  AkomodasiPreviewModel? _akomodasiPreview;
  String? _selectedHotelNama;
  String? _selectedKamarNama;

  PesawatModel? _selectedPesawat;
  MobilModel? _selectedMobil;

  @override
  void initState() {
    super.initState();
    _cities = LocationState.getLocations();
    _initHiveBoxesAndPreview();
  }

  Future<void> _initHiveBoxesAndPreview() async {
    await _initHiveBoxes();

    if (widget.previewPlanIndex != null && widget.previewPlanIndex! >= 0) {
      final plan = _rencanaBox!.getAt(widget.previewPlanIndex!);
      if (plan != null) {
        _loadSelectedPlan(plan);
        setState(() {
          _isEditMode = !widget.isNewPlanMode;
          _previewPlan = plan;
          _previewPlanIndex = widget.previewPlanIndex;
          _selectedHotelNama = plan.akomodasi;
          _selectedKamarNama = plan.kamarNama;
          _akomodasiPreview = _mapPlanToPreview(plan);

          // Load pesawat data
          if (plan.transportasi != null && plan.transportasi!.isNotEmpty) {
            _loadPesawatFromPlan(plan);
          }
          
          // Load mobil data
          if (plan.mobil != null && plan.mobil!.isNotEmpty) {
            _loadMobilFromPlan(plan);
          }
        });
      }
    } else if (!widget.isNewPlanMode && widget.selectedPlan != null) {
      _loadSelectedPlan(widget.selectedPlan!);
      setState(() {
        _isEditMode = true;
        _previewPlan = widget.selectedPlan;
        _previewPlanIndex = widget.previewPlanIndex;
        _selectedHotelNama = widget.selectedPlan!.akomodasi;
        _selectedKamarNama = widget.selectedPlan!.kamarNama;
        _akomodasiPreview = _mapPlanToPreview(widget.selectedPlan!);

        // Load pesawat data
        if (widget.selectedPlan!.transportasi != null && widget.selectedPlan!.transportasi!.isNotEmpty) {
          _loadPesawatFromPlan(widget.selectedPlan!);
        }
        
        // Load mobil data
        if (widget.selectedPlan!.mobil != null && widget.selectedPlan!.mobil!.isNotEmpty) {
          _loadMobilFromPlan(widget.selectedPlan!);
        }
      });
    }
  }

  // PERBAIKAN: Method untuk load pesawat dari plan dengan error handling
  void _loadPesawatFromPlan(RencanaModel plan) {
    try {
      final pesawatBox = Hive.box<PesawatModel>('pesawatBox');
      _selectedPesawat = pesawatBox.values.firstWhere(
        (p) => p.nama == plan.transportasi,
        orElse: () => PesawatModel(
          nama: plan.transportasi ?? '',
          asal: plan.asalPesawat ?? '',
          tujuan: plan.tujuanPesawat ?? '',
          kelas: plan.kelasPesawat ?? '',
          harga: (plan.hargaPesawat ?? 0) ~/ int.parse(plan.people.isEmpty ? '1' : plan.people),
          waktu: plan.waktuPesawat != null ? DateTime.tryParse(plan.waktuPesawat!) ?? DateTime.now() : DateTime.now(),
          durasi: plan.durasiPesawat ?? 0,
          imageBase64: plan.imagePesawat ?? '',
        ),
      );
    } catch (e) {
      print('Error loading pesawat: $e');
    }
  }

  // PERBAIKAN: Method untuk load mobil dari plan dengan error handling
  void _loadMobilFromPlan(RencanaModel plan) {
    try {
      final mobilBox = Hive.box<MobilModel>('mobilBox');
      _selectedMobil = mobilBox.values.firstWhere(
        (m) => m.merk == plan.mobil,
        orElse: () => MobilModel(
          merk: plan.mobil ?? '',
          tipeMobil: plan.tipeMobil ?? '',
          hargaSewa: plan.hargaMobil ?? 0,
          jumlahPenumpang: plan.jumlahPenumpangMobil ?? '',
          imageBase64: plan.imageMobil ?? '',
        ),
      );
    } catch (e) {
      print('Error loading mobil: $e');
    }
  }

  void _loadSelectedPlan(RencanaModel plan) {
    _nameController.text = plan.name;
    _originController.text = plan.origin;
    _destinationController.text = plan.destination;
    _startDateController.text = plan.startDate;
    _endDateController.text = plan.endDate;
    _sumDateController.text = plan.sumDate;
    _peopleController.text = plan.people;
    _selectedOrigin = plan.origin;
    _selectedDestination = plan.destination;
    _imageBase64 = plan.imageBase64;
    setState(() {
      _previewPlan = plan;
      _selectedHotelNama = plan.akomodasi;
      _selectedKamarNama = plan.kamarNama;
    });
  }

  Future<void> _initHiveBoxes() async {
    if (!Hive.isBoxOpen('rencanaBox')) {
      await Hive.openBox<RencanaModel>('rencanaBox');
    }
    if (!Hive.isBoxOpen('hotelBox')) {
      await Hive.openBox<HotelModel>('hotelBox');
    }
    if (!Hive.isBoxOpen('kamarBox')) {
      await Hive.openBox<KamarModel>('kamarBox');
    }
    if (!Hive.isBoxOpen('pesawatBox')) {
      await Hive.openBox<PesawatModel>('pesawatBox');
    }
    if (!Hive.isBoxOpen('mobilBox')) {
      await Hive.openBox<MobilModel>('mobilBox');
    }
    _rencanaBox = Hive.box<RencanaModel>('rencanaBox');
  }

  void _clearForm() {
    _nameController.clear();
    _originController.clear();
    _destinationController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _sumDateController.clear();
    _peopleController.clear();
    _selectedOrigin = null;
    _selectedDestination = null;
    setState(() {
      _imageBase64 = null;
      _akomodasiPreview = null;
      _selectedHotelNama = null;
      _selectedKamarNama = null;
      _selectedPesawat = null;
      _selectedMobil = null;
    });
  }

  void _clearFormAndPreview() {
    _clearForm();
    setState(() {
      _previewPlan = null;
      _previewPlanIndex = null;
      _isEditMode = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  AkomodasiPreviewModel? _mapPlanToPreview(RencanaModel plan) {
    if (plan.akomodasi == null ||
        plan.akomodasi!.isEmpty ||
        plan.kamarNama == null ||
        plan.kamarNama!.isEmpty) {
      return null;
    }
    final hotelBox = Hive.box<HotelModel>('hotelBox');
    final kamarBox = Hive.box<KamarModel>('kamarBox');

    HotelModel? hotel;
    try {
      hotel = hotelBox.values.firstWhere((h) => h.nama == plan.akomodasi);
    } catch (e) {
      hotel = null;
    }
    if (hotel == null) return null;

    KamarModel? kamar;
    try {
      kamar = kamarBox.values.firstWhere(
        (k) => k.hotelId == hotel!.key.toString() && k.nama == plan.kamarNama,
      );
    } catch (e) {
      kamar = null;
    }
    if (kamar == null) return null;

    return AkomodasiPreviewModel(
      namaHotel: hotel.nama,
      tipeHotel: hotel.tipe,
      lokasi: hotel.lokasi,
      imageBase64: hotel.imageBase64,
      rating: hotel.rating,
      reviewCount: hotel.reviewCount,
      namaKamar: kamar.nama,
      sizeKasur: kamar.tipeKasur,
      badges: kamar.badges,
      estimasiBiaya: plan.biayaAkomodasi ?? kamar.harga,
    );
  }

  // PERBAIKAN: Method untuk update plan dari modal dengan kategori spesifik
  void updatePlanFromModal(RencanaModel updatedPlan) {
    setState(() {
      _previewPlan = updatedPlan;
      
      // Update preview berdasarkan kategori yang ditambahkan
      if (updatedPlan.akomodasi != null && updatedPlan.akomodasi!.isNotEmpty) {
        _selectedHotelNama = updatedPlan.akomodasi;
        _selectedKamarNama = updatedPlan.kamarNama;
        _akomodasiPreview = _mapPlanToPreview(updatedPlan);
      }
      
      if (updatedPlan.transportasi != null && updatedPlan.transportasi!.isNotEmpty) {
        _loadPesawatFromPlan(updatedPlan);
      }
      
      if (updatedPlan.mobil != null && updatedPlan.mobil!.isNotEmpty) {
        _loadMobilFromPlan(updatedPlan);
      }
    });
  }

  void _onAkomodasiTap() {
    widget.onCategoryTap?.call('Akomodasi');
  }

  void _onTransportasiTap() {
    widget.onCategoryTap?.call('Transportasi');
  }

  void _setSelectedPesawat(PesawatModel pesawat) {
    setState(() {
      _selectedPesawat = pesawat;
    });
  }
  
  void _setSelectedMobil(MobilModel mobil) {
    setState(() {
      _selectedMobil = mobil;
    });
  }

  void _onTransportasiDelete() {
    setState(() {
      _selectedPesawat = null;
    });
  }

  void _onMobilDelete() {
    setState(() {
      _selectedMobil = null;
    });
  }

  void _onAktivitasTap() {
    widget.onCategoryTap?.call('Aktivitas Seru');
  }

  void _onKulinerTap() {
    widget.onCategoryTap?.call('Kuliner');
  }

  Future<void> _onAkomodasiDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus akomodasi dari rencana?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() {
        _akomodasiPreview = null;
        _selectedHotelNama = null;
        _selectedKamarNama = null;
      });

      if (_previewPlanIndex != null && _rencanaBox != null) {
        final plan = _rencanaBox!.getAt(_previewPlanIndex!);
        if (plan != null) {
          final updatedPlan = plan.copyWith(
            akomodasi: null,
            kamarNama: null,
            biayaAkomodasi: null,
          );
          await _rencanaBox!.putAt(_previewPlanIndex!, updatedPlan);
        }
      }
    }
  }

  int get estimasiTotalBiaya {
    int total = 0;
    // Akomodasi
    if (_akomodasiPreview != null && _akomodasiPreview!.estimasiBiaya != null) {
      total += _akomodasiPreview!.estimasiBiaya!;
    } else if (_previewPlan?.biayaAkomodasi != null) {
      total += _previewPlan!.biayaAkomodasi!;
    }
    // Transportasi (Pesawat)
    if (_selectedPesawat != null) {
      int jumlahPenumpang = 1;
      if (_peopleController.text.isNotEmpty) {
        final n = int.tryParse(_peopleController.text.trim());
        if (n != null && n > 0) jumlahPenumpang = n;
      } else if (_previewPlan?.people != null && _previewPlan!.people.isNotEmpty) {
        final n = int.tryParse(_previewPlan!.people.trim());
        if (n != null && n > 0) jumlahPenumpang = n;
      }
      total += _selectedPesawat!.harga * jumlahPenumpang;
    } else if (_previewPlan?.hargaPesawat != null) {
      total += _previewPlan!.hargaPesawat!;
    }
    // Mobil
    if (_selectedMobil != null) {
      total += _selectedMobil!.hargaSewa;
    } else if (_previewPlan?.hargaMobil != null) {
      total += _previewPlan!.hargaMobil!;
    }
    return total;
  }

  void _savePlan() async {
    final name = _nameController.text;
    final origin = _originController.text;
    final destination = _destinationController.text;
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final sumDate = _sumDateController.text;
    final people = _peopleController.text;

    if (name.isEmpty ||
        origin.isEmpty ||
        destination.isEmpty ||
        startDate.isEmpty ||
        endDate.isEmpty ||
        people.isEmpty ||
        sumDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua kolom.')),
      );
      return;
    }

    int? hargaPesawat;
    if (_selectedPesawat != null) {
      int jumlahPenumpang = 1;
      if (_peopleController.text.isNotEmpty) {
        final n = int.tryParse(_peopleController.text.trim());
        if (n != null && n > 0) jumlahPenumpang = n;
      }
      hargaPesawat = _selectedPesawat!.harga * jumlahPenumpang;
    }

    final newPlan = RencanaModel(
      userId: widget.currentUser.email,
      name: name,
      origin: origin,
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      sumDate: sumDate,
      people: people,
      imageBase64: _imageBase64,
      akomodasi: _selectedHotelNama,
      kamarNama: _selectedKamarNama,
      biayaAkomodasi: _akomodasiPreview?.estimasiBiaya,
      transportasi: _selectedPesawat?.nama,
      kelasPesawat: _selectedPesawat?.kelas,
      hargaPesawat: hargaPesawat,
      asalPesawat: _selectedPesawat?.asal,
      tujuanPesawat: _selectedPesawat?.tujuan,
      waktuPesawat: _selectedPesawat?.waktu.toIso8601String(),
      durasiPesawat: _selectedPesawat?.durasi,
      imagePesawat: _selectedPesawat?.imageBase64,
      mobil: _selectedMobil?.merk,
      tipeMobil: _selectedMobil?.tipeMobil,
      hargaMobil: _selectedMobil?.hargaSewa,
      jumlahPenumpangMobil: _selectedMobil?.jumlahPenumpang,
      imageMobil: _selectedMobil?.imageBase64,
    );

    await _rencanaBox?.add(newPlan);

    setState(() {
      _previewPlan = newPlan;
      _previewPlanIndex = _rencanaBox!.length - 1;
      _akomodasiPreview = _mapPlanToPreview(newPlan);
      _isEditMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rencana berhasil disimpan!')),
    );
    if (widget.afterSaveOrUpdate != null) {
      widget.afterSaveOrUpdate!(newPlan, _previewPlanIndex ?? 0, editMode: false);
    }
  }

  void _updatePlan() async {
    if (_previewPlanIndex == null) return;
    final name = _nameController.text;
    final origin = _originController.text;
    final destination = _destinationController.text;
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final sumDate = _sumDateController.text;
    final people = _peopleController.text;

    if (name.isEmpty ||
        origin.isEmpty ||
        destination.isEmpty ||
        startDate.isEmpty ||
        endDate.isEmpty ||
        people.isEmpty ||
        sumDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua kolom.')),
      );
      return;
    }

    int? hargaPesawat;
    if (_selectedPesawat != null) {
      int jumlahPenumpang = 1;
      if (_peopleController.text.isNotEmpty) {
        final n = int.tryParse(_peopleController.text.trim());
        if (n != null && n > 0) jumlahPenumpang = n;
      }
      hargaPesawat = _selectedPesawat!.harga * jumlahPenumpang;
    }

    final updatedPlan = RencanaModel(
      userId: widget.currentUser.email,
      name: name,
      origin: origin,
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      sumDate: sumDate,
      people: people,
      imageBase64: _imageBase64,
      akomodasi: _selectedHotelNama,
      kamarNama: _selectedKamarNama,
      biayaAkomodasi: _akomodasiPreview?.estimasiBiaya,
      transportasi: _selectedPesawat?.nama,
      kelasPesawat: _selectedPesawat?.kelas,
      hargaPesawat: hargaPesawat,
      asalPesawat: _selectedPesawat?.asal,
      tujuanPesawat: _selectedPesawat?.tujuan,
      waktuPesawat: _selectedPesawat?.waktu.toIso8601String(),
      durasiPesawat: _selectedPesawat?.durasi,
      imagePesawat: _selectedPesawat?.imageBase64,
      mobil: _selectedMobil?.merk,
      tipeMobil: _selectedMobil?.tipeMobil,
      hargaMobil: _selectedMobil?.hargaSewa,
      jumlahPenumpangMobil: _selectedMobil?.jumlahPenumpang,
      imageMobil: _selectedMobil?.imageBase64,
    );

    await _rencanaBox?.putAt(_previewPlanIndex!, updatedPlan);

    setState(() {
      _previewPlan = updatedPlan;
      _akomodasiPreview = _mapPlanToPreview(updatedPlan);
      _isEditMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rencana berhasil diperbarui!')),
    );
    if (widget.afterSaveOrUpdate != null) {
      widget.afterSaveOrUpdate!(updatedPlan, _previewPlanIndex, editMode: false);
    }
  }

  void _deletePlan() async {
    if (_previewPlanIndex == null) return;
    await _rencanaBox?.deleteAt(_previewPlanIndex!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rencana berhasil dihapus!')),
    );
    if (widget.afterSaveOrUpdate != null) {
      widget.afterSaveOrUpdate!(null, null, editMode: false);
    }
    _clearFormAndPreview();
  }

  void _editPlan() {
    if (_previewPlan == null) return;
    _nameController.text = _previewPlan!.name;
    _originController.text = _previewPlan!.origin;
    _destinationController.text = _previewPlan!.destination;
    _startDateController.text = _previewPlan!.startDate;
    _endDateController.text = _previewPlan!.endDate;
    _sumDateController.text = _previewPlan!.sumDate;
    _peopleController.text = _previewPlan!.people;
    _selectedOrigin = _previewPlan!.origin;
    _selectedDestination = _previewPlan!.destination;
    _imageBase64 = _previewPlan!.imageBase64;
    _selectedHotelNama = _previewPlan!.akomodasi;
    _selectedKamarNama = _previewPlan!.kamarNama;
    setState(() {
      _isEditMode = true;
      _akomodasiPreview = _mapPlanToPreview(_previewPlan!);
    });
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
    void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.location_on_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
        items: _cities
            .map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(city),
                ))
            .toList(),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }

  Widget _buildImagePicker(double width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Unggah Foto Perjalanan",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: width * 0.26 + 40,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _imageBase64 != null && _imageBase64!.isNotEmpty
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            base64Decode(_imageBase64!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (ctx, err, stack) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: GestureDetector(
                            onTap: () => setState(() => _imageBase64 = null),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.close, size: 20, color: Colors.black54),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'Unggah Foto',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk card kategori kosong yang sesuai dengan gambar
  Widget _buildEmptyCategoryCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _akomodasiCardSection() {
    final akomodasiPreviewToShow = _akomodasiPreview ??
        (_previewPlan != null
            ? _mapPlanToPreview(_previewPlan!)
            : null);

    if (akomodasiPreviewToShow != null) {
      return PreviewAkomodasiCard(
        preview: akomodasiPreviewToShow,
        onDelete: _onAkomodasiDelete,
      );
    }
    
    return _buildEmptyCategoryCard(
      title: "Akomodasi",
      icon: Icons.hotel,
      onTap: _onAkomodasiTap,
    );
  }

  Widget _transportasiCardSection() {
    final pesawatToShow = _selectedPesawat ?? (_previewPlan?.transportasi != null && _previewPlan!.transportasi!.isNotEmpty
        ? _selectedPesawat // Sudah di-load di initState
        : null);

    final mobilToShow = _selectedMobil ?? (_previewPlan?.mobil != null && _previewPlan!.mobil!.isNotEmpty
        ? _selectedMobil // Sudah di-load di initState
        : null);

    // Jika ada transportasi yang dipilih, tampilkan preview card
    if ((pesawatToShow != null && pesawatToShow.nama.isNotEmpty) || 
        (mobilToShow != null && mobilToShow.merk.isNotEmpty)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: PreviewTransportasiCard(
          pesawat: pesawatToShow,
          mobil: mobilToShow,
          onDeletePesawat: _onTransportasiDelete,
          onDeleteMobil: _onMobilDelete,
          onAddMobil: () {
            widget.onCategoryTap?.call('Transportasi');
          },
        ),
      );
    }

    // Jika belum ada transportasi, tampilkan empty card
    return _buildEmptyCategoryCard(
      title: "Transportasi",
      icon: Icons.flight,
      onTap: _onTransportasiTap,
    );
  }

  Widget _aktivitasCardSection() {
    // Untuk sementara selalu tampilkan empty card karena belum ada data aktivitas
    return _buildEmptyCategoryCard(
      title: "Aktivitas",
      icon: Icons.local_activity,
      onTap: _onAktivitasTap,
    );
  }

  Widget _kulinerCardSection() {
    // Untuk sementara selalu tampilkan empty card karena belum ada data kuliner
    return _buildEmptyCategoryCard(
      title: "Kuliner",
      icon: Icons.restaurant,
      onTap: _onKulinerTap,
    );
  }

  Widget _estimationCard() {
    int jumlahPenumpang = 1;
    if (_peopleController.text.isNotEmpty) {
      final n = int.tryParse(_peopleController.text.trim());
      if (n != null && n > 0) jumlahPenumpang = n;
    } else if (_previewPlan?.people != null && _previewPlan!.people.isNotEmpty) {
      final n = int.tryParse(_previewPlan!.people.trim());
      if (n != null && n > 0) jumlahPenumpang = n;
    }
    int hargaPesawat = 0;
    if (_selectedPesawat != null) {
      hargaPesawat = _selectedPesawat!.harga * jumlahPenumpang;
    } else if (_previewPlan?.hargaPesawat != null) {
      hargaPesawat = _previewPlan!.hargaPesawat!;
    }
    int hargaMobil = 0;
    if (_selectedMobil != null) {
      hargaMobil = _selectedMobil!.hargaSewa;
    } else if (_previewPlan?.hargaMobil != null) {
      hargaMobil = _previewPlan!.hargaMobil!;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 30),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estimasi Biaya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.hotel, size: 17, color: Colors.black45),
              const SizedBox(width: 7),
              const Expanded(child: Text('Akomodasi')),
              Text(
                _akomodasiPreview != null && _akomodasiPreview!.estimasiBiaya != null
                    ? 'Rp ${NumberFormat.decimalPattern('id').format(_akomodasiPreview!.estimasiBiaya!)}'
                    : (_previewPlan?.biayaAkomodasi != null
                        ? 'Rp ${NumberFormat.decimalPattern('id').format(_previewPlan!.biayaAkomodasi!)}'
                        : 'Rp -'),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.flight, size: 17, color: Colors.black45),
              const SizedBox(width: 7),
              const Expanded(child: Text('Pesawat')),
              Text(
                hargaPesawat > 0
                    ? 'Rp ${NumberFormat.decimalPattern('id').format(hargaPesawat)} (x$jumlahPenumpang)'
                    : 'Rp -',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.directions_car, size: 17, color: Colors.black45),
              const SizedBox(width: 7),
              const Expanded(child: Text('Mobil')),
              Text(
                hargaMobil > 0
                    ? 'Rp ${NumberFormat.decimalPattern('id').format(hargaMobil)}'
                    : 'Rp -',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.emoji_emotions_outlined, size: 17, color: Colors.black45),
              SizedBox(width: 7),
              Expanded(child: Text('Aktivitas')),
              Text('Rp -', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.restaurant, size: 17, color: Colors.black45),
              SizedBox(width: 7),
              Expanded(child: Text('Kuliner')),
              Text('Rp -', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.06),
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: widget.onCancel ?? () => Navigator.pop(context),
                ),
                const SizedBox(width: 2),
                Text(
                  _isEditMode ? "Edit Rencana" : "Rencana Perjalanan Kamu",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 21),
              children: [
                if (widget.isNewPlanMode || _isEditMode)
                  Container(
                    margin: const EdgeInsets.only(bottom: 22),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Nama Perjalanan',
                          icon: Icons.description_outlined,
                          controller: _nameController,
                        ),
                        _buildDropdownField('Asal Kota', _selectedOrigin, (val) {
                          setState(() {
                            _selectedOrigin = val;
                            _originController.text = val!;
                          });
                        }),
                        _buildDropdownField('Kota Tujuan', _selectedDestination, (val) {
                          setState(() {
                            _selectedDestination = val;
                            _destinationController.text = val!;
                          });
                        }),
                        _buildTextField(
                          label: 'Tanggal Mulai',
                          icon: Icons.calendar_today_outlined,
                          controller: _startDateController,
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              _startDateController.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                            }
                          },
                        ),
                        _buildTextField(
                          label: 'Tanggal Akhir',
                          icon: Icons.calendar_today_outlined,
                          controller: _endDateController,
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              _endDateController.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              if (_startDateController.text.isNotEmpty) {
                                final start = DateTime.tryParse(_startDateController.text);
                                final end = picked;
                                if (start != null) {
                                  final diff = end.difference(start).inDays;
                                  int jumlahMalam = diff >= 0 ? diff + 1 : 1;
                                  int jumlahHari = jumlahMalam + 1;
                                  _sumDateController.text = "$jumlahHari Hari, $jumlahMalam Malam";
                                }
                              }
                            }
                          },
                        ),
                        _buildTextField(
                          label: 'Jumlah Orang',
                          icon: Icons.people_outline,
                          controller: _peopleController,
                        ),
                        _buildTextField(
                          label: 'Jumlah Hari',
                          icon: Icons.calendar_view_day_outlined,
                          controller: _sumDateController,
                        ),
                        _buildImagePicker(screenWidth),
                      ],
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                  child: Text("Ringkasan Perjalananmu",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 5),
                
                // Gunakan card kategori yang baru
                _akomodasiCardSection(),
                _transportasiCardSection(),
                _aktivitasCardSection(),
                _kulinerCardSection(),
                
                if (_isEditMode)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    child: ElevatedButton(
                      onPressed: _updatePlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Perbarui Rencana',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (!_isEditMode)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    child: ElevatedButton(
                      onPressed: _savePlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Simpan Rencana',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                _estimationCard(),
                if (_previewPlan != null && !_isEditMode)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 6, bottom: 8),
                          child: Text(
                            "Preview Rencana",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        DetailPerjalananCard(
                          plan: _previewPlan!,
                          onEdit: _editPlan,
                          onDelete: _deletePlan,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isEditMode
          ? BarReserve(
              total: estimasiTotalBiaya,
              onKonfirmasi: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KonfirmasiRencanaPage(
                      rencana: _previewPlan!,
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
