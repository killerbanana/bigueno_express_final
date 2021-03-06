import 'package:biguenoexpress/models/orders.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodDeliverySalesHistory extends StatefulWidget {
  static String routeName = "/foodDeliverySalesHistory";
  final String uid;

  const FoodDeliverySalesHistory({Key key, this.uid}) : super(key: key);
  @override
  _FoodDeliverySalesHistoryState createState() =>
      _FoodDeliverySalesHistoryState();
}

class _FoodDeliverySalesHistoryState extends State<FoodDeliverySalesHistory> {
  static const int defaultRowsPerPage = 20;
  int sortColumnIndex;
  bool isAscending = false;

  _ProductDataSource _dataSource = null;

  FirebaseServices _firebaseServices = FirebaseServices();

  int _rowsPerPage = defaultRowsPerPage;

  List<int> _availableRowsPerPage = [20, 50, 100];

  @override
  void initState() {
    super.initState();
    print(widget.uid);
    _dataSource = _ProductDataSource(
      _firebaseServices.snapshots(widget.uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    final columnStyle = Theme
        .of(context)
        .textTheme
        .caption;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales History'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PaginatedDataTable(
                showFirstLastButtons: true,
                dataRowHeight: 54.0,
                showCheckboxColumn: false,
                availableRowsPerPage: _availableRowsPerPage,
                rowsPerPage: _rowsPerPage,
                sortColumnIndex: sortColumnIndex,
                sortAscending: isAscending,
                onRowsPerPageChanged: (rowsPerPage) =>
                    setState(() => _rowsPerPage = rowsPerPage),
                columns: [
                  DataColumn(
                    label: Text('SHOP NAME', style: columnStyle),
                  ),
                  DataColumn(
                    label: Text('CATEGORY', style: columnStyle),
                  ),
                  DataColumn(
                    label: Text('STATUS', style: columnStyle),
                  ),
                  DataColumn(
                    label: Text('OPENING HOURS', style: columnStyle),
                  ),
                  DataColumn(
                    label: Text('FEATURED', style: columnStyle),
                  ),
                  DataColumn(
                    label: Text('FEATURED', style: columnStyle),
                  ),
                ],
                source: _dataSource),
          ],
        ),
      ),
    );
  }
}

class _ProductDataSource extends DataTableSource {
  // List<Map<String, dynamic>> _products = null;
  List<Map<String, dynamic>> orders;

  List<Order> _orders = null;

  bool get isRowCountApproximate => false;

  int get rowCount => _orders?.length ?? 0;

  int get selectedRowCount => 0;

  List<Order> get productsForExport {
    return _orders.toList();
  }

  _ProductDataSource(Stream<QuerySnapshot<Map<String, dynamic>>> snapshots) {
    snapshots.listen((snapshot) {
      orders = snapshot.docs.map((element) {
        return element.data();
      }).toList();

      // var products = List<Products>();

      _orders = orders.map((doc) {
        String date = DateTime.parse(doc['date delivered'].toDate().toString()).toString();
        return Order(
            doc['contact number'],
            date,
            date,
            doc['deliveryAddress'],
            doc['name'],
            doc['order'],
            doc['seller'],
            doc['status'],
            doc['total'],
            doc['uid']);
      }).toList();

      notifyListeners();
    });
  }

  @override
  DataRow getRow(int index) {
    var row = _orders[index];

    return DataRow(cells: [
      DataCell(
          Text(
              row.name,
        ),
      ),
      DataCell(
        row.dateDelivered == null ? Text('-') :
        Text(
          row.dateDelivered,
        ),
      ),
      DataCell(
        Text(
          row.status,
        ),
      ),
      DataCell(
        Text(
          'Click here for order details'
        )
      ),
      DataCell(
        Text(
          '\u20B1 ${row.total}',
        ),
      ),
    ]);
  }
}
