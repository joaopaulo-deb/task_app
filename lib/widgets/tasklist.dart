import 'package:flutter/material.dart';
import 'package:taskapp/plugins/path_provider.dart';

class TaskList extends StatefulWidget {
  List _myList;

  TaskList(this._myList);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Map<String, dynamic> _lastRemoved;
  int _lastPosRemoved;

  @override
  Widget build(BuildContext context) {
    var _myList = widget._myList;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            _myList.sort((a,b){
              if (a["done"] && !b["done"]) return 1;
              else if(!a["done"] && b["done"]) return -1;
              else return 0;
            });
            PathProvider.saveData(_myList);
          });
        },
        child: ListView.builder(
          itemCount: _myList.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment(-0.9, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              direction: DismissDirection.startToEnd,
              child: SwitchListTile(
                title: Text(_myList[index]["title"]),
                value: _myList[index]["done"],
                activeColor: Colors.red,
                secondary: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  child:
                      Icon(_myList[index]["done"] ? Icons.check : Icons.close),
                ),
                onChanged: (c) {
                  setState(() {
                    _myList[index]["done"] = c;
                    PathProvider.saveData(_myList);
                  });
                },
              ),
              onDismissed: (direction) {
                setState(() {
                  _lastRemoved = Map.from(widget._myList[index]);
                  _lastPosRemoved = index;
                  widget._myList.removeAt(index);

                  PathProvider.saveData(_myList);
                  final snack = SnackBar(
                    content: Text("Task ${_lastRemoved["title"]} removed!"),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        setState(() {
                          widget._myList.insert(_lastPosRemoved, _lastRemoved);
                          PathProvider.saveData(_myList);
                        });
                      },
                    ),
                    duration: Duration(seconds: 3),
                  );
                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(snack);
                });
              },
            );
          },
        ),
      ),
    );
  }
}
