import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/models/user_model.dart';

void showTambahDalamRencanaModal({
  required BuildContext context,
  required UserModel currentUser,
  required List<RencanaModel> userPlans,
  required void Function(RencanaModel) onPlanSelected,
  VoidCallback? onAddPlanningBaru,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // Header & Close
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Tambahkan item ke rencana perjalanan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 10),
            // Tombol tambah planning baru
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Tambah Planning Baru', style: TextStyle(fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  if (onAddPlanningBaru != null) onAddPlanningBaru();
                },
              ),
            ),
            const SizedBox(height: 20),
            if (userPlans.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "Belum ada rencana perjalanan.\nSilakan buat rencana dulu.",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            if (userPlans.isNotEmpty)
              ...userPlans.map(
                (plan) => Container(
                  margin: const EdgeInsets.only(bottom: 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(11),
                          bottomLeft: Radius.circular(11),
                        ),
                        child: plan.imageBase64 != null && plan.imageBase64!.isNotEmpty
                            ? Image.memory(
                                base64Decode(plan.imageBase64!),
                                width: 90,
                                height: 95,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 90,
                                height: 95,
                                color: Colors.grey[300],
                                child: const Icon(Icons.photo, color: Colors.white),
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                // Misal: "2 Hari 1 Malam" jika sumDate = "2"
                                "${plan.sumDate} Hari"
                                "${int.tryParse(plan.sumDate) != null && int.parse(plan.sumDate) > 1 ? ' ${int.parse(plan.sumDate) - 1} Malam' : ''}",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Color(0xFFDC2626), size: 32),
                        onPressed: () {
                          Navigator.pop(ctx);
                          onPlanSelected(plan);
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}