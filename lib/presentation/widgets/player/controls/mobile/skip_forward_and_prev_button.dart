import 'package:flutter/material.dart';

class _BuildButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  const _BuildButton({super.key, required this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.0,
      width: 35.0,
      child: IconButton(
        padding: EdgeInsets.all(0.0),

        style:
            const ButtonStyle(shape: MaterialStatePropertyAll(CircleBorder())),
        onPressed: onTap,
        // alignment: Alignment.center,
        icon: Icon(
          iconData,
          size: 35.0,
        ),
      ),
    );
  }
}

class NextEpisodeButtonMobile extends StatelessWidget {
  const NextEpisodeButtonMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return _BuildButton(
      onTap: () {},
      iconData: Icons.skip_next_rounded,
    );
  }
}

class PrevEpisodeButtonMobile extends StatelessWidget {
  const PrevEpisodeButtonMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return _BuildButton(
      onTap: () {},
      iconData: Icons.skip_previous_rounded,
    );
  }
}
