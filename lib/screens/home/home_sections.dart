import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'home_section.dart';

/// Add a dashboard block by adding one entry here.
final homeSections = <HomeSection>[
  HomeSection(
    title: 'Overview',
    builder: (context) => const ShadCard(
      title: Text('Nothing here yet'),
      description: Text('Your devices and readings will show up here.'),
    ),
  ),
];
