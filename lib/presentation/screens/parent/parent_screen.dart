import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/content/alphabets.dart';
import '../../bloc/progress_cubit.dart';
import '../../bloc/settings_cubit.dart';
import '../../widgets/basics.dart';
import '../../widgets/review_prompt.dart';
import '../home/script_picker.dart';

const String kAppVersion = '2.0.0';

/// Ota-onalar bo'limi: sozlamalar va natijalar.
class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  late final TextEditingController _name =
      TextEditingController(text: context.read<SettingsCubit>().state.childName);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final st = context.watch<SettingsCubit>().state;
    final p = context.watch<ProgressCubit>().state;
    final cubit = context.read<SettingsCubit>();
    final a = alphabetOf(st.script);

    return Scaffold(
      body: SoftBackground(
        child: SafeArea(
          child: Column(
            children: [
              ScreenHeader(title: s.t('parents')),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                  children: [
                    _Section(title: s.t('progress'), children: [
                      Row(
                        children: [
                          _Stat(icon: Icons.star_rounded, color: AppColors.sun, value: '${p.totalStars}', label: s.t('totalStars')),
                          _Stat(
                              icon: Icons.local_fire_department_rounded,
                              color: AppColors.coral,
                              value: '${p.streak}',
                              label: s.t('streak')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _Stat(icon: Icons.school_rounded, color: AppColors.sky, value: '${p.lessonsDoneAll}', label: s.t('lessonsDone')),
                          _Stat(
                              icon: Icons.sports_esports_rounded,
                              color: AppColors.grape,
                              value: '${p.gamesPlayed}',
                              label: s.t('gamesPlayed')),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(s.t('lettersLearned'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 8),
                      for (final alpha in allAlphabets)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              SizedBox(width: 130, child: Text(s.t(alpha.shortKey), style: const TextStyle(fontWeight: FontWeight.w700))),
                              Expanded(child: StepBar(value: p.learnedCount(alpha.id) / alpha.letters.length, color: alpha.color)),
                              const SizedBox(width: 8),
                              Text('${p.learnedCount(alpha.id)}/${alpha.letters.length}',
                                  style: const TextStyle(fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                    ]),
                    _Section(title: s.t('settings'), children: [
                      Text(s.t('uiLanguage'), style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final l in UiLang.values)
                            ChoiceChip(
                              label: Text(l.selfName),
                              selected: st.lang == l,
                              onSelected: (_) => cubit.setLang(l),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(s.t('defaultScript'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: Text(s.t(a.titleKey)),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => showScriptPicker(context),
                      ),
                      TextField(
                        controller: _name,
                        maxLength: 20,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: s.t('childName'),
                          hintText: s.t('childNameHint'),
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        onChanged: cubit.setChildName,
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(s.t('voiceGuide'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        value: st.voice,
                        onChanged: cubit.setVoice,
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(s.t('effects'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        value: st.sfx,
                        onChanged: cubit.setSfx,
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(s.t('music'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        value: st.music,
                        onChanged: cubit.setMusic,
                      ),
                    ]),
                    _Section(title: s.t('about'), children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.star_rate_rounded, color: AppColors.sun),
                        title: Text(s.t('rateApp'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        onTap: () => askForReview(context, s),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.privacy_tip_rounded, color: AppColors.teal),
                        title: Text(s.t('privacy'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        onTap: () => _info(context, s.t('privacy'), s.t('privacyBody')),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.info_rounded, color: AppColors.sky),
                        title: Text(s.t('about'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: Text(s.t('version', [kAppVersion])),
                        onTap: () => _info(context, s.t('about'),
                            '${s.t('aboutBody')}\n\n3D rasmlar: Microsoft Fluent Emoji (MIT).\n${s.t('version', [kAppVersion])}'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.wrong,
                          side: const BorderSide(color: AppColors.wrong),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: Text(s.t('resetProgress'), style: const TextStyle(fontWeight: FontWeight.w800)),
                        onPressed: () => _reset(context, s),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _info(BuildContext context, String title, String body) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Text(body),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.sRead.t('close')))],
      ),
    );
  }

  Future<void> _reset(BuildContext context, S s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.t('resetProgress'), style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Text(s.t('resetConfirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.t('cancel'))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.wrong),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(s.t('yes')),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) await context.read<ProgressCubit>().reset();
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.line, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.color, required this.value, required this.label});
  final IconData icon;
  final Color color;
  final String value, label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.tint(color, 0.85), borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  Text(label, maxLines: 2, style: const TextStyle(fontSize: 12.5, color: AppColors.inkSoft)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
