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
  List<Map<String, String>> _plans = [];

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
        title: const Text('Konfirmasi'),
        content: Text(_editingIndex == null
            ? 'Simpan rencana baru?'
            : 'Simpan perubahan rencana?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffdc2626),
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Simpan', ),
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

    setState(() {
      if (_editingIndex == null) {
        _plans.add(plan);
      } else {
        _plans[_editingIndex!] = plan;
        _editingIndex = null;
      }
      _clearForm();
    });
  }

  void _clearForm() {
    _tripNameController.clear();
    _originCityController.clear();
    _destinationCityController.clear();
    _tripDateController.clear();
    _endDateController.clear();
    _totalDaysController.clear();
    _numberOfPeopleController.clear();
    _selectedOrigin = null;
    _selectedDestination = null;
  }

  void _editPlan(int index) {
    final plan = _plans[index];
    setState(() {
      _editingIndex = index;
      _tripNameController.text = plan['name']!;
      _originCityController.text = plan['origin']!;
      _destinationCityController.text = plan['destination']!;
      _tripDateController.text = plan['start date']!;
      _endDateController.text = plan['end date']!;
      _totalDaysController.text = plan['sum date']!;
      _numberOfPeopleController.text = plan['people']!;
      _selectedOrigin = plan['origin'];
      _selectedDestination = plan['destination'];
    });
  }

  void _deletePlan(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Rencana'),
        content: const Text('Yakin ingin menghapus rencana ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xffdc2626)),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _plans.removeAt(index);
        _editingIndex = null;
        _clearForm();
      });
    }
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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

  Widget _buildDropdownField(
    String hint,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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

  Widget _buildPlanCard(Map<String, String> plan, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(plan['name']!),
        subtitle: Text('${plan['origin']} → ${plan['destination']} • ${plan['start date']} s/d ${plan['end date']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _editPlan(index)),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deletePlan(index)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perencanaan Perjalanan"),
        backgroundColor: const Color(0xffdc2626),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTextField(hint: 'Nama Perjalanan', icon: Icons.description_outlined, controller: _tripNameController),
          _buildDropdownField('Asal Kota', _selectedOrigin, (val) {
            setState(() {
              _selectedOrigin = val;
              _originCityController.text = val!;
            });
          }),
          _buildDropdownField('Kota Tujuan', _selectedDestination, (val) {
            setState(() {
              _selectedDestination = val;
              _destinationCityController.text = val!;
            });
          }),
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
          _buildTextField(hint: 'Jumlah Hari', icon: Icons.calendar_view_day_outlined, controller: _totalDaysController),
          _buildTextField(hint: 'Jumlah Orang', icon: Icons.people_outline, controller: _numberOfPeopleController),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _savePlan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffdc2626),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              _editingIndex == null ? 'Simpan Rencana' : 'Update Rencana',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Daftar Rencana:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Column(
            children: _plans.asMap().entries.map((e) => _buildPlanCard(e.value, e.key)).toList(),
          ),
          
        ],
      ),
    );
  }
}