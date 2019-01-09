

import 'package:flutter/material.dart';

class BottomAppBarDemo extends StatefulWidget{

  @override
  State<StatefulWidget> createState() =>_BottomAppBarDemoState();

}

class _BottomAppBarDemoState extends State<BottomAppBarDemo>{

  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _ChoiceValue<Widget> kNoFab = _ChoiceValue<Widget>(
    title: 'None',
    label: 'do not show a floating action button',
    value: null,
  );

  static const _ChoiceValue<Widget> kCircularFab = _ChoiceValue(
    title: 'Circular',
    label: 'circular floating action button',
    value: FloatingActionButton(
      onPressed: _showSnackbar,
      child: Icon(Icons.add, semanticLabel: 'Action'),
      backgroundColor: Colors.orange,
    ),
  );

  static const _ChoiceValue<Widget> kDiamondFab = _ChoiceValue<Widget>(
    title: 'Diamond',
    label: 'diamond shape floating action button',
    value: _DiamondFab(
      onPressed: _showSnackbar,
      child: Icon(Icons.add, semanticLabel: 'Action'),
    ),
  );

  static const _ChoiceValue<bool> kShowNotchTrue = _ChoiceValue<bool>(
    title: 'On',
    label: 'show bottom appbar notch',
    value: true,
  );

  static const _ChoiceValue<bool> kShowNotchFalse = _ChoiceValue<bool>(
    title: 'Off',
    label: 'do not show bottom appbar notch',
    value: false,
  );

  // FAB Position

  static const _ChoiceValue<FloatingActionButtonLocation> kFabEndDocked = _ChoiceValue<FloatingActionButtonLocation>(
    title: 'Attached - End',
    label: 'floating action button is docked at the end of the bottom app bar',
    value: FloatingActionButtonLocation.endDocked,
  );

  static const _ChoiceValue<FloatingActionButtonLocation> kFabCenterDocked = _ChoiceValue<FloatingActionButtonLocation>(
    title: 'Attached - Center',
    label: 'floating action button is docked at the center of the bottom app bar',
    value: FloatingActionButtonLocation.centerDocked,
  );

  static const _ChoiceValue<FloatingActionButtonLocation> kFabEndFloat= _ChoiceValue<FloatingActionButtonLocation>(
    title: 'Free - End',
    label: 'floating action button floats above the end of the bottom app bar',
    value: FloatingActionButtonLocation.endFloat,
  );

  static const _ChoiceValue<FloatingActionButtonLocation> kFabCenterFloat = _ChoiceValue<FloatingActionButtonLocation>(
    title: 'Free - Center',
    label: 'floating action button is floats above the center of the bottom app bar',
    value: FloatingActionButtonLocation.centerFloat,
  );

  static void _showSnackbar() {
    const String text =
        "When the Scaffold's floating action button location changes, "
        'the floating action button animates to its new position.'
        'The BottomAppBar adapts its shape appropriately.';
    _scaffoldKey.currentState.showSnackBar(
      const SnackBar(content: Text(text)),
    );
  }

  // App bar color

  static const List<_NamedColor> kBabColors = <_NamedColor>[
    _NamedColor(null, 'Clear'),
    _NamedColor(Color(0xFFFFC100), 'Orange'),
    _NamedColor(Color(0xFF91FAFF), 'Light Blue'),
    _NamedColor(Color(0xFF00D1FF), 'Cyan'),
    _NamedColor(Color(0xFF00BCFF), 'Cerulean'),
    _NamedColor(Color(0xFF009BEE), 'Blue'),
  ];


  _ChoiceValue<Widget> _fabShape = kCircularFab;
  _ChoiceValue<bool> _showNotch = kShowNotchTrue;
  _ChoiceValue<FloatingActionButtonLocation> _fabLocation = kFabEndDocked;
  Color _babColor = kBabColors.first.color;


  void _onShowNotchChanged(_ChoiceValue<bool> value) {
    setState(() {
      _showNotch = value;
    });
  }

  void _onFabShapeChanged(_ChoiceValue<Widget> value) {
    setState(() {
      _fabShape = value;
    });
  }

