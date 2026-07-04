enum VisitStatus {
  pending,
  ongoing,
  completed,
  cancelled,
}

class FarmTask {
  final int id;

  final String farmName;
  final String ownerName;
  final String phone;
  final String village;

  final double latitude;
  final double longitude;

  final int cycleDay;
  final double distance;

  final VisitStatus status;
  final bool isSynced;

  final DateTime visitDate;

  const FarmTask({
    required this.id,
    required this.farmName,
    required this.ownerName,
    required this.phone,
    required this.village,
    required this.latitude,
    required this.longitude,
    required this.cycleDay,
    required this.distance,
    required this.status,
    required this.isSynced,
    required this.visitDate,
  });

  //==========================
  // Helpers
  //==========================

  bool get isCompleted => status == VisitStatus.completed;

  bool get isPending => status == VisitStatus.pending;

  bool get isOngoing => status == VisitStatus.ongoing;

  bool get isCancelled => status == VisitStatus.cancelled;

  String get statusText {
    switch (status) {
      case VisitStatus.pending:
        return "Pending";
      case VisitStatus.ongoing:
        return "Ongoing";
      case VisitStatus.completed:
        return "Completed";
      case VisitStatus.cancelled:
        return "Cancelled";
    }
  }

  //==========================
  // CopyWith
  //==========================

  FarmTask copyWith({
    int? id,
    String? farmName,
    String? ownerName,
    String? phone,
    String? village,
    double? latitude,
    double? longitude,
    int? cycleDay,
    double? distance,
    VisitStatus? status,
    bool? isSynced,
    DateTime? visitDate,
  }) {
    return FarmTask(
      id: id ?? this.id,
      farmName: farmName ?? this.farmName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      village: village ?? this.village,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cycleDay: cycleDay ?? this.cycleDay,
      distance: distance ?? this.distance,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      visitDate: visitDate ?? this.visitDate,
    );
  }

  //==========================
  // JSON
  //==========================

  factory FarmTask.fromJson(Map<String, dynamic> json) {
    return FarmTask(
      id: json["id"],
      farmName: json["farmName"],
      ownerName: json["ownerName"],
      phone: json["phone"],
      village: json["village"],
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      cycleDay: json["cycleDay"],
      distance: (json["distance"] as num).toDouble(),
      status: VisitStatus.values.firstWhere(
            (e) => e.name == json["status"],
        orElse: () => VisitStatus.pending,
      ),
      isSynced: json["isSynced"] ?? false,
      visitDate: DateTime.parse(json["visitDate"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "farmName": farmName,
      "ownerName": ownerName,
      "phone": phone,
      "village": village,
      "latitude": latitude,
      "longitude": longitude,
      "cycleDay": cycleDay,
      "distance": distance,
      "status": status.name,
      "isSynced": isSynced,
      "visitDate": visitDate.toIso8601String(),
    };
  }

  //==========================
  // Equality
  //==========================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FarmTask &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FarmTask(id: $id, farm: $farmName, status: ${status.name})';
  }
}