extension StringTime on DateTime {
  String getStringTime() {
    final timeDifference = difference(DateTime.now()).abs();
    if (timeDifference.inDays > 365) {
      return "${timeDifference.inDays ~/ 365} year${timeDifference.inDays ~/ 365 >= 2 ? "s" : ""}";
    } else if (timeDifference.inDays > 31) {
      return "${timeDifference.inDays ~/ 31} month${timeDifference.inDays ~/ 31 >= 2 ? "s" : ""}";
    } else if (timeDifference.inDays > 7) {
      return "${timeDifference.inDays ~/ 7} weak${timeDifference.inDays ~/ 7 >= 2 ? "s" : ""}";
    } else if (timeDifference.inDays > 1) {
      return "${timeDifference.inDays} day${timeDifference.inDays >= 2 ? "s" : ""}";
    } else if (timeDifference.inHours > 1) {
      return "${timeDifference.inHours} hour${timeDifference.inHours >= 2 ? "s" : ""}";
    } else if (timeDifference.inMinutes > 1) {
      return "${timeDifference.inMinutes} minute${timeDifference.inMinutes >= 2 ? "s" : ""}";
    } else {
      return "a few sec ago";
    }
  }
}
