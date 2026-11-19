import '../../domain/repositories/settings_repository.dart';
import '../sources/local_storage.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._st);
  final Storage _st;

  @override
  String? get uiLang => _st.get<String?>('uiLang', null);
  @override
  set uiLang(String? v) => _st.set('uiLang', v);

  @override
  String? get script => _st.get<String?>('script', null);
  @override
  set script(String? v) => _st.set('script', v);

  @override
  bool get voice => _st.get<bool>('voice', true);
  @override
  set voice(bool v) => _st.set('voice', v);

  @override
  bool get sfx => _st.get<bool>('sfx', true);
  @override
  set sfx(bool v) => _st.set('sfx', v);

  @override
  bool get music => _st.get<bool>('music', true);
  @override
  set music(bool v) => _st.set('music', v);

  @override
  String get childName => _st.get<String>('childName', '');
  @override
  set childName(String v) => _st.set('childName', v);

  @override
  bool get onboarded => _st.get<bool>('onboarded', false);
  @override
  set onboarded(bool v) => _st.set('onboarded', v);

  @override
  int get introOffset => _st.get<int>('introOffset', 0);
  @override
  set introOffset(int v) => _st.set('introOffset', v);

  @override
  int get reviewAskedAt => _st.get<int>('reviewAskedAt', 0);
  @override
  set reviewAskedAt(int v) => _st.set('reviewAskedAt', v);
}
