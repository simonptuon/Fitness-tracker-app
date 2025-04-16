//ValueNotifier - holds the data
//ValueListenableBuilder - Listen to the date (Doesn't need the setState)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<List<Map<String, dynamic>>> historyNotifier = ValueNotifier([]);
