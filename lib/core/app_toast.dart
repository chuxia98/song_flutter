import 'dart:async';

import 'package:flutter/material.dart';

enum AppToastDuration { short, long }
enum AppToastPosition { top, bottom, center }

class AppToast {
  AppToast(
    String text,
    BuildContext context, {
    Key? key,
    IconData? iconData,
    AppToastDuration duration = AppToastDuration.short,
    AppToastPosition position = AppToastPosition.center,
  }) {
    AppToastSingleton.dismiss();
    AppToastSingleton.createView(
      text,
      context,
      key,
      iconData,
      duration,
      position,
    );
  }
}

class AppToastSingleton {
  static final AppToastSingleton _singleton = AppToastSingleton._internal();

  factory AppToastSingleton() {
    return _singleton;
  }

  AppToastSingleton._internal();

  static OverlayState? _overlayState;
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  static Timer? _t;

  static void createView(
    String text,
    BuildContext context,
    Key? key,
    IconData? iconData,
    AppToastDuration duration,
    AppToastPosition position,
  ) async {
    _overlayState = Overlay.of(context);
    var toastMargin = EdgeInsets.all(0);
    var crossPosition = CrossAxisAlignment.start;

    switch (position) {
      case AppToastPosition.center:
        toastMargin = EdgeInsets.only(top: 100.0);
        crossPosition = CrossAxisAlignment.center;
        break;
      case AppToastPosition.bottom:
        toastMargin = EdgeInsets.only(bottom: 50.0);
        crossPosition = CrossAxisAlignment.end;
        break;
      default:
        toastMargin = EdgeInsets.only(top: 100.0);
        break;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => _AppToastView(
        text: text,
        iconData: iconData,
        position: crossPosition,
        toastMargin: toastMargin,
        key: key,
      ),
    );

    _isVisible = true;
    _overlayState?.insert(_overlayEntry!);

    _t = Timer(delayDuration(duration), dismiss);
  }

  static Duration delayDuration(AppToastDuration duration) =>
      Duration(milliseconds: duration == AppToastDuration.long ? 3500 : 2000);

  static void dismiss() async {
    if (!_isVisible) {
      return;
    }

    if (_t != null && _t!.isActive) {
      _t!.cancel();
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class _AppToastView extends StatelessWidget {
  final String text;
  final IconData? iconData;
  final CrossAxisAlignment position;
  final EdgeInsets toastMargin;

  const _AppToastView({
    required this.text,
    this.iconData,
    required this.position,
    required this.toastMargin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context);

    final maxToastWidth = MediaQuery.of(context).size.width - 32 * 2;

    final widgets = <Widget>[];

    var leftPadding = 12.0;

    if (iconData != null) {
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 4.0),
        child: Icon(
          iconData,
          key: Key('AppToastIcon'),
          color: themeColor.primaryColor,
          size: 16,
        ),
      ));
      leftPadding = 6.0;
    }

    int maxLines = 3;
    bool softWrap = false;
    if (maxLines == 1) {
      softWrap = false;
    } else if (maxLines > 1) {
      softWrap = true;
    }
    widgets.add(
      Flexible(
        child: Text(
          text,
          overflow: (maxLines == null || maxLines <= 1) ? TextOverflow.fade : TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          softWrap: softWrap,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
        ),
      ),
    );

    return Row(
      key: key,
      crossAxisAlignment: position,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: maxToastWidth),
          margin: toastMargin,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            key: Key('ToastContainer'),
            child: Padding(
              padding: EdgeInsets.all(leftPadding), //EdgeInsets.fromLTRB(leftPadding, 6.0, 12.0, 6.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: widgets,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
