import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../model/product.dart';

class updatePage extends StatefulWidget {
  //const updatePage({super.key});
  int? productId;
  List<Product> prods = [];
  updatePage({Key? mykey, this.productId, required this.prods}) : super(key: mykey);

  @override
  State<updatePage> createState() => _updatePageState();
}

class _updatePageState extends State<updatePage> {
  
  var productname = TextEditingController();
  var stock = TextEditingController();
  
  List<Product> prodHolder = [];
  var idHolder;

  var res;

  void populateUpdate(){
    //print('${widget.productId}');
    //print('${widget.prods[1].Productname}');
    prodHolder = widget.prods;
    idHolder = widget.productId;

    res = prodHolder.firstWhere((element) => element.ProductId == idHolder);
    if(res == null){
      print("Found nothing");
    }
    else{
      productname.text = res.Productname;
      stock.text = '${res.Stock}';
    }
  }

  //update the product
  Future updateProd(prodVal) async 
  {
    print(prodVal.ProductId);
    var res = prodHolder.indexWhere((element) => element.ProductId == prodVal.ProductId);
    try
    {
      var response = await http.post(
      Uri.parse("https://localhost:7276/api/newapi/updateProd"),
      body: {
          "ProductId" : prodVal.ProductId.toString(),
          "Productname" : prodVal.Productname,
          "Stock" : prodVal.Stock.toString(),
          "Status" : "Active",
        }
      );
      print(response.statusCode);
      if(response.statusCode < 299)
      {
        setState(() {
          Navigator.pop(context);
        });
      }
    }
    catch(e)
    {
      print(e);
    }
  }

  //var res = products.firstWhere((element) => element.ProductId == id);
  
  @override
  Widget build(BuildContext context) {
    populateUpdate();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productname,
              decoration: const InputDecoration(
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
            const SizedBox(height: 16.0),
            TextField(
              controller: stock,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
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
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      res.Productname = productname.text;
                      res.Stock = int.parse(stock.text);
                      updateProd(res);
                    });
                  },
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}