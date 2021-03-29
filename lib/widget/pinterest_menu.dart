import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinteresMenuWidget extends StatefulWidget {
  final List<PinterestButton> listaItems;

  const PinteresMenuWidget({@required this.listaItems});
  @override
  _PinteresMenuWidgetState createState() => _PinteresMenuWidgetState();
}

class _PinteresMenuWidgetState extends State<PinteresMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _PinterestMenuProvider(),
      child: Builder(builder: (context) {
        return Card(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white70,
          child: _MenuItems(listaItems: widget.listaItems),
        );
      }),
    );
  }
}

class _MenuItems extends StatelessWidget {
  const _MenuItems({@required this.listaItems});

  final List<PinterestButton> listaItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        listaItems.length,
        (index) => _ItemMenu(index: index, item: listaItems[index]),
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  const _ItemMenu({
    @required this.item,
    this.index,
  });

  final PinterestButton item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final _PinterestMenuProvider provider =
        Provider.of<_PinterestMenuProvider>(context);
    return IconButton(
      splashRadius: 20.0,
      icon: Icon(item.icon,
          color: provider.indiceSeleccionado == index
              ? provider.colorSeleccion
              : provider.colorSegundario,
          size: provider.indiceSeleccionado == index
              ? provider.sizeButtonSeleccion
              : provider.sizeButton),
      onPressed: () {
        provider.indiceSeleccionado = index;
        item.onPressed();
      },
    );
  }
}

class PinterestButton {
  final Function onPressed;
  final IconData icon;
  PinterestButton({@required this.onPressed, @required this.icon});
}

class _PinterestMenuProvider with ChangeNotifier {
  int _indiceSeleccionado = 0;
  Color _colorSeleccion = Colors.pinkAccent;
  Color _colorSegundario = Colors.blueGrey;
  double _sizeButtonSeleccion = 30.0;
  double _sizeButton = 25.0;

  int get indiceSeleccionado => this._indiceSeleccionado;

  set indiceSeleccionado(int indice) {
    this._indiceSeleccionado = indice;
    notifyListeners();
  }

  Color get colorSeleccion => this._colorSeleccion;

  set colorSeleccion(Color color) {
    this._colorSeleccion = color;
  }

  Color get colorSegundario => this._colorSegundario;

  set colorSegundario(Color color) {
    this._colorSegundario = color;
  }

  double get sizeButtonSeleccion => this._sizeButtonSeleccion;

  set sizeButtonSeleccion(double size) {
    this._sizeButtonSeleccion = size;
  }

  double get sizeButton => this._sizeButton;

  set sizeButton(double size) {
    this._sizeButton = size;
  }
}
