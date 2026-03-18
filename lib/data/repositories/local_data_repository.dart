import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetxService;

import '../../core/theme/app_colors.dart';
import '../local/app_database.dart';
import '../models/app_notification.dart';
import '../models/app_reminder.dart';
import '../models/family_member.dart';
import '../models/followup_plan.dart';
import '../models/medical_record.dart' as record_model;
import '../models/member_summary.dart';
import '../models/next_appointment.dart';
import '../models/record_attachment.dart' as attachment_model;

class LocalDataRepository extends GetxService {
  LocalDataRepository({AppDatabase? database}) : _db = database ?? AppDatabase();

  final AppDatabase _db;

  Future<LocalDataRepository> init() async {
    await _ensureSeedData();
    return this;
  }

  AppDatabase get db => _db;

  Future<void> _ensureSeedData() async {
    final existing = await (_db.select(_db.members)..limit(1)).getSingleOrNull();
    if (existing != null) return;

    final now = DateTime.now();
    final memberId = _newId('member');
    final tagClinicId = _newId('tag');
    final tagHealthId = _newId('tag');
    final visitDate = now.subtract(const Duration(days: 5));
    final followupAt = now.add(const Duration(days: 2));
    final reminderAt = DateTime(now.year, now.month, now.day, 20, 0);
    final recordId = _newId('record');

    await _db.transaction(() async {
      await _db
          .into(_db.members)
          .insert(
            MembersCompanion.insert(
              id: memberId,
              name: '默认病历本',
              accentColor: AppColors.accent.toARGB32(),
              tagBgColor: AppColors.accentLight.toARGB32(),
              tagTextColor: AppColors.accentDark.toARGB32(),
              isDefaultMember: const drift.Value(true),
              createdAt: now,
            ),
          );

      await _db.batch((batch) {
        batch.insertAll(_db.tags, [
          TagsCompanion.insert(id: tagClinicId, label: '#门诊', createdAt: now),
          TagsCompanion.insert(id: tagHealthId, label: '#体检', createdAt: now),
          TagsCompanion.insert(id: _newId('tag'), label: '#复诊', createdAt: now),
        ]);

        batch.insert(
          _db.medicalRecords,
          MedicalRecordsCompanion.insert(
            id: recordId,
            hospitalName: '协和互联网医院',
            department: const drift.Value('全科门诊'),
            doctorName: const drift.Value('李医生'),
            visitDate: visitDate,
            complaint: const drift.Value('例行复查'),
            diagnosis: const drift.Value('恢复良好'),
            aiSummary: 'AI 摘要：整体恢复良好，建议继续观察作息与饮食。',
            doctorOrder: const drift.Value('两周后复查，注意规律作息，多饮水。'),
            source: const drift.Value('系统初始化'),
            memberId: drift.Value(memberId),
            createdAt: now,
            updatedAt: now,
          ),
        );

        batch.insertAll(_db.recordTagLinks, [
          RecordTagLinksCompanion.insert(recordId: recordId, tagId: tagClinicId),
          RecordTagLinksCompanion.insert(recordId: recordId, tagId: tagHealthId),
        ]);

        batch.insert(
          _db.reminders,
          RemindersCompanion.insert(
            id: _newId('reminder'),
            title: '我 · 睡前测量体温',
            body: '记录今晚体温变化，若异常请补充备注。',
            remindAt: reminderAt,
            type: const drift.Value('health'),
            memberId: drift.Value(memberId),
            createdAt: now,
          ),
        );

        batch.insert(
          _db.followups,
          FollowupsCompanion.insert(
            id: _newId('followup'),
            hospital: '协和互联网医院',
            department: '全科门诊',
            scheduledAt: followupAt,
            note: const drift.Value('携带最近一次体温记录'),
            memberId: drift.Value(memberId),
            createdAt: now,
          ),
        );

        batch.insert(
          _db.notifications,
          NotificationsCompanion.insert(
            id: _newId('notice'),
            title: '欢迎使用病历管家',
            body: '已为你创建默认成员“我”，可以前往设置页随时修改名称。',
            type: const drift.Value('welcome'),
            memberId: drift.Value(memberId),
            createdAt: now,
          ),
        );
      });
    });
  }

