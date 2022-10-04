class Img {
  final String title;
  final String filename;

  const Img({
    required this.title,
    required this.filename,
  });

  factory Img.fromJson(Map<String, dynamic> json) => Img(
        title: json['title'],
        filename: json['filename'],
      );

  @override
  String toString() {
    return 'Image(title: $title, filename: $filename,)';
  }
}
