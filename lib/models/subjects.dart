class Subject {
	String? subjectId;
	String? subjectName;
  String? subjectDesc;
	String? subjectPrice;
	String? tuturId;
  String? subjectSessions;
  String? subjectRating;

	Subject({this.subjectId, this.subjectName, this.subjectDesc, this.subjectPrice, this.tuturId, this.subjectSessions,this.subjectRating});

	Subject.fromJson(Map<String, dynamic> json) {
		subjectId = json['subject_id'];
		subjectName = json['subject_name'];
		subjectDesc = json['subject_description'];
		subjectPrice = json['subject_price'];
		tuturId = json['tutur_id'];
    subjectSessions = json['subject_sessions'];
    subjectRating = json['subject_rating'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['subject_id'] = subjectId;
		data['subject_name'] = subjectName;
		data['subject_description'] = subjectDesc;
		data['subject_price'] = subjectPrice;
		data['tutur_id'] = tuturId;
    data['subject_sessions'] = subjectSessions;
    data['subject_rating'] = subjectRating;
		return data;
	}
}