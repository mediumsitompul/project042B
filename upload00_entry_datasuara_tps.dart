import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:path/path.dart';
import 'package:flutter/services.dart'; // PlatformException

import 'menu00.dart';
import 'upload00_rejected.dart';
import 'upload00_success.dart';

class Upload00_EntryDataSuaraTps extends StatelessWidget {
  const Upload00_EntryDataSuaraTps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 50, 5, 210),
          foregroundColor: Colors.white,
          title: const Center(
              child: Text('         MENYIMPAN HASIL\nPEMUNGUTAN SUARA DI TPS')),
        ),
        body: const MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  TextEditingController cSuaraCaleg1 = TextEditingController();
  TextEditingController cDescription = TextEditingController(); // new version
  TextEditingController cAlamat = TextEditingController();
  TextEditingController cTpsId = TextEditingController();

  bool dropdown001Available = false;
  bool dropdown002Available = false;
  bool dropdown003Available = false;
  bool dropdown004Available = false;

  bool select001 = false;
  bool select002 = false;
  bool select003 = false;
  bool select004 = false;

  final String provincename = "";
  final String regencyname = "";
  final String kecamatanname = "";
  final String villagesname = "";

  final String provinceid = "";
  final String regencyid = "";
  final String kecamatanid = "";
  final String villagesid = "";

  var data_001;
  var data_002;
  var data_003;
  var data_004;

  var provincename1;
  var regencyname1;
  var kecamatanname1;
  var kelurahanname1;

  var usernamex;
  var panjfile;

  String? _selected001;
  String? _selected002;
  String? _selected003;
  String? _selected004;

  // HOSTING OK
  var data001_url = "https://mediumsitompul.com/qcri/province_ri.php";
  var data002_url = "https://mediumsitompul.com/qcri/kabupatenkota_ri.php";
  var data003_url = "https://mediumsitompul.com/qcri/kecamatan_ri.php";
  var data004_url = "https://mediumsitompul.com/qcri/villages_ri.php";

  //NEW
  late SharedPreferences pref;
  late String username0 = "";
  late String namamu0 = "";

  Future<void> initial() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      username0 = pref.getString('username')!;
      namamu0 = pref.getString('namamu')!;
    });
  }

  //******************************************************* START DROP DOWN **************************************************************/
  Widget data001List() {
    List<query001> data001_list = List<query001>.from(
      data_001["datajs"].map(
        (i) {
          return query001.fromJSON(i);
        },
      ),
    );

    return DropdownButton(
      hint: const Text("Pilih Province"), //Data1
      isExpanded: true,
      items: data001_list.map((query001) {
        return DropdownMenuItem(
          onTap: () {
            setState(() {
              //if(username0.isNotEmpty){
              select001 = true;
              //}
            });
          },
          child: Text(query001.provincename), //show
          value: query001.provinceid, //value yg di send
        );
      }).toList(),
      value: _selected001,

      onChanged: (newValue) {
        setState(() {
          _selected001 = newValue.toString();
          final provinceid = _selected001;
          print(
              "_selected001 provinceid ========== " + _selected001.toString());
          showToastMessage(provinceid.toString());
          get_data002(provinceid); //send to input dropdown2
          _selected002 = null;
          _selected003 = null;
          _selected004 = null;
          // }
        });
      },
    );
  }

  //******************************************************************************************************************************************** */
  Widget data002List() {
    List<query002> data002_list =
        List<query002>.from(data_002['datajs'].map((i) {
      return query002.fromJSON(i);
    }));

    return DropdownButton(
      hint: const Text("Pilih Kabupaten / Kota"), //Data2, Regency
      isExpanded: true,
      items: data002_list.map((query002) {
        return DropdownMenuItem(
          onTap: () {
            setState(() {
              select002 = true;
            });
          },

          child: Text(query002.regencyname), //DATA SHOW
          value: query002.regencyid, //DATA SENDING
        );
      }).toList(),
      value: _selected002,
      onChanged: (newValue) {
        setState(() {
          _selected002 = newValue.toString();
          //_selected002 = "";

          final regencyid = _selected002; //medium new
          print("_selected002 regency ========== " + _selected002.toString());
          showToastMessage(regencyid.toString());
          get_data003(regencyid); // medium new
          _selected003 = null;
          _selected004 = null;
        });
      },
    );
  }

  //******************************************************************************************************************************************** */
  Widget data003List() {
    List<query003> data003_list =
        List<query003>.from(data_003['datajs'].map((i) {
      return query003.fromJSON(i);
    }));

    return DropdownButton(
      hint: const Text("Pilih Kecamatan"), //Data3, Kecamatan
      isExpanded: true,
      items: data003_list.map((query003) {
        return DropdownMenuItem(
          onTap: () {
            setState(() {
              select003 = true;
            });
          },
          child: Text(query003.kecamatanname),
          value: query003.kecamatanid,
        );
      }).toList(),
      value: _selected003,
      onChanged: (newValue) {
        setState(() {
          _selected003 = newValue.toString();
          final kecamatanid = _selected003;
          print("_selected003 Kecamatan ========== " + _selected003.toString());
          showToastMessage(kecamatanid.toString());
          get_data004(
              kecamatanid); //Jika tidak ada query lagi dibawahnya. STOP THIS
          _selected004 = null;
        });
      },
    );
  }

  //******************************************************************************************************************************************** */

  Widget data004List() {
    List<query004> data004_list =
        List<query004>.from(data_004['datajs'].map((i) {
      return query004.fromJSON(i);
    }));

    return DropdownButton(
      hint: const Text("Pilih Kelurahan"), //Data4, Villages
      isExpanded: true,
      items: data004_list.map((query004) {
        return DropdownMenuItem(
          onTap: () {
            setState(() {
              select004 = true;
            });
          },
          child: Text(query004.villagesname),
          value: query004.villagesid,
        );
      }).toList(),
      value: _selected004,
      onChanged: (newValue) {
        setState(() {
          _selected004 = newValue.toString();
          final villagesid = _selected004;
          print("_selected004 villages =========== " + _selected004.toString());
          showToastMessage(villagesid.toString());
          //get_data5(nextid); //Jika tidak ada query lagi dibawahnya. Jika tidak, maka STOP THIS
          //_selected5 = null;
          //showToastMessage("Next, Please enter TPS-ID....!!!");
        });
      },
    );
  }
  // //******************************************************************************************************************************************** */

  Future<void> get_data001() async {
    //NO.3
    var res001 = await http.post(Uri.parse(data001_url));

    print("res001 = " + res001.toString());
    if (res001.statusCode == 200) {
      setState(() {
        data_001 = json.decode(res001.body); // data JSON like di file PHP
        print("data_001 = " + data_001.toString());

        //*************************** */
        setState(() {
          dropdown001Available = true;
        });
        //*************************** */
      });
    } else {
      setState(() {
        bool error = true;
        String message = "Error during fetching data";
      });
    }
  }
  //========================================================================================================================================

