import 'dart:io';

import 'package:contatos/helpers/contact_helper.dart';
import 'package:contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllContacts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactPage,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
          itemCount: contacts.length,
          itemBuilder: (context, index){
          return _contactCard(context, index);
          }
      ),
    );
  }
  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ?
                          FileImage(File(contacts[index].img)) :
                          AssetImage("assets/person.png")
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    Text(contacts[index].name ?? "", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    Text(contacts[index].email ?? "", style: TextStyle(fontSize: 18),),
                    Text(contacts[index].phone ?? "", style: TextStyle(fontSize: 18),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        _showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts = list;
      });
    });
  }
}
