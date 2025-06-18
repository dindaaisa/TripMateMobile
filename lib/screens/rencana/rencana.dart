import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'new_planning.dart';

class RencanaScreen extends StatefulWidget {
  final UserModel currentUser;
  final void Function(String category)? onCategoryTap;
  const RencanaScreen({super.key, required this.currentUser, this.onCategoryTap});

  @override
  State<RencanaScreen> createState() => _RencanaScreenState();
}

class _RencanaScreenState extends State<RencanaScreen> {
  bool showForm = false;
  RencanaModel? selectedPlan;
  int? selectedPlanIndex;
  bool isEditMode = false;
  Box<RencanaModel>? _rencanaBox;
  List<RencanaModel> _userPlans = [];
  List<RencanaModel> _filteredPlans = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  RencanaModel? _previewPlan;
  int? _previewPlanIndex;

  @override
  void initState() {
    super.initState();
    _initHiveBoxes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterPlans();
    });
  }

  void _filterPlans() {
    if (_searchQuery.isEmpty) {
      _filteredPlans = List.from(_userPlans);
    } else {
      _filteredPlans = _userPlans.where((plan) {
        final name = plan.name.toLowerCase();
        final origin = plan.origin.toLowerCase();
        final destination = plan.destination.toLowerCase();
        final akomodasi = plan.akomodasi?.toLowerCase() ?? '';
        final transportasi = plan.transportasi?.toLowerCase() ?? '';
        final mobil = plan.mobil?.toLowerCase() ?? '';
        
        return name.contains(_searchQuery) || 
               origin.contains(_searchQuery) || 
               destination.contains(_searchQuery) ||
               akomodasi.contains(_searchQuery) ||
               transportasi.contains(_searchQuery) ||
               mobil.contains(_searchQuery);
      }).toList();
    }
  }

  Future<void> _initHiveBoxes() async {
    if (!Hive.isBoxOpen('rencanaBox')) {
      await Hive.openBox<RencanaModel>('rencanaBox');
    }
    _rencanaBox = Hive.box<RencanaModel>('rencanaBox');
    _refreshUserPlans();
  }

  void _refreshUserPlans() {
    if (_rencanaBox != null) {
      // Ambil semua rencana user yang belum dibayar (isPaid == false atau null)
      final plans = _rencanaBox!.values
          .where((plan) => 
              plan.userId == widget.currentUser.email && 
              (plan.isPaid == false || plan.isPaid == null))
          .toList();
      
      // Urutkan berdasarkan tanggal mulai
      plans.sort((a, b) {
        try {
          final dateA = DateTime.parse(a.startDate);
          final dateB = DateTime.parse(b.startDate);
          return dateA.compareTo(dateB);
        } catch (_) {
          return 0;
        }
      });
      
      // Update state hanya jika data berubah
      if (_userPlans.length != plans.length || 
          !_listEquals(_userPlans, plans)) {
        setState(() {
          _userPlans = plans;
          _filterPlans();
        });
      }
    }
  }

  // Helper method untuk membandingkan list
  bool _listEquals(List<RencanaModel> a, List<RencanaModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].key != b[i].key) return false;
    }
    return true;
  }

  void _showAddForm() {
    setState(() {
      showForm = true;
      selectedPlan = null;
      _previewPlan = null;
      _previewPlanIndex = null;
      isEditMode = false;
    });
  }

  void _editPlan(RencanaModel plan, int planIndex) {
    final updatedPlan = _rencanaBox!.getAt(planIndex);
    setState(() {
      showForm = true;
      selectedPlan = updatedPlan;
      _previewPlan = updatedPlan;
      _previewPlanIndex = planIndex;
      isEditMode = true;
    });
  }

  void _afterSaveOrUpdate(RencanaModel? plan, int? index, {bool editMode = false}) {
    _refreshUserPlans();
    setState(() {
      _previewPlan = plan;
      _previewPlanIndex = index;
      showForm = false;
      selectedPlan = null;
      isEditMode = false;
    });
  }

  int getTotalBiaya(RencanaModel plan) {
    // Akomodasi
    int akomodasi = plan.biayaAkomodasi ?? 0;
    // Transportasi (pesawat)
    int transportasi = plan.hargaPesawat ?? 0;
    // Mobil
    int mobil = plan.hargaMobil ?? 0;
    return akomodasi + transportasi + mobil;
  }

  @override
  Widget build(BuildContext context) {
    if (showForm) {
      return NewPlanningPageBody(
        currentUser: widget.currentUser,
        onCategoryTap: widget.onCategoryTap,
        isNewPlanMode: !isEditMode,
        selectedPlan: isEditMode ? selectedPlan : null,
        onCancel: () {
          setState(() {
            showForm = false;
            isEditMode = false;
            selectedPlan = null;
            _previewPlan = null;
            _previewPlanIndex = null;
          });
          _refreshUserPlans();
        },
        previewPlan: _previewPlan,
        previewPlanIndex: _previewPlanIndex,
        afterSaveOrUpdate: _afterSaveOrUpdate,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Temukan perjalanan impianmu! Ketik sesuatu...',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC2626),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        // Pencarian sudah dihandle oleh listener
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Konten utama dengan ListView
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _rencanaBox!.listenable(),
                builder: (context, Box<RencanaModel> box, _) {
                  // Panggil refresh setelah build selesai
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _refreshUserPlans();
                  });
                  
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Section info & tombol tambah rencana baru
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rencana Perjalanan Kamu!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Kumpulkan semua rencana seru di satu tempat!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC2626),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _showAddForm,
                                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                label: const Text(
                                  'Tambah Rencana Baru',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Tampilkan pesan jika tidak ada rencana
                      if (_filteredPlans.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Center(
                            child: Text(
                              _searchQuery.isNotEmpty
                                  ? "Tidak ada rencana yang sesuai dengan pencarian.\nCoba kata kunci lain."
                                  : "Belum ada rencana perjalanan.\nYuk tambah rencana baru!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      
                      // Tampilkan rencana terdekat (paling awal)
                      if (_filteredPlans.isNotEmpty) ...[
                        const Text(
                          'Rencana Terdekatmu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._filteredPlans.take(1).map((plan) {
                          final idx = _rencanaBox!.values.toList().indexOf(plan);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ModernRencanaCard(
                              plan: plan,
                              total: getTotalBiaya(plan),
                              onEdit: () => _editPlan(plan, idx),
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text('Hapus rencana perjalanan ini?'),
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
                                
                                if (confirm == true && idx >= 0) {
                                  await _rencanaBox!.deleteAt(idx);
                                  _refreshUserPlans();
                                }
                              },
                            ),
                          );
                        }),
                        
                        // Tampilkan semua rencana lainnya
                        if (_filteredPlans.length > 1) ...[
                          const Text(
                            'Semua Rencana Kamu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._filteredPlans.skip(1).map((plan) {
                            final idx = _rencanaBox!.values.toList().indexOf(plan);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ModernRencanaCard(
                                plan: plan,
                                total: getTotalBiaya(plan),
                                onEdit: () => _editPlan(plan, idx),
                                onDelete: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: const Text('Hapus rencana perjalanan ini?'),
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
                                  
                                  if (confirm == true && idx >= 0) {
                                    await _rencanaBox!.deleteAt(idx);
                                    _refreshUserPlans();
                                  }
                                },
                              ),
                            );
                          }),
                        ],
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card yang disesuaikan dengan gambar
class ModernRencanaCard extends StatelessWidget {
  final RencanaModel plan;
  final int total;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ModernRencanaCard({
    super.key,
    required this.plan,
    required this.total,
    this.onEdit,
    this.onDelete,
  });

