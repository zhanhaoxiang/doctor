import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/next_appointment.dart';
import '../../../routes/app_routes.dart';

class ReminderBanner extends StatelessWidget {
  final NextAppointment? appointment;

  const ReminderBanner({super.key, this.appointment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.reminders),
      child: appointment != null ? _AppointmentCard(appointment: appointment!) : const _EmptyCard(),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final NextAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF9F0A).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9F0A).withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('⏰', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '下次就诊：${appointment.formattedDate}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${appointment.hospital} · ${appointment.department}',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFB45309).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Color(0xFFD97706)),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x0F000000)),
      ),
      child: Row(
        children: [
          const Text('📅', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              '暂无下次就诊安排',
              style: TextStyle(fontSize: 14, color: Color(0xFF8A8A8F)),
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Color(0xFF8A8A8F)),
        ],
      ),
    );
  }
}

