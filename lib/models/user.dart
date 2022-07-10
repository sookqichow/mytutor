class User {
	String? id;
	String? name;
	String? email;
	String? phoneno;
  String? password;
  String? address;
  String? datereg;
  String? cart;

	User({this.id, this.name, this.email, this.phoneno, this.address, this.password,this.datereg,this.cart});

	User.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		name = json['name'];
		email = json['email'];
		phoneno = json['phoneno'];
		password = json['password'];
    address = json['address'];
    datereg = json['datereg'];
    cart = json['cart.toString()'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['id'] = id;
		data['name'] = name;
		data['email'] = email;
		data['phoneno'] = phoneno;
		data['password'] = password;
    data['address'] = address;
    data['datereg'] = datereg;
    data['cart'] = cart;
		return data;
	}
}