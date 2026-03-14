import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/family_member.dart';
import '../../data/models/medical_record.dart';
import '../../data/models/next_appointment.dart';

class HomeController extends GetxController {
  // ── 家庭成员 ─────────────────────────────────────────────
  final familyMembers = const <FamilyMember>[
    FamilyMember(
      id: 'mom',
      name: '妈妈',
      accentColor: AppColors.memberOrange,
      tagBgColor: AppColors.tagMomBg,
      tagTextColor: AppColors.tagMomText,
    ),
    FamilyMember(
      id: 'dad',
      name: '爸爸',
      accentColor: AppColors.memberBlue,
      tagBgColor: AppColors.tagDadBg,
      tagTextColor: AppColors.tagDadText,
    ),
    FamilyMember(
      id: 'child1',
      name: '大宝',
      accentColor: AppColors.memberPurple,
      tagBgColor: AppColors.tagChild1Bg,
      tagTextColor: AppColors.tagChild1Text,
    ),
    FamilyMember(
      id: 'child2',
      name: '二宝',
      accentColor: AppColors.accent,
      tagBgColor: AppColors.tagChild2Bg,
      tagTextColor: AppColors.tagChild2Text,
    ),
  ];

  /// -1 = 全部
  final selectedMemberIndex = (-1).obs;

  // ── 下次就诊提醒 ─────────────────────────────────────────
  final nextAppointment = NextAppointment(
    dateTime: DateTime(2026, 3, 15, 9, 30),
    hospital: '北京协和医院',
    department: '呼吸内科复诊',
  ).obs;

  // ── 病历记录（模拟数据）──────────────────────────────────
  final records = <MedicalRecord>[
    MedicalRecord(
      id: '1',
      hospitalName: '北京协和医院',
      visitDate: DateTime(2026, 3, 8, 9, 22),
      aiSummary: 'AI 摘要：咳嗽 2 周，影像提示轻度炎症。医嘱：按时用药，3 天后复诊。',
      tags: const [RecordTag('#呼吸内科')],
      familyMemberId: 'mom',
    ),
    MedicalRecord(
      id: '2',
      hospitalName: '儿童医院',
      visitDate: DateTime(2026, 3, 3, 15, 40),
      aiSummary: 'AI 摘要：发热 38.5°C，咽部充血。医嘱：布洛芬退热，多饮水，2 日后复查。',
      tags: const [RecordTag('#儿科')],
      familyMemberId: 'child1',
    ),
    MedicalRecord(
      id: '3',
      hospitalName: '社区医院',
      visitDate: DateTime(2026, 3, 1, 10, 00),
      aiSummary: 'AI 摘要：常规打疫苗，无异常反应。医嘱：观察 24 小时。',
      tags: const [RecordTag('#预防接种')],
      familyMemberId: 'child2',
    ),
    MedicalRecord(
      id: '4',
      hospitalName: '301 医院',
      visitDate: DateTime(2026, 2, 21, 14, 18),
      aiSummary: 'AI 摘要：血压波动，心电图无明显异常。医嘱：调整降压药剂量，记录血压。',
      tags: const [RecordTag('#心内科')],
      familyMemberId: 'dad',
    ),
    MedicalRecord(
      id: '5',
      hospitalName: '社区医院',
      visitDate: DateTime(2026, 2, 2, 11, 30),
      aiSummary: 'AI 摘要：体检指标整体稳定。医嘱：保持作息，3 个月复查。',
      tags: const [RecordTag('#全科'), RecordTag('#家庭')],
      familyMemberId: null,
    ),
    MedicalRecord(
      id: '6',
      hospitalName: '北京协和医院',
      visitDate: DateTime(2026, 1, 15, 9, 00),
      aiSummary: 'AI 摘要：复查结果正常，肺部炎症已消退。医嘱：停药，注意保暖。',
      tags: const [RecordTag('#呼吸内科')],
      familyMemberId: 'mom',
    ),
  ];

  // ── 过滤 & 分组 ─────────────────────────────────────────
  List<MedicalRecord> get filteredRecords {
    final idx = selectedMemberIndex.value;
    if (idx < 0) return records;
    final memberId = familyMembers[idx].id;
    return records.where((r) => r.familyMemberId == null || r.familyMemberId == memberId).toList();
  }

  /// 按月分组，返回有序列表
  List<({String label, List<MedicalRecord> records})> get groupedRecords {
    final filtered = filteredRecords;
    final Map<String, List<MedicalRecord>> map = {};
    for (final r in filtered) {
      map.putIfAbsent(r.monthGroupKey, () => []).add(r);
    }
    return map.entries.map((e) => (label: e.key, records: e.value)).toList();
  }

  FamilyMember? memberById(String? id) {
    if (id == null) return null;
    try {
      return familyMembers.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> selectMember(int index) async {
    selectedMemberIndex.value = selectedMemberIndex.value == index ? -1 : index;
    var dio = Dio();
    var res = await dio.get('https://www.baidu.com');
    debugPrint('Dio response status: ${res.statusCode}');
  }
}
