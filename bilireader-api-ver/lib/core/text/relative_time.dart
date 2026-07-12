/// 相對時間顯示（繁體）。社群時間戳多為「秒」，書架/進度為「毫秒」。
library;

String relativeTimeFromSeconds(int epochSeconds) =>
    relativeTimeFromMillis(epochSeconds * 1000);

String relativeTimeFromMillis(int epochMs) {
  if (epochMs <= 0) {
    return '';
  }
  final DateTime then = DateTime.fromMillisecondsSinceEpoch(epochMs);
  final Duration diff = DateTime.now().difference(then);
  if (diff.isNegative || diff.inMinutes < 1) {
    return '剛剛';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} 分鐘前';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} 小時前';
  }
  if (diff.inDays < 30) {
    return '${diff.inDays} 天前';
  }
  return '${then.year}/${then.month.toString().padLeft(2, '0')}/'
      '${then.day.toString().padLeft(2, '0')}';
}
