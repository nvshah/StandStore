import 'package:flutter/material.dart';

import '../providers/product.dart';

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

  var _editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0);

  @override
  void initState() {
    //Now this method will listen & handle when focus happens or loses
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
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
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    //this will save the form -> onSaved() of every TextFormField will be called
    _form.currentState.save();
    //print('Save Form is called');
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          //Establish connection with Form So that it's state can be access outside in current code
          key: _form,
          child: ListView(
            children: <Widget>[
              //TITLE INPUT
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
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
                    id: null,
                    title: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                  );
                },
              ),
              //PRICE INPUT
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                //Fetch only numbers for current input
                keyboardType: TextInputType.number,
                //attaching focusNode so that it can be focussed whenever required from other input element/widget
                focusNode: _priceFocusNode,
                //here function takes arg as value but we are not using the value so using _
                onFieldSubmitted: (_) {
                  //When the current input is subitted or next button is click, then we want to focus the Input that fetch the price i/p
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
                    id: null,
                    title: _editedProduct.title,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                  );
                },
              ),
              //DESCRIPTION INPUT
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
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
                    id: null,
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: value,
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
                          id: null,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          imageUrl: value,
                          description: _editedProduct.description,
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
