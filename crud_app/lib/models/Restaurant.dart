class Restaurant {
  String? name;
  String? email;
  DateTime? created;

  Restaurant(this.name, this.email, this.created);

  dynamic toJson() {
    return {
      'name': name,
      'email': email,
      'created': created,
    };
  }

  Restaurant.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        created = json['created'].toDate();
}
