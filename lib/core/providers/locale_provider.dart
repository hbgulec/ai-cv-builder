import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider managing active app locale ('en' by default, 'tr' available)
final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});
