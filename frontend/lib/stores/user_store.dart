class UserStore{
  static final UserStore __instance = UserStore.__internal();

  String? token;
  int? userId;
  double? balance;
  String? username;
  bool isAdmin = false;
  bool isVendor = false;

  factory UserStore(){
    return __instance;
  }

  void setToken(String token, int userId){
    this.token = token;
    this.userId = userId;
  }
  void setBalance(double balance){
    this.balance = balance;
  }
  void setUsername(String username){
    this.username = username;
  }

  String getToken(){
    return token!;
  }

  int getUserId(){
    return userId!;
  }

  void clearUser(){
    token = null;
    userId = null;
    balance = null;
    username = null;
  }

  UserStore.__internal();
}