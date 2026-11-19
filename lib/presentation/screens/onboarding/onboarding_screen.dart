import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/voice_lines.dart';
import '../../widgets/basics.dart';
import '../../../data/content/alphabets.dart';
import '../../../domain/entities/alphabet.dart';
import '../../bloc/settings_cubit.dart';
import '../home/home_screen.dart';
import '../home/script_picker.dart';

/// Birinchi ochilish: til → ism → alifbo. Uch qadam, hammasi bitta qo'l
/// bilan, matn kiritish ixtiyoriy.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  final _name = TextEditingController();
  int _step = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService.instance.say(Lines.greeting.$1, lang: Lines.greeting.$2);
    });
  }

  @override
  void dispose() {
    _page.dispose();
    _name.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    FocusScope.of(context).unfocus();
    setState(() => _step = i);
    _page.animateToPage(i, duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic);
  }

  void _finish() {
    final cubit = context.read<SettingsCubit>();
    cubit.setChildName(_name.text);
    cubit.finishOnboarding();
    Navigator.of(context).pushReplacement(softRoute(const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final settings = context.watch<SettingsCubit>().state;
    return Scaffold(
      body: SoftBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    if (_step > 0)
                      RoundButton(icon: Icons.arrow_back_rounded, onTap: () => _goTo(_step - 1))
                    else
                      const SizedBox(width: 52),
                    const SizedBox(width: 16),
                    Expanded(child: StepBar(value: (_step + 1) / 3, color: AppColors.teal)),
                    const SizedBox(width: 68),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _page,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _LangStep(
                      selected: settings.lang,
                      onPick: (l) {
                        context.read<SettingsCubit>().setLang(l);
                        _goTo(1);
                      },
                    ),
                    _NameStep(controller: _name, onNext: () => _goTo(2), s: s),
                    _ScriptStep(
                      s: s,
                      selected: settings.script,
                      onPick: (id) => context.read<SettingsCubit>().setScript(id),
                      onGo: _finish,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangStep extends StatelessWidget {
  const _LangStep({required this.selected, required this.onPick});
  final UiLang selected;
  final ValueChanged<UiLang> onPick;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        const Center(child: Ziko(mood: ZikoMood.hello, size: 130)),
        const SizedBox(height: 12),
        Text(s.t('obWelcome'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(s.t('obWelcomeBody'),
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, color: AppColors.inkSoft)),
        const SizedBox(height: 24),
        Text(s.t('obLang'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        for (final l in UiLang.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ChoiceTile(
              title: l.selfName,
              leading: switch (l) {
                UiLang.uz => 'Oʻz',
                UiLang.uzc => 'Ўз',
                UiLang.ru => 'Ру',
                UiLang.en => 'En',
              },
              selected: l == selected,
              color: AppColors.teal,
              onTap: () => onPick(l),
            ),
          ),
      ],
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({required this.controller, required this.onNext, required this.s});
  final TextEditingController controller;
  final VoidCallback onNext;
  final S s;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      children: [
        const Center(child: Ziko(mood: ZikoMood.think, size: 120)),
        const SizedBox(height: 16),
        Text(s.t('obName'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(s.t('obNameBody'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: AppColors.inkSoft)),
        const SizedBox(height: 24),
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          maxLength: 20,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          decoration: InputDecoration(
            hintText: s.t('childNameHint'),
            hintStyle: const TextStyle(color: Color(0xFFB5AEC9), fontWeight: FontWeight.w700),
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
          onSubmitted: (_) => onNext(),
        ),
        const SizedBox(height: 24),
        ChunkyButton(label: s.t('next'), color: AppColors.teal, icon: Icons.arrow_forward_rounded, onTap: onNext),
        const SizedBox(height: 8),
        TextButton(onPressed: onNext, child: Text(s.t('skip'))),
      ],
    );
  }
}

class _ScriptStep extends StatelessWidget {
  const _ScriptStep({required this.s, required this.selected, required this.onPick, required this.onGo});
  final S s;
  final ScriptId selected;
  final ValueChanged<ScriptId> onPick;
  final VoidCallback onGo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      children: [
        Text(s.t('obScript'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        Text(s.t('obScriptBody'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: AppColors.inkSoft)),
        const SizedBox(height: 18),
        for (final a in allAlphabets)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ScriptTile(alphabet: a, selected: a.id == selected, onTap: () => onPick(a.id), s: s),
          ),
        const SizedBox(height: 12),
        ChunkyButton(label: s.t('obGo'), color: AppColors.coral, icon: Icons.rocket_launch_rounded, onTap: onGo),
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({required this.title, required this.leading, required this.selected, required this.color, required this.onTap});
  final String title;
  final String leading;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bouncy(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.tint(color, 0.85) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? color : AppColors.line, width: 2.5),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
              alignment: Alignment.center,
              child: Text(leading, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
            if (selected) Icon(Icons.check_circle_rounded, color: color, size: 28),
          ],
        ),
      ),
    );
  }
}
