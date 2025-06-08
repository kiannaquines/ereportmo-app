class IncidentType {
  final int id;
  final String incident;
  final int officeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Office office;

  IncidentType({
    required this.id,
    required this.incident,
    required this.officeId,
    required this.createdAt,
    required this.updatedAt,
    required this.office,
  });

  factory IncidentType.fromJson(Map<String, dynamic> json) {
    return IncidentType(
      id: json['id'],
      incident: json['incident'],
      officeId: json['office_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      office: Office.fromJson(json['office']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incident': incident,
      'office_id': officeId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'office': office.toJson(),
    };
  }
}

class Office {
  final int id;
  final String office;

  Office({required this.id, required this.office});

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(id: json['id'], office: json['office']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'office': office};
  }
}

class IncidentTypeResponse {
  final List<IncidentType> incidentTypes;

  IncidentTypeResponse({required this.incidentTypes});

  factory IncidentTypeResponse.fromJson(Map<String, dynamic> json) {
    return IncidentTypeResponse(
      incidentTypes: List<IncidentType>.from(
        json['types'].map((item) => IncidentType.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'types': incidentTypes.map((e) => e.toJson()).toList()};
  }
}
