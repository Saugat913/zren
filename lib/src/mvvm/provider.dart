import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ZrenProvider<T> extends StatefulWidget {
  final T Function() create;
  final Widget child;
  const ZrenProvider({super.key, required this.create, required this.child});

  @override
  State<ZrenProvider<T>> createState() => _ZrenProviderState<T>();

  static T of<T>(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_ZrenProvider<T>>();
    if (inherited == null) {
      throw FlutterError(
        'ZrenProvider.of<$T> called with no ZrenProvider<$T> in the widget tree.\n'
        'Ensure ZrenProvider<$T> is an ancestor of the widget calling of<$T>().',
      );
    }
    return inherited.data;
  }
}

class _ZrenProvider<T> extends InheritedWidget {
  final T data;
  const _ZrenProvider({super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant _ZrenProvider<T> oldWidget) {
    return data != oldWidget.data;
  }
}

class _ZrenProviderState<T> extends State<ZrenProvider<T>> {
  late T _data;
  @override
  Widget build(BuildContext context) {
    return _ZrenProvider(data: _data, child: widget.child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>("data", _data));
  }

  @override
  void dispose() {
    final data = _data;
    if (data is ChangeNotifier) data.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _data = widget.create();
  }
}
