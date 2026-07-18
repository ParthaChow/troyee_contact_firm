class FarmBatch {
  final int id;
  final String batchCode;
  final String breed;
  final int farmId;
  final int initialCount;
  final int currentCount;
  final int mortalityCount;
  final DateTime placementDate;
  final String healthStatus;
  final double averageWeightKg;
  final double totalFeedKg;
  final bool isActive;
  final DateTime createdAt;
  final int ageInDays;
  final double mortalityRate;
  final String? farmName;

  FarmBatch({
    required this.id,
    required this.batchCode,
    required this.breed,
    required this.farmId,
    required this.initialCount,
    required this.currentCount,
    required this.mortalityCount,
    required this.placementDate,
    required this.healthStatus,
    required this.averageWeightKg,
    required this.totalFeedKg,
    required this.isActive,
    required this.createdAt,
    required this.ageInDays,
    required this.mortalityRate,
    this.farmName,
  });

  FarmBatch copyWith({
    int? id,
    String? batchCode,
    String? breed,
    int? farmId,
    int? initialCount,
    int? currentCount,
    int? mortalityCount,
    DateTime? placementDate,
    String? healthStatus,
    double? averageWeightKg,
    double? totalFeedKg,
    bool? isActive,
    DateTime? createdAt,
    int? ageInDays,
    double? mortalityRate,
    String? farmName,
  }) {
    return FarmBatch(
      id: id ?? this.id,
      batchCode: batchCode ?? this.batchCode,
      breed: breed ?? this.breed,
      farmId: farmId ?? this.farmId,
      initialCount: initialCount ?? this.initialCount,
      currentCount: currentCount ?? this.currentCount,
      mortalityCount: mortalityCount ?? this.mortalityCount,
      placementDate: placementDate ?? this.placementDate,
      healthStatus: healthStatus ?? this.healthStatus,
      averageWeightKg: averageWeightKg ?? this.averageWeightKg,
      totalFeedKg: totalFeedKg ?? this.totalFeedKg,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      ageInDays: ageInDays ?? this.ageInDays,
      mortalityRate: mortalityRate ?? this.mortalityRate,
      farmName: farmName ?? this.farmName,
    );
  }

  factory FarmBatch.fromJson(Map<String, dynamic> json) {
    return FarmBatch(
      id: json['id'] as int,
      batchCode: json['batchCode'] as String,
      breed: json['breed'] as String,
      farmId: json['farmId'] as int,
      initialCount: json['initialCount'] as int,
      currentCount: json['currentCount'] as int,
      mortalityCount: json['mortalityCount'] as int,
      placementDate: DateTime.parse(json['placementDate'] as String),
      healthStatus: json['healthStatus'] as String,
      averageWeightKg: (json['averageWeightKg'] as num).toDouble(),
      totalFeedKg: (json['totalFeedKg'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      ageInDays: json['ageInDays'] as int,
      mortalityRate: (json['mortalityRate'] as num).toDouble(),
      farmName: json['farmName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batchCode': batchCode,
      'breed': breed,
      'farmId': farmId,
      'initialCount': initialCount,
      'currentCount': currentCount,
      'mortalityCount': mortalityCount,
      'placementDate': placementDate.toIso8601String(),
      'healthStatus': healthStatus,
      'averageWeightKg': averageWeightKg,
      'totalFeedKg': totalFeedKg,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'ageInDays': ageInDays,
      'mortalityRate': mortalityRate,
      'farmName': farmName,
    };
  }
}
