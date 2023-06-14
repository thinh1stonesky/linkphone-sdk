

import 'package:flutter/material.dart';
import 'package:linphone_sdk/providers/features_provider.dart';
import 'package:provider/provider.dart';

class ListContactsMeet extends StatefulWidget {
  const ListContactsMeet({Key? key}) : super(key: key);

  @override
  State<ListContactsMeet> createState() => _ListContactsMeet();
}

class _ListContactsMeet extends State<ListContactsMeet> {
  @override
  Widget build(BuildContext context) {
    FeaturesProvider featuresProvider = Provider.of(context, listen: true);
    return ListView.builder(
      itemCount: featuresProvider.contacts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(featuresProvider.contacts[index]),
        );
      },
    );
  }
}

