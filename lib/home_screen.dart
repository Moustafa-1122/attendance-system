import 'dart:html';

import 'package:finalproject/db_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
class _HomeScreenState extends State<HomeScreen>{
  List<Map<String,dynamic>> _allData =[];
  bool _isLoading = true;

  void _refreshData() async{
    final data = await SQLHelper.getData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }
  @override
  void initState(){
    super.initState();
    _refreshData();

  }


  Future<void> _addData() async{
    await SQLHelper.creatData(_titleController.text,_descController.text );
    _refreshData();
  }

  Future<void> _updateData(int id) async{
    await SQLHelper.creatData(id,_titleController.text,_descController.text );
    _refreshData();
  }
  void _deleteData(int id) async{
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context)
    .showSnackBar(const SnackBar (
      backgroundColor: Colors.red,
        content: Text("Data Deleted")));
    _refreshData();
  }

  @override
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void showBottomsheet(int? id) async{
    if (id !=null){
      final existingData =
          _allData.firstWhere((element) => element['id']==id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];

    }
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom+50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder()
                hintText:"Title",
              ),
            ),
            SizedBox(height: 10),
      TextField(
        controller: _descController,
        maxLines: 4,
        decoration:  InputDecoration(
          border: OutlineInputBorder(
            hintText:"Description",
          ),
        ),

      ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async{
                  if(id==null){
                    await _addData();
                  }

                  _titleController.text ="";
                  _descController.text ="";
                  Navigator.of(context).pop();
                  print("Data added");
                }, child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(id==null ? "Add Data" : "Update",
                style: TextStyle(
                    fontSize: 18,
                  fontWeight: FontWeight.w500,
                )
                ),
              ),
                
              ),
            )
  ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
  backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text("CRUS OPERATION"),
      ),
      body: _isLoading
      ? Center(
        child: CircularProgressIndicator(),
    )
          : ListView.builder(itemBuilder:(context,index)=>Card(
        margin: EdgeInsets.all(15),
        child: ListTile(
          title: Padding(padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              _allData[index]['title'],
              style: TextStyle(
                fontSize: 20,
              ),
            ),

          ),
        ),
      ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> showBottomSheet(null, context: null, builder: (BuildContext context) {  }),
        child: Icon(Icons.add),
      ),
    );
  }
}
