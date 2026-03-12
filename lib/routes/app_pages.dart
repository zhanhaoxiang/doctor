import 'package:get/get.dart';
import '../pages/main/main_binding.dart';
import '../pages/main/main_page.dart';
import '../pages/detail/detail_binding.dart';
import '../pages/detail/detail_page.dart';
import '../pages/add/add_binding.dart';
import '../pages/add/add_page.dart';
import '../pages/edit/edit_binding.dart';
import '../pages/edit/edit_page.dart';
import '../pages/family/family_binding.dart';
import '../pages/family/family_page.dart';
import '../pages/stats/stats_binding.dart';
import '../pages/stats/stats_page.dart';
import '../pages/calendar/calendar_binding.dart';
import '../pages/calendar/calendar_page.dart';
import '../pages/notifications/notifications_binding.dart';
import '../pages/notifications/notifications_page.dart';
import '../pages/export/export_binding.dart';
import '../pages/export/export_page.dart';
import '../pages/import_records/import_records_binding.dart';
import '../pages/import_records/import_records_page.dart';
import '../pages/tags/tags_binding.dart';
import '../pages/tags/tags_page.dart';
import '../pages/attachments/attachments_binding.dart';
import '../pages/attachments/attachments_page.dart';
import '../pages/ocr_review/ocr_review_binding.dart';
import '../pages/ocr_review/ocr_review_page.dart';
import '../pages/followup/followup_binding.dart';
import '../pages/followup/followup_page.dart';
import '../pages/medication/medication_binding.dart';
import '../pages/medication/medication_page.dart';
import '../pages/report_view/report_view_binding.dart';
import '../pages/report_view/report_view_page.dart';
import '../pages/print_preview/print_preview_binding.dart';
import '../pages/print_preview/print_preview_page.dart';
import '../pages/permissions/permissions_binding.dart';
import '../pages/permissions/permissions_page.dart';
import '../pages/onboarding/onboarding_binding.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/camera/camera_binding.dart';
import '../pages/camera/camera_page.dart';
import '../pages/photo_preview/photo_preview_binding.dart';
import '../pages/photo_preview/photo_preview_page.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.main, page: () => const MainPage(), binding: MainBinding()),
    GetPage(name: AppRoutes.detail, page: () => const DetailPage(), binding: DetailBinding()),
    GetPage(name: AppRoutes.add, page: () => const AddPage(), binding: AddBinding()),
    GetPage(name: AppRoutes.edit, page: () => const EditPage(), binding: EditBinding()),
    GetPage(name: AppRoutes.family, page: () => const FamilyPage(), binding: FamilyBinding()),
    GetPage(name: AppRoutes.stats, page: () => const StatsPage(), binding: StatsBinding()),
    GetPage(name: AppRoutes.calendar, page: () => const CalendarPage(), binding: CalendarBinding()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsPage(), binding: NotificationsBinding()),
    GetPage(name: AppRoutes.export, page: () => const ExportPage(), binding: ExportBinding()),
    GetPage(name: AppRoutes.importRecords, page: () => const ImportRecordsPage(), binding: ImportRecordsBinding()),
    GetPage(name: AppRoutes.tags, page: () => const TagsPage(), binding: TagsBinding()),
    GetPage(name: AppRoutes.attachments, page: () => const AttachmentsPage(), binding: AttachmentsBinding()),
    GetPage(name: AppRoutes.ocrReview, page: () => const OcrReviewPage(), binding: OcrReviewBinding()),
    GetPage(name: AppRoutes.followup, page: () => const FollowupPage(), binding: FollowupBinding()),
    GetPage(name: AppRoutes.medication, page: () => const MedicationPage(), binding: MedicationBinding()),
    GetPage(name: AppRoutes.reportView, page: () => const ReportViewPage(), binding: ReportViewBinding()),
    GetPage(name: AppRoutes.printPreview, page: () => const PrintPreviewPage(), binding: PrintPreviewBinding()),
    GetPage(name: AppRoutes.permissions, page: () => const PermissionsPage(), binding: PermissionsBinding()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingPage(), binding: OnboardingBinding()),
    GetPage(name: AppRoutes.camera, page: () => const CameraPage(), binding: CameraBinding()),
    GetPage(name: AppRoutes.photoPreview, page: () => const PhotoPreviewPage(), binding: PhotoPreviewBinding()),
  ];
}
