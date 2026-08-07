import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final Locale locale;
  final bool soundEnabled;
  final double voiceSpeed;
  final bool hasChosenLanguage;
  final bool parentPinSet;

  const SettingsState({
    required this.locale,
    this.soundEnabled = true,
    this.voiceSpeed = 0.45,
    this.hasChosenLanguage = false,
    this.parentPinSet = false,
  });

  SettingsState copyWith({
    Locale? locale,
    bool? soundEnabled,
    double? voiceSpeed,
    bool? hasChosenLanguage,
    bool? parentPinSet,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      voiceSpeed: voiceSpeed ?? this.voiceSpeed,
      hasChosenLanguage: hasChosenLanguage ?? this.hasChosenLanguage,
      parentPinSet: parentPinSet ?? this.parentPinSet,
    );
  }

  @override
  List<Object?> get props =>
      [locale, soundEnabled, voiceSpeed, hasChosenLanguage, parentPinSet];
}
