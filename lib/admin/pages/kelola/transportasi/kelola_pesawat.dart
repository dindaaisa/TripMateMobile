import 'package:flutter/material.dart';

class KelolaPesawatPage extends StatefulWidget {
  final VoidCallback? onBack;

  const KelolaPesawatPage({Key? key, this.onBack}) : super(key: key);

  @override
  State<KelolaPesawatPage> createState() => _KelolaPesawatPageState();
}

class _KelolaPesawatPageState extends State<KelolaPesawatPage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? flightId;
  final airlineController = TextEditingController();
  final departureController = TextEditingController();
  final arrivalController = TextEditingController();
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final priceController = TextEditingController();

  // Dummy data
  List<Map<String, String>> flights = [];

  void resetForm() {
    setState(() {
      flightId = null;
      airlineController.clear();
      departureController.clear();
      arrivalController.clear();
      originController.clear();
      destinationController.clear();
      priceController.clear();
    });
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      final flight = {
        'id': flightId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'airline': airlineController.text,
        'departure': departureController.text,
        'arrival': arrivalController.text,
        'origin': originController.text,
        'destination': destinationController.text,
        'price': priceController.text,
      };

      if (flightId != null) {
        // Tampilkan dialog konfirmasi hanya saat update
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi Update'),
            content: const Text('Yakin ingin menyimpan perubahan data ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Ya'),
              ),
            ],
          ),
        );

        if (confirmed != true) return;
      }

      setState(() {
        if (flightId != null) {
          flights =
              flights.map((f) => f['id'] == flightId ? flight : f).toList();
        } else {
          flights.add(flight);
        }
        resetForm();
      });
    }
  }

  void editFlight(Map<String, String> flight) {
    setState(() {
      flightId = flight['id'];
      airlineController.text = flight['airline']!;
      departureController.text = flight['departure']!;
      arrivalController.text = flight['arrival']!;
      originController.text = flight['origin']!;
      destinationController.text = flight['destination']!;
      priceController.text = flight['price']!;
    });
  }

  void deleteFlight(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin mau hapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        flights.removeWhere((flight) => flight['id'] == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                'Kelola Pesawat',
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
          children: [
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField("Maskapai", airlineController),
                  buildDateTimeField("Waktu Keberangkatan", departureController),
                  buildDateTimeField("Waktu Kedatangan", arrivalController),
                  buildTextField("Asal", originController),
                  buildTextField("Tujuan", destinationController),
                  buildTextField("Harga", priceController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              flightId == null ? Colors.blue : Colors.green,
                        ),
                        child: Text(flightId == null ? 'Tambah' : 'Update'),
                      ),
                      ElevatedButton(
                        onPressed: resetForm,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        child: const Text("Reset"),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const Text(
              'Daftar Penerbangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text('${flight['airline']} (${flight['price']})'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${flight['origin']} → ${flight['destination']}'),
                        Text('Keberangkatan: ${flight['departure']}'),
                        Text('Kedatangan: ${flight['arrival']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () async {
                            editFlight(flight);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteFlight(flight['id']!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  Widget buildDateTimeField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              final dateTime = DateTime(
                  date.year, date.month, date.day, time.hour, time.minute);
              controller.text = dateTime.toString();
            }
          }
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }
}