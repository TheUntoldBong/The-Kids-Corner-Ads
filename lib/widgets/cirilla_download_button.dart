import 'dart:io';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/download/download.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:path_provider/path_provider.dart';

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;

  double get progress;

  void startDownload(Download download);

  void stopDownload();

  void openDownload();
}

class HandleDownloadController extends DownloadController with ChangeNotifier {
  HandleDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required VoidCallback onOpenDownload,
    required VoidCallback onCallbackDownload,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _onOpenDownload = onOpenDownload,
        _onCallbackDownload = onCallbackDownload;

  DownloadStatus _downloadStatus;

  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;

  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;

  final VoidCallback _onCallbackDownload;

  bool _isDownloading = false;

  @override
  void startDownload(Download download) {
    if (downloadStatus == DownloadStatus.notDownloaded || downloadStatus == DownloadStatus.downloaded) {
      _progress = 0.0;
      _handleDownload(download);
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<void> _handleDownload(Download download) async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloading phase.
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();

    Dio dio = Dio();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    List<String> arrFile = download.file?.file?.split('.') ?? [];
    String extensionFile = arrFile.isNotEmpty ? arrFile[arrFile.length - 1] : 'jpg';

    await dio.download(download.url ?? '', '$appDocPath/${download.file?.name ?? 'new'}.$extensionFile',
        onReceiveProgress: (rec, total) {
      avoidPrint(rec / total);
      _progress = rec / total;
      notifyListeners();
    });

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloaded state, completing the simulation.
    _downloadStatus = DownloadStatus.downloaded;
    _isDownloading = false;
    notifyListeners();
    _onCallbackDownload();
  }
}

class CirillaDownloadButton extends StatelessWidget {
  final DownloadStatus status;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;

  const CirillaDownloadButton({
    Key? key,
    required this.status,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
  }) : super(key: key);

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
      case DownloadStatus.downloaded:
        onDownload();
        break;
      case DownloadStatus.downloading:
        onCancel();
        break;
      case DownloadStatus.fetchingDownload:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    IconData icon = FeatherIcons.download;

    if (status == DownloadStatus.downloading) {
      icon = FontAwesomeIcons.square;
    }

    return Column(
      children: [
        InkResponse(
          onTap: () => _onPressed(),
          radius: 25,
          child: Icon(
            icon,
            size: 20,
            color: theme.textTheme.subtitle1!.color,
          ),
        ),
        const SizedBox(height: 12),
        if (status == DownloadStatus.downloaded)
          InkResponse(
            onTap: () => onOpen(),
            radius: 25,
            child: Icon(
              FontAwesomeIcons.folderOpen,
              size: 20,
              color: theme.textTheme.subtitle1!.color,
            ),
          ),
      ],
    );
  }
}

@immutable
class CirillaDownloadButtonLoading extends StatelessWidget {
  const CirillaDownloadButtonLoading({
    Key? key,
    this.downloadProgress = 0.0,
    this.transitionDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final double downloadProgress;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${(downloadProgress * 100).toInt()}%',
          style: theme.textTheme.overline!.copyWith(color: theme.textTheme.subtitle1!.color),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: borderRadiusTiny,
          child: LinearProgressIndicator(
            value: downloadProgress,
            backgroundColor: theme.dividerColor,
            valueColor: AlwaysStoppedAnimation(theme.primaryColor),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
