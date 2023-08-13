import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutteract/model/product.dart';
import 'package:http/http.dart' as http;

import 'updatePage.dart';

class oStockPages extends StatefulWidget {
  const oStockPages({super.key});

  @override
  State<oStockPages> createState() => _oStockPagesState();
}

class _oStockPagesState extends State<oStockPages> {
  
  List<Product> products = [];

  Future getProdOutOfStocks() async 
  {
    products.clear();
    var response = await http.get(Uri.https('localhost:7276','api/newapi/getProdOutOfStock'));
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

  void popDeleteConfirmation(int val)
  {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Are you sure you want to delete product?"),
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Center(child: Text("Out of Stocks")),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: FutureBuilder(
            future: getProdOutOfStocks(),
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
                                    MaterialPageRoute(builder: (context) => updatePage(productId: products[index].ProductId, prods: products,)),
                                    ).then((value) {
                                      setState(() {
                                        print("ok");
                                      });
                                    });
                                
                                },
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
  );
  }
}