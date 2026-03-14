class GeoLocationModel {
  final String lat;
  final String long;

  GeoLocationModel({required this.lat, required this.long});

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) {
    return GeoLocationModel(
      lat: json['lat'] ?? '',
      long: json['long'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'long': long,
      };
}

class AddressModel {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeoLocationModel geolocation;

  AddressModel({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      number: json['number'] ?? 0,
      zipcode: json['zipcode'] ?? '',
      geolocation:
          GeoLocationModel.fromJson(json['geolocation'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'street': street,
        'number': number,
        'zipcode': zipcode,
        'geolocation': geolocation.toJson(),
      };
}

class NameModel {
  final String firstname;
  final String lastname;

  NameModel({required this.firstname, required this.lastname});

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
      };
}

class UserModel {
  final int? id;
  final String email;
  final String username;
  final String password;
  final String phone;
  final NameModel name;
  final AddressModel address;

  UserModel({
    this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
    required this.name,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      name: NameModel.fromJson(json['name'] ?? {}),
      address: AddressModel.fromJson(json['address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'password': password,
        'phone': phone,
        'name': name.toJson(),
        'address': address.toJson(),
      };
}