  Stream<List<FamilyMember>> watchMembers() {
    final query = _db.select(_db.members)..orderBy([(table) => drift.OrderingTerm.asc(table.createdAt)]);
    return query.watch().map((rows) => rows.map(_mapMember).toList());
  }

  Future<List<FamilyMember>> loadMembers() async {
    final query = _db.select(_db.members)..orderBy([(table) => drift.OrderingTerm.asc(table.createdAt)]);
    final rows = await query.get();
    return rows.map(_mapMember).toList();
  }

  Future<String?> getMemberName(String? memberId) async {
    if (memberId == null) return null;
    final row = await (_db.select(_db.members)..where((table) => table.id.equals(memberId))).getSingleOrNull();
    return row?.name;
  }

  Stream<List<MemberSummary>> watchMemberSummaries() {
    return _db
        .customSelect(
          '''
          SELECT m.id,
                 m.name,
                 m.accent_color,
                 m.tag_bg_color,
                 m.tag_text_color,
                 m.is_default_member,
                 COUNT(DISTINCT mr.id) AS records_count,
                 COUNT(DISTINCT f.id) AS followups_count
            FROM members m
            LEFT JOIN medical_records mr ON mr.member_id = m.id
            LEFT JOIN followups f ON f.member_id = m.id
           GROUP BY m.id
           ORDER BY m.created_at ASC
          ''',
          readsFrom: {_db.members, _db.medicalRecords, _db.followups},
        )
        .watch()
        .map(
          (rows) => rows.map((row) {
            final member = FamilyMember(
              id: row.read<String>('id'),
              name: row.read<String>('name'),
              accentColor: Color(row.read<int>('accent_color')),
              tagBgColor: Color(row.read<int>('tag_bg_color')),
              tagTextColor: Color(row.read<int>('tag_text_color')),
            );
            return MemberSummary(
              member: member,
              records: row.read<int>('records_count'),
              followups: row.read<int>('followups_count'),
              isDefaultMember: row.read<bool>('is_default_member'),
            );
          }).toList(),
        );
  }

  Stream<List<record_model.MedicalRecord>> watchMedicalRecords() {
    return _db
        .customSelect(
          '''
          SELECT mr.id,
                 mr.hospital_name,
                 mr.department,
                 mr.doctor_name,
                 mr.visit_date,
                 mr.complaint,
                 mr.diagnosis,
                 mr.ai_summary,
                 mr.doctor_order,
                 mr.source,
                 mr.member_id,
                 t.label AS tag_label,
                 t.bg_color AS tag_bg_color,
                 t.text_color AS tag_text_color
            FROM medical_records mr
            LEFT JOIN record_tag_links rtl ON rtl.record_id = mr.id
            LEFT JOIN tags t ON t.id = rtl.tag_id
           ORDER BY mr.visit_date DESC
          ''',
          readsFrom: {_db.medicalRecords, _db.recordTagLinks, _db.tags},
        )
        .watch()
        .map(_groupRecordRows);
  }

  Stream<NextAppointment?> watchNextAppointment() {
    // 优先从复诊提醒（type=followup）中读取，再 fallback 到 followups 表
    return _db
        .customSelect(
          '''
          SELECT title AS hospital, body AS department, remind_at AS scheduled_at
            FROM reminders
           WHERE type = 'followup' AND remind_at >= ?
           UNION ALL
          SELECT hospital, department, scheduled_at
            FROM followups
           WHERE scheduled_at >= ?
           ORDER BY scheduled_at ASC
           LIMIT 1
          ''',
          variables: [
            drift.Variable.withDateTime(DateTime.now()),
            drift.Variable.withDateTime(DateTime.now()),
          ],
          readsFrom: {_db.reminders, _db.followups},
        )
        .watch()
        .map((rows) {
          if (rows.isEmpty) return null;
          final row = rows.first;
          return NextAppointment(
            dateTime: row.read<DateTime>('scheduled_at'),
            hospital: row.read<String>('hospital'),
            department: row.read<String>('department'),
          );
        });
  }

