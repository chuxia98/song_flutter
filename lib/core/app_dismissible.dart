import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AppDismissible extends StatelessWidget {
  final Key slidableKey;
  final Widget listItem;
  final bool dragToRemove;
  final ActionConfiguration removeAction;
  final ActionConfiguration? editAction;
  final ConfirmationDialogConfiguration? confirmationRemoveDialog;
  final SnackbarConfiguration? onDismissedSnackbar;
  final FutureOr<bool> Function()? willDismissCondition;

  final SlidableController? slidableController;

  const AppDismissible({
    Key? key,
    required this.slidableKey,
    required this.listItem,
    required this.removeAction,
    this.dragToRemove = true,
    this.editAction,
    this.confirmationRemoveDialog,
    this.onDismissedSnackbar,
    this.willDismissCondition,
    this.slidableController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEditAction = editAction != null;
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          if (isEditAction)
            SlidableAction(
              flex: 2,
              onPressed: (context) {
                editAction?.performAction.call();
              },
              backgroundColor: editAction?.backgroundColor ?? Colors.red,
              foregroundColor: Colors.white,
              icon: editAction?.icon,
              label: editAction?.label,
            ),
          SlidableAction(
            // flex: 2,
            onPressed: (context) {
              removeAction.performAction.call();
            },
            backgroundColor: removeAction.backgroundColor ?? Colors.red,
            foregroundColor: Colors.white,
            icon: removeAction.icon,
            label: removeAction.label,
          ),
        ],
      ),
      child: listItem,
    );
  }
}

class ActionConfiguration {
  final String label;
  final VoidCallback performAction;
  final IconData? icon;
  final bool closeOnTap;
  final Color? backgroundColor;

  const ActionConfiguration({
    required this.label,
    required this.performAction,
    this.icon,
    this.closeOnTap = false,
    this.backgroundColor,
  });
}

class ConfirmationDialogConfiguration {
  final String dialogTitle;
  final String dialogDescription;
  final String confirmLabel;
  final String cancelLabel;

  const ConfirmationDialogConfiguration({
    required this.dialogTitle,
    required this.dialogDescription,
    required this.confirmLabel,
    required this.cancelLabel,
  });
}

class SnackbarConfiguration {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final VoidCallback? onSnackbarClosed;

  const SnackbarConfiguration({
    required this.title,
    this.onSnackbarClosed,
    this.actionLabel,
    this.onActionTap,
  });
}
