import 'dart:convert';

/// Ovoz fayllari nomi matnning FNV-1a (64-bit) xeshidan olinadi:
/// `assets/voice/<til>/<xesh>.webm`. Ziyrak ilovasi bilan bir xil sxema —
/// shuning uchun Ziyrak'da yozilgan ovozlar shu yerda ham ishlaydi, yangi
/// ovoz kerak bo'lsa `tools/voice_tool.py` bilan xuddi shunday nomlab
/// qo'shiladi.
///
/// 64-bit ko'paytmani ikki 32-bitli yarim bilan hisoblaymiz: barcha oraliq
/// qiymatlar 2^53 dan kichik, shuning uchun har qanday platformada aniq.
String voiceKey(String text) {
  const two32 = 0x100000000;
  const primeLo = 0x1b3; // FNV prime = 0x100000001b3
  const primeHi = 0x100;
  var hi = 0xcbf29ce4;
  var lo = 0x84222325;
  for (final byte in utf8.encode(text)) {
    lo = lo ^ byte;
    final full = lo * primeLo;
    final newLo = full % two32;
    final carry = full ~/ two32;
    hi = (hi * primeLo + lo * primeHi + carry) % two32;
    lo = newLo;
  }
  return hi.toRadixString(16).padLeft(8, '0') +
      lo.toRadixString(16).padLeft(8, '0');
}
