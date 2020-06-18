import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //focus node to focus specific input
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  //Controllers
  final _imageUrlController = TextEditingController();

  //Global key to communicate with Form State
  final _form = GlobalKey<FormState>();

  //product instance
  var _editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0);

  // inorder to ensure that didChangeDependencies only fetch the data from ModalRoute when screen is loaded
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '0',
    'imageUrl': '',
  };

  var _isLoading = false;

  @override
  void initState() {
    //Now this method will listen & handle when focus happens or loses
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //Fetch Roue params only once when screen loaded
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          //'imageUrl': _editedProduct.imageUrl,    //As you can't have Controller & initValue assign both at same time
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //We need to dispose the focusNode's instances when state get cleared, as the object get removed or when you leave that screen
    //Avoid memory leak problem
    //Keep track of if it's being focussed or not
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    _imageUrlFocusNode.removeListener(_updateImage);

    super.dispose();
  }

  //This method used as a listener handler so it will be called when particular field comes into action
  //This will be call when focus changes on ImageURL text field
  void _updateImage() {
    //If focus looses from the Image Url Text input then we will display image if image url target possess image
    if (!_imageUrlFocusNode.hasFocus) {
      final value = _imageUrlController.text;
      //if image url is not valid or do not possess image
      if ((!value.startsWith('http') && !value.startsWith('https')) ||
          (!value.endsWith('.jpg') &&
              !value.endsWith('.jpeg') &&
              !value.endsWith('.png'))) {
        return;
      }

      //It's a bit of hack
      setState(() {});
      //print('Focus Of Image Changes');
    }
  }

  void _saveForm() {
    //Check if there is any error message on validation before saving the form inputs
    //this will call validator() of every Form TextFormField()
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    //this will save the form -> onSaved() of every TextFormField will be called
    _form.currentState.save();
    //print('Save Form is called');

    setState(() {
      _isLoading = true;
    });

    //here we just want one way communication i.e access of methods of Products class
    if (_editedProduct.id != null) {
      //update product from global products list
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
      setState(() {
        _isLoading = false;
      });
      // Go back to previous screen
      Navigator.of(context).pop();
    } else {
      //add product to global products list
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        // Go back to previous screen
        //We will only navigate back when item gets added into global list
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('ReBuild');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                //Establish connection with Form So that it's state can be access outside in current code
                key: _form,
                child: ListView(
                  children: <Widget>[
                    //TITLE INPUT
                    TextFormField(
                      decoration: InputDecoration(labelText: "Title"),
                      initialValue: _initValues['title'],
                      textInputAction: TextInputAction.next,
                      //When the current input is subitted or next button is click, then we want to focus the Input that fetch the price i/p
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (value) {
                        if (value.isEmpty) {
                          //this string will be treated as a error message
                          return 'Please provide a input !';
                        }
                        //null means no error
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          description: _editedProduct.description,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    //PRICE INPUT
                    TextFormField(
                      decoration: InputDecoration(labelText: "Price"),
                      initialValue: _initValues['price'],
                      textInputAction: TextInputAction.next,
                      //Fetch only numbers for current input
                      keyboardType: TextInputType.number,
                      //attaching focusNode so that it can be focussed whenever required from other input element/widget
                      focusNode: _priceFocusNode,
                      //here function takes arg as value but we are not using the value so using _
                      onFieldSubmitted: (_) {
                        //When the current input is subitted or next button is click, then we want to focus the Input that fetch the price i/p
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) < 0) {
                          return 'Please enter a number greater than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                          description: _editedProduct.description,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    //DESCRIPTION INPUT
                    TextFormField(
                      decoration: InputDecoration(labelText: "Description"),
                      initialValue: _initValues['description'],
                      //3 line space available
                      maxLines: 3,
                      //facilitate multiline fetch
                      keyboardType: TextInputType.multiline,
                      //attaching focusNode so that it can be focussed whenever required from other input element/widget
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 5) {
                          return 'Should be atleast 5 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          description: value,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    //IMAGE INPUT
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        //IMAGE BOX
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          //Display Image present at target URL
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a Url !')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        //IMAGE URL INPUT
                        //As TextFormField takes as much width as it can so we need to Wrap it with Expanded widget to avoid undesirable result
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            //After this field is inputted, done -> submit the form || Also may be it re-build the Widget
                            textInputAction: TextInputAction.done,
                            //after inputting text over here we can access that text value via attaching the controller
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image Url.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid Url.';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg') &&
                                  !value.endsWith('.png')) {
                                return 'Please enter a valid image Url';
                              }
                              return null;
                            },
                            //save the form after clicking done button from keyboard
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                imageUrl: value,
                                description: _editedProduct.description,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