  void _onFabLocationChanged(_ChoiceValue<FloatingActionButtonLocation> value) {
    setState(() {
      _fabLocation = value;
    });
  }

  void _onBabColorChanged(Color value) {
    setState(() {
      _babColor = value;
    });
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home:  Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Bottom app bar'),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.sentiment_very_satisfied, semanticLabel: 'Update shape'),
              onPressed: (){
                setState(() {
                  _fabShape = _fabShape == kCircularFab ? kDiamondFab : kCircularFab;
                });
              },
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 88.0),
          children: <Widget>[
            const _Heading('FAB Shape'),

            _RadioItem<Widget>(kCircularFab, _fabShape, _onFabShapeChanged),
            _RadioItem<Widget>(kDiamondFab, _fabShape, _onFabShapeChanged),
            _RadioItem<Widget>(kNoFab, _fabShape, _onFabShapeChanged),

            const Divider(),
            const _Heading('Notch'),

            _RadioItem<bool>(kShowNotchTrue, _showNotch, _onShowNotchChanged),
            _RadioItem<bool>(kShowNotchFalse, _showNotch, _onShowNotchChanged),

            const Divider(),
            const _Heading('FAB Position'),

            _RadioItem<FloatingActionButtonLocation>(kFabEndDocked, _fabLocation, _onFabLocationChanged),
            _RadioItem<FloatingActionButtonLocation>(kFabCenterDocked, _fabLocation, _onFabLocationChanged),
            _RadioItem<FloatingActionButtonLocation>(kFabEndFloat, _fabLocation, _onFabLocationChanged),
            _RadioItem<FloatingActionButtonLocation>(kFabCenterFloat, _fabLocation, _onFabLocationChanged),

            const Divider(),
            const _Heading('App bar color'),

            _ColorsItem(kBabColors, _babColor, _onBabColorChanged),
          ],
        ),
        floatingActionButton: _fabShape.value,
        floatingActionButtonLocation: _fabLocation.value,
        bottomNavigationBar: _DemoBottomAppBar(
            color: _babColor,
            fabLocation: _fabLocation.value,
            shape:_selectNotch()),
      ),
    ) ;
  }

  NotchedShape _selectNotch() {
    if (!_showNotch.value)
      return null;
    if (_fabShape == kCircularFab)
      return const CircularNotchedRectangle();
    if (_fabShape == kDiamondFab)
      return const _DiamondNotchedRectangle();
    return null;
  }
}

class _DiamondNotchedRectangle implements NotchedShape {
  const _DiamondNotchedRectangle();

  @override
  Path getOuterPath(Rect host, Rect guest) {
    if (!host.overlaps(guest))
      return Path()..addRect(host);
    assert(guest.width > 0.0);

    final Rect intersection = guest.intersect(host);
    // We are computing a "V" shaped notch, as in this diagram:
    //    -----\****   /-----
    //          \     /
    //           \   /
    //            \ /
    //
    //  "-" marks the top edge of the bottom app bar.
    //  "\" and "/" marks the notch outline
    //
    //  notchToCenter is the horizontal distance between the guest's center and
    //  the host's top edge where the notch starts (marked with "*").
    //  We compute notchToCenter by similar triangles:
    final double notchToCenter =
        intersection.height * (guest.height / 2.0)
            / (guest.width / 2.0);

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(guest.center.dx - notchToCenter, host.top)
      ..lineTo(guest.left + guest.width / 2.0, guest.bottom)
      ..lineTo(guest.center.dx + notchToCenter, host.top)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}

class _ChoiceValue<T>{
  const _ChoiceValue({ this.value, this.title, this.label });

  final T value;
  final String title;
  final String label; // For the Semantics widget that contains title

  @override
  String toString() => '$runtimeType("$title")';
}

class _DiamondFab extends StatelessWidget{

