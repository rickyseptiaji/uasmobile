import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Map<String, String>> data = [];

  void addData(String nama, String alamat, String umur) {
    setState(() {
      data.add({'nama': nama, 'alamat': alamat, 'umur': umur});
    });
  }

  void updateData(int index, String nama, String alamat, String umur) {
    setState(() {
      data[index] = {'nama': nama, 'alamat': alamat, 'umur': umur};
    });
  }

  void deleteData(int index) {
    setState(() {
      data.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIST DATA'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddData(onSubmit: addData),
              ),
            ),
            child: Icon(Icons.add, size: 30),
          )
        ],
      ),
      body: ListData(
        data: data,
        onDelete: deleteData,
        onEdit: (index) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddData(
                onSubmit: (nama, alamat, umur) {
                  updateData(index, nama, alamat, umur);
                },
                initialData: data[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListData extends StatelessWidget {
  final List<Map<String, String>> data;
  final Function(int) onDelete;
  final Function(int) onEdit;

  const ListData({
    super.key,
    required this.data,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: ${data[index]['nama']}'),
                  Text('Alamat: ${data[index]['alamat']}'),
                  Text('Umur: ${data[index]['umur']} Tahun')
                ]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      onEdit(index);
                    }),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => onDelete(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddData extends StatefulWidget {
  final Function(String, String, String) onSubmit;
  final Map<String, String>? initialData;

  const AddData({required this.onSubmit, this.initialData});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController umurController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      namaController.text = widget.initialData!['nama']!;
      alamatController.text = widget.initialData!['alamat']!;
      umurController.text = widget.initialData!['umur']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.initialData == null ? 'TAMBAHKAN DATA' : 'EDIT DATA',
                style: TextStyle(fontSize: 30),
              ),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'NAMA'),
              ),
              TextFormField(
                controller: alamatController,
                decoration: InputDecoration(labelText: 'ALAMAT'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: umurController,
                decoration: InputDecoration(labelText: 'UMUR'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.onSubmit(
                    namaController.text,
                    alamatController.text,
                    umurController.text,
                  );
                  Navigator.pop(context);
                },
                child: Text(widget.initialData == null
                    ? 'Tambahkan Data'
                    : 'Update Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
