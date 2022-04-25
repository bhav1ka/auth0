class Participants {
  String email;
  bool emailVerified;
  String userid;
  String picture;
  String userName;
  Participants.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    emailVerified = json['email_verified'];
    userid = json['uuid'];
    userName = json['username'];
    picture = json['picture'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['email_verified'] = emailVerified;
    data['uuid'] = userid;
    data['picture'] = picture;
    data['username'] = userName;
    return data;
  }
}
