import 'package:flutter/material.dart';
import 'package:streamify/widgets/add_space.dart';
import 'package:streamify/helpers/color_from_theme.dart';
import 'package:streamify/providers/meta_providers/models/main_api_models.dart';
import 'package:streamify/utils/month_name.dart';
import 'package:streamify/widgets/default_grey.dart';

class MetaFieldsData {
  final String meanScore;
  final String status;
  final String totalEpisodes;
  final String runtime;
  final String type;
  final String source;
  final String releaseDate;
  final String endDate;

  const MetaFieldsData(
      {required this.meanScore,
      required this.totalEpisodes,
      required this.runtime,
      required this.releaseDate,
      required this.endDate,
      required this.status,
      required this.source,
      required this.type});

  static String parseDateAndTime(DateTime? date) {
    if (date == null) return defaultStringValue;
    return '${date.day} ${getMonthName(date.month)} ${date.year.toString()}';
  }

  static const String defaultStringValue = '??';

  factory MetaFieldsData.fromMediaDetails(MediaDetails data) {
    return MetaFieldsData(
        status: data.status ?? 'Unknown',
        meanScore: data.averageScore.toStringAsFixed(1),
        totalEpisodes: data.lastEpisode?.toString() ?? defaultStringValue,
        runtime: data.runtime?.toString() ?? defaultStringValue,
        releaseDate: parseDateAndTime(data.releaseDate),
        endDate: defaultStringValue,
        source: defaultStringValue,
        type: data.mediaType);
  }
}

class MetaDataView extends StatelessWidget {
  final MetaFieldsData data;

  const MetaDataView({required this.data, super.key});

  static const TextStyle defaultWhite = TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.5);

  static TextStyle defaultPrimary(BuildContext context) => TextStyle(
      color: getPrimaryColor(context),
      fontWeight: FontWeight.bold,
      fontSize: 15.5);

  Widget _defaultPostion({required Widget child, bool padToLeft = false}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
            left: (!padToLeft) ? 35 : 0.0, right: (padToLeft) ? 35 : 0.0),
        child: child,
      ),
    );
  }

  static Widget _buildText(String field) {
    return Text(
      field,
      textAlign: TextAlign.left,
    );
  }

  @override
  Widget build(BuildContext context) {
    final verticalSpace = addVerticalSpace(5);
    return Column(
      children: [
        DefaultGrey(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _defaultPostion(child: _buildText('Mean Score')),
            _defaultPostion(
              padToLeft: true,
              child: RichText(
                text: TextSpan(
                    text: data.meanScore,
                    style: defaultPrimary(context),
                    children: const [
                      TextSpan(
                          text: ' / ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16)),
                      TextSpan(text: '10', style: defaultWhite),
                    ]),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        )),
        verticalSpace,
        DefaultGrey(
          child: Row(
            children: [
              _defaultPostion(child: _buildText('Status')),
              _defaultPostion(
                  padToLeft: true,
                  child: Text(
                    data.status,
                    textAlign: TextAlign.right,
                    style: defaultWhite,
                  )),
            ],
          ),
        ),
        verticalSpace,
        DefaultGrey(
          child: Row(
            children: [
              _defaultPostion(child: _buildText('Total Episodes')),
              _defaultPostion(
                  padToLeft: true,
                  child: Text(
                    data.totalEpisodes,
                    textAlign: TextAlign.right,
                    style: defaultWhite,
                  )),
            ],
          ),
        ),
        verticalSpace,
        DefaultGrey(
          child: Row(
            children: [
              _defaultPostion(child: _buildText('Runtime')),
              _defaultPostion(
                  padToLeft: true,
                  child: Text(
                    data.runtime,
                    textAlign: TextAlign.right,
                    style: defaultWhite,
                  )),
            ],
          ),
        ),
        verticalSpace,
        DefaultGrey(
          child: Row(
            children: [
              _defaultPostion(child: _buildText('Type')),
              _defaultPostion(
                  padToLeft: true,
                  child: Text(
                    data.type,
                    textAlign: TextAlign.right,
                    style: defaultWhite,
                  )),
            ],
          ),
        ),
        verticalSpace,
        DefaultGrey(
          child: Row(
            children: [
              _defaultPostion(child: _buildText('Source')),
              _defaultPostion(
                  padToLeft: true,
                  child: Text(
                    data.source,
                    textAlign: TextAlign.right,
                    style: defaultWhite,
                  )),
            ],
          ),
        ),
        verticalSpace,
        DefaultGrey(
          child: Row(
            children: [
              _defaultPostion(child: _buildText('Release Date')),
              _defaultPostion(
                  padToLeft: true,
                  child: Text(
                    data.releaseDate,
                    textAlign: TextAlign.right,
                    style: defaultWhite,
                  )),
            ],
          ),
        ),
        verticalSpace,
        DefaultGrey(
          child: Row(
            children: [
              _defaultPostion(child: _buildText('End Date')),
              _defaultPostion(
                  padToLeft: true,
                  child: Text(
                    data.endDate,
                    textAlign: TextAlign.right,
                    style: defaultWhite,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
