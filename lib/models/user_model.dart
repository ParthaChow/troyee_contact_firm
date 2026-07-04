class UserModel {
  final UserInfo userInfo;

  UserModel({
    required this.userInfo,
});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(userInfo: UserInfo.fromJson(json['UserInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserInfo': userInfo.toJson(),
    };
  }
}

class UserInfo {
  final String uName;
  final int isStatus;
  final String compID;
  final String compName;

  UserInfo({
    required this.uName,
    required this.isStatus,
    required this.compID,
    required this.compName,
});
  factory UserInfo.fromJson(Map<String, dynamic> json){
    return UserInfo(
        uName: json['UName'],
        isStatus: json['isStatus'],
        compID: json['compID'],
        compName: json['compName']);
  }

  Map<String, dynamic> toJson(){
    return {
      'UName': uName,
      'isStatus': isStatus,
      'compID': compID,
      'compName': compName
    };
  }
}