import 'dart:io';

import 'package:contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage({this.contact});
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _editedContact;
  bool _userEdited = false;

  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPhone = TextEditingController();

  final _phoneFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.contact == null)
      _editedContact = Contact();
    else{
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _controllerName.text = _editedContact.name;
      _controllerEmail.text = _editedContact.email;
      _controllerPhone.text = _editedContact.phone;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        if( _editedContact.phone != null && _editedContact.phone.isNotEmpty)
          Navigator.pop(context, _editedContact);
        else{
          FocusScope.of(context).requestFocus(_phoneFocus);
        }
      },
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _editedContact.img != null ?
                      FileImage(File(_editedContact.img)) :
                      AssetImage("assets/person.png")
                  ),
                ),
              ),
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (name){
                _userEdited = true;
                setState(() {
                  _editedContact.name = name;
                });
              },
              controller: _controllerName,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "E-mail"),
              onChanged: (email){
                _userEdited = true;
                  _editedContact.email = email;
              },
              controller: _controllerEmail,
            ),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Telefone"),
              onChanged: (phone){
                _userEdited = true;
                _editedContact.email = phone;
              },
              maxLength: 11,
              maxLengthEnforced: true,
              controller: _controllerPhone,
              focusNode: _phoneFocus,
            ),
          ],
        ),
      ),
    );
  }
}
