import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:the_miller/services/notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_miller/models/customer.dart';
import 'package:the_miller/services/customerapi.dart';

class CustomerForm extends StatefulWidget {
  final bool isUpdating;
  CustomerForm({@required this.isUpdating});

  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Customer _currentCustomer;
  String _imageUrl;
  File _imageFile;

  @override
  void initState() {
    super.initState();
    CustomerNotifier customerNotifier =
        Provider.of<CustomerNotifier>(context, listen: false);

    if (customerNotifier.currentCustomer != null) {
      _currentCustomer = customerNotifier.currentCustomer;
    } else {
      _currentCustomer = Customer();
    }

    _imageUrl = _currentCustomer.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Image(
        image: AssetImage('assets/images/dp.png'),
        width: 150,
        fit: BoxFit.fitWidth,
      );
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 200,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 200,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    PickedFile imagePFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 400);
    File imageFile = File(imagePFile.path);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Customer Name'),
      initialValue: _currentCustomer.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3) {
          return 'Name must be more than 3 characters';
        }

        return null;
      },
      onSaved: (String value) {
        _currentCustomer.name = value;
      },
    );
  }

  Widget _buildNicField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'NIC No'),
      initialValue: _currentCustomer.nic,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'NIC  is required';
        }

        if (value.length < 9) {
          return 'NIC must be more than 9 numbers';
        }

        return null;
      },
      onSaved: (String value) {
        _currentCustomer.nic = value;
      },
    );
  }

  Widget _buildMobileField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Mobile No'),
      initialValue: _currentCustomer.mobile,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Mobile number is required';
        }

        if (value.length != 10) {
          return 'Mobile Number must be 10 digits';
        }

        return null;
      },
      onSaved: (String value) {
        _currentCustomer.mobile = value;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Address'),
      initialValue: _currentCustomer.address,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      onSaved: (String value) {
        _currentCustomer.address = value;
      },
    );
  }

  _onCustomerUploaded(Customer customer) {
    CustomerNotifier customerNotifier =
        Provider.of<CustomerNotifier>(context, listen: false);
    customerNotifier.addCustomer(customer);
    Navigator.pop(context);
  }

  _saveCustomer() async {
    print('saveCustomer Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadCustomerAndImage(
        _currentCustomer, widget.isUpdating, _imageFile, _onCustomerUploaded);

    print("name: ${_currentCustomer.name}");
    print("nic: ${_currentCustomer.nic}");
    print("mobile: ${_currentCustomer.mobile}");
    print("address: ${_currentCustomer.address}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Customer Form'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Customer" : "Create Customer",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? RaisedButton(
                    color: Colors.green[700],
                    onPressed: () => _getLocalImage(),
                    child: Text(
                      'Add Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SizedBox(height: 0),
            _buildNameField(),
            _buildNicField(),
            _buildMobileField(),
            _buildAddressField(),
            SizedBox(height: 16),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAlertDialog(context);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _saveCustomer();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Text("Do you want to update/save the customer?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
