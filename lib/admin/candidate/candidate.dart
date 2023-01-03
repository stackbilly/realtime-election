class Candidate {
  String firstName;
  String lastName;
  String facultyName;
  String regNo;
  String imgUrl;
  String phoneNo;
  int votes;

  Candidate(this.firstName, this.lastName, this.facultyName, this.regNo,
      this.imgUrl, this.phoneNo, this.votes);

  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "facultyName": facultyName,
      "regNo": regNo,
      "imgUrl": imgUrl,
      "phoneNo": phoneNo,
      "votes": votes
    };
  }

  static Candidate fromMap(Map<String, dynamic> map) {
    return Candidate(map['firstName'], map['lastName'], map['facultyName'],
        map['regNo'], map['imgUrl'], map['phoneNo'], map['votes']);
  }
}
