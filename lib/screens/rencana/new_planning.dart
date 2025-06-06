import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/models/user_model.dart';

class NewPlanningPageBody extends StatefulWidget {
  final UserModel currentUser;

  const NewPlanningPageBody({Key? key, required this.currentUser}) : super(key: key);

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
  int? _editingIndex;

  String? _selectedOrigin;
  String? _selectedDestination;

  final List<String> _cities = [
    'Jakarta',
    'Bandung',
    'Yogyakarta',
    'Surabaya',
    'Denpasar'
  ];

  @override
  void initState() {
    super.initState();
    _initHiveBoxes();
  }

  Future<void> _initHiveBoxes() async {
    if (!Hive.isBoxOpen('rencana')) {
      await Hive.openBox<RencanaModel>('rencana');
    }

    _rencanaBox = Hive.box<RencanaModel>('rencana');
    setState(() {});
  }

  void _savePlan() {
    final name = _nameController.text;
    final origin = _originController.text;
    final destination = _destinationController.text;
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final sumDate = _sumDateController.text;
    final people = _peopleController.text;

    if (name.isEmpty || origin.isEmpty || destination.isEmpty || startDate.isEmpty || endDate.isEmpty || people.isEmpty || sumDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua kolom.')),
      );
      return;
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
    );

    if (_editingIndex == null) {
      _rencanaBox?.add(newPlan);
    } else {
      _rencanaBox?.putAt(_editingIndex!, newPlan);
      _editingIndex = null;
    }

    _nameController.clear();
    _originController.clear();
    _destinationController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _sumDateController.clear();
    _peopleController.clear();
    _selectedOrigin = null;
    _selectedDestination = null;

    setState(() {});
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    void Function()? onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.03),
      child: TextField(
        controller: controller,
        readOnly: onTap != null,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: screenWidth * 0.03),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue, ValueChanged<String?> onChanged) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.03),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.location_on_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: screenWidth * 0.03),
        ),
        items: _cities.map((city) => DropdownMenuItem(
          value: city,
          child: Text(city),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_rencanaBox == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userPlans = _rencanaBox!.values.where((plan) => plan.userId == widget.currentUser.email).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perencanaan Perjalanan"),
        backgroundColor: const Color(0xffdc2626),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.045),
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.045),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTextField(label: 'Nama Perjalanan', icon: Icons.description_outlined, controller: _nameController),
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
                _buildTextField(label: 'Jumlah Orang', icon: Icons.people_outline, controller: _peopleController),
                _buildTextField(
                  label: 'Tanggal Mulai',
                  icon: Icons.calendar_today_outlined,
                  controller: _startDateController,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                    }
                  },
                ),
                _buildTextField(
                  label: 'Tanggal Akhir',
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
                      if (_startDateController.text.isNotEmpty) {
                        final start = DateTime.tryParse(_startDateController.text);
                        final end = picked;
                        if (start != null) {
                          final diff = end.difference(start).inDays + 1;
                          _sumDateController.text = diff.toString();
                        }
                      }
                    }
                  },
                ),
                _buildTextField(label: 'Jumlah Hari', icon: Icons.calendar_view_day_outlined, controller: _sumDateController),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _savePlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffdc2626),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      _editingIndex == null ? 'Simpan Rencana' : 'Update Rencana',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Daftar Rencana:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Column(
            children: List.generate(userPlans.length, (i) => Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(userPlans[i].name),
                subtitle: Text("${userPlans[i].origin} ➜ ${userPlans[i].destination}\n${userPlans[i].startDate} - ${userPlans[i].endDate} (${userPlans[i].sumDate} hari)"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        _nameController.text = userPlans[i].name;
                        _originController.text = userPlans[i].origin;
                        _destinationController.text = userPlans[i].destination;
                        _startDateController.text = userPlans[i].startDate;
                        _endDateController.text = userPlans[i].endDate;
                        _sumDateController.text = userPlans[i].sumDate;
                        _peopleController.text = userPlans[i].people;
                        _selectedOrigin = userPlans[i].origin;
                        _selectedDestination = userPlans[i].destination;
                        _editingIndex = _rencanaBox!.values.toList().indexOf(userPlans[i]);
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        final actualIndex = _rencanaBox!.values.toList().indexOf(userPlans[i]);
                        _rencanaBox?.deleteAt(actualIndex);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}