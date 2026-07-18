import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'api_fetch.dart';

class AuthService extends GetxService {
  late GetStorage storage;
  final ApiFetch _apiFetch = ApiFetch();

  final isLoggedIn = false.obs;
  final savedProfilesList = <Map<String, dynamic>>[].obs;

  Future<AuthService> init() async {
    storage = GetStorage('auth_storage');
    isLoggedIn.value = storage.hasData("accessToken");
    _loadProfiles();
    return this;
  }

  Future<bool> refreshAccessToken() async {
    final baseUrl = this.baseUrl;
    final access = accessToken;
    final refresh = refreshToken;

    if (baseUrl == null || access == null || refresh == null) return false;

    try {
      final response = await _apiFetch.refreshToken(
        accessToken: access,
        refreshToken: refresh,
        baseUrl: baseUrl,
      );

      await saveLogin(
        username: storage.read("lastUsername") ?? "", // We might need to store the username during login
        password: storage.read("lastPassword") ?? "", // And password if needed for profile
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        fieldOfficerId: response.fieldOfficerId,
        fullName: response.fullName,
        zone: response.zone,
        expiresAt: response.accessTokenExpiresAt.toIso8601String(),
        baseUrl: baseUrl,
      );
      return true;
    } catch (e) {
      print("Token refresh error: $e");
      logout();
      return false;
    }
  }

  void _loadProfiles() {
    try {
      final rawData = storage.read("savedProfiles");
      if (rawData is List) {
        final profiles = rawData.map((p) {
          if (p is Map) {
            return Map<String, dynamic>.from(p);
          }
          return <String, dynamic>{};
        }).where((p) => p.isNotEmpty).toList();
        
        _sortProfilesList(profiles);
        savedProfilesList.assignAll(profiles);
      }
    } catch (e) {
      print("Error loading profiles: $e");
    }
  }

  void _sortProfilesList(List<Map<String, dynamic>> list) {
    list.sort((a, b) {
      final aDate = DateTime.tryParse(a['lastLogin'] ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b['lastLogin'] ?? '') ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
  }

  Future<void> saveLogin({
    required String username,
    required String password,
    required String accessToken,
    required String refreshToken,
    required int fieldOfficerId,
    required String fullName,
    required String zone,
    required String expiresAt,
    required String baseUrl,
  }) async {
    await storage.write("accessToken", accessToken);
    await storage.write("refreshToken", refreshToken);
    await storage.write("fieldOfficerId", fieldOfficerId);
    await storage.write("fullName", fullName);
    await storage.write("zone", zone);
    await storage.write("accessTokenExpiresAt", expiresAt);
    await storage.write("baseUrl", baseUrl);
    await storage.write("lastUsername", username);
    await storage.write("lastPassword", password);

    await _saveProfile(
      username: username,
      password: password,
      fullName: fullName,
      zone: zone,
    );

    isLoggedIn.value = true;
  }

  Future<void> _saveProfile({
    required String username,
    required String password,
    required String fullName,
    required String zone,
  }) async {
    final profileData = {
      'username': username,
      'password': password,
      'fullName': fullName,
      'zone': zone,
      'lastLogin': DateTime.now().toIso8601String(),
    };

    // Fresh read from storage
    final rawData = storage.read("savedProfiles");
    List<Map<String, dynamic>> profiles = [];
    if (rawData is List) {
      profiles = rawData.map((p) => Map<String, dynamic>.from(p as Map)).toList();
    }

    final index = profiles.indexWhere((p) => p['username'] == username);

    if (index != -1) {
      profiles[index] = profileData;
    } else {
      profiles.add(profileData);
    }
    
    _sortProfilesList(profiles);
    
    // Save to storage and update reactive list
    await storage.write("savedProfiles", profiles);
    savedProfilesList.assignAll(profiles);
  }

  List<Map<String, dynamic>> get savedProfiles => savedProfilesList;

  String? get baseUrl => storage.read<String>("baseUrl");

  String? get accessToken => storage.read<String>("accessToken");

  String? get refreshToken => storage.read<String>("refreshToken");

  String? get accessTokenExpiresAt => storage.read<String>("accessTokenExpiresAt");

  bool get isTokenExpired {
    final expiry = storage.read<String>("accessTokenExpiresAt");
    if (expiry == null) return true;
    try {
      final expiryDate = DateTime.parse(expiry);
      // Add a small buffer (e.g., 5 minutes) to handle network latency
      return expiryDate.isBefore(DateTime.now().add(const Duration(minutes: 5)));
    } catch (e) {
      return true;
    }
  }

  int? get fieldOfficerId => storage.read<int>("fieldOfficerId");

  String? get fullName => storage.read<String>("fullName");

  String? get zone => storage.read<String>("zone");

  Future<bool> ensureValidToken() async {
    if (!isTokenExpired) return true;
    return await refreshAccessToken();
  }

  void logout() {
    storage.remove("accessToken");
    storage.remove("refreshToken");
    storage.remove("fieldOfficerId");
    storage.remove("fullName");
    storage.remove("zone");
    storage.remove("accessTokenExpiresAt");
    isLoggedIn.value = false;
  }
}