  Future<record_model.MedicalRecord?> getMedicalRecord(String recordId) async {
    final row = await (_db.select(_db.medicalRecords)..where((table) => table.id.equals(recordId))).getSingleOrNull();
    if (row == null) return null;

    final tagRows = await _db
        .customSelect(
          '''
      SELECT t.label, t.bg_color, t.text_color
        FROM record_tag_links rtl
        JOIN tags t ON t.id = rtl.tag_id
       WHERE rtl.record_id = ?
      ''',
          variables: [drift.Variable.withString(recordId)],
          readsFrom: {_db.recordTagLinks, _db.tags},
        )
        .get();

    final attachments =
        await (_db.select(_db.recordAttachments)
              ..where((table) => table.recordId.equals(recordId))
              ..orderBy([(table) => drift.OrderingTerm.asc(table.addedAt)]))
            .get();

    return record_model.MedicalRecord(
      id: row.id,
      hospitalName: row.hospitalName,
      visitDate: row.visitDate,
      aiSummary: row.aiSummary,
      tags: tagRows
          .map(
            (tagRow) => record_model.RecordTag(
              tagRow.read<String>('label'),
              bgColorValue: tagRow.data['bg_color'] as int?,
              textColorValue: tagRow.data['text_color'] as int?,
            ),
          )
          .toList(),
      familyMemberId: row.memberId,
      department: row.department,
      doctorName: row.doctorName,
      complaint: row.complaint,
      diagnosis: row.diagnosis,
      doctorOrder: row.doctorOrder,
      source: row.source,
      attachments: attachments
          .map(
            (attachment) => attachment_model.RecordAttachment(
              id: attachment.id,
              path: attachment.path,
              name: attachment.name,
              type: _attachmentTypeFromDb(attachment.type),
              addedAt: attachment.addedAt,
            ),
          )
          .toList(),
    );
  }

  Future<List<String>> loadHospitalHistory() async {
    final rows = await _db
        .customSelect(
          'SELECT DISTINCT hospital_name FROM medical_records ORDER BY updated_at DESC',
          readsFrom: {_db.medicalRecords},
        )
        .get();
    return rows.map((row) => row.read<String>('hospital_name')).toList();
  }

  Future<List<String>> loadDepartmentHistory() async {
    final rows = await _db
        .customSelect(
          "SELECT DISTINCT department FROM medical_records WHERE department IS NOT NULL AND department != '' ORDER BY updated_at DESC",
          readsFrom: {_db.medicalRecords},
        )
        .get();
    return rows.map((row) => row.read<String>('department')).toList();
  }

