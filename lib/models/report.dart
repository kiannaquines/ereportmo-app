class ReportedIncident {
  final int id;
  final int userId;
  final int incidentId;
  final String image;
  final String incidentResponseStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double latitude;
  final double longitude;
  final String description;
  final Incident incident;
  final User user;

  ReportedIncident({
    required this.id,
    required this.userId,
    required this.incidentId,
    required this.image,
    required this.incidentResponseStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.incident,
    required this.user,
  });

  factory ReportedIncident.fromJson(Map<String, dynamic> json) {
    return ReportedIncident(
      id: json['id'],
      userId: json['user_id'],
      incidentId: json['incident_id'],
      image: json['image'],
      incidentResponseStatus: json['incident_response_status'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: DateTime.parse(json['updated_at']).toLocal(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'],
      incident: Incident.fromJson(json['incident']),
      user: User.fromJson(json['user']),
    );
  }
}

class Incident {
  final int id;
  final String incident;
  final int officeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Incident({
    required this.id,
    required this.incident,
    required this.officeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'],
      incident: json['incident'],
      officeId: json['office_id'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: DateTime.parse(json['updated_at']).toLocal(),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String municipality;
  final String barangay;
  final String? emailVerifiedAt;
  final int? officeId;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.municipality,
    required this.barangay,
    this.emailVerifiedAt,
    this.officeId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      municipality: json['municipality'],
      barangay: json['barangay'],
      emailVerifiedAt: json['email_verified_at'],
      officeId: json['office_id'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
