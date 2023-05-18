import 'package:flutter/material.dart';
import 'package:social_credit/classes.dart';
import 'firebase.dart';

Map<String, int> acts = {};
bool isEdit = false;

class ControlPanelPage extends StatefulWidget {
  const ControlPanelPage({Key? key}) : super(key: key);

  @override
  State<ControlPanelPage> createState() => _ControlPanelPageState();
}

class _ControlPanelPageState extends State<ControlPanelPage> {
  final CloudStore _cloudStore = CloudStore();

  @override
  Widget build(BuildContext context) {
    PopupMenuButton addAct(String idAccount) {
      return PopupMenuButton(
        tooltip: 'Добавить событие',
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context) {
          return acts.entries.map((MapEntry entry) {
            return PopupMenuItem(
              child: Text('${entry.key} (${entry.value})'),
              onTap: () async {
                await _cloudStore
                    .addAct(Act(dateTime: DateTime.now(), name: entry.key, score: entry.value, idAccount: idAccount));
                setState(() {});
              },
            );
          }).toList();
        },
        child: const Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('+'),
          ),
        ),
      );
    }

    PopupMenuButton editAct(Act act) {
      return PopupMenuButton(
        tooltip: '',
        padding: EdgeInsets.zero,
        enabled: isEdit,
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              child: const Text('Редактировать'),
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 100));
                if (!mounted) return;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String name = act.name;
                    int score = act.score;
                    return SimpleDialog(
                      title: const Text('Редактирование'),
                      contentPadding: const EdgeInsets.all(10),
                      children: [
                        TextFormField(
                          initialValue: name,
                          decoration: const InputDecoration(labelText: 'Название события'),
                          onChanged: (value) => name = value,
                        ),
                        TextFormField(
                          initialValue: score.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Баллы'),
                          onChanged: (value) {
                            int? scoreTEMP = int.tryParse(value);
                            if (scoreTEMP != null) {
                              score = scoreTEMP;
                            } else {
                              score = 0;
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              act.name = name;
                              act.score = score;
                              await _cloudStore.editAct(act);
                              setState(() {});
                            },
                            child: const Text('OK'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            PopupMenuItem(
              child: const Text('Удалить'),
              onTap: () async {
                await _cloudStore.removeAct(act.id);
                setState(() {});
              },
            ),
          ];
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${act.name} (${act.score})'),
          ),
        ),
      );
    }

    List<DataCell> cells(Student student) {
      final row = [
        student.name,
        student.getCredit().toString(),
        student.acts.toString(),
      ];
      List<DataCell> cells = [];
      Widget cell(int i) {
        if (i == 2) {
          return SingleChildScrollView(
            child: Wrap(
              spacing: 2,
              runSpacing: 2,
              children: <Widget>[if (isEdit) addAct(student.idAccount)] +
                  List<Widget>.generate(student.acts.length, (index) => editAct(student.acts[index])),
            ),
          );
        } else {
          return Text(row[i]);
        }
      }

      for (int i = 0; i < row.length; i++) {
        cells.add(
          DataCell(cell(i)),
        );
      }
      return cells;
    }

    DataTable table(Students students) {
      return DataTable(
        dataRowMinHeight: 70,
        dataRowMaxHeight: 70,
        border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
        columns: const [
          DataColumn(label: Text('ФИО')),
          DataColumn(label: Text('Рейтинг')),
          DataColumn(label: Text('События')),
        ],
        rows: List<DataRow>.generate(students.students.length, (index) {
          return DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                }
                if (index.isEven) {
                  return Colors.grey.withOpacity(0.1);
                }
                return null; // Use default value for other states and odd rows.
              },
            ),
            cells: cells(students.students[index]),
          );
        }),
      );
    }

    getTable() async {
      acts = await _cloudStore.getTable();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Обновить'),
                  ),
                ),
                Switch(
                  value: isEdit,
                  onChanged: (bool value) => setState(() {
                    isEdit = value;
                  }),
                ),
                const Text('Редактирование'),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                key: const PageStorageKey('Students'),
                child: FutureBuilder(
                  future: _cloudStore.getSocialCreditAll(),
                  builder: (context, snapshot) {
                    getTable();
                    if (snapshot.hasData) {
                      return table(snapshot.data as Students);
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Ошибка'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
