//import 'dart:ffi';

//import 'dart:js_interop';

import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteract/model/product.dart';
import 'package:flutteract/pages/ActivePage.dart';
import 'package:flutteract/pages/outOfStockPage.dart';
import 'package:flutteract/pages/updatePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class productapi extends StatefulWidget {
  const productapi({super.key});

  @override
  State<productapi> createState() => _productapiState();
}

class _productapiState extends State<productapi> {

  List<Product> products = [];

  void printContext()
  {
    getProducts();
  }

  //populate the products
  Future getProducts() async {
    products.clear();
    var response = await http.get(Uri.https('localhost:7276','api/newapi/getprod'));
    var jsonData = jsonDecode(response.body);

    for(var eachProd in jsonData){
      final prd = Product(
        ProductId: eachProd['productId'],
        Productname: eachProd['productname'], 
        Status: eachProd['status'], 
        Stock: eachProd['stock'],
        );
      products.add(prd);
    }
    //print(products);
    print(products.length);
  }

  //send the value to the API
  Future postProducts(String prodname, String stck) async {

    //final product = Product(ProductId: 0, Productname: "Shabu", Stock: 100, Status: "Active");

    try{
        var response = await http.post(
        Uri.parse("https://localhost:7276/api/newapi/postprod"),
        //headers: {'Content-Type': 'application/json'},
        body: {
          "Productname" : prodname,
          "Stock" : stck,
          "Status" : "Active",
        }
        //body: jsonEncode(product.toJson()),
      );
      print(response.statusCode);

      if(response.statusCode < 299)
      {
        print('Data posted successfully!');
        var jsonData = jsonDecode(response.body);

        final newProduct = Product(
        ProductId: jsonData['productId'],
        Productname: jsonData['productname'],
        Stock: jsonData['stock'],
        Status: jsonData['status'],
        );

        // products.add(newProduct);
        // print(products);

        setState(() {
          Navigator.pop(context);
          products.add(newProduct);
          //getProducts();
        });
      }
      else
      {
        print('Failed to post data');
        print('Response : ${response.body}');
      }
    }
    catch(e){
      print(e);
    }
  }

  //update the product
  Future updateProd(prodVal) async 
  {
    print(prodVal.ProductId);
    var res = products.indexWhere((element) => element.ProductId == prodVal.ProductId);
    print("index val : ");print(res);
    try
    {
      var response = await http.post(
      Uri.parse("https://localhost:7276/api/newapi/updateProd"),
        //headers: {'Content-Type': 'application/json'},
      body: {
          "ProductId" : prodVal.ProductId.toString(),
          "Productname" : prodVal.Productname,
          "Stock" : prodVal.Stock.toString(),
          "Status" : "Active",
        }
      //body: jsonEncode(product.toJson()),
      );
      print(response.statusCode);
      if(response.statusCode < 299)
      {
        setState(() {
          Navigator.pop(context);
          // products[res].Productname = prodVal.Productname;
          // products[res].Stock = prodVal.Stock;
          // products[res].Status = prodVal.Status;
        });
      }

    }
    catch(e)
    {
      print(e);
    }
  }

  //after confirming, proceed to this function
  Future deleteProd(int val) async
  {
    try{
      var response = await http.post(
        Uri.parse("https://localhost:7276/api/newapi/deleteProd"),
        body: {
          'id' : val.toString(),
        }
      );
      print(response.statusCode);

      if(response.statusCode < 299)
      {
        setState(() {
          products.removeWhere((element) => element.ProductId == val);
          Navigator.pop(context);
        });
      }
    }
    catch(e){
      print(e);
    }
  }

  // void testProd(int val){
  //   print(val);
  // }

  void popDeleteConfirmation(int val)
  {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Are you sure you want to delete this shit?"),
        // content: Scaffold(
        //   body: Text("Are you sure you want to delete bords?"),
        // ),
        actions: [
            MaterialButton(
              onPressed: () => deleteProd(val),
              child: const Text('Delete'),
            ),
            MaterialButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            )
          ],
      );
    }
    );
  }

  //to populate the value of products inside
  void popUpdate(int id)
  {
    var productname = TextEditingController();
    var stock = TextEditingController();

    var res = products.firstWhere((element) => element.ProductId == id);
    if(res.isNull){
      print("Found nothing");
    }
    else{
      print(res);
      productname.text = res.Productname;
      stock.text = '${res.Stock}';
    }

    showDialog(
      context: context, 
      builder: (context)
      {
        return AlertDialog(
          title: const Center(child: Text("Update product")),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: productname,
                  decoration: const InputDecoration(
                    hintText: "Product name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 10,
                        style: BorderStyle.solid)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
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
                        width: 10,
                        style: BorderStyle.solid)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () => 
              setState(() {
                res.Productname = productname.text;
                res.Stock = int.parse(stock.text);
                updateProd(res);
              }),
              child: const Text('Update'),
            ),
            MaterialButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            )
          ],
        );
      }  
    );
  }

  void popDialog()
  {
    final productname = TextEditingController();
    final stock = TextEditingController();
    showDialog(
      context: context, 
      builder: (context)
      {
        return AlertDialog(
          title: const Center(child: Text("Add product")),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: productname,
                  decoration: const InputDecoration(
                    hintText: "Product name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 10,
                        style: BorderStyle.solid)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
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
                        width: 10,
                        style: BorderStyle.solid)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () => postProducts(productname.text, stock.text),
              child: const Text('Save'),
            ),
            MaterialButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            )
          ],
        );
      }  
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Center(child: Text("Product")),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: ShapeDecoration(
                  color: const Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const activePage()),
                    ).then((value) {
                      setState(() {
                        print("ok");
                      });
                    });
                  },
                  child: const Center(
                    child: Text(
                      "Active",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 100),
              Container(
                width: 110,
                height: 110,
                decoration: ShapeDecoration(
                  color: const Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => oStockPages()),
                    ).then((value) {
                      setState(() {
                        print("ok");
                      });
                    });
                  },
                  child: const Center(
                    child: Text(
                      "Out of stock",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(products[index].Productname),
                          subtitle: Text("Stocks: ${products[index].Stock}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => updatePage(productId: products[index].ProductId,)),
                                    ).then((value) {
                                      setState(() {
                                        print("ok");
                                      });
                                    });
                                }, //=> popUpdate(products[index].ProductId),
                                child: const Text('Update'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => popDeleteConfirmation(products[index].ProductId),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: popDialog,
      tooltip: 'Create Product',
      child: const Icon(Icons.add),
    ),
  );
  }
}