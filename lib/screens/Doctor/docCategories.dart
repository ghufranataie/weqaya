// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/components/mainDrawer.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/screens/Doctor/doctors.dart';

class DoctorCategory extends StatelessWidget {
  const DoctorCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(pageName: "کتگوری داکتر"),
      ),
      endDrawer: const MainDrawer(),
      body: ScreenLayout(
        mobile: Container(
          padding: const EdgeInsets.all(20),
          child: _docCategories(),
        ),
        tablet: Container(
          padding: const EdgeInsets.all(40),
            child: _docCategories()),
        web: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width-200,
            child: _docCategories(),
          ),
        ),
      ),
    );
  }

  Widget _docCategories(){
    List<ListDoctorCategories> ls = [];
    ls.add(ListDoctorCategories("داخله عمومی", "general.png"));
    ls.add(ListDoctorCategories("دندان", "tooth.png"));
    ls.add(ListDoctorCategories("نسایی ولادی", "fetalMedicine.png"));
    ls.add(ListDoctorCategories("داخله اطفال", "childCure.png"));
    ls.add(ListDoctorCategories("چشم", "eye.png"));
    ls.add(ListDoctorCategories("ارتوپیدی", "orthopedics.png"));
    ls.add(ListDoctorCategories("جلدی", "beauty.png"));
    ls.add(ListDoctorCategories("امراض قلبی", "heart.png"));
    ls.add(ListDoctorCategories("عقلی و عصبی", "head.png"));
    ls.add(ListDoctorCategories("جراحی عمومی", "surgery.png"));
    ls.add(ListDoctorCategories("گوش و گلو", "ent.png"));
    ls.add(ListDoctorCategories("حساسیت", "allergy.png"));
    ls.add(ListDoctorCategories("رادیولوژی", "radiology.png"));
    ls.add(ListDoctorCategories("التراسوند", "ultrasound.png"));
    ls.add(ListDoctorCategories("فزیوتراپی", "physiotherapy.png"));
    ls.add(ListDoctorCategories("سرطانی", "cancer.png"));
    ls.add(ListDoctorCategories("لیبرانت", "labdoc.png"));
    ls.add(ListDoctorCategories("نرس", "nurse.png"));
    ls.add(ListDoctorCategories("داروساز", "pharmacist.png"));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: ls.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160, mainAxisExtent: 170),
        itemBuilder: (context, index) {
          return GestureDetector(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Env.appColorLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/" + ls[index].docCatIcon.toString(),
                        width: 80,
                      ),
                      Text(
                        ls[index].docField.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () => Env.goto(context, Doctors(docField: ls[index].docField))
          );
        },
      ),
    );
  }
}

class ListDoctorCategories {
  final String? docField;
  final String? docCatIcon;
  ListDoctorCategories(this.docField, this.docCatIcon);
}
