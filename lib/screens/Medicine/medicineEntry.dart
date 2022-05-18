import 'package:flutter/material.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/stuff.dart';


class NewMedicine extends StatefulWidget {
  const NewMedicine({Key? key}) : super(key: key);

  @override
  State<NewMedicine> createState() => _NewMedicineState();
}

class _NewMedicineState extends State<NewMedicine> {
  final GlobalKey<FormState> _newMedicineKey = GlobalKey<FormState>();
  final TextEditingController _medName = TextEditingController();
  final TextEditingController _medEName = TextEditingController();
  final TextEditingController _medFormula = TextEditingController();
  final TextEditingController _medInfo = TextEditingController();
  final TextEditingController _medSideEffect = TextEditingController();
  bool otc = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(
          maxWidth: 800,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InputSingleText(
                    controller: _medName,
                    isMandatory: true,
                    labelText: "اسم دری",
                    hintText: "پرستامول",
                    maxLength: 30,
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: InputSingleText(
                    controller: _medName,
                    isMandatory: true,
                    labelText: "اسم انگلیسی",
                    hintText: "Paracetamol",
                    maxLength: 30,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InputSingleText(
                    controller: _medFormula,
                    labelText: "فورمل کیمیاوی",
                    hintText: "C8 H9 NO2",
                    maxLength: 100,
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: Row(
                    children: [
                      const Text("نیاز به نسخه"),
                      Checkbox(
                        value: otc,
                        onChanged: (value){
                          setState(() => otc = !otc);
                        },
                        checkColor: Colors.white,
                        activeColor: Env.appColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 120,
              child: InputText(
                controller: _medInfo,
                isMandatory: true,
                maxLine: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
