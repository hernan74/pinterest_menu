import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_menu/widget/pinterest_menu.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _MenuProvider(),
      child: Scaffold(
        body: _PinterestPage(
          lista: List.generate(200, (index) => index),
        ),
        floatingActionButton: _AnimarVisualizacionMenu(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class _AnimarVisualizacionMenu extends StatefulWidget {
  @override
  __AnimarVisualizacionMenuState createState() =>
      __AnimarVisualizacionMenuState();
}

class __AnimarVisualizacionMenuState extends State<_AnimarVisualizacionMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _ocultar;
  Animation<double> _mostrar;
  Animation<double> _mostrarOpacidad;
  Animation<double> _ocultarOpacidad;

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));
    _ocultar = Tween(begin: 0.0, end: 200.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.3, 1.0, curve: Curves.linear)));
    _mostrar = Tween(begin: 200.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 1.0, curve: Curves.linear)));

    _mostrarOpacidad = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 1.0, curve: Curves.linear)));
    _ocultarOpacidad = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 1.0, curve: Curves.linear)));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool valorAnterior = false;
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        final provider = Provider.of<_MenuProvider>(context);

        if ((valorAnterior != provider.mostrarMenu)) {
          valorAnterior = provider.mostrarMenu;
          _controller.forward(from: 0.0);
        }

        return Opacity(
          opacity: provider.mostrarMenu
              ? _mostrarOpacidad.value
              : _ocultarOpacidad.value,
          child: Transform.translate(
            offset: Offset(
                0.0, provider.mostrarMenu ? _mostrar.value : _ocultar.value),
            child: PinteresMenuWidget(
              listaItems: [
                PinterestButton(icon: Icons.pie_chart, onPressed: () {}),
                PinterestButton(icon: Icons.search, onPressed: () {}),
                PinterestButton(icon: Icons.notifications, onPressed: () {}),
                PinterestButton(
                    icon: Icons.supervised_user_circle, onPressed: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PinterestPage extends StatefulWidget {
  final List<int> lista;

  const _PinterestPage({@required this.lista});
  @override
  __PinterestPageState createState() => __PinterestPageState();
}

class __PinterestPageState extends State<_PinterestPage> {
  ScrollController controller = new ScrollController();
  double scrolAnterior = 0.0;
  @override
  void initState() {
    final provider = Provider.of<_MenuProvider>(context, listen: false);
    controller.addListener(() {
      provider.mostrarMenu = !(controller.offset > scrolAnterior);
      scrolAnterior = controller.offset;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StaggeredGridView.countBuilder(
      controller: controller,
      crossAxisCount: 4,
      itemCount: widget.lista.length,
      itemBuilder: (BuildContext context, int index) => _ItemPinterestPage(
        index: index,
      ),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}

class _ItemPinterestPage extends StatelessWidget {
  final int index;

  const _ItemPinterestPage({this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 5.0,
      color: Colors.deepPurpleAccent,
      child: new Container(
          child: new Center(
        child: new CircleAvatar(
          backgroundColor: Colors.white,
          child: new Text('$index'),
        ),
      )),
    );
  }
}

class _MenuProvider with ChangeNotifier {
  bool _mostrarMenu = true;

  bool get mostrarMenu => this._mostrarMenu;

  set mostrarMenu(bool mostrar) {
    this._mostrarMenu = mostrar;
    notifyListeners();
  }
}
