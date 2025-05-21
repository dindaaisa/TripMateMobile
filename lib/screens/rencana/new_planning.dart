import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewPlanningPageBody extends StatefulWidget {
  final Function(Map<String, String> plan, int? editingIndex) onSave;

  const NewPlanningPageBody({super.key, required this.onSave});

  @override
  State<NewPlanningPageBody> createState() => _NewPlanningPageBodyState();
}

class _NewPlanningPageBodyState extends State<NewPlanningPageBody> {
  final _tripNameController = TextEditingController();
  final _originCityController = TextEditingController();
  final _destinationCityController = TextEditingController();
  final _tripDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _totalDaysController = TextEditingController();
  final _numberOfPeopleController = TextEditingController();

  final List<String> _cityOptions = ['Surabaya', 'Bali', 'Jogja'];
  String? _selectedOrigin;
  String? _selectedDestination;

  int? _editingIndex;

  @override
  void dispose() {
    _tripNameController.dispose();
    _originCityController.dispose();
    _destinationCityController.dispose();
    _tripDateController.dispose();
    _endDateController.dispose();
    _totalDaysController.dispose();
    _numberOfPeopleController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    List<String> errors = [];

    if (_tripNameController.text.isEmpty) errors.add("Nama Perjalanan");
    if (_originCityController.text.isEmpty) errors.add("Asal Kota");
    if (_destinationCityController.text.isEmpty) errors.add("Kota Tujuan");
    if (_tripDateController.text.isEmpty) errors.add("Tanggal Perjalanan");
    if (_endDateController.text.isEmpty) errors.add("Tanggal Akhir");
    if (_totalDaysController.text.isEmpty) errors.add("Jumlah Hari");
    if (_numberOfPeopleController.text.isEmpty) errors.add("Jumlah Orang");

    if (errors.isNotEmpty) {
      final message = "Harap isi: ${errors.join(', ')}";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    return true;
  }

  void _savePlan() async {
    if (!_validateInputs()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Simpan'),
        content: Text(_editingIndex == null
            ? 'Yakin ingin menyimpan rencana baru ini?'
            : 'Yakin ingin menyimpan perubahan rencana ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xffdc2626),
            ),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final plan = {
      'name': _tripNameController.text,
      'origin': _originCityController.text,
      'destination': _destinationCityController.text,
      'start date': _tripDateController.text,
      'end date': _endDateController.text,
      'sum date': _totalDaysController.text,
      'people': _numberOfPeopleController.text,
    };

    widget.onSave(plan, _editingIndex);
    Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: onTap != null,
              onTap: onTap,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rencana Baru"),
        backgroundColor: const Color(0xffdc2626),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTextField(hint: 'Nama Perjalanan', icon: Icons.description_outlined, controller: _tripNameController),
                  const SizedBox(height: 18),
                  _buildDropdownField('Asal Kota', _selectedOrigin, (val) {
                    setState(() {
                      _selectedOrigin = val;
                      _originCityController.text = val!;
                    });
                  }),
                  const SizedBox(height: 16),
                  _buildDropdownField('Kota Tujuan', _selectedDestination, (val) {
                    setState(() {
                      _selectedDestination = val;
                      _destinationCityController.text = val!;
                    });
                  }),
                  const SizedBox(height: 16),
                  _buildTextField(
                    hint: 'Tanggal Perjalanan',
                    icon: Icons.calendar_today_outlined,
                    controller: _tripDateController,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        _tripDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    hint: 'Tanggal Akhir',
                    icon: Icons.calendar_today_outlined,
                    controller: _endDateController,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(hint: 'Jumlah Hari', icon: Icons.calendar_view_day_outlined, controller: _totalDaysController),
                  const SizedBox(height: 18),
                  _buildTextField(hint: 'Jumlah Orang', icon: Icons.people_outline, controller: _numberOfPeopleController),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _savePlan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffdc2626),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Simpan Rencana',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String hint,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedValue,
                hint: Text(hint),
                items: _cityOptions.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
