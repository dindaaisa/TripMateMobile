import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:hive/hive.dart';
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
  final TextEditingController _searchController = TextEditingController();

  RencanaModel? _previewPlan;
  int? _previewPlanIndex;

  @override
  void initState() {
    super.initState();
    _initHiveBoxes();
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
      setState(() {
        _userPlans = _rencanaBox!.values
            .where((plan) => plan.userId == widget.currentUser.email)
            .toList();
        _userPlans.sort((a, b) {
          try {
            final dateA = DateTime.parse(a.startDate);
            final dateB = DateTime.parse(b.startDate);
            return dateA.compareTo(dateB);
          } catch (_) {
            return 0;
          }
        });
      });
    }
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
    // Ambil data terbaru dari Hive setelah update/hapus akomodasi
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

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header search bar
          Container(
            padding: const EdgeInsets.all(0),
            color: Colors.white,
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
                  decoration: BoxDecoration(
                    color: Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
          if (_userPlans.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: Text(
                  "Belum ada rencana perjalanan.\nYuk tambah rencana baru!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          if (_userPlans.isNotEmpty) ...[
            const Text(
              'Rencana Terdekatmu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            ..._userPlans.take(1).map((plan) {
              final idx = _rencanaBox!.values.toList().indexOf(plan);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RencanaCard(
                  plan: plan,
                  onEdit: () => _editPlan(plan, idx),
                  onDelete: () async {
                    if (idx >= 0) {
                      await _rencanaBox!.deleteAt(idx);
                      _refreshUserPlans();
                    }
                  },
                ),
              );
            }),
            if (_userPlans.length > 1) ...[
              const Text(
                'Semua Rencana Kamu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              ..._userPlans.skip(1).map((plan) {
                final idx = _rencanaBox!.values.toList().indexOf(plan);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RencanaCard(
                    plan: plan,
                    onEdit: () => _editPlan(plan, idx),
                    onDelete: () async {
                      if (idx >= 0) {
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
      ),
    );
  }
}

class RencanaCard extends StatelessWidget {
  final RencanaModel plan;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RencanaCard({
    super.key,
    required this.plan,
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

  @override
  Widget build(BuildContext context) {
    final akomodasi = (plan.akomodasi == null || plan.akomodasi!.trim().isEmpty) ? "-" : plan.akomodasi!;
    final transportasi = (plan.transportasi == null || plan.transportasi!.trim().isEmpty) ? "-" : plan.transportasi!;
    final aktivitasSeru = (plan.aktivitasSeru == null || plan.aktivitasSeru!.trim().isEmpty) ? "-" : plan.aktivitasSeru!;
    final kuliner = (plan.kuliner == null || plan.kuliner!.trim().isEmpty) ? "-" : plan.kuliner!;

    return Container(
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 100,
              height: 120,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plan.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (onDelete != null)
                        GestureDetector(
                          onTap: onDelete,
                          child: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (onEdit != null)
                        GestureDetector(
                          onTap: onEdit,
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Color(0xFFF0AA14),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.hotel, size: 14, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          akomodasi,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.flight, size: 14, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          transportasi,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.surfing, size: 14, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          aktivitasSeru,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.restaurant, size: 14, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          kuliner,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Text(
                        "${formatTanggal(plan.startDate)} - ${formatTanggal(plan.endDate)}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.people, size: 12, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Text(
                        '${plan.people} orang',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}