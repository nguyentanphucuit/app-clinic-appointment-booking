import 'package:intl/intl.dart';

class Formatters {
  // Currency formatter for consultation fees
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return '${formatter.format(amount).replaceAll(',', '.')}đ';
  }

  // Date formatters
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  static String formatDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  // Relative date formatting
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today, ${formatTime(date)}';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow, ${formatTime(date)}';
    } else if (dateOnly == yesterday) {
      return 'Yesterday, ${formatTime(date)}';
    } else if (dateOnly.isAfter(today) &&
        dateOnly.isBefore(today.add(const Duration(days: 7)))) {
      return '${formatDayOfWeek(date)}, ${formatTime(date)}';
    } else {
      return formatDateTime(date);
    }
  }

  // Phone number formatter
  static String formatPhoneNumber(String phone) {
    if (phone.length == 10) {
      return '${phone.substring(0, 4)} ${phone.substring(4, 7)} ${phone.substring(7)}';
    }
    return phone;
  }

  // Rating formatter
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  // Review count formatter
  static String formatReviewCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
