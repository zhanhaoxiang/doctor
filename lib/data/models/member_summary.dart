import 'family_member.dart';

class MemberSummary {
  const MemberSummary({
    required this.member,
    required this.records,
    required this.followups,
    required this.isDefaultMember,
  });

  final FamilyMember member;
  final int records;
  final int followups;
  final bool isDefaultMember;

  String get badge {
    if (isDefaultMember) return '默认成员';
    if (followups > 0) return '待复诊';
    if (records > 0) return '已建档';
    return '未建档';
  }
}
