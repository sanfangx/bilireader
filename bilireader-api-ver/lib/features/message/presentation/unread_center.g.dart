// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_center.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全域未讀中心（doc 08 §9、doc 09 §1.2）。keepAlive：整個 App 生命週期共用，
/// 訂閱兩條 socket 的未讀事件，跨分頁廣播「私訊+通知」合併未讀，供 MainShell「我的」紅點。
///
/// - 未登入強制 0（doc 09 §1.2：`if (!isLogin) count = 0`）；socket 亦不連。
/// - 未讀以 socket 為主（doc 08 §9.1）：`*_connected`/`*_unread` 事件帶 `data.unread`。
///   'notification' 內容形狀未文件化（doc 08 §10）→ 不解析，只依賴有文件依據的 `*_unread`。
/// - F-04：收到 `chat_message` 一併 invalidate 會話列表（列表以 `skipLoadingOnReload` 不閃）。

@ProviderFor(UnreadCenter)
final unreadCenterProvider = UnreadCenterProvider._();

/// 全域未讀中心（doc 08 §9、doc 09 §1.2）。keepAlive：整個 App 生命週期共用，
/// 訂閱兩條 socket 的未讀事件，跨分頁廣播「私訊+通知」合併未讀，供 MainShell「我的」紅點。
///
/// - 未登入強制 0（doc 09 §1.2：`if (!isLogin) count = 0`）；socket 亦不連。
/// - 未讀以 socket 為主（doc 08 §9.1）：`*_connected`/`*_unread` 事件帶 `data.unread`。
///   'notification' 內容形狀未文件化（doc 08 §10）→ 不解析，只依賴有文件依據的 `*_unread`。
/// - F-04：收到 `chat_message` 一併 invalidate 會話列表（列表以 `skipLoadingOnReload` 不閃）。
final class UnreadCenterProvider
    extends $NotifierProvider<UnreadCenter, UnreadState> {
  /// 全域未讀中心（doc 08 §9、doc 09 §1.2）。keepAlive：整個 App 生命週期共用，
  /// 訂閱兩條 socket 的未讀事件，跨分頁廣播「私訊+通知」合併未讀，供 MainShell「我的」紅點。
  ///
  /// - 未登入強制 0（doc 09 §1.2：`if (!isLogin) count = 0`）；socket 亦不連。
  /// - 未讀以 socket 為主（doc 08 §9.1）：`*_connected`/`*_unread` 事件帶 `data.unread`。
  ///   'notification' 內容形狀未文件化（doc 08 §10）→ 不解析，只依賴有文件依據的 `*_unread`。
  /// - F-04：收到 `chat_message` 一併 invalidate 會話列表（列表以 `skipLoadingOnReload` 不閃）。
  UnreadCenterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadCenterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadCenterHash();

  @$internal
  @override
  UnreadCenter create() => UnreadCenter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnreadState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnreadState>(value),
    );
  }
}

String _$unreadCenterHash() => r'80b73069c544fac50d16ea8e7ccce2a69c5b8d8e';

/// 全域未讀中心（doc 08 §9、doc 09 §1.2）。keepAlive：整個 App 生命週期共用，
/// 訂閱兩條 socket 的未讀事件，跨分頁廣播「私訊+通知」合併未讀，供 MainShell「我的」紅點。
///
/// - 未登入強制 0（doc 09 §1.2：`if (!isLogin) count = 0`）；socket 亦不連。
/// - 未讀以 socket 為主（doc 08 §9.1）：`*_connected`/`*_unread` 事件帶 `data.unread`。
///   'notification' 內容形狀未文件化（doc 08 §10）→ 不解析，只依賴有文件依據的 `*_unread`。
/// - F-04：收到 `chat_message` 一併 invalidate 會話列表（列表以 `skipLoadingOnReload` 不閃）。

abstract class _$UnreadCenter extends $Notifier<UnreadState> {
  UnreadState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UnreadState, UnreadState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UnreadState, UnreadState>,
              UnreadState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
