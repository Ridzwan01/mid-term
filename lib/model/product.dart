class Product {
  String? id;
  String? name; 
  String? desc;
  String? address;
  String? price;
  String? guest;
  String? state;
  String? local;

  Product(
      {this.id,
      this.name,
      this.desc,
      this.address,
      this.price,
      this.guest,
      this.state,
      this.local,});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['homestay_id'];
    name = json['homestay_name'];
    desc = json['homestay_desc'];
    address = json['product_address'];
    price = json['homestay_price'];
    guest = json['homestay_guest'];
    state = json['homestay_state'];
    local = json['homestay_local'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['homestay_id'] = id;
    data['homestay_name'] = name;
    data['homestay_desc'] = desc;
    data['homestay_address'] = address;
    data['homestay_price'] = price;
    data['homestay_guest'] = guest;
    data['homestay_state'] = state;
    data['homestay_local'] = local;
    return data;
  }
}