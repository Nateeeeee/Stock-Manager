// Exemplo de Scaffold com Drawer para navegação
import 'package:flutter/material.dart';
import 'templates_page.dart';
import 'contagenssalvas_page.dart';
import 'cadastrartemplate_page.dart';

class HomeMenuPage extends StatefulWidget {
  const HomeMenuPage({super.key});

  @override
  State<HomeMenuPage> createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TemplatesPage(),
    ContagensSalvasPage(),
    CadastrarTemplatePage(),
  ];

  final List<String> _titles = [
    'Templates',
    'Contagens Salvas',
    'Cadastrar Template',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              decoration: BoxDecoration(color: Colors.teal),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Templates'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save),
              title: Text('Contagens Salvas'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Cadastrar Template'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
