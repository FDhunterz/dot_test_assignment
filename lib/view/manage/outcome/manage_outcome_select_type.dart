import 'package:dot_test/controllers/manage_outcome/manage_outcome_controller.dart';
import 'package:dot_test/material/button/button.dart';
import 'package:dot_test/material/popup/bottom.dart';
import 'package:flutter/material.dart';

class ManageOutcomeSelectType extends StatelessWidget {
  final ScrollController scrollController;
  const ManageOutcomeSelectType({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final controller = ManageOutcomeController.state;
    return bottom(
      context: context,
      scrollController: scrollController,
      headerAnimation: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text('Pilih Kategori', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                ),
                NoSplashButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: controller.listType.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = controller.listType[index];
                  return NoSplashButton(
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: item.data?.colorhex, shape: BoxShape.circle),
                          child: Center(
                            child: ImageIcon(AssetImage(item.data?.assetIcon ?? ''), color: Colors.white, size: 16),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item.data?.name ?? '',
                          style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
