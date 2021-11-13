// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/products_repository.dart';
import 'model/product.dart';

import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

// Replace this entire method
  List<Card> _buildGridCards(BuildContext context) {
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (products == null || products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: Column(
          // TODO: Center items on the card (103)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                product.assetName,
                package: product.assetPackage,
                // TODO: Adjust the box size (102)
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  // TODO: Align labels to the bottom and center (103)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // TODO: Change innermost Column (103)
                  children: <Widget>[
                    // TODO: Handle overflowing labels (103)
                    Text(
                      product.name,
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    const _url = 'https://www.handong.edu/' ;
    void _launchURL() async =>
        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

    List<bool> _isSelected = List.generate(2, (index) => false);

    _gridView (BuildContext context, orientation) {
      return Scaffold(
        body: Center(
          child: GridView.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              // TODO: Build a grid of cards (102)
              children: _buildGridCards(context) // Changed code
          ),
        ),
      );
    }


    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(margin: EdgeInsets.only(bottom: 100.0)),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey[850],
              ),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),

            ListTile(
              leading: Icon(
                Icons.search,
                color: Colors.grey[850],
              ),
              title: Text('Search'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.location_city,
                color: Colors.grey[850],
              ),
              title: Text('Favorite Hotel'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.grey[850],
              ),
              title: Text('My page'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.grey[850],
              ),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              print('Search button');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.language,
              semanticLabel: 'filter',
            ),
            onPressed:
              _launchURL,
          ),
        ],
      ),

      body:
        SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: ToggleButtons(
                        color: Colors.black.withOpacity(0.60),
                        selectedColor: Color(0xFF6200EE),
                        selectedBorderColor: Color(0xFF6200EE),
                        fillColor: Color(0xFF6200EE).withOpacity(0.08),
                        splashColor: Color(0xFF6200EE).withOpacity(0.12),
                        hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                        borderRadius: BorderRadius.circular(4.0),

                        onPressed: (int index) => {
                          // Respond to button selection
                          setState(() {
                            for (int buttonIndex = 0; buttonIndex < _isSelected.length; buttonIndex++) {
                              if (buttonIndex == index) {
                                _isSelected[buttonIndex] = !_isSelected[buttonIndex];
                              } else {
                                _isSelected[buttonIndex] = false;
                              }
                            }
                          })
                        },
                        isSelected: _isSelected,

                        children: const [
                          Icon(Icons.list_outlined),
                          Icon(Icons.grid_view_outlined),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ListView.builder(
              //     itemBuilder: (context, index) {
              //       padding: EdgeInsets.all(16.0),
              //     })
              Expanded(
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    return _gridView(context, orientation);
                  },
                ),
              ),
            ],
          ),
        ),
      resizeToAvoidBottomInset: false,
    );
  }

}

getListView (BuildContext context, String gridItem) {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(

        ),
      ),
    );
  }

}

