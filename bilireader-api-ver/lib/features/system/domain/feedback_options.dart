import 'package:flutter/foundation.dart';

/// 意見回饋大分類（`reportSort`，1-based）。值取自反編譯 `FeedbackActivity`
/// （`selectedSortIndex + 1`）；標籤以 zh-TW 呈現（原站為簡體）。
enum FeedbackSort {
  suggestion(1, '建議'),
  error(2, '錯誤'),
  complaint(3, '投訴'),
  apply(4, '申請');

  const FeedbackSort(this.value, this.label);

  final int value;
  final String label;

  /// 該分類的細項（`reportType`）。值取自反編譯 `FeedbackActivity.typeOptions`；
  /// `0` 一律代表「其他」（為合法值，非未選）。
  List<FeedbackType> get types => switch (this) {
    FeedbackSort.suggestion => const <FeedbackType>[
      FeedbackType(1, '網站功能'),
      FeedbackType(2, '頁面美工'),
      FeedbackType(3, '求書許願'),
      FeedbackType(0, '其他'),
    ],
    FeedbackSort.error => const <FeedbackType>[
      FeedbackType(1, '連結錯誤'),
      FeedbackType(2, '內容錯誤'),
      FeedbackType(3, '圖像錯誤'),
      FeedbackType(0, '其他'),
    ],
    FeedbackSort.complaint => const <FeedbackType>[
      FeedbackType(1, '投訴本站服務'),
      FeedbackType(2, '投訴其他會員'),
      FeedbackType(0, '其他'),
    ],
    FeedbackSort.apply => const <FeedbackType>[
      FeedbackType(1, '申請版主'),
      FeedbackType(2, '刪除帳號'),
      FeedbackType(0, '其他'),
    ],
  };
}

/// 意見回饋細項（`reportType` 值 + 顯示標籤）。`value` 可為 0（其他）。
@immutable
class FeedbackType {
  const FeedbackType(this.value, this.label);

  final int value;
  final String label;

  @override
  bool operator ==(Object other) =>
      other is FeedbackType && other.value == value && other.label == label;

  @override
  int get hashCode => Object.hash(value, label);
}
