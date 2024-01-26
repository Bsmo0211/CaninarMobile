class MascotasModel {
  String? name;
  String? gender;
  bool? sterilized;
  String? petSize;
  String? race;
  String? image;
  String? id;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['gender'] = gender;
    data['pet_size'] = petSize;
    data['race'] = race;
    data['name'] = name;
    data['image'] = image;
    data['id'] = id;

    return data;
  }

  MascotasModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gender = json['gender'];
    sterilized = json['sterilized'];
    petSize = json['pet_size'];
    image = json['image'];
    name = json['name'];
    race = json['race'];
  }
}
