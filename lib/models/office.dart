class OfficeResponse {
  final List<Office> offices;

  OfficeResponse({required this.offices});

  factory OfficeResponse.fromJson(Map<String, dynamic> json) {
    return OfficeResponse(
      offices: List<Office>.from(
        json['offices'].map((office) => Office.fromJson(office)),
      ),
    );
  }
}

class Office {
  final int id;
  final String office;

  Office({required this.id, required this.office});

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(id: json['id'], office: json['office']);
  }
}