//now
  Future<void> get_data002(res001) async {
    final provinceid = res001;

    //pakai final: OK
    final res002 = await http
        .post(Uri.parse(data002_url + "?pilihan1=" + provinceid.toString()));

    print("res002 = " + res002.toString());

    if (res002.statusCode == 200) {
      setState(() {
        data_002 = json.decode(res002.body.toString());
        print("data_002 = " + data_002.toString());

        //*************************** */
        setState(() {
          dropdown002Available = true;
        });
        //*************************** */
      });
    } else {
      setState(() {
        bool error = true;
        String message = "Error during fetching data";
      });
    }
  }

  //========================================================================================================================================
  Future<void> get_data003(res002) async {
    final regencyid = res002;
    //var res003 = await http.post(Uri.parse(data003_url + "?pilihan1=" + provinceid.toString() + "&pilihan2=" + regencyid.toString())); //OK dgn design table
    final res003 = await http
        .post(Uri.parse(data003_url + "?pilihan2=" + regencyid.toString()));

    print("res003 = " + res003.toString());

    if (res003.statusCode == 200) {
      setState(() {
        data_003 = json.decode(res003.body.toString()); //new medium
        print("data_003 = " + data_003.toString());

        //*************************** */
        setState(() {
          dropdown003Available = true;
        });
        //*************************** */
      });
    } else {
      setState(() {
        bool error = true;
        String message = "Error during fetching data";
      });
    }
  }

  //========================================================================================================================================
  Future<void> get_data004(res003) async {
    final kecamatanid = res003;

    //var res004 = await http.post(Uri.parse(data004_url + "?pilihan1=" + provinceid.toString() + "&pilihan3=" + kecamatanid.toString()));
    var res004 = await http
        .post(Uri.parse(data004_url + "?pilihan3=" + kecamatanid.toString()));

    print("res004 = " + res004.toString());

    if (res004.statusCode == 200) {
      setState(() {
        data_004 = json.decode(res004.body.toString()); //new medium
        print("data_004 = " + data_004.toString());

        //*************************** */
        setState(() {
          dropdown004Available = true;
        });
        //*************************** */
      });
    } else {
      setState(() {
        bool error = true;
        String message = "Error during fetching data";
      });
    }
  }

  //******************************************************* END DROP DOWN ************************************************************************************* */

  File? uploadImage;
  Future _imageCamera() async {
    try {
      var imageFile = await ImagePicker().pickImage(
          //source: ImageSource.camera, imageQuality: 50); //image_picker
          source: ImageSource.camera,
          imageQuality: 100);

      if (imageFile == null) return;
      final imageTemp = File(imageFile.path);

      panjfile = imageTemp.length;

      print("panjfile +++++++++");
      print(panjfile.toString().length); //=51

      // print("imageTemp +++++++++");
      // print(imageFile.toString().length); //=19

      setState(() {
        uploadImage = File(imageTemp.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //......................................................................

  Future _upload(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://mediumsitompul.com/qcri/upload_try.php"); //new
    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.fields['tps_id'] = cTpsId.text;
    request.fields['alamat'] = cAlamat.text;
    request.fields['province'] = _selected001.toString();
    request.fields['kabupatenkota'] = _selected002.toString();
    request.fields['kecamatan'] = _selected003.toString();
    request.fields['kelurahan'] = _selected004.toString();
    request.fields['suara_caleg1'] = cSuaraCaleg1.text;
    request.fields['description'] = cDescription.text;
    request.fields['username_entry'] = username0;
    request.fields['name_entry'] = namamu0;
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var responseJson = json.decode(responseString);

      if (responseJson == 'failed') {
        Navigator.push(this.context,
            MaterialPageRoute(builder: (context) => Uploadl00_Rejected()));
      } else if (responseJson == 'success') {
        Navigator.push(this.context,
            MaterialPageRoute(builder: (context) => UploadSuccess()));
      }
    }
  }

  //..................................................................................

  @override
  void initState() {
    initial();
    get_data002(provinceid);
    get_data003(regencyid);
    get_data004(kecamatanid);
    get_data001();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Welcome " + namamu0 + "\n" + username0,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              const Center(
                  child: Text(
                "     ENTRY DATA\nREKAPITULASI TPS",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue),
              )),

              const SizedBox(
                height: 20,
              ),
              //................................................................

              dropdown001Available == false ? Container() : data001List(),
              dropdown002Available == false ? Container() : data002List(),
              dropdown003Available == false ? Container() : data003List(),
              dropdown004Available == false ? Container() : data004List(),
              //................................................................

              Container(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //inputFormatters: [FilteringTextInputFormatter.d

                  maxLength: 3,
                  cursorColor: Colors.red,
                  controller: cTpsId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'TPS-ID',
                  ),
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
              //................................................................
              Container(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  maxLength: 50,
                  cursorColor: Colors.red,
                  controller: cAlamat,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Alamat / Lokasi TPS',
                  ),
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),

              //************************ */

              Container(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 3,
                  cursorColor: Colors.red,
                  controller: cSuaraCaleg1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Jumlah suara caleg1',
                  ),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              //.....................
              Container(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  maxLength: 50,
                  cursorColor: Colors.red,
                  controller: cDescription,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),

              //..................................................................
              Container(
                height: 70,
                padding: const EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _imageCamera();
                  },
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text("Take picture for evident\n(Rekap Suara)"),
                ),
              ),
              Container(
                //show image here after choosing image
                child: uploadImage == null
                    ? Container()
                    : //if uploadImage is null then show empty container
                    //else show image here
                    SizedBox(
                        height: 100,
                        child: Image.file(uploadImage!) //load image from file
                        ),
              ),

              //......................................... VALIDATION NEXT PROCESS ......................
              Container(
                height: 70,
                padding: const EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (!select001) {
                      showToastMessage("Please select PROVINCE ....!!!");
                      print("select001+++++++++++");
                      print(select001);
                    } else if (!select002) {
                      showToastMessage("Please select KABUPATEN/KOTA ....!!!");
                      print("select002+++++++++++");
                      print(select002);
                    } else if (!select003) {
                      showToastMessage("Please select KECAMATAN ....!!!");
                      print("select003+++++++++++");
                      print(select003);
                    } else if (!select004) {
                      showToastMessage("Please select KELURAHAN ....!!!");
                      print("select004+++++++++++");
                      print(select004);
                    } else if (cTpsId.value.text.isEmpty) {
                      showToastMessage("Please isi TPS-ID....!!!");
                    } else if (cAlamat.value.text.isEmpty) {
                      showToastMessage("Please isi Alamat....!!!");
                    } else if (cSuaraCaleg1.value.text.isEmpty) {
                      showToastMessage("Please isi jumlah suara CALEG....!!!");
                    } else if (panjfile != null) {
                      _upload(uploadImage!);
                    } else
                      showToastMessage("Please take a picture....!!!");
                  },
                  icon: const Icon(Icons.file_upload),
                  label: const Text("UPLOAD\n(IMAGE & DATA)"),
                ),
              ),
              //...................................................................................
            ],
          ),
        ),

        //................... floatingActionButton >>> IN SCAFFOLD() ................
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            print('Tombol Reffresh di pencettt');

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Menu00(), //What is that?
                ));
          }),
          tooltip: 'Reload data',
          child: const Icon(Icons.ac_unit),
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
        ),
        //...........................................................................
      ),
    );
  }
}

