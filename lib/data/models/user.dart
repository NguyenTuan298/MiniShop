class User {
  final String? userId;
  final String username;
  final String? email;
  final String? phone;

  User({this.userId, required this.username, this.email, this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}