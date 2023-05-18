class User{
  int userId;
  String username;
  String role;
  User({required this.userId, required this.username, required this.role});

  factory User.fromMap(Map<String,dynamic> data){
    return User(userId: data['user_id'], username: data['username'], role: data['role']);
  }

  @override
  String toString() {
    return 'User{userId: $userId, username: $username, role: $role}';
  }
}