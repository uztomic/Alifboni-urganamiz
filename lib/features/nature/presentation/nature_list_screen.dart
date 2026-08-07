import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/native_ad_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/models/nature_entry.dart';
import '../data/nature_data.dart';
import 'nature_detail_screen.dart';
import 'nature_thumbnail.dart';

String natureCategoryTitle(AppLocalizations l10n, NatureCategoryType category) {
  switch (category) {
    case NatureCategoryType.animals:
      return l10n.natureAnimals;
    case NatureCategoryType.plants:
      return l10n.naturePlants;
    case NatureCategoryType.birds:
      return l10n.natureBirds;
    case NatureCategoryType.vehicles:
      return l10n.natureVehicles;
    case NatureCategoryType.professions:
      return l10n.natureProfessions;
  }
}

class NatureListScreen extends StatelessWidget {
  final NatureCategoryType category;
  const NatureListScreen({super.key, required this.category});

  static const _itemsPerAdBreak = 6;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = entriesForCategory(category);
    final localeCode = Localizations.localeOf(context).languageCode;

    // Split into chunks of 6, with a Native ad tile between chunks — the
    // "orasiga" (in between) placement that was asked for, rather than
    // just one ad tacked on at the very end.
    final chunks = <List<NatureEntry>>[];
    for (var i = 0; i < entries.length; i += _itemsPerAdBreak) {
      chunks.add(entries.sublist(i, (i + _itemsPerAdBreak).clamp(0, entries.length)));
    }

    return Scaffold(
      appBar: AppBar(title: Text(natureCategoryTitle(l10n, category))),
      body: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: 16)),
          for (var c = 0; c < chunks.length; c++) ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final entry = chunks[c][i];
                    final globalIndex = c * _itemsPerAdBreak + i;
                    return FadeSlideIn(
                      index: globalIndex > 8 ? 8 : globalIndex,
                      baseDelay: const Duration(milliseconds: 40),
                      child: _NatureTile(
                        entry: entry,
                        name: entry.nameFor(localeCode),
                        onTap: () => pushAnimated(context, NatureDetailScreen(entry: entry)),
                      ),
                    );
                  },
                  childCount: chunks[c].length,
                ),
              ),
            ),
            if (c < chunks.length - 1)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: const SliverToBoxAdapter(child: NativeAdCard()),
              ),
          ],
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}

class _NatureTile extends StatefulWidget {
  final NatureEntry entry;
  final String name;
  final VoidCallback onTap;
  const _NatureTile({required this.entry, required this.name, required this.onTap});

  @override
  State<_NatureTile> createState() => _NatureTileState();
}

class _NatureTileState extends State<_NatureTile> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(child: NatureThumbnail(entry: widget.entry)),
              const SizedBox(height: 8),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.baloo2(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
