
import 'package:flutter/material.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';


class CustomDropdownWithTitle extends StatefulWidget {
  final String title;
  final String? hint;
  final List<String> items;
  final bool isExpanded;
  final Function(int) onSelectItem;
  final VoidCallback onTapExpand;
  final Color? titleColor;
  final TextEditingController? controller;
  final bool? isClearable;
  const CustomDropdownWithTitle({
    super.key,
    required this.isExpanded,
    required this.onSelectItem,
    required this.title,
    required this.onTapExpand,
    required this.items,
    this.hint,
    this.titleColor,
    this.controller,
    this.isClearable = false,
  });

  @override
  State<CustomDropdownWithTitle> createState() =>
      _CustomDropdownWithTitleState();
}

class _CustomDropdownWithTitleState extends State<CustomDropdownWithTitle> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.controller != null ? widget.controller!.text : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(widget.title, style: TextStyle(
          fontSize: size.height*0.02,
          color: Constants.mainColor,
        ),),

        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.black26,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeaderTextField(  size: size,),
              if (widget.isExpanded)
                Container(

                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: widget.items.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => _buildSubListItem(
                      size: size,
                      title: widget.items[index],
                      onTap: () {
                        widget.onSelectItem(index);
                        widget.isClearable!
                            ? widget.controller!.text = widget.items[index]
                            : 
                            controller.text = widget.items[index];
                      },
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  StatelessWidget _buildSubListItem(
      {required String title, required VoidCallback onTap ,required Size size}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height*0.07,
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(title,),
      ),
    );
  }

  Widget _buildHeaderTextField({required Size size}) {
    return SizedBox(
      height: size.height*0.06,
      child: GestureDetector(
        onTap: widget.onTapExpand,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller:
                    widget.isClearable! ? widget.controller : controller,
                enabled: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: widget.hint ?? widget.title,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
            Container(
              width: 60,
              height: double.infinity,
              color: Colors.transparent,
              child: Icon(
                widget.isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
