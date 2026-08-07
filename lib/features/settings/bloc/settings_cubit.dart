import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_languages.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/tts_service.dart';
import 'settings_state.dart';

Locale _localeFromCode(String code) {
  final parts = code.split('_');
  if (parts.length == 2) {
    return Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]);
  }
  return Locale(parts[0]);
}

String _codeFromLocale(Locale locale) {
  return locale.scriptCode == null
      ? locale.languageCode
      : '${locale.languageCode}_${locale.scriptCode}';
}

class SettingsCubit extends Cubit<SettingsState> {
  final StorageService _storage;

  SettingsCubit({StorageService? storage})
      : _storage = storage ?? StorageService.instance,
        super(SettingsState(
          locale: _initialLocale(storage ?? StorageService.instance),
          soundEnabled: (storage ?? StorageService.instance).soundEnabled,
          voiceSpeed: (storage ?? StorageService.instance).voiceSpeed,
          hasChosenLanguage:
              (storage ?? StorageService.instance).interfaceLanguageCode != null,
          parentPinSet:
              (storage ?? StorageService.instance).parentPinHash != null,
        )) {
    TtsService.instance.setEnabled(state.soundEnabled);
  }

  static Locale _initialLocale(StorageService storage) {
    final code = storage.interfaceLanguageCode;
    return code != null ? _localeFromCode(code) : kInterfaceLanguages.first.locale;
  }

  Future<void> changeLanguage(Locale locale) async {
    await _storage.setInterfaceLanguageCode(_codeFromLocale(locale));
    emit(state.copyWith(locale: locale, hasChosenLanguage: true));
  }

  Future<void> toggleSound(bool enabled) async {
    await _storage.setSoundEnabled(enabled);
    TtsService.instance.setEnabled(enabled);
    emit(state.copyWith(soundEnabled: enabled));
  }

  Future<void> changeVoiceSpeed(double speed) async {
    await _storage.setVoiceSpeed(speed);
    await TtsService.instance.setSpeed(speed);
    emit(state.copyWith(voiceSpeed: speed));
  }

  String _hash(String pin) => sha256.convert(utf8.encode(pin)).toString();

  Future<void> setParentPin(String pin) async {
    await _storage.setParentPinHash(_hash(pin));
    emit(state.copyWith(parentPinSet: true));
  }

  Future<void> clearParentPin() async {
    await _storage.setParentPinHash(null);
    emit(state.copyWith(parentPinSet: false));
  }

  bool verifyParentPin(String pin) {
    final stored = _storage.parentPinHash;
    if (stored == null) return true; // no PIN set yet -> zone is open
    return stored == _hash(pin);
  }
}
