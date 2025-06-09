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
  final Box<HotelModel> hotelBox = Hive.box<HotelModel>('hotelBox');
  final Box<HotelOptionsModel> optionsBox = Hive.box<HotelOptionsModel>('hotelOptionsBox');
  final Box lokasiBox = Hive.box('lokasiBox');

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

  @override
  void initState() {
    super.initState();
    final options = optionsBox.get(0);
    if (options != null) {
      facilitiesMap = _buildFacilityIcons(options.facilities);
    }
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
    }
  }

  void saveHotel() {
    if (_formKey.currentState!.validate() &&
        selectedFacilities.isNotEmpty &&
        selectedLokasi != null &&
        lokasiDetailController.text.isNotEmpty &&
        areaAkomodasi.isNotEmpty
    ) {
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
        hotelBox.add(hotel);
      } else {
        hotelBox.putAt(editingIndex!, hotel);
      }

      resetForm();
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
    }
  }

  void deleteHotel(int index) {
    hotelBox.deleteAt(index);
    setState(() {});
  }

  // === Area Akomodasi Management ===
  void addAreaAkomodasi() async {
    final namaController = TextEditingController();
    final jarakController = TextEditingController();
    String? selectedIcon = "location_on";

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tambah Area Sekitar"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Area"),
            ),
            TextFormField(
              controller: jarakController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jarak (km)"),
            ),
            DropdownButtonFormField<String>(
              value: selectedIcon,
              items: [
                "location_on", "beach_access", "shopping_bag", "restaurant",
                "park", "museum", "local_activity"
              ].map((icon) => DropdownMenuItem(
                value: icon,
                child: Row(
                  children: [
                    Icon(_iconDataFromName(icon)),
                    const SizedBox(width: 6),
                    Text(icon),
                  ],
                ),
              )).toList(),
              onChanged: (val) => selectedIcon = val,
              decoration: const InputDecoration(labelText: "Icon"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (namaController.text.isNotEmpty && jarakController.text.isNotEmpty) {
                setState(() {
                  areaAkomodasi.add(
                    AreaAkomodasiModel(
                      nama: namaController.text,
                      jarakKm: double.tryParse(jarakController.text) ?? 0,
                      iconName: selectedIcon ?? "location_on",
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
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
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
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
                leading: Icon(_iconDataFromName(area.iconName)),
                title: Text(area.nama),
                subtitle: Text('${area.jarakKm.toStringAsFixed(2)} km'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    setState(() {
                      areaAkomodasi.remove(area);
                    });
                  },
                ),
              )),
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
            const Text('Masukkan Data Hotel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(
                    controller: nameController,
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
                    label: 'Lokasi Detail (Alamat Lengkap)',
                    icon: Icons.place,
                    hint: 'Masukkan alamat lengkap hotel',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          controller: ratingController,
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
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                base64Decode(imageBase64!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(child: Text('Unggah Foto')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: saveHotel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text("Simpan"),
                    ),
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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
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
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
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
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
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
                    Icon(icon, size: 16),
                    const SizedBox(width: 4),
                    Text(fasilitas),
                  ],
                ),
                selected: selected,
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
                label: Text(badge),
                selected: selected,
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
}