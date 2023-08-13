import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class updatePage extends StatefulWidget {
  //const updatePage({super.key});
  int productId;
  updatePage({required this.productId});

  @override
  State<updatePage> createState() => _updatePageState(productId: this.productId);
}

class _updatePageState extends State<updatePage> {
  int productId;
  _updatePageState({required this.productId});
  
  var productname = TextEditingController();
  var stock = TextEditingController();

  //var res = products.firstWhere((element) => element.ProductId == id);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productname,
              decoration: InputDecoration(
                hintText: "Product name",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: stock,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                hintText: "Stocks",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // res.Productname = productname.text;
                      // res.Stock = int.parse(stock.text);
                      // updateProd(res);
                    });
                  },
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}