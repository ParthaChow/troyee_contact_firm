enum VisitStatus {
  pending,
  ongoing,
  completed,
  cancelled,
}

class FarmTask {
  final int id;
  final String name;
  final String location;
  final int capacity;
  final int currentStock;
  final int employeeCount;
  final String certStatus;
  final DateTime certExpiry;
  final bool isActive;
  final double utilizationPercent;
  
  // Local state fields
  final VisitStatus status;
  final bool isSynced;

  const FarmTask({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.currentStock,
    required this.employeeCount,
    required this.certStatus,
    required this.certExpiry,
    required this.isActive,
    required this.utilizationPercent,
    this.status = VisitStatus.pending,
    this.isSynced = true,
  });

  //==========================
  // Helpers
  //==========================

  bool get isCompleted => status == VisitStatus.completed;
  bool get isPending => status == VisitStatus.pending;
  bool get isOngoing => status == VisitStatus.ongoing;

  //==========================
  // CopyWith
  //==========================

  FarmTask copyWith({
    int? id,
    String? name,
    String? location,
    int? capacity,
    int? currentStock,
    int? employeeCount,
    String? certStatus,
    DateTime? certExpiry,
    bool? isActive,
    double? utilizationPercent,
    VisitStatus? status,
    bool? isSynced,
  }) {
    return FarmTask(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      currentStock: currentStock ?? this.currentStock,
      employeeCount: employeeCount ?? this.employeeCount,
      certStatus: certStatus ?? this.certStatus,
      certExpiry: certExpiry ?? this.certExpiry,
      isActive: isActive ?? this.isActive,
      utilizationPercent: utilizationPercent ?? this.utilizationPercent,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  //==========================
  // JSON
  //==========================

  factory FarmTask.fromJson(Map<String, dynamic> json) {
    return FarmTask(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      location: json["location"] ?? "",
      capacity: json["capacity"] ?? 0,
      currentStock: json["currentStock"] ?? 0,
      employeeCount: json["employeeCount"] ?? 0,
      certStatus: json["certStatus"] ?? "Valid",
      certExpiry: json.containsKey("certExpiry") 
          ? DateTime.parse(json["certExpiry"]) 
          : DateTime.now(),
      isActive: json["isActive"] ?? true,
      utilizationPercent: (json["utilizationPercent"] as num?)?.toDouble() ?? 0.0,
      status: json["certStatus"] == "Expiring Soon" 
          ? VisitStatus.pending 
          : VisitStatus.completed, // Mapping for demonstration
      isSynced: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "location": location,
      "capacity": capacity,
      "currentStock": currentStock,
      "employeeCount": employeeCount,
      "certStatus": certStatus,
      "certExpiry": certExpiry.toIso8601String(),
      "isActive": isActive,
      "utilizationPercent": utilizationPercent,
      "status": status.name,
      "isSynced": isSynced,
    };
  }

  @override
  String toString() => 'FarmTask(id: $id, name: $name)';
}
