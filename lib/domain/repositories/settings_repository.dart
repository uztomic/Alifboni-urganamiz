/// Sozlamalarni saqlash shartnomasi (domen qatlami saqlash usulini bilmaydi).
abstract interface class SettingsRepository {
  String? get uiLang;
  set uiLang(String? v);
  String? get script;
  set script(String? v);
  bool get voice;
  set voice(bool v);
  bool get sfx;
  set sfx(bool v);
  bool get music;
  set music(bool v);
  String get childName;
  set childName(String v);
  bool get onboarded;
  set onboarded(bool v);
  int get introOffset;
  set introOffset(int v);
  int get reviewAskedAt;
  set reviewAskedAt(int v);
}
