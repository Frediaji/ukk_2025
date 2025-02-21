import 'package:flutter/material.dart';
import 'package:fredi_kasirukk/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Pastikan file main.dart Anda sudah sesuai

// Halaman utama (HomePage) yang mengatur navigasi
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> produk = [];
  List<Map<String, dynamic>> pelanggan = [];
  List<Map<String, dynamic>> penjualan = [];
  List<Map<String, dynamic>> riwayat = [];
  var myTab;

  void fetchProduk() async {
    var result = await Supabase.instance.client
        .from("Produk")
        .select()
        .order("ProdukID", ascending: true);
    setState(() {
      produk = result;
    });
  }

  void fetchPelanggan() async {
    var result = await Supabase.instance.client
        .from("Pelanggan")
        .select()
        .order("PelangganID", ascending: true);
    setState(() {
      pelanggan = result;
    });
  }

  void editProduk(Map produk) {
    final namaCtrl = TextEditingController(text: produk["NamaProduk"]);
    final alamatCtrl = TextEditingController(text: produk["Harga"].toString());
    final noTelpCtrl = TextEditingController(text: produk["Stok"].toString());
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: namaCtrl,
                decoration: InputDecoration(labelText: "Nama Produk"),
              ),
              TextField(
                controller: alamatCtrl,
                decoration: InputDecoration(labelText: "Harga"),
              ),
              TextField(
                controller: noTelpCtrl,
                decoration: InputDecoration(labelText: "Stok"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await Supabase.instance.client.from("Produk").update({
                      "NamaProduk": namaCtrl.text,
                      "Harga": alamatCtrl.text,
                      "Stok": noTelpCtrl.text
                    }).eq("ProdukID", produk["ProdukID"]);
                    fetchProduk();
                    Navigator.of(context).pop();
                  },
                  child: Text("Simpan"))
            ]),
          );
        });
  }

  void editPelanggan(Map produk) {
    final namaCtrl = TextEditingController(text: produk["NamaPelanggan"]);
    final alamatCtrl = TextEditingController(text: produk["Alamat"]);
    final noTelpCtrl = TextEditingController(text: produk["NoTelp"]);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: namaCtrl,
                decoration: InputDecoration(labelText: "Nama Pelanggan"),
              ),
              TextField(
                controller: alamatCtrl,
                decoration: InputDecoration(labelText: "Alamat"),
              ),
              TextField(
                controller: noTelpCtrl,
                decoration: InputDecoration(labelText: "Nomor telepon"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await Supabase.instance.client.from("Pelanggan").update({
                      "NamaPelanggan": namaCtrl.text,
                      "Alamat": alamatCtrl.text,
                      "NoTelp": noTelpCtrl.text
                    }).eq("PelangganID", produk["PelangganID"]);
                    fetchPelanggan();
                    Navigator.of(context).pop();
                  },
                  child: Text("Simpan"))
            ]),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTab = TabController(length: 4, vsync: this);
    fetchProduk();
    fetchPelanggan();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login UI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            //bacgrondcolor layar home
            // backgroundColor: Colors.orangeAccent,
            appBar: AppBar(
              title: const Text('Selamat Datang Di Toko Gitar '),
              centerTitle: true,
              bottom: TabBar(controller: myTab, tabs: [
                Text("Produk"),
                Text("Pelanggan"),
                Text("Penjualan"),
                Text("Riwayat"),
              ]),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TabBarView(controller: myTab, children: [
                  Scaffold(
                    body: ListView(
                      children: [
                        ...List.generate(produk.length, (index) {
                          Map myproduk = produk[index];
                          return ListTile(
                            title: Text(myproduk["NamaProduk"]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Stok: ${myproduk["Stok"]}"),
                                Text("Harga:Rp.${myproduk["Harga"]}"),
                              ],
                            ),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                  onPressed: () {
                                    editProduk(produk[index]);
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    await Supabase.instance.client
                                        .from("Produk")
                                        .delete()
                                        .eq("ProdukID", myproduk["ProdukID"]);
                                    fetchProduk();
                                  },
                                  icon: Icon(Icons.delete)),
                            ]),
                          );
                        }),
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        final namaCtrl = TextEditingController();
                        final alamatCtrl = TextEditingController();
                        final noTelpCtrl = TextEditingController();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: namaCtrl,
                                        decoration: InputDecoration(
                                            labelText: "Nama Produk"),
                                      ),
                                      TextField(
                                        controller: alamatCtrl,
                                        decoration:
                                            InputDecoration(labelText: "Harga"),
                                      ),
                                      TextField(
                                        controller: noTelpCtrl,
                                        decoration:
                                            InputDecoration(labelText: "Stok"),
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await Supabase.instance.client
                                                .from("Produk")
                                                .insert([
                                              {
                                                "NamaProduk": namaCtrl.text,
                                                "Harga": alamatCtrl.text,
                                                "Stok": noTelpCtrl.text
                                              }
                                            ]);
                                            fetchProduk();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Simpan"))
                                    ]),
                              );
                            });
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                  Scaffold(
                    body: ListView(
                      children: [
                        ...List.generate(pelanggan.length, (index) {
                          Map myproduk = pelanggan[index];
                          return ListTile(
                            title: Text(myproduk["NamaPelanggan"]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat:${myproduk["Alamat"]}"),
                                Text("NoTelp:${myproduk["NoTelp"]}"),
                              ],
                            ),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                  onPressed: () {
                                    editPelanggan(pelanggan[index]);
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    await Supabase.instance.client
                                        .from("Pelanggan")
                                        .delete()
                                        .eq("PelangganID",
                                            myproduk["PelangganID"]);
                                            fetchPelanggan();
                                  },
                                  icon: Icon(Icons.delete)),

                            ]),
                          );
                        }),
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        final namaCtrl = TextEditingController();
                        final alamatCtrl = TextEditingController();
                        final noTelpCtrl = TextEditingController();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: namaCtrl,
                                        decoration: InputDecoration(
                                            labelText: "Nama Pelanggan"),
                                      ),
                                      TextField(
                                        controller: alamatCtrl,
                                        decoration: InputDecoration(
                                            labelText: "Alamat"),
                                      ),
                                      TextField(
                                        controller: noTelpCtrl,
                                        decoration: InputDecoration(
                                            labelText: "Nomor telepon"),
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await Supabase.instance.client
                                                .from("Pelanggan")
                                                .insert([
                                              {
                                                "NamaPelanggan": namaCtrl.text,
                                                "Alamat": alamatCtrl.text,
                                                "NoTelp": noTelpCtrl.text
                                              }
                                            ]);
                                            fetchPelanggan();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Simpan"))
                                    ]),
                              );
                            });
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                  ListView(
                    children: [
                      ...List.generate(produk.length, (index) {
                        Map myproduk = produk[index];
                        return ListTile(
                          title: Text(myproduk["NamaProduk"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Stok: ${myproduk["Stok"]}"),
                              Text("Harga:Rp.${myproduk["Harga"]}"),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  ListView(
                    children: [
                      ...List.generate(produk.length, (index) {
                        Map myproduk = produk[index];
                        return ListTile(
                          title: Text(myproduk["NamaProduk"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Stok: ${myproduk["Stok"]}"),
                              Text("Harga:Rp.${myproduk["Harga"]}"),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ]))));
  }
}

// Layar Home dengan tombol navigasi ke pendataan barang dan logout
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

// Layar logout dengan konfirmasi
class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bacground layar logout
      backgroundColor: Colors.cyanAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Logout',
                        style: TextStyle(color: Colors.white)),
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

// Layar pendataan barang (InventoryScreen)
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Item> _items = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _addItem() {
    final String name = _nameController.text;
    final int? quantity = int.tryParse(_quantityController.text);
    final double? price = double.tryParse(_priceController.text);
    if (name.isNotEmpty && quantity != null && price != null) {
      setState(() {
        _items.add(Item(name: name, quantity: quantity, price: price));
      });
      _nameController.clear();
      _quantityController.clear();
      _priceController.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jenis Gitar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form input data barang
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Gitar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Gitar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga Gitar',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            // Tombol untuk menambahkan barang
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Masukkan di keranjang',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            // Daftar barang yang telah ditambahkan
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Belum ada data barang'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Card(
                          child: ListTile(
                            title: Text(item.name),
                            subtitle: Text(
                                'Jumlah: ${item.quantity}, Harga: ${item.price}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Kelas model untuk data barang
class Item {
  final String name;
  final int quantity;
  final double price;

  Item({required this.name, required this.quantity, required this.price});
}
