class SBPWidgetBank {
  final String name;

  final String? logoURL;

  final String dboLink;

  const SBPWidgetBank({
    required this.name,
    required this.dboLink,
    this.logoURL,
  });

  factory SBPWidgetBank.fromJson(Map<String, dynamic> json) {
    return SBPWidgetBank(
      name: json['name'] ?? json['bankName'],
      dboLink: json['dboLink'],
      logoURL: json['logoURL'],
    );
  }
}
