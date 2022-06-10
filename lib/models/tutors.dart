class listTutors{
 String? tutorId;
 String?  tutorEmail;
 String?  tutorPhone;
  String?  tutorName;
   String?  tutorPass;
  String? tutorDesc;
  String?  tutorDatereg;

 listTutors(
      {this. tutorId,
      this. tutorEmail,
      this. tutorPhone,
      this.tutorName,
      this. tutorPass,
      this.tutorDesc,
      this. tutorDatereg
      });

  listTutors.fromJson(Map<String, dynamic> json) {
   tutorId = json['tutor_id'];
    tutorEmail = json['tutor_email'];
    tutorPhone = json['tutor_phone'];
   tutorName = json['tutor_name'];
    tutorPass = json['tutor_password'];
   tutorDesc = json['tutor_description'];
    tutorDatereg = json['tutor_datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tutor_id'] = tutorId;
    data['tutor_email'] = tutorEmail;
    data['tutor_phone'] =  tutorPhone;
    data['tutor_name'] =  tutorName;
    data['tutor_password'] =  tutorPass;
    data['tutor_description'] =  tutorDesc;
     data['tutor_datereg']= tutorDatereg;
    return data;
  }
}


