import 'package:flutter/material.dart';

class AddLeadCategoryDialog extends StatefulWidget {
  final Function(String leadName, String cost, String? subcategory) onSubmit;

  const AddLeadCategoryDialog({super.key, required this.onSubmit});

  @override
  State<AddLeadCategoryDialog> createState() => _AddLeadCategoryDialogState();
}

class _AddLeadCategoryDialogState extends State<AddLeadCategoryDialog> {
  final _leadController = TextEditingController();
  final _costController = TextEditingController();
  final _subController = TextEditingController();
  bool _addSub = false;

  OutlineInputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add Stream',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _leadController,
                decoration: InputDecoration(
                  labelText: "Stream",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: _border(),
                  focusedBorder: _border(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Cost",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: _border(),
                  focusedBorder: _border(),
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Add Subcategory"),
                value: _addSub,
                onChanged: (val) => setState(() => _addSub = val ?? false),
              ),
              if (_addSub)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: _subController,
                    decoration: InputDecoration(
                      labelText: "Subcategory",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: _border(),
                      focusedBorder: _border(),
                    ),
                  ),
                ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                    child: const Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A5AC7),
                      foregroundColor: const Color.fromARGB(255, 255, 252, 252),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      final lead = _leadController.text.trim();
                      final cost = _costController.text.trim();
                      final sub = _addSub ? _subController.text.trim() : null;
                      if (lead.isNotEmpty ) {
                        widget.onSubmit(lead, cost, sub);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Lead and cost are required")),
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
