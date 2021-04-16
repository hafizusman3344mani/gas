class BranchModel {
  String id;
  String name;
  bool isVerified;
  String createdBy;
  String searchString;
  String branchAddress;
  String cityId;
  String createdAt;

  BranchModel();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'createdAt': createdAt,
        'searchString': searchString,
        'isVerified': isVerified,
        'createdBy': createdBy,
        'branchAddress': branchAddress,
        'cityId': cityId
      };

  BranchModel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdAt = json['createdAt'],
        isVerified = json['isVerified'],
        searchString = json['searchString'],
        createdBy = json['createdBy'],
        branchAddress = json['branchAddress'],
        cityId = json['cityId'];
}
