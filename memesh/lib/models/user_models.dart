class UserModel {
  final String id; // uid
  final String anonymousId;
  final String name;
  final String avatar;
  final bool isOnline;
  final int dayActive;
  final DateTime lastSeen;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.anonymousId,
    this.name = 'Anonymous',
    this.avatar = '',
    this.isOnline = false,
    this.dayActive = 0,
    required this.lastSeen,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'anonymousId': anonymousId,
      'name': name,
      'avatar': avatar,        
      'isOnline': isOnline,
      'dayActive': dayActive,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
  
  // fromMap TANPA secretKey
  factory UserModel.fromMap(Map<String, dynamic> map) {  // HAPUS parameter secretKey
    return UserModel(
      id: map['id'] ?? '',
      anonymousId: map['anonymousId'] ?? '',
      name: map['name'] ?? 'Anonymous',
      avatar: map['avatar'] ?? '',
      isOnline: map['isOnline'] ?? false,
      dayActive: map['dayActive'] ?? 0,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] ?? 0),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  // copyWith TANPA secretKey
  UserModel copyWith({
    String? id,
    String? anonymousId,
    String? name,
    String? avatar,
    bool? isOnline,
    int? dayActive,
    DateTime? lastSeen,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      anonymousId: anonymousId ?? this.anonymousId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
      dayActive: dayActive ?? this.dayActive,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}