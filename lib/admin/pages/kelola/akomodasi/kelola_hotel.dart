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

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final ratingController = TextEditingController();
  final priceController = TextEditingController();

  String? selectedTipe;
  List<String> selectedFacilities = [];
  List<String> selectedBadges = [];
  String? imageBase64;
  int? editingIndex;

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
    locationController.clear();
    ratingController.clear();
    priceController.clear();
    selectedTipe = null;
    selectedFacilities.clear();
    selectedBadges.clear();
    imageBase64 = null;
    editingIndex = null;
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
    if (_formKey.currentState!.validate() && selectedFacilities.isNotEmpty) {
      final hotel = HotelModel(
        nama: nameController.text,
        lokasi: locationController.text,
        rating: double.tryParse(ratingController.text) ?? 0.0,
        harga: int.tryParse(priceController.text) ?? 0,
        tipe: selectedTipe ?? '',
        fasilitas: List.from(selectedFacilities),
        badge: List.from(selectedBadges),
        imageBase64: imageBase64 ?? '',
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
        locationController.text = hotel.lokasi;
        ratingController.text = hotel.rating.toString();
        priceController.text = hotel.harga.toString();
        selectedTipe = hotel.tipe;
        selectedFacilities = List<String>.from(hotel.fasilitas);
        selectedBadges = List<String>.from(hotel.badge);
        imageBase64 = hotel.imageBase64;
      });
    }
  }

  void deleteHotel(int index) {
    hotelBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final options = optionsBox.get(0);
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
                children: [
                  buildTextField(nameController, 'Nama'),
                  buildTextField(locationController, 'Lokasi'),
                  buildTextField(ratingController, 'Rating + Review'),
                  buildTextField(priceController, 'Harga kamar termurah', type: TextInputType.number),
                  buildDropdownField('Tipe', options.tipe, selectedTipe,
                      (value) => setState(() => selectedTipe = value)),
                  buildMultiFacilityField(options.facilities),
                  buildMultiBadgeField(options.badge),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: screenWidth * 0.26 + 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: imageBase64 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                base64Decode(imageBase64!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(child: Text('Unggah Foto')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: saveHotel,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan"),
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

  Widget buildTextField(TextEditingController controller, String label,
      {TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items, String? selectedValue,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        validator: (val) => val == null || val.isEmpty ? 'Wajib dipilih' : null,
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