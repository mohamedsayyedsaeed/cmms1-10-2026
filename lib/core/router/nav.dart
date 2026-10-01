import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// `navigate(-1)` from the prototype: pop if possible, otherwise go somewhere sensible.
void goBack(BuildContext context, {String fallback = '/dashboard'}) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallback);
  }
}