  /// 全文搜索病历：匹配医院名称、科室、诊断、主诉、AI摘要、医生姓名
  Future<List<record_model.MedicalRecord>> searchMedicalRecords(
    String query, {
    String? memberId,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final like = '%$q%';
    final variables = [
      drift.Variable.withString(like),
      drift.Variable.withString(like),
      drift.Variable.withString(like),
      drift.Variable.withString(like),
      drift.Variable.withString(like),
      drift.Variable.withString(like),
      if (memberId != null) drift.Variable.withString(memberId),
    ];
    final memberFilter = memberId != null ? 'AND mr.member_id = ?' : '';
    final rows = await _db
        .customSelect(
          '''
          SELECT mr.id,
                 mr.hospital_name,
                 mr.department,
                 mr.doctor_name,
                 mr.visit_date,
                 mr.complaint,
                 mr.diagnosis,
                 mr.ai_summary,
                 mr.doctor_order,
                 mr.source,
                 mr.member_id,
                 t.label  AS tag_label,
                 t.bg_color   AS tag_bg_color,
                 t.text_color AS tag_text_color
            FROM medical_records mr
            LEFT JOIN record_tag_links rtl ON rtl.record_id = mr.id
            LEFT JOIN tags t ON t.id = rtl.tag_id
           WHERE (
                      mr.hospital_name LIKE ?
                  OR  IFNULL(mr.department,  '') LIKE ?
                  OR  IFNULL(mr.diagnosis,   '') LIKE ?
                  OR  IFNULL(mr.complaint,   '') LIKE ?
                  OR  mr.ai_summary           LIKE ?
                  OR  IFNULL(mr.doctor_name, '') LIKE ?
                 )
                 $memberFilter
           ORDER BY mr.visit_date DESC
          ''',
          variables: variables,
          readsFrom: {_db.medicalRecords, _db.recordTagLinks, _db.tags},
        )
        .get();
    return _groupRecordRows(rows);
  }

  Stream<List<record_model.RecordTag>> watchTags() {
    final query = _db.select(_db.tags)..orderBy([(table) => drift.OrderingTerm.asc(table.createdAt)]);
    return query.watch().map(
      (rows) => rows
          .map((row) => record_model.RecordTag(row.label, bgColorValue: row.bgColor, textColorValue: row.textColor))
          .toList(),
    );
  }

  Stream<List<AppReminder>> watchReminders() {
    return _db
        .customSelect(
          '''
          SELECT r.id,
                 r.title,
                 r.body,
                 r.remind_at,
                 r.type,
                 r.member_id,
                 r.record_id,
                 m.name AS member_name
            FROM reminders r
            LEFT JOIN members m ON m.id = r.member_id
           ORDER BY r.remind_at ASC
          ''',
          readsFrom: {_db.reminders, _db.members},
        )
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => AppReminder(
                  id: row.read<String>('id'),
                  title: row.read<String>('title'),
                  body: row.read<String>('body'),
                  remindAt: row.read<DateTime>('remind_at'),
                  type: row.read<String>('type'),
                  memberId: row.data['member_id'] as String?,
                  memberName: row.data['member_name'] as String?,
                  recordId: row.data['record_id'] as String?,
                ),
              )
              .toList(),
        );
  }

  Stream<List<FollowupPlan>> watchFollowups() {
    return _db
        .customSelect(
          '''
          SELECT f.id,
                 f.hospital,
                 f.department,
                 f.scheduled_at,
                 f.note,
                 f.member_id,
                 m.name AS member_name,
                 m.is_default_member
            FROM followups f
            LEFT JOIN members m ON m.id = f.member_id
           ORDER BY f.scheduled_at ASC
          ''',
          readsFrom: {_db.followups, _db.members},
        )
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => FollowupPlan(
                  id: row.read<String>('id'),
                  hospital: row.read<String>('hospital'),
                  department: row.read<String>('department'),
                  scheduledAt: row.read<DateTime>('scheduled_at'),
                  note: row.data['note'] as String?,
                  memberId: row.data['member_id'] as String?,
                  memberName: row.data['member_name'] as String?,
                  isDefaultMember: (row.data['is_default_member'] as bool?) ?? false,
                ),
              )
              .toList(),
        );
  }

  Stream<List<AppNotification>> watchNotifications() {
    final query = _db.select(_db.notifications)..orderBy([(table) => drift.OrderingTerm.desc(table.createdAt)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) =>
                AppNotification(id: row.id, title: row.title, body: row.body, createdAt: row.createdAt, type: row.type),
          )
          .toList(),
    );
  }

  Future<void> clearNotifications() => _db.delete(_db.notifications).go();

  Future<void> addMember(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('成员名称不能为空');
    }

    final palette = _paletteAt((await loadMembers()).length);
    await _db
        .into(_db.members)
        .insert(
          MembersCompanion.insert(
            id: _newId('member'),
            name: trimmed,
            accentColor: palette.$1.toARGB32(),
            tagBgColor: palette.$2.toARGB32(),
            tagTextColor: palette.$3.toARGB32(),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> renameMember(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('成员名称不能为空');
    }

    await (_db.update(
      _db.members,
    )..where((table) => table.id.equals(id))).write(MembersCompanion(name: drift.Value(trimmed)));
  }

  Future<void> addTag(String label) async {
    final normalized = _normalizeTagLabel(label);
    if (normalized.isEmpty) {
      throw ArgumentError('标签名称不能为空');
    }

    final exists = await (_db.select(_db.tags)..where((table) => table.label.equals(normalized))).getSingleOrNull();
    if (exists != null) return;

    await _db
        .into(_db.tags)
        .insert(TagsCompanion.insert(id: _newId('tag'), label: normalized, createdAt: DateTime.now()));
  }

  Future<void> renameTag(String oldLabel, String newLabel) async {
    final normalized = _normalizeTagLabel(newLabel);
    if (normalized.isEmpty) {
      throw ArgumentError('标签名称不能为空');
    }

    await (_db.update(
      _db.tags,
    )..where((table) => table.label.equals(oldLabel))).write(TagsCompanion(label: drift.Value(normalized)));
  }

  Future<void> addReminder({
    required String title,
    required String body,
    required DateTime remindAt,
    String? memberId,
    String type = 'general',
  }) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db
          .into(_db.reminders)
          .insert(
            RemindersCompanion.insert(
              id: _newId('reminder'),
              title: title.trim(),
              body: body.trim(),
              remindAt: remindAt,
              type: drift.Value(type),
              memberId: drift.Value(memberId),
              createdAt: now,
            ),
          );
      await _db
          .into(_db.notifications)
          .insert(
            NotificationsCompanion.insert(
              id: _newId('notice'),
              title: title.trim(),
              body: body.trim(),
              type: const drift.Value('reminder'),
              memberId: drift.Value(memberId),
              createdAt: now,
            ),
          );
    });
  }

  Future<void> saveMedicalRecord({
    String? recordId,
    required String hospitalName,
    required String department,
    required String doctorName,
    required DateTime visitDate,
    required String diagnosis,
    required String summary,
    required String doctorOrder,
    required String? memberId,
    required List<attachment_model.RecordAttachment> attachments,
    DateTime? followupDate,
  }) async {
    final now = DateTime.now();
    final normalizedHospital = hospitalName.trim();
    final normalizedDepartment = department.trim();
    final normalizedDoctor = doctorName.trim();
    final normalizedDiagnosis = diagnosis.trim();
    final normalizedSummary = summary.trim();
    final normalizedDoctorOrder = doctorOrder.trim();
    final resolvedRecordId = recordId ?? _newId('record');
    final departmentTagId = normalizedDepartment.isEmpty ? null : await _ensureTagExists('#$normalizedDepartment');

    await _db.transaction(() async {
      if (recordId == null) {
        await _db
            .into(_db.medicalRecords)
            .insert(
              MedicalRecordsCompanion.insert(
                id: resolvedRecordId,
                hospitalName: normalizedHospital,
                department: drift.Value(normalizedDepartment.isEmpty ? null : normalizedDepartment),
                doctorName: drift.Value(normalizedDoctor.isEmpty ? null : normalizedDoctor),
                visitDate: visitDate,
                complaint: drift.Value(normalizedDiagnosis.isEmpty ? null : normalizedDiagnosis),
                diagnosis: drift.Value(normalizedDiagnosis.isEmpty ? null : normalizedDiagnosis),
                aiSummary: normalizedSummary.isEmpty ? '暂无摘要' : normalizedSummary,
                doctorOrder: drift.Value(normalizedDoctorOrder),
                source: const drift.Value('手动录入'),
                memberId: drift.Value(memberId),
                createdAt: now,
                updatedAt: now,
              ),
            );
      } else {
        await (_db.update(_db.medicalRecords)..where((table) => table.id.equals(resolvedRecordId))).write(
          MedicalRecordsCompanion(
            hospitalName: drift.Value(normalizedHospital),
            department: drift.Value(normalizedDepartment.isEmpty ? null : normalizedDepartment),
            doctorName: drift.Value(normalizedDoctor.isEmpty ? null : normalizedDoctor),
            visitDate: drift.Value(visitDate),
            complaint: drift.Value(normalizedDiagnosis.isEmpty ? null : normalizedDiagnosis),
            diagnosis: drift.Value(normalizedDiagnosis.isEmpty ? null : normalizedDiagnosis),
            aiSummary: drift.Value(normalizedSummary.isEmpty ? '暂无摘要' : normalizedSummary),
            doctorOrder: drift.Value(normalizedDoctorOrder),
            source: const drift.Value('手动录入'),
            memberId: drift.Value(memberId),
            updatedAt: drift.Value(now),
          ),
        );
        await (_db.delete(_db.recordAttachments)..where((table) => table.recordId.equals(resolvedRecordId))).go();
        await (_db.delete(_db.recordTagLinks)..where((table) => table.recordId.equals(resolvedRecordId))).go();
      }

      if (departmentTagId != null) {
        await _db
            .into(_db.recordTagLinks)
            .insert(RecordTagLinksCompanion.insert(recordId: resolvedRecordId, tagId: departmentTagId));
      }

      if (attachments.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(
            _db.recordAttachments,
            attachments
                .map(
                  (attachment) => RecordAttachmentsCompanion.insert(
                    id: attachment.id,
                    recordId: resolvedRecordId,
                    path: attachment.path,
                    name: attachment.name,
                    type: _attachmentTypeToDb(attachment.type),
                    addedAt: attachment.addedAt,
                  ),
                )
                .toList(),
          );
        });
      }
    });

    // 处理复诊提醒
    await upsertFollowupReminder(
      recordId: resolvedRecordId,
      followupDate: followupDate,
      memberId: memberId,
      hospitalName: normalizedHospital,
    );
  }

  /// 创建或更新/删除病历关联的复诊提醒
  Future<void> upsertFollowupReminder({
    required String recordId,
    DateTime? followupDate,
    String? memberId,
    String hospitalName = '',
  }) async {
    final now = DateTime.now();
    // 查找已有关联提醒
    final existing = await (_db.select(_db.reminders)
          ..where(
            (r) => r.recordId.equals(recordId) & r.type.equals('followup'),
          ))
        .getSingleOrNull();

    if (followupDate == null) {
      // 没有复诊日期 → 删除已有的
      if (existing != null) {
        await (_db.delete(_db.reminders)
              ..where((r) => r.id.equals(existing.id)))
            .go();
      }
      return;
    }

    if (existing != null) {
      // 更新已有提醒
      await (_db.update(_db.reminders)
            ..where((r) => r.id.equals(existing.id)))
          .write(
            RemindersCompanion(
              remindAt: drift.Value(followupDate),
              memberId: drift.Value(memberId),
              title: drift.Value(hospitalName.isNotEmpty ? hospitalName : existing.title),
            ),
          );
    } else {
      // 创建新的复诊提醒
      await _db.into(_db.reminders).insert(
            RemindersCompanion.insert(
              id: _newId('reminder'),
              title: hospitalName.isEmpty ? '下次复诊' : hospitalName,
              body: '下次复诊提醒',
              remindAt: followupDate,
              type: const drift.Value('followup'),
              memberId: drift.Value(memberId),
              recordId: drift.Value(recordId),
              createdAt: now,
            ),
          );
    }
  }

  /// 获取病历关联的复诊提醒日期
  Future<DateTime?> getFollowupReminderDate(String recordId) async {
    final row = await (_db.select(_db.reminders)
          ..where(
            (r) => r.recordId.equals(recordId) & r.type.equals('followup'),
          ))
        .getSingleOrNull();
    return row?.remindAt;
  }

  Future<void> close() => _db.close();

  FamilyMember _mapMember(Member row) {
    return FamilyMember(
      id: row.id,
      name: row.name,
      accentColor: Color(row.accentColor),
      tagBgColor: Color(row.tagBgColor),
      tagTextColor: Color(row.tagTextColor),
    );
  }

  List<record_model.MedicalRecord> _groupRecordRows(List<drift.QueryRow> rows) {
    final grouped = <String, record_model.MedicalRecord>{};
    final tagMap = <String, List<record_model.RecordTag>>{};

    for (final row in rows) {
      final recordId = row.read<String>('id');
      grouped.putIfAbsent(
        recordId,
        () => record_model.MedicalRecord(
          id: recordId,
          hospitalName: row.read<String>('hospital_name'),
          visitDate: row.read<DateTime>('visit_date'),
          aiSummary: row.read<String>('ai_summary'),
          tags: const [],
          familyMemberId: row.data['member_id'] as String?,
          department: row.data['department'] as String?,
          doctorName: row.data['doctor_name'] as String?,
          complaint: row.data['complaint'] as String?,
          diagnosis: row.data['diagnosis'] as String?,
          doctorOrder: row.read<String>('doctor_order'),
          source: row.read<String>('source'),
        ),
      );

      final label = row.data['tag_label'] as String?;
      if (label != null) {
        tagMap.putIfAbsent(recordId, () => []);
        tagMap[recordId]!.add(
          record_model.RecordTag(
            label,
            bgColorValue: row.data['tag_bg_color'] as int?,
            textColorValue: row.data['tag_text_color'] as int?,
          ),
        );
      }
    }

    return grouped.values
        .map(
          (item) => record_model.MedicalRecord(
            id: item.id,
            hospitalName: item.hospitalName,
            visitDate: item.visitDate,
            aiSummary: item.aiSummary,
            tags: tagMap[item.id] ?? const [],
            familyMemberId: item.familyMemberId,
            department: item.department,
            doctorName: item.doctorName,
            complaint: item.complaint,
            diagnosis: item.diagnosis,
            doctorOrder: item.doctorOrder,
            source: item.source,
          ),
        )
        .toList();
  }

  Future<String> _ensureTagExists(String label) async {
    final normalized = _normalizeTagLabel(label);
    final existing = await (_db.select(_db.tags)..where((table) => table.label.equals(normalized))).getSingleOrNull();
    if (existing != null) return existing.id;

    final id = _newId('tag');
    await _db.into(_db.tags).insert(TagsCompanion.insert(id: id, label: normalized, createdAt: DateTime.now()));
    return id;
  }

  String _normalizeTagLabel(String label) {
    final trimmed = label.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.startsWith('#') ? trimmed : '#$trimmed';
  }

  (Color, Color, Color) _paletteAt(int index) {
    const palettes = [
      (AppColors.memberOrange, AppColors.tagMomBg, AppColors.tagMomText),
      (AppColors.memberBlue, AppColors.tagDadBg, AppColors.tagDadText),
      (AppColors.memberPurple, AppColors.tagChild1Bg, AppColors.tagChild1Text),
      (AppColors.accent, AppColors.tagChild2Bg, AppColors.tagChild2Text),
    ];
    return palettes[index % palettes.length];
  }

  String _newId(String prefix) => '${prefix}_${DateTime.now().microsecondsSinceEpoch}';

  attachment_model.AttachmentType _attachmentTypeFromDb(String value) {
    switch (value) {
      case 'medicalPhoto':
        return attachment_model.AttachmentType.medicalPhoto;
      case 'reportPhoto':
        return attachment_model.AttachmentType.reportPhoto;
      case 'pdf':
        return attachment_model.AttachmentType.pdf;
      default:
        return attachment_model.AttachmentType.other;
    }
  }

  String _attachmentTypeToDb(attachment_model.AttachmentType type) {
    switch (type) {
      case attachment_model.AttachmentType.medicalPhoto:
        return 'medicalPhoto';
      case attachment_model.AttachmentType.reportPhoto:
        return 'reportPhoto';
      case attachment_model.AttachmentType.pdf:
        return 'pdf';
      case attachment_model.AttachmentType.other:
        return 'other';
    }
  }
}
