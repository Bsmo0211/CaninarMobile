class CertificadosModel {
  String? name;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;

    return data;
  }

  CertificadosModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
