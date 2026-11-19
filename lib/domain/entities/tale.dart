/// Ertak: tabiiy ovozda yozib olingan audio.
class Tale {
  const Tale(this.file, this.title, this.emoji, this.seconds);
  final String file;
  final String title; // o'zbekcha (lotin)
  final String emoji;
  final int seconds;

  String get asset => 'assets/tales/$file.webm';
}

