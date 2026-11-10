class AvatarOption {
  const AvatarOption({required this.id, required this.url});

  factory AvatarOption.fromJson(Map<String, dynamic> json) =>
      AvatarOption(id: json['id'] as String, url: json['url'] as String);

  final String id;
  final String url;
}
