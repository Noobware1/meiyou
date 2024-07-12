import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/folder_provider/storage_folder_provider.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data and Storage'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Storage Location'),
            subtitle:  Text(StorageFolderProvider().pathSync()),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Clear all data'),
            subtitle: const Text('Clear all data and reset the app'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
