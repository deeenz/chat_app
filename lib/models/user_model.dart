class UserModel {
  String id;
  String fullName;
  String email;
  String phone;


  UserModel({
   required this.id,
   required this.fullName,
   required this.email,
   required this.phone,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        fullName = json['full_name'] as String,
        email = json['email'] as String,
        phone = json['phone'] as String
        ;

  Map<String, dynamic> toJson() => {
    'id':id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
      };
}
