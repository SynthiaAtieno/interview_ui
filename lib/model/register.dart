

import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  final int code;
  final String message;
  final User user;

  Register({
    required this.code,
    required this.message,
    required this.user,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
    code: json["code"],
    message: json["message"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "user": user.toJson(),
  };
}

class User {
  final int id;
  final String name;
  final String status;
  final String email;
  final DateTime createdAt;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.status,
    required this.email,
    required this.createdAt,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    email: json["email"],
    createdAt: DateTime.parse(json["createdAt"]),
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "email": email,
    "createdAt": createdAt.toIso8601String(),
    "role": role,
  };
}
