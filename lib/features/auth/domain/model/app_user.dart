//user id
//email

// convert app user -> json . (how is the data is stored in firebase)
// convert json -> app user.
class AppUser {
  final String uid;
  final String email;

  //constructor
  AppUser({required this.uid, required this.email});

  // app user -> json
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email};
  }

  // json -> app user
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(uid: jsonUser['uid'], email: jsonUser['email']);
  }
}