  const _DiamondFab({
    this.child,
    this.onPressed,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const _DiamondBorder(),
      color: Colors.orange,
      child: InkWell(/*有水波纹效果的view*/
        onTap: onPressed,
        child: Container(
          width: 56.0,
          height: 56.0,
          child: IconTheme.merge(
              data: IconThemeData(color: Theme.of(context).accentIconTheme.color),
              child: child),
        ),
      ),
      elevation: 6.0,
    );
  }
}

class _DiamondBorder extends ShapeBorder{
  const _DiamondBorder();
  // boderWidth
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only();

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  /*自定义boder 外边形状*/
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width  / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  /*自己可以绘制内容*/
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    /*自己写的 可有可无*/
    canvas.drawCircle(Offset(rect.width/2, rect.height/2),rect.width/4, Paint()..color=Colors.red);
  }

  /*没看懂怎么实现*/
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}

class _NamedColor {
  const _NamedColor(this.color, this.name);

  final Color color;
  final String name;
}

class _RadioItem<T> extends StatelessWidget{

  const _RadioItem(this.value, this.groupValue, this.onChanged);

  final _ChoiceValue<T> value;
  final _ChoiceValue<T> groupValue;
  final ValueChanged<_ChoiceValue<T>> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: 56.0,
      padding: const EdgeInsetsDirectional.only(start: 16.0),
      alignment: AlignmentDirectional.centerStart,
      child: MergeSemantics(
        child: Row(
          children: <Widget>[
            Radio<_ChoiceValue<T>>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,/*只有被选中的时候 才会 回调 判定选中的条件是 value 与 groupValue 相等*/
            ),
            Expanded(
                child: Semantics(
                  container: true,
                  button: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      onChanged(value);
                    },
                    child: Text(
                      value.title,
                      style: theme.textTheme.subhead,
                    ),
                  ),
                ))/*占据剩余所有空间的widget*/
          ],
        ),
      ),
    );
  }

}

class _Heading extends StatelessWidget{

  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      height: 48.0,
      padding: const EdgeInsetsDirectional.only(start: 56.0),
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: themeData.textTheme.body1.copyWith(
            color: themeData.primaryColor
        ),
      ),
    );
  }
}

class _ColorsItem extends StatelessWidget{

  const _ColorsItem(this.colors, this.selectedColor, this.onChanged);

  final List<_NamedColor> colors;
  final Color selectedColor;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: colors.map((_NamedColor color){

        return RawMaterialButton(
          onPressed:(){
            onChanged(color.color);
          },
          constraints:BoxConstraints.tightFor(
            width: 32.0,
            height: 32.0,
          ),
          fillColor: color.color,
          shape: CircleBorder(side: BorderSide(
            color: color.color == selectedColor ? Colors.black : const Color(0xFFD5D7DA),
            width: 2.0,
          )),
          child: Semantics(
            value: color.name,
            selected: color.color == selectedColor,
          ),
        );

      }).toList(),
    );
  }
}

class _DemoBottomAppBar extends StatelessWidget{
  const _DemoBottomAppBar({
    this.color,
    this.fabLocation,
    this.shape
  });

  final Color color;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape shape;

  static final List<FloatingActionButtonLocation> kCenterLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContents = <Widget>[
      IconButton(
          icon: const Icon(Icons.menu, semanticLabel: 'Show bottom sheet'),
          onPressed:(){
            showModalBottomSheet(context: context, builder:(BuildContext context){
              return _DemoDrawer();
            });
          }),
    ];

    if (kCenterLocations.contains(fabLocation)) {
      rowContents.add(
        const Expanded(child: SizedBox()),
      );
    }

    rowContents.addAll(<Widget> [
      IconButton(
        icon: const Icon(Icons.search, semanticLabel: 'show search action',),
        onPressed: () {
          Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text('This is a dummy search action.')),
          );
        },
      ),
      IconButton(
        icon: Icon(
          Theme.of(context).platform == TargetPlatform.iOS
              ? Icons.more_horiz
              : Icons.more_vert,
          semanticLabel: 'Show menu actions',
        ),
        onPressed: () {
          Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text('This is a dummy menu action.')),
          );
        },
      ),
    ]);

    return BottomAppBar(
      color: color,
      child: Row(children: rowContents),
      shape: shape,
    );
  }
}

class _DemoDrawer  extends StatelessWidget{
  const _DemoDrawer();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
          ),
          ListTile(
            leading: Icon(Icons.threed_rotation),
            title: Text('3D'),
          ),
        ],
      ),
    );
  }
}