import 'package:flutter/material.dart';

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

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void dispose() {
    //We need to dispose the focusNode's instances when state get cleared, as the object get removed or when you leave that screen
    //Avoid memory leak problem
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    _imageUrlFocusNode.removeListener(_updateImage);

    super.dispose();
  }

  void _updateImage(){
    //If focus looses from the Image Url Text input then we will display image if image url target possess image
    if(!_imageUrlFocusNode.hasFocus){
      //It's a bit of hack
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: ListView(
            children: <Widget>[
              //TITLE INPUT
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  //When the current input is subitted or next button is click, then we want to focus the Input that fetch the price i/p
                  FocusScope.of(context).requestFocus(_priceFocusNode);
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
                onFieldSubmitted: (_) {
                  //When the current input is subitted or next button is click, then we want to focus the Input that fetch the price i/p
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
              ),
              Row(
                children: <Widget>[
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
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a Url !')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Image Url'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    focusNode: _imageUrlFocusNode,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
