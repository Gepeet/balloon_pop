import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameWidget(game: BalloonPopGame()));
}

class BalloonPopGame extends FlameGame {
  late TextComponent scoreText;
  late TextComponent miss;
  late TimerComponent counter;

  int score = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    scoreText = TextComponent(text: 'Score = 0', position: Vector2(100, 100));
    miss = TextComponent(text: 'You Miss');
    counter = TimerComponent(
      period: 5,
      onTick: () {
        counter.timer.reset();
        add(BalloonComponent());
      },
    );
    add(scoreText);
    add(BalloonComponent());
  }

  void updateScore() {
    score += 1;
    scoreText.text = 'Score: $score';
  }

  void showMiss(Vector2 position) {
    miss.position = position;
    add(counter);
    add(miss);
  }
}

class MissComponent extends PositionComponent with HoverCallbacks {}

class BalloonComponent extends RectangleComponent
    with HasGameReference<BalloonPopGame>, TapCallbacks {
  BalloonComponent()
      : super(
            size: Vector2(100, 100),
            position: Vector2(330, 100),
            anchor: Anchor.center,
            paint: BasicPalette.red.paint());

  @override
  void onTapUp(TapUpEvent event) {
    game.showMiss(event.devicePosition);
    removeFromParent();
    game.updateScore();
  }
}
