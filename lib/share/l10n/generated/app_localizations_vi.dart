// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'ClipStack';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsTooltip => 'Cài đặt';

  @override
  String get saveClipTooltip => 'Lưu đoạn sao chép';

  @override
  String get historyTab => 'Lịch sử';

  @override
  String get starredTab => 'Đã ghim';

  @override
  String get drawerDescription =>
      'Những đoạn bạn sao chép được sắp xếp gọn gàng và sẵn sàng để dùng lại.';

  @override
  String savedPinnedSummary(int savedCount, int pinnedCount) {
    return '$savedCount mục đã lưu | $pinnedCount mục đã ghim';
  }

  @override
  String get searchClipboardPlaceholder => 'Tìm trong clipboard...';

  @override
  String get clearSearchTooltip => 'Xóa tìm kiếm';

  @override
  String get recentSnippetsTitle => 'Đoạn mới gần đây';

  @override
  String get recentSnippetsHelper =>
      'Chạm để sao chép nhanh, nhấn giữ để mở thêm thao tác.';

  @override
  String get pinnedSnippetsTitle => 'Đoạn đã ghim';

  @override
  String get pinnedSnippetsHelper =>
      'Những mục đã ghim luôn ở trên cùng để dùng lại nhanh hơn.';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục',
      one: '1 mục',
    );
    return '$_temp0';
  }

  @override
  String get copiedMessage => 'Đã sao chép';

  @override
  String get copyAction => 'Sao chép';

  @override
  String get pinAction => 'Ghim';

  @override
  String get unpinAction => 'Bỏ ghim';

  @override
  String get pinnedMessage => 'Đã ghim';

  @override
  String get unpinnedMessage => 'Đã bỏ ghim';

  @override
  String get editAction => 'Chỉnh sửa';

  @override
  String get deleteAction => 'Xóa';

  @override
  String get deletedMessage => 'Đã xóa';

  @override
  String get savedMessage => 'Đã lưu';

  @override
  String get updatedMessage => 'Đã cập nhật';

  @override
  String get duplicateClipMessage =>
      'Nội dung này đã có trong danh sách của bạn';

  @override
  String get saveClipTitle => 'Lưu đoạn sao chép';

  @override
  String get editClipTitle => 'Chỉnh sửa đoạn sao chép';

  @override
  String get saveClipButton => 'Lưu đoạn sao chép';

  @override
  String get updateClipButton => 'Cập nhật đoạn sao chép';

  @override
  String get editorCreateDescription =>
      'Lưu nội dung đang có trong clipboard hoặc viết một đoạn mới.';

  @override
  String get editorEditDescription =>
      'Điều chỉnh đoạn nội dung và giữ nó sẵn sàng để dùng lại.';

  @override
  String get editorHint => 'Dán hoặc nhập nội dung tại đây';

  @override
  String get settingsIntro =>
      'Tùy chỉnh trải nghiệm và giữ việc theo dõi clipboard hoạt động mượt mà.';

  @override
  String get appearanceTitle => 'Giao diện';

  @override
  String get darkModeTitle => 'Chế độ tối';

  @override
  String get darkModeSubtitle => 'Chuyển đổi giữa giao diện sáng và tối.';

  @override
  String get languageTitle => 'Ngôn ngữ';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get clipboardSectionTitle => 'Clipboard';

  @override
  String get autoTrackingTitle => 'Tự động theo dõi';

  @override
  String get autoTrackingSubtitle => 'Bật khi ứng dụng đang mở';

  @override
  String get savedSnippetsTitle => 'Đoạn đã lưu';

  @override
  String savedSnippetsSubtitle(int count) {
    return '$count mục trong lịch sử của bạn';
  }

  @override
  String pinnedSnippetsSubtitle(int count) {
    return '$count mục sẵn sàng ở trên cùng';
  }

  @override
  String get duplicateProtectionTitle => 'Chống trùng lặp';

  @override
  String get duplicateProtectionSubtitle =>
      'Nội dung lặp lại sẽ được bỏ qua tự động';

  @override
  String get emptyClipboardDescription =>
      'Những mục bạn sao chép sẽ xuất hiện ở đây dưới dạng các đoạn nội dung đã được chọn lọc.';

  @override
  String get pinClipPrompt => 'Hãy ghim một mục để luôn giữ nó ở gần bạn.';

  @override
  String get noSearchResultsMessage =>
      'Chưa có mục nào khớp với tìm kiếm của bạn.';

  @override
  String get linkChip => 'Liên kết';

  @override
  String get phoneChip => 'Số điện thoại';

  @override
  String get pinnedChip => 'Đã ghim';

  @override
  String get justNow => 'Vừa xong';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phút trước',
      one: '1 phút trước',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giờ trước',
      one: '1 giờ trước',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày trước',
      one: '1 ngày trước',
    );
    return '$_temp0';
  }

  @override
  String weeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tuần trước',
      one: '1 tuần trước',
    );
    return '$_temp0';
  }

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get loginWelcomeMessage => 'Chào mừng bạn quay lại với ClipStack';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'name@example.com';

  @override
  String get loginPasswordLabel => 'Mật khẩu';

  @override
  String get loginPasswordHint => 'Nhập mật khẩu của bạn';

  @override
  String get loginShowPasswordTooltip => 'Hiện mật khẩu';

  @override
  String get loginHidePasswordTooltip => 'Ẩn mật khẩu';

  @override
  String get loginForgotPasswordButton => 'Quên mật khẩu?';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get loginLoadingButton => 'Đang đăng nhập...';

  @override
  String get loginPrivacyNote => 'Bảo vệ dữ liệu clipboard cá nhân của bạn.';

  @override
  String get loginBrandTagline => 'Quản lý ghi chú nhanh gọn, an toàn';

  @override
  String get loginForgotPasswordUnavailable =>
      'Tính năng khôi phục mật khẩu sẽ được cập nhật sau';

  @override
  String get loginEmailRequired => 'Vui lòng nhập email';

  @override
  String get loginEmailInvalid => 'Email chưa đúng định dạng';

  @override
  String get loginPasswordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get loginPasswordTooShort => 'Mật khẩu tối thiểu 6 ký tự';

  @override
  String get textOr => 'Hoặc';
}
