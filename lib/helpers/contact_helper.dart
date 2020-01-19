import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper{
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database _db;
  Future<Database> get db async{
    if(_db != null)
      return _db;
    else
      _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async{
    final database = await getDatabasesPath();
    final path = join(database, "contact1.db");
    return await openDatabase(path, version: 1, onCreate: (Database db, newVersion) async{
      String sql = "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn VARCHAR, $emailColumn VARCHAR, $phoneColumn VARCHAR, $imgColumn VARCHAR)";
      await db.execute(sql);
    });
  }

  Future<Contact> saveContact(Contact contact) async{
    Database database = await db;
    contact.id = await database.insert(
        contactTable,
        contact.toMap()
    );
    return contact;
  }

  Future<Contact> getContact(int id)async{
    Database database = await db;
    List<Map> maps = await database.query(
      contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ? ",
      whereArgs: [id],
    );
    if(maps.length > 0)
      return Contact.fromMap(maps.first);
    else
      return null;
  }

  Future<int>deleteContact(int id) async{
    Database database = await db;
    return await database.delete(contactTable, where: "$idColumn = ? ", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async{
    Database database = await db;
    return await database.update(contactTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async{
    Database database = await db;
    String sql = "SELECT * FROM $contactTable";
    List listMap = await database.rawQuery(sql);
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber()async{
    final database = await db;
    String sql = "SELECT COUNT(*) FROM $contactTable";
    return Sqflite.firstIntValue(await database.rawQuery(sql));

  }

  Future close() async{
    final database = await db;
    await database.close();
  }
}

class Contact{

  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[phoneColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if(id != null)
      map[idColumn] = id;

    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }

}