  String formatTanggal(String tanggal) {
    try {
      final date = DateTime.parse(tanggal);
      final hari = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"][date.weekday - 1];
      return "$hari, ${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')} ${date.year.toString().substring(2)}";
    } catch (_) {
      return tanggal;
    }
  }

  // Method untuk menggabungkan multiple items dengan koma
  String _combineItems(List<String?> items) {
    final validItems = items.where((item) => item != null && item.trim().isNotEmpty).toList();
    return validItems.isEmpty ? "-" : validItems.join(", ");
  }

  @override
  Widget build(BuildContext context) {
    // Gabungkan transportasi dan mobil jika keduanya ada
    final transportasiItems = <String?>[];
    if (plan.transportasi != null && plan.transportasi!.trim().isNotEmpty) {
      transportasiItems.add(plan.transportasi);
    }
    if (plan.mobil != null && plan.mobil!.trim().isNotEmpty) {
      transportasiItems.add(plan.mobil);
    }
    final transportasiText = _combineItems(transportasiItems);

    // Gabungkan aktivitas dan kuliner jika keduanya ada
    final aktivitasItems = <String?>[];
    if (plan.aktivitasSeru != null && plan.aktivitasSeru!.trim().isNotEmpty) {
      aktivitasItems.add(plan.aktivitasSeru);
    }
    if (plan.kuliner != null && plan.kuliner!.trim().isNotEmpty) {
      aktivitasItems.add(plan.kuliner);
    }
    final aktivitasText = _combineItems(aktivitasItems);

    final akomodasi = (plan.akomodasi == null || plan.akomodasi!.trim().isEmpty) ? "-" : plan.akomodasi!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar persegi di sebelah kiri
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 100,
              height: 100,
              child: plan.imageBase64 != null && plan.imageBase64!.isNotEmpty
                  ? Image.memory(
                      base64Decode(plan.imageBase64!),
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, color: Colors.red, size: 30),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.photo, color: Colors.white, size: 30),
                    ),
            ),
          ),
          
          // Konten di sebelah kanan
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dengan action buttons
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${plan.name} (${plan.sumDate})",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEdit != null)
                        GestureDetector(
                          onTap: onEdit,
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Color(0xFFF0AA14),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (onDelete != null)
                        GestureDetector(
                          onTap: onDelete,
                          child: const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Informasi dengan icon dalam satu baris
                  if (akomodasi != "-")
                    _buildInfoRow(
                      icon: Icons.business,
                      text: akomodasi,
                      color: const Color(0xFF666666),
                    ),
                  
                  if (transportasiText != "-")
                    _buildInfoRow(
                      icon: Icons.flight,
                      text: transportasiText,
                      color: const Color(0xFF666666),
                    ),
                  
                  if (aktivitasText != "-")
                    _buildInfoRow(
                      icon: Icons.restaurant,
                      text: aktivitasText,
                      color: const Color(0xFF666666),
                    ),
                  
                  const SizedBox(height: 4),
                  
                  // Tanggal dan jumlah orang
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    text: "${formatTanggal(plan.startDate)} - ${formatTanggal(plan.endDate)}",
                    color: const Color(0xFF666666),
                  ),
                  
                  _buildInfoRow(
                    icon: Icons.people,
                    text: "${plan.people} orang",
                    color: const Color(0xFF666666),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
