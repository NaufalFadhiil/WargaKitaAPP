import 'package:flutter/material.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';

typedef DeleteAction = Future<void> Function();

void showDeleteConfirmationDialog(
    BuildContext context, String itemName, DeleteAction deleteAction) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Konfirmasi Hapus",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Apakah Anda yakin ingin menghapus '$itemName' ini? Tindakan ini tidak dapat dibatalkan."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Batal",
              style: TextStyle(color: WargaKitaColors.primary.color),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await deleteAction();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$itemName berhasil dihapus!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus $itemName: ${e.toString()}'),
                      backgroundColor: WargaKitaColors.secondary.color,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WargaKitaColors.secondary.color,
              foregroundColor: WargaKitaColors.white.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Hapus"),
          ),
        ],
      );
    },
  );
}