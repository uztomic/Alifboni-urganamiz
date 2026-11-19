import 'package:alifbo/presentation/screens/alphabet/trace_pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TracePad: harf ustidan chizilganda qabul qiladi', (tester) async {
    var ok = 0;
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: TracePad(glyph: 'I', color: Colors.teal, size: 300, onSuccess: () => ok++),
          ),
        ),
      ));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pump();
    final state = tester.state<TracePadState>(find.byType(TracePad));
    final box = tester.getRect(find.byType(TracePad));
    // Ahem shriftida harf — to'liq kvadrat. Uni ilonsimon chiziqlar bilan to'ldiramiz.
    final g = await tester.startGesture(box.topLeft + const Offset(60, 50));
    for (var y = 50.0; y <= 250; y += 14) {
      await g.moveTo(box.topLeft + Offset(60, y));
      await g.moveTo(box.topLeft + Offset(240, y));
      await g.moveTo(box.topLeft + Offset(240, y + 7));
      await g.moveTo(box.topLeft + Offset(60, y + 7));
    }
    await g.up();
    await tester.pump();
    expect(state.coverage, greaterThan(0), reason: 'maska qurilmadi');
    expect(ok, 1);
  });

  testWidgets('TracePad: tasodifiy chiziqni qabul qilmaydi', (tester) async {
    var ok = 0;
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: TracePad(glyph: 'I', color: Colors.teal, size: 300, onSuccess: () => ok++),
          ),
        ),
      ));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pump();
    final box = tester.getRect(find.byType(TracePad));
    await tester.dragFrom(box.topLeft + const Offset(5, 5), const Offset(20, 0));
    await tester.pump();
    expect(ok, 0);
  });
}
