class CoreMX {
  String userId;
  String name;
  String parentCloud;
  String globalAddress;
  String capabilites;
  String controlSecret;
  CoreMX(this.userId, this.name, this.parentCloud, this.globalAddress,
      this.capabilites, this.controlSecret);
  CoreMX.fromJson(Map<String, dynamic> json) {
    userId = json['uuid'];
    name = json['name'];
    parentCloud = json['parent_cloud'];
    globalAddress = json['global_address'];
    capabilites = json['capabilities'];
    controlSecret = json['control_secret'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['parent_cloud'] = parentCloud;
    data['uuid'] = userId;
    data['capabilities'] = capabilites;
    data['global_address'] = globalAddress;
    data['control_secret'] = controlSecret;
    return data;
  }
}
