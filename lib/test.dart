import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Grocery> groceryList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groceries'),
      ),
      body: ListView(
        children: List.generate(
          groceryList.length,
          (index) {
            final grocery = groceryList[index];
            return ListTile(
              title: Text(
                grocery.amount.toString() + ' ' + grocery.name,
              ),
              subtitle: Text('Each cost: \$' + grocery.price.toString()),
              trailing: Text('\$' + (grocery.price * grocery.amount).toString()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return GroceryNameForm();
            },
          ));
        },
      ),
    );
  }
}

class Grocery {
  final String name;
  final int amount;
  final int price;

  const Grocery({required this.name, required this.amount, required this.price});

  Grocery copyWith({required String name, required int amount, required int price}) {
    return Grocery(
      name: this.name,
      amount: this.amount,
      price: this.price,
    );
  }
}

class GroceryNameForm extends StatefulWidget {
  @override
  _GroceryNameFormState createState() => _GroceryNameFormState();
}

class _GroceryNameFormState extends State<GroceryNameForm> {
  var _name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Name'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) => setState(() => _name = value),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Banana',
                ),
              ),
              RaisedButton(
                child: const Text('Continue'),
                onPressed: () {
                  if (_name.isEmpty) return null;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroceryAmountForm(),
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GroceryAmountForm extends StatefulWidget {
  @override
  _GroceryAmountFormState createState() => _GroceryAmountFormState();
}

class _GroceryAmountFormState extends State<GroceryAmountForm> {
  var _amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amount')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() => _amount = int.tryParse(value));
                },
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: '42',
                ),
                keyboardType: TextInputType.number,
              ),
              RaisedButton(
                child: const Text('Continue'),
                onPressed: () {
                  if (_amount == null) return null;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroceryPriceForm(),
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GroceryPriceForm extends StatefulWidget {
  @override
  _GroceryPriceFormState createState() => _GroceryPriceFormState();
}

class _GroceryPriceFormState extends State<GroceryPriceForm> {
  var _price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Price')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() => _price = int.tryParse(value));
                },
                decoration: const InputDecoration(
                  labelText: 'Price (\$SGD)',
                  hintText: '\$170',
                ),
                keyboardType: TextInputType.number,
              ),
              RaisedButton(
                child: const Text('Continue'),
                onPressed: () {
                  if (_price == null) return null;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
