import 'package:pappettante_chayakada/infrastructure/sales/sales_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class filterDate extends StatefulWidget {
  const filterDate({super.key});

  @override
  State<filterDate> createState() => _filterDateState();
}

class _filterDateState extends State<filterDate> {
  DateRange? selectedDateRange;
  String dropdownValue = 'ALL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 71, 71, 71),
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(
          'PICK DATE',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/1234.jpg",
                      ),
                      fit: BoxFit.cover,
                      opacity: .004,
                      invertColors: true)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: DefaultTabController(
                    length: 3,
                    child: TabBarView(
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "   FILTER DATE",
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              const SizedBox(height: 50),
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 234, 228, 173),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.all(8),
                                width: 250,
                                child: DateRangeField(
                                  decoration: InputDecoration(
                                    label: Text(
                                      "DATE RANGE",
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                    hintText: 'PLEASE SELECT DAYS',
                                    hintStyle: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                  onDateRangeSelected: (DateRange? value) {
                                    setState(() {
                                      selectedDateRange = value;
                                      SalesReport.filterSaleReport(
                                          range: value!);
                                    });
                                  },
                                  selectedDateRange: selectedDateRange,
                                  pickerBuilder: datePickerBuilder,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 150),
                            Text(
                              "FILTER DATE",
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: 250,
                              child: DateRangeFormField(
                                decoration: InputDecoration(
                                  label: Text(
                                    "DATE RANGE",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                  hintText: 'PLEASE SELECT DAYS',
                                  hintStyle:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                                pickerBuilder: (x, y) =>
                                    datePickerBuilder(x, y, false),
                              ),
                            )
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 50),
                              const Text("The decomposed widgets example :"),
                              const SizedBox(height: 20),
                              const Text("The date range picker widget:"),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 560,
                                child: DateRangePickerWidget(
                                  maximumDateRangeLength: 31,
                                  minimumDateRangeLength: 1,
                                  // disabledDates: [DateTime(2023, 11, 20)],
                                  initialDisplayedDate: DateTime.now(),
                                  onDateRangeChanged: print,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text("The month selector:"),
                              SizedBox(
                                width: 450,
                                child: MonthSelectorAndDoubleIndicator(
                                  currentMonth: DateTime(2023, 11, 20),
                                  onNext: () => debugPrint("Next"),
                                  onPrevious: () => debugPrint("Previous"),
                                  nextMonth: DateTime(2023, 12, 20),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text("A button to open the picker:"),
                              TextButton(
                                onPressed: () => showDateRangePickerDialog(
                                    context: context,
                                    builder: datePickerBuilder),
                                child: const Text("Open the picker"),
                              ),
                              const SizedBox(height: 20),
                              const Text("The quick dateRanges:"),
                              SizedBox(
                                width: 250,
                                height: 200,
                                child: QuickSelectorWidget(
                                    selectedDateRange: selectedDateRange,
                                    quickDateRanges: [
                                      QuickDateRange(
                                        label: 'Last 3 days',
                                        dateRange: DateRange(
                                          DateTime.now().subtract(
                                              const Duration(days: 3)),
                                          DateTime.now(),
                                        ),
                                      ),
                                      QuickDateRange(
                                        label: 'Last 7 days',
                                        dateRange: DateRange(
                                          DateTime.now().subtract(
                                              const Duration(days: 7)),
                                          DateTime.now(),
                                        ),
                                      ),
                                      QuickDateRange(
                                        label: 'Last 30 days',
                                        dateRange: DateRange(
                                          DateTime.now().subtract(
                                              const Duration(days: 30)),
                                          DateTime.now(),
                                        ),
                                      ),
                                      QuickDateRange(
                                        label: 'Last 90 days',
                                        dateRange: DateRange(
                                          DateTime.now().subtract(
                                              const Duration(days: 90)),
                                          DateTime.now(),
                                        ),
                                      ),
                                      QuickDateRange(
                                        label: 'Last 180 days',
                                        dateRange: DateRange(
                                          DateTime.now().subtract(
                                              const Duration(days: 180)),
                                          DateTime.now(),
                                        ),
                                      ),
                                    ],
                                    onDateRangeChanged: print,
                                    theme: kTheme),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .1,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        'APPLY FILTER',
                        style: GoogleFonts.poppins(),
                      )),
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget datePickerBuilder(
          BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
          [bool doubleMonth = true]) =>
      Container(
        height: MediaQuery.of(context).size.height * .5,
        child: DateRangePickerWidget(
          doubleMonth: doubleMonth,
          maximumDateRangeLength: 31,
          quickDateRanges: [
            QuickDateRange(dateRange: null, label: "Remove date range"),
            QuickDateRange(
              label: 'Last 3 days',
              dateRange: DateRange(
                DateTime.now().subtract(const Duration(days: 3)),
                DateTime.now(),
              ),
            ),
            QuickDateRange(
              label: 'Last 7 days',
              dateRange: DateRange(
                DateTime.now().subtract(const Duration(days: 7)),
                DateTime.now(),
              ),
            ),
            QuickDateRange(
              label: 'Last 30 days',
              dateRange: DateRange(
                DateTime.now().subtract(const Duration(days: 30)),
                DateTime.now(),
              ),
            ),
            QuickDateRange(
              label: 'Last 90 days',
              dateRange: DateRange(
                DateTime.now().subtract(const Duration(days: 90)),
                DateTime.now(),
              ),
            ),
            QuickDateRange(
              label: 'Last 180 days',
              dateRange: DateRange(
                DateTime.now().subtract(const Duration(days: 180)),
                DateTime.now(),
              ),
            ),
          ],
          minimumDateRangeLength: 1,
          initialDateRange: selectedDateRange,

          // disabledDates: [DateTime(2023, 11, 20)],
          initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
          onDateRangeChanged: onDateRangeChanged,
        ),
      );
}
