class MascotasModel {
  String? name;
  String? gender;
  bool? sterilized;
  String? pet_size;
  String? race;
  String? image;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['gender'] = gender;
    data['pet_size'] = pet_size;
    data['race'] = race;
    data['name'] = name;
    data['image'] = image;

    return data;
  }

  MascotasModel.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    sterilized = json['sterilized'];
    pet_size = json['pet_size'];
    image = json['image'];
    name = json['name'];
    race = json['race'];
  }
}
