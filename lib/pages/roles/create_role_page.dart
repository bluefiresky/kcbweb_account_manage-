
import 'package:flutter/material.dart';

class CreateRolePage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  CreateRolePage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreateRolePageState();
}

class CreateRolePageState extends State<CreateRolePage> {

  @override
  void initState() {
    super.initState();
    this._fetching();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: this._renderSubView());
  }

  /// SubView
  Widget _renderSubView(){
    return Center(child: Text('CreateRolePage -- id -->> ${widget.propsParams['id']}'));
  }

  /// Api
  void _fetching() {
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}