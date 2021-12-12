import 'package:biguenoexpress/models/orders.dart';
import 'package:biguenoexpress/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PawItDeliverHistory extends StatefulWidget {
  static String routeName = "/pawItSalesHistory";
  final String uid;

  const PawItDeliverHistory({Key key, this.uid}) : super(key: key);
  @override
  _PawItDeliverHistoryState createState() => _PawItDeliverHistoryState();
}

class _PawItDeliverHistoryState extends State<PawItDeliverHistory> {
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
      _firebaseServices.snapshotsRider(widget.uid),
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
                    label: Text('CUSTOMER NAME', style: columnStyle),
                  ),
                  DataColumn(
                    label: Text('DATE DELIVERED', style: columnStyle),
                  ),
                  DataColumn(
                    label: Text('STATUS', style: columnStyle),
                  ),
                  DataColumn(
                    label: Text('ORDER', style: columnStyle),
                  ),
                  DataColumn(
                    label: Text('TOTAL', style: columnStyle),
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

