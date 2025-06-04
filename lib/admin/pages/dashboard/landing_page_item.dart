import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:tripmate_mobile/models/landing_page_model.dart'; // Sesuaikan path jika perlu

class LandingPageItem extends StatefulWidget {
  final int pageIndex;

  const LandingPageItem({
    required this.pageIndex,
    super.key,
  });

  @override
  State<LandingPageItem> createState() => _LandingPageItemState();
}

class _LandingPageItemState extends State<LandingPageItem> {
  late LandingPageModel landingData;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<LandingPageModel>('landingPageBox');

    // Ambil data dari Hive berdasarkan pageIndex, jika tidak ada gunakan default
    landingData = box.get(widget.pageIndex,
        defaultValue: LandingPageModel(
          title: 'Judul Default ${widget.pageIndex + 1}',
          description: 'Deskripsi default halaman ${widget.pageIndex + 1}',
          imageBytes: null,
        ))!;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        landingData.imageBytes = bytes;
      });
      _saveToHive();
    }
  }

  void _editContent() {
    final titleController = TextEditingController(text: landingData.title);
    final descriptionController = TextEditingController(text: landingData.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Konten'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Judul')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Deskripsi')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                landingData.title = titleController.text;
                landingData.description = descriptionController.text;
              });
              _saveToHive();
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _saveToHive() {
    final box = Hive.box<LandingPageModel>('landingPageBox');
    box.put(widget.pageIndex, landingData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: landingData.imageBytes != null
                  ? Image.memory(landingData.imageBytes!, width: 120, height: double.infinity, fit: BoxFit.cover)
                  : Image.asset('assets/pics/onboarding${widget.pageIndex + 1}.jpg',
                      width: 120, height: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Landing Page - ${widget.pageIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(landingData.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(landingData.description, style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload, size: 16),
                        label: const Text('Unggah Foto', style: TextStyle(fontSize: 10)),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _editContent,
                        icon: const Icon(Icons.edit, size: 14),
                        label: const Text('Edit', style: TextStyle(fontSize: 10)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0AA14),
                          minimumSize: const Size(60, 30),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
