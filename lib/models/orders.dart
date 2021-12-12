class Order{
  final String contactNumber;
  final String dateOrdered;
  final String dateDelivered;
  final String deliveryAddress;
  final String name;
  final List<dynamic> order;
  final String seller;
  final String status;
  final double total;
  final String uid;

  Order(this.contactNumber, this.dateOrdered, this.dateDelivered, this.deliveryAddress, this.name, this.order, this.seller, this.status, this.total, this.uid);
}

class Orders{
  final String imgUrl;
  final double price;
  final String productName;
  final int qty;
  final String seller;

  Orders(this.imgUrl, this.price, this.productName, this.qty, this.seller);
}