//No Build Context
//showToastMessage("Show Toast Message on Flutter");
void showToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      fontSize: 16.0);
}

//zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz

class query001 {
  var provincename;
  var provinceid;
  query001({required this.provincename, required this.provinceid});

  factory query001.fromJSON(Map<String, dynamic> datarow) {
    var provincename = datarow['province_name'];
    var provinceid = datarow['province_id'];
    print("provinceid = " + provinceid.toString());
    print("provincename = " + provincename.toString());
    return query001(provincename: provincename, provinceid: provinceid);
  }
}

class query002 {
  var regencyid;
  var regencyname;
  query002({required this.regencyid, required this.regencyname});

  factory query002.fromJSON(Map<String, dynamic> datarow) {
    var regencyid = datarow['regency_id'] as String;
    var regencyname = datarow['regency_name'] as String;
    print("regencyid = " + regencyid.toString());
    print("regencyname = " + regencyname.toString());
    return query002(regencyid: regencyid, regencyname: regencyname);
  }
}

class query003 {
  var kecamatanid;
  var kecamatanname;
  query003({required this.kecamatanid, required this.kecamatanname});

  factory query003.fromJSON(Map<String, dynamic> datarow) {
    var kecamatanid = datarow['kecamatan_id'] as String;
    var kecamatanname = datarow['kecamatan_name'] as String;
    print("kecamatanid = " + kecamatanid.toString());
    print("kecamatanname = " + kecamatanname.toString());
    return query003(kecamatanid: kecamatanid, kecamatanname: kecamatanname);
  }
}

class query004 {
  var villagesid;
  var villagesname;
  query004({required this.villagesid, required this.villagesname});

  factory query004.fromJSON(Map<String, dynamic> datarow) {
    var villagesid = datarow['villages_id'] as String;
    var villagesname = datarow['villages_name'] as String;
    print("villagesid = " + villagesid.toString());
    print("villagesname = " + villagesname.toString());
    return query004(villagesid: villagesid, villagesname: villagesname);
  }
}
