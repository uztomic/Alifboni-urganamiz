#!/usr/bin/env python3
"""Ovoz yozuvlari bilan ishlash vositasi.

Ishlatish:
  python3 tools/voice_tool.py key "Matn"        # fayl nomi (FNV-1a xesh)
  python3 tools/voice_tool.py check             # kontentda ovozi yo'q matnlar
  python3 tools/voice_tool.py add uz "Matn" fayl.mp3
      # yangi ovozni (masalan ElevenLabs'dan) qo'shadi: webm/opus ga
      # o'giradi va assets/voice/uz/<xesh>.webm ga joylaydi (ffmpeg kerak).

Ilova matn uchun ovozni shu xesh bo'yicha topadi, shuning uchun fayl nomi
matnning o'zi bilan harfma-harf bir xil bo'lishi shart (ʻ belgisi ham).
"""
import json, os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
M = (1 << 64) - 1

def key(text):
    x = 0xcbf29ce484222325
    for c in text.encode('utf-8'):
        x ^= c
        x = (x * 0x100000001b3) & M
    return '%016x' % x

def have(lang, text):
    return os.path.exists(os.path.join(ROOT, 'assets', 'voice', lang, key(text) + '.webm'))

def dart_strings(path):
    src = open(os.path.join(ROOT, path), encoding='utf-8').read()
    return src

def needed():
    """Kontent fayllaridan ovoz kerak bo'lgan o'zbekcha matnlarni yig'adi."""
    need = []
    a = dart_strings('lib/data/content/alphabets.dart')
    base = a[a.index('_uzBase = ['):a.index('];', a.index('_uzBase = ['))]
    for m in re.finditer(r"\('([^']+)', '[^']*', (?:'[^']*'|null)\)", base):
        need.append(('uz', m.group(1), 'alifbo soʻzi'))
    for m in re.finditer(r"^  \('([^']+)', LetterKind", base, re.M):
        if m.group(1) != 'ʼ':
            need.append(('uz', m.group(1), 'harf'))
    cy = a[a.index('_cyrl = ['):a.index('];', a.index('_cyrl = ['))]
    for m in re.finditer(r"\('([a-zʻ]+)', '[^']*', (?:'[^']*'|null)\)", cy):
        need.append(('uz', m.group(1), 'kirill soʻzi'))
    w = dart_strings('lib/data/content/words.dart')
    for m in re.finditer(r"VocabWord\('([^']+)'", w):
        need.append(('uz', m.group(1), 'lugʻat'))
    q = dart_strings('lib/data/content/quizzes.dart')
    for m in re.finditer(r"QuizItem\('([^']+)', '([^']+)', \[([^\]]*)\]\)", q):
        need.append(('uz', m.group(1), 'savol'))
        need.append(('uz', m.group(2), 'javob'))
        for o in re.findall(r"'([^']+)'", m.group(3)):
            need.append(('uz', o, 'variant'))
    for path in ('lib/data/content/lessons.dart', 'lib/core/voice_lines.dart'):
        if os.path.exists(os.path.join(ROOT, path)):
            src = dart_strings(path)
            for m in re.finditer(r"uz\('((?:[^'\\]|\\.)+)'\)", src):
                need.append(('uz', m.group(1).replace("\\'", "'"), path.split('/')[-1]))
    return need

def check():
    miss = {}
    for lang, text, where in needed():
        if not have(lang, text):
            miss.setdefault((lang, text), where)
    for (lang, text), where in sorted(miss.items(), key=lambda x: x[1]):
        print(f'[{lang}] {text}    ({where})')
    print(f'\nOvozi yoʻq matnlar: {len(miss)}')

def add(lang, text, src):
    out = os.path.join(ROOT, 'assets', 'voice', lang, key(text) + '.webm')
    subprocess.check_call(['ffmpeg', '-y', '-loglevel', 'error', '-i', src,
                           '-ac', '1', '-c:a', 'libopus', '-b:a', '32k', out])
    print('qoʻshildi:', out)

if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'check'
    if cmd == 'key':
        print(key(sys.argv[2]))
    elif cmd == 'check':
        check()
    elif cmd == 'add':
        add(sys.argv[2], sys.argv[3], sys.argv[4])
