

class UserInfoModel {
  int? id;
  dynamic roleId;
  String? firstName;
  String?lastName;
  String? email;
  String? contactNo;
  String? username;
  String? designation;
  String? photo;
  dynamic statusId;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;

  UserInfoModel(
      {this.id,
        this.roleId,
        this.firstName,
        this.lastName,
        this.email,
        this.contactNo,
        this.username,
        this.designation,
        this.photo,
        this.statusId,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    contactNo = json['contact_no'];
    username = json['username'];
    designation = json['designation'];
    photo = json['photo'];
    statusId = json['status_id'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['contact_no'] = this.contactNo;
    data['username'] = this.username;
    data['designation'] = this.designation;
    data['photo'] = this.photo;
    data['status_id'] = this.statusId;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


