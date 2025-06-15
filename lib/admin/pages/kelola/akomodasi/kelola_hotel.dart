import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/admin/widgets/card_penginapan_baru.dart';

class KelolaHotel extends StatefulWidget {
  final VoidCallback? onBack;
  const KelolaHotel({Key? key, this.onBack}) : super(key: key);

  @override
  State<KelolaHotel> createState() => _KelolaHotelState();
}

class _KelolaHotelState extends State<KelolaHotel> {
  final _formKey = GlobalKey<FormState>();
  late Box<HotelModel> hotelBox;
  late Box<HotelOptionsModel> optionsBox;
  late Box lokasiBox;

  final nameController = TextEditingController();
  final ratingController = TextEditingController();
  final reviewCountController = TextEditingController();
  final priceController = TextEditingController();
  final lokasiDetailController = TextEditingController();

  String? selectedTipe;
  String? selectedLokasi;
  List<String> selectedFacilities = [];
  List<String> selectedBadges = [];
  String? imageBase64;
  int? editingIndex;
  List<AreaAkomodasiModel> areaAkomodasi = [];

  Map<String, IconData> facilitiesMap = {};

  // Focus nodes untuk mengubah warna border
  final FocusNode nameFocus = FocusNode();
  final FocusNode ratingFocus = FocusNode();
  final FocusNode reviewFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode lokasiDetailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    hotelBox = Hive.box<HotelModel>('hotelBox');
    optionsBox = Hive.box<HotelOptionsModel>('hotelOptionsBox');
    lokasiBox = Hive.box('lokasiBox');
    final options = optionsBox.get(0);
    if (options != null) {
      facilitiesMap = _buildFacilityIcons(options.facilities);
    }
  }

  @override
  void dispose() {
    nameFocus.dispose();
    ratingFocus.dispose();
    reviewFocus.dispose();
    priceFocus.dispose();
    lokasiDetailFocus.dispose();
    super.dispose();
  }

  Map<String, IconData> _buildFacilityIcons(List<String> facilities) {
    return {
      for (var f in facilities) f: _iconForFacility(f),
    };
  }

  IconData _iconForFacility(String name) {
    switch (name) {
      case 'Wi-Fi':
        return Icons.wifi;
      case 'Breakfast':
        return Icons.free_breakfast;
      case 'Kolam Renang':
        return Icons.pool;
      case 'Gym':
        return Icons.fitness_center;
      case 'Parkir':
        return Icons.local_parking;
      case 'AC':
        return Icons.ac_unit;
      default:
        return Icons.help_outline;
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void resetForm() {
    nameController.clear();
    ratingController.clear();
    reviewCountController.clear();
    priceController.clear();
    lokasiDetailController.clear();
    selectedTipe = null;
    selectedLokasi = null;
    selectedFacilities.clear();
    selectedBadges.clear();
    imageBase64 = null;
    editingIndex = null;
    areaAkomodasi.clear();
    setState(() {});
  }

  void pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        imageBase64 = base64Encode(bytes);
      });
      _showSuccessSnackBar('Foto berhasil dipilih!');
    }
  }

  Future<bool> _showSaveConfirmation() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFDC2626),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                editingIndex == null ? 'Konfirmasi Tambah Hotel' : 'Konfirmasi Update Hotel',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            editingIndex == null
              ? 'Apakah Anda yakin ingin menambahkan hotel "${nameController.text}"?'
              : 'Apakah Anda yakin ingin memperbarui data hotel "${nameController.text}"?',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    editingIndex == null ? 'Tambah' : 'Update',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ) ?? false;
  }

  void saveHotel() async {
    if (_formKey.currentState!.validate() &&
        selectedFacilities.isNotEmpty &&
        selectedLokasi != null &&
        lokasiDetailController.text.isNotEmpty &&
        areaAkomodasi.isNotEmpty
    ) {
      final confirmed = await _showSaveConfirmation();
      if (!confirmed) return;

      try {
        final hotel = HotelModel(
          nama: nameController.text,
          lokasi: selectedLokasi!,
          rating: double.tryParse(ratingController.text) ?? 0.0,
          reviewCount: int.tryParse(reviewCountController.text) ?? 0,
          harga: int.tryParse(priceController.text) ?? 0,
          tipe: selectedTipe ?? '',
          fasilitas: List.from(selectedFacilities),
          badge: List.from(selectedBadges),
          imageBase64: imageBase64 ?? '',
          lokasiDetail: lokasiDetailController.text,
          areaAkomodasi: List.from(areaAkomodasi),
        );

        if (editingIndex == null) {
          await hotelBox.add(hotel);
          _showSuccessSnackBar('Hotel "${nameController.text}" berhasil ditambahkan!');
        } else {
          await hotelBox.putAt(editingIndex!, hotel);
          _showSuccessSnackBar('Hotel "${nameController.text}" berhasil diperbarui!');
        }
        resetForm();
      } catch (e) {
        _showErrorSnackBar('Gagal menyimpan hotel. Silakan coba lagi.');
      }
    } else {
      _showErrorSnackBar('Mohon lengkapi semua field yang wajib diisi!');
    }
  }

  void editHotel(int index) {
    final hotel = hotelBox.getAt(index);
    if (hotel != null) {
      setState(() {
        editingIndex = index;
        nameController.text = hotel.nama;
        selectedLokasi = hotel.lokasi;
        ratingController.text = hotel.rating.toString();
        reviewCountController.text = hotel.reviewCount.toString();
        priceController.text = hotel.harga.toString();
        selectedTipe = hotel.tipe;
        selectedFacilities = List<String>.from(hotel.fasilitas);
        selectedBadges = List<String>.from(hotel.badge);
        imageBase64 = hotel.imageBase64;
        lokasiDetailController.text = hotel.lokasiDetail;
        areaAkomodasi = List<AreaAkomodasiModel>.from(hotel.areaAkomodasi);
      });
      _showSuccessSnackBar('Data hotel "${hotel.nama}" dimuat untuk diedit');
    }
  }

  Future<bool> _showDeleteConfirmation(String hotelName) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Konfirmasi Hapus Hotel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Apakah Anda yakin ingin menghapus hotel "$hotelName"?\n\nTindakan ini tidak dapat dibatalkan.',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ) ?? false;
  }

  void deleteHotel(int index) async {
    final hotel = hotelBox.getAt(index);
    if (hotel != null) {
      final confirmed = await _showDeleteConfirmation(hotel.nama);
      if (confirmed) {
        try {
          await hotelBox.deleteAt(index);
          _showSuccessSnackBar('Hotel "${hotel.nama}" berhasil dihapus!');
          setState(() {});
        } catch (e) {
          _showErrorSnackBar('Gagal menghapus hotel. Silakan coba lagi.');
        }
      }
    }
  }

  IconData _iconDataFromName(String name) {
    switch (name) {
      case "location_on":
        return Icons.location_on;
      case "beach_access":
        return Icons.beach_access;
      case "shopping_bag":
        return Icons.shopping_bag;
      case "restaurant":
        return Icons.restaurant;
      case "park":
        return Icons.park;
      case "museum":
        return Icons.museum;
      case "local_activity":
        return Icons.local_activity;
      default:
        return Icons.location_on;
    }
  }

  Widget buildAreaAkomodasiField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Area Sekitar Akomodasi', style: TextStyle(fontSize: 16)),
              const Spacer(),
              TextButton.icon(
                onPressed: addAreaAkomodasi,
                icon: const Icon(Icons.add, color: Color(0xFFDC2626)),
                label: const Text('Tambah', style: TextStyle(color: Color(0xFFDC2626))),
              )
            ],
          ),
          if (areaAkomodasi.isEmpty)
            const Text(
              'Belum ada area sekitar, tambahkan minimal satu.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ...areaAkomodasi.map((area) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(_iconDataFromName(area.iconName), color: const Color(0xFFDC2626)),
                title: Text(area.nama),
                subtitle: Text('${area.jarakKm.toStringAsFixed(2)} km'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () async {
                    final confirmed = await _showDeleteAreaConfirmation(area.nama);
                    if (confirmed) {
                      setState(() {
                        areaAkomodasi.remove(area);
                      });
                      _showSuccessSnackBar('Area "${area.nama}" berhasil dihapus!');
                    }
                  },
                ),
              )),
        ],
      ),
    );
  }

  Future<void> addAreaAkomodasi() async {
    final namaController = TextEditingController();
    final jarakController = TextEditingController();
    String? selectedIcon = "location_on";

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFDC2626),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.add_location_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                "Tambah Area Sekitar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: "Nama Area",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFDC2626)),
                ),
                labelStyle: const TextStyle(color: Colors.grey),
                floatingLabelStyle: const TextStyle(color: Color(0xFFDC2626)),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: jarakController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Jarak (km)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFDC2626)),
                ),
                labelStyle: const TextStyle(color: Colors.grey),
                floatingLabelStyle: const TextStyle(color: Color(0xFFDC2626)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedIcon,
              items: [
                "location_on", "beach_access", "shopping_bag", "restaurant",
                "park", "museum", "local_activity"
              ].map((icon) => DropdownMenuItem(
                value: icon,
                child: Row(
                  children: [
                    Icon(_iconDataFromName(icon), color: Colors.black),
                    const SizedBox(width: 6),
                    Text(icon),
                  ],
                ),
              )).toList(),
              onChanged: (val) => selectedIcon = val,
              decoration: InputDecoration(
                labelText: "Icon",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFDC2626)),
                ),
                labelStyle: const TextStyle(color: Colors.grey),
                floatingLabelStyle: const TextStyle(color: Color(0xFFDC2626)),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Text(
                    "Batal",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (namaController.text.isNotEmpty && jarakController.text.isNotEmpty) {
                      Navigator.pop(ctx, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Tambah",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (result == true && namaController.text.isNotEmpty && jarakController.text.isNotEmpty) {
      setState(() {
        areaAkomodasi.add(
          AreaAkomodasiModel(
            nama: namaController.text,
            jarakKm: double.tryParse(jarakController.text) ?? 0,
            iconName: selectedIcon ?? "location_on",
          ),
        );
      });
      _showSuccessSnackBar('Area "${namaController.text}" berhasil ditambahkan!');
    }
  }

  Future<bool> _showDeleteAreaConfirmation(String areaName) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Hapus Area',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Apakah Anda yakin ingin menghapus area "$areaName"?',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ) ?? false;
  }

  Widget buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: type,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color(0xFFDC2626)),
          alignLabelWithHint: true,
        ),
        validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  Widget buildDropdownField({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color(0xFFDC2626)),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item, textAlign: TextAlign.left));
        }).toList(),
        validator: (val) => val == null || val.isEmpty ? 'Wajib dipilih' : null,
      ),
    );
  }

  Widget buildDropdownLokasiField({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color(0xFFDC2626)),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item, textAlign: TextAlign.left));
        }).toList(),
        validator: (val) => val == null || val.isEmpty ? 'Wajib pilih lokasi' : null,
      ),
    );
  }

  Widget buildMultiFacilityField(List<String> facilities) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fasilitas Utama', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: facilities.map((fasilitas) {
              final selected = selectedFacilities.contains(fasilitas);
              final icon = facilitiesMap[fasilitas] ?? Icons.check;
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16, color: selected ? Colors.white : Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      fasilitas,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                selected: selected,
                selectedColor: const Color(0xFFDC2626),
                checkmarkColor: Colors.white,
                backgroundColor: Colors.white,
                side: BorderSide(color: selected ? const Color(0xFFDC2626) : Colors.grey),
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      selectedFacilities.add(fasilitas);
                    } else {
                      selectedFacilities.remove(fasilitas);
                    }
                  });
                },
              );
            }).toList(),
          ),
          if (selectedFacilities.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text('Minimal pilih 1 fasilitas.',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            )
        ],
      ),
    );
  }

  Widget buildMultiBadgeField(List<String> badges) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Badge Tambahan', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: badges.map((badge) {
              final selected = selectedBadges.contains(badge);
              return FilterChip(
                label: Text(
                  badge,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                  ),
                ),
                selected: selected,
                selectedColor: const Color(0xFFDC2626),
                checkmarkColor: Colors.white,
                backgroundColor: Colors.white,
                side: BorderSide(color: selected ? const Color(0xFFDC2626) : Colors.grey),
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      selectedBadges.add(badge);
                    } else {
                      selectedBadges.remove(badge);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = optionsBox.get(0);
    final lokasiList = (lokasiBox.get('list') as List?)?.cast<String>() ?? [];
    final screenWidth = MediaQuery.of(context).size.width;

    if (options == null) {
      return const Center(child: Text('HotelOptionsModel belum tersedia.'));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFDC2626),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(left: 8, top: screenWidth * 0.08, bottom: 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: widget.onBack ?? () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              const Text(
                'Kelola Hotel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              editingIndex == null ? 'Masukkan Data Hotel Baru' : 'Edit Data Hotel',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(
                    controller: nameController,
                    focusNode: nameFocus,
                    label: 'Nama Hotel',
                    icon: Icons.business,
                    hint: 'Masukkan nama hotel',
                  ),
                  buildDropdownLokasiField(
                    label: 'Lokasi',
                    icon: Icons.location_city,
                    items: lokasiList,
                    selectedValue: selectedLokasi,
                    onChanged: (value) => setState(() => selectedLokasi = value),
                  ),
                  buildTextField(
                    controller: lokasiDetailController,
                    focusNode: lokasiDetailFocus,
                    label: 'Lokasi Detail (Alamat Lengkap)',
                    icon: Icons.place,
                    hint: 'Masukkan alamat lengkap hotel',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          controller: ratingController,
                          focusNode: ratingFocus,
                          label: 'Rating',
                          icon: Icons.star,
                          hint: 'Contoh: 4.8',
                          type: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: buildTextField(
                          controller: reviewCountController,
                          focusNode: reviewFocus,
                          label: 'Jumlah Reviews',
                          icon: Icons.people,
                          hint: 'Contoh: 205',
                          type: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  buildTextField(
                    controller: priceController,
                    focusNode: priceFocus,
                    label: 'Harga kamar termurah',
                    icon: Icons.attach_money,
                    hint: 'Masukkan harga kamar termurah',
                    type: TextInputType.number,
                  ),
                  buildDropdownField(
                    label: 'Tipe',
                    icon: Icons.hotel,
                    items: options.tipe,
                    selectedValue: selectedTipe,
                    onChanged: (value) => setState(() => selectedTipe = value),
                  ),
                  buildMultiFacilityField(options.facilities),
                  buildMultiBadgeField(options.badge),
                  buildAreaAkomodasiField(),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Unggah Foto Penginapan",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: screenWidth * 0.26 + 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: imageBase64 != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    base64Decode(imageBase64!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(Icons.check, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add_photo_alternate, size: 40, color: Colors.black),
                                  const SizedBox(height: 8),
                                  const Text('Unggah Foto', style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (editingIndex != null) ...[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              resetForm();
                              _showSuccessSnackBar('Form berhasil direset');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.clear),
                            label: const Text("Batal Edit"),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: saveHotel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(editingIndex == null ? Icons.add : Icons.update),
                          label: Text(editingIndex == null ? "Tambah Hotel" : "Update Hotel"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Daftar Hotel', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: hotelBox.listenable(),
              builder: (context, Box<HotelModel> box, _) {
                if (box.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.hotel_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada hotel yang ditambahkan',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final hotel = box.getAt(index)!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: CardPenginapanBaru(
                        hotel: hotel,
                        facilitiesMap: facilitiesMap,
                        onEdit: () => editHotel(index),
                        onDelete: () => deleteHotel(index),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}