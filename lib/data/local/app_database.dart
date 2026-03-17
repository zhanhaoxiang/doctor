import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Members extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get accentColor => integer()();
  IntColumn get tagBgColor => integer()();
  IntColumn get tagTextColor => integer()();
  BoolColumn get isDefaultMember =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get label => text().unique()();
  IntColumn get bgColor => integer().nullable()();
  IntColumn get textColor => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MedicalRecords extends Table {
  TextColumn get id => text()();
  TextColumn get hospitalName => text()();
  TextColumn get department => text().nullable()();
  TextColumn get doctorName => text().nullable()();
  DateTimeColumn get visitDate => dateTime()();
  TextColumn get complaint => text().nullable()();
  TextColumn get diagnosis => text().nullable()();
  TextColumn get aiSummary => text()();
  TextColumn get doctorOrder => text().withDefault(const Constant(''))();
  TextColumn get source => text().withDefault(const Constant('手动录入'))();
  TextColumn get memberId => text().nullable().references(Members, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class RecordTagLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recordId => text().references(MedicalRecords, #id)();
  TextColumn get tagId => text().references(Tags, #id)();
}

class RecordAttachments extends Table {
  TextColumn get id => text()();
  TextColumn get recordId => text().references(MedicalRecords, #id)();
  TextColumn get path => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get remindAt => dateTime()();
  TextColumn get type => text().withDefault(const Constant('general'))();
  TextColumn get memberId => text().nullable().references(Members, #id)();
  // 关联病历记录（复诊提醒时使用）
  TextColumn get recordId => text().nullable().references(MedicalRecords, #id)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Followups extends Table {
  TextColumn get id => text()();
  TextColumn get hospital => text()();
  TextColumn get department => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get memberId => text().nullable().references(Members, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get type => text().withDefault(const Constant('info'))();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  TextColumn get memberId => text().nullable().references(Members, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Members,
    Tags,
    MedicalRecords,
    RecordTagLinks,
    RecordAttachments,
    Reminders,
    Followups,
    Notifications,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'doctor_app'));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(reminders, reminders.recordId);
      }
    },
  );
}
