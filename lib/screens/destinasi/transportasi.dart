import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'cari_transportasi.dart';

class TransportasiWidget extends StatefulWidget {
  final UserModel currentUser;
  final String? location;

  const TransportasiWidget({Key? key, required this.currentUser, this.location}) : super(key: key);

  @override
  State<TransportasiWidget> createState() => _TransportasiWidgetState();
}

class _TransportasiWidgetState extends State<TransportasiWidget> {
  final TextEditingController _penumpangController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _tanggalKedatanganController = TextEditingController();

  String? _selectedAsal;
  String? _selectedTujuan;
  bool _pulangPergi = false;

  final FocusNode _penumpangFocus = FocusNode();

  List<String> _lokasiList = [];

  @override
  void initState() {
    super.initState();
    final lokasiBox = Hive.box('lokasiBox');
    final list = lokasiBox.get('list');
    if (list != null && list is List) {
      _lokasiList = List<String>.from(list);
    } else {
      _lokasiList = [
        "Jakarta, DKI Jakarta",
        "Surabaya, Jawa Timur",
        "Denpasar, Bali",
        "Yogyakarta, DI Yogyakarta",
      ];
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _penumpangController.dispose();
    _tanggalController.dispose();
    _tanggalKedatanganController.dispose();
    _penumpangFocus.dispose();
    super.dispose();
  }

  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 15),
        floatingLabelStyle: const TextStyle(color: Color(0xFFDC2626)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      ),
      items: items
          .map((loc) => DropdownMenuItem<String>(
                value: loc,
                child: Text(loc),
              ))
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
      style: const TextStyle(fontSize: 15, color: Colors.black),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: type,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
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
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 15),
        floatingLabelStyle: const TextStyle(color: Color(0xFFDC2626)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      ),
      style: const TextStyle(fontSize: 15),
    );
  }

  void _goToCariTransportasi() {
    if (_selectedAsal == null || _selectedTujuan == null || _tanggalController.text.isEmpty || _penumpangController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi data pencarian!')),
      );
      return;
    }

    final DateTime? tanggalBerangkat = DateTime.tryParse(_tanggalController.text);
    final DateTime? tanggalPulang = _pulangPergi && _tanggalKedatanganController.text.isNotEmpty
        ? DateTime.tryParse(_tanggalKedatanganController.text)
        : null;
    final int? jumlahPenumpang = int.tryParse(_penumpangController.text);

    if (tanggalBerangkat == null || (_pulangPergi && tanggalPulang == null) || jumlahPenumpang == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format tanggal/jumlah penumpang salah!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CariTransportasiPage(
          args: CariTransportasiArgs(
            asal: _selectedAsal!,
            tujuan: _selectedTujuan!,
            tanggalBerangkat: tanggalBerangkat,
            tanggalPulang: tanggalPulang,
            jumlahPenumpang: jumlahPenumpang,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = 16.0;
    final cardRadius = 18.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 2, left: 2),
                child: Text(
                  "Butuh Transportasi?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.13),
                        blurRadius: 24,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildDropdownField(
                              label: "Asal Kota",
                              value: _selectedAsal,
                              items: _lokasiList,
                              icon: Icons.person_pin_circle_outlined,
                              onChanged: (val) {
                                setState(() {
                                  _selectedAsal = val;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: buildDropdownField(
                              label: "Kota Tujuan",
                              value: _selectedTujuan,
                              items: _lokasiList,
                              icon: Icons.location_on_outlined,
                              onChanged: (val) {
                                setState(() {
                                  _selectedTujuan = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context, _tanggalController),
                              child: AbsorbPointer(
                                child: buildTextField(
                                  controller: _tanggalController,
                                  focusNode: FocusNode(),
                                  label: "Tanggal Keberangkatan",
                                  icon: Icons.calendar_today_outlined,
                                  readOnly: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pulang Pergi?",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Switch(
                                value: _pulangPergi,
                                onChanged: (val) {
                                  setState(() {
                                    _pulangPergi = val;
                                    if (!val) _tanggalKedatanganController.clear();
                                  });
                                },
                                activeColor: const Color(0xFFDC2626),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (_pulangPergi) ...[
                        const SizedBox(height: 10),
                        buildTextField(
                          controller: _tanggalKedatanganController,
                          focusNode: FocusNode(),
                          label: "Tanggal Kedatangan",
                          icon: Icons.calendar_month_outlined,
                          readOnly: true,
                          onTap: () => _selectDate(context, _tanggalKedatanganController),
                        ),
                      ],
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: _penumpangController,
                        focusNode: _penumpangFocus,
                        label: "Jumlah Penumpang",
                        icon: Icons.person_outline,
                        type: TextInputType.number,
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          onPressed: _goToCariTransportasi,
                          child: const Text(
                            "Cari",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}