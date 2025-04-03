class FolderItem {
  final String name;
  final String type;
  final List<FolderItem>? children;
  final bool isDirectory;
  final String? dateModified;
  final int? size;

  FolderItem({
    required this.name,
    required this.type,
    this.children,
    required this.isDirectory,
    this.dateModified,
    this.size,
  });

  factory FolderItem.fromJson(Map<String, dynamic> json) {
    return FolderItem(
      name: json['name'] ?? '',
      type: json['type'] ?? 'unknown',
      isDirectory: json['isDirectory'] ?? false,
      children: json['children'] != null
          ? (json['children'] as List)
              .map((item) => FolderItem.fromJson(item))
              .toList()
          : null,
      dateModified: json['dateModified'],
      size: json['size'],
    );
  }
}