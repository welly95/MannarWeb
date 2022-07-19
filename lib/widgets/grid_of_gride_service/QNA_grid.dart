import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/qna/qna_cubit.dart';
import '../../constants/size_config.dart';
import '../../constants/styles.dart';
import 'package:flutter/material.dart';
import '../../models/qna.dart';

class QNAGrid extends StatefulWidget {
  @override
  State<QNAGrid> createState() => _QNAGridState();
}

class _QNAGridState extends State<QNAGrid> {
  List<QNA> listItem = [];

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      listItem = await BlocProvider.of<QnaCubit>(context).getQNA();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<QnaCubit, QnaState>(
      builder: (context, state) {
        if (state is GetQNAState) {
          return ListView.builder(
              itemCount: listItem.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        // height: SizeConfig.screenHeight * 0.2,
                        width: SizeConfig.screenWidth * 0.85,
                        // constraints: BoxConstraints(maxHeight: SizeConfig.screenHeight * 0.25),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                listItem[index].question!,
                                textAlign: TextAlign.right,
                                style: TextStyles.h3,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                listItem[index].answer!,
                                style: TextStyles.h3.copyWith(color: Colors.grey),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                  ],
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
