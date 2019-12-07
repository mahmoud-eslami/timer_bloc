import 'package:flutter/material.dart';
import 'package:timer_bloc/bloc/bloc.dart';
import 'package:timer_bloc/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BlocProvider(
          create: (context) => TimerBloc(ticker: Ticker()),
          child: Timer()),
    );
  }
}



class Timer extends StatelessWidget {
  static const TextStyle timerTextStyle = TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.bold,
      color: Colors.white
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BlocBuilder<TimerBloc,TimerState>(
                  builder: (context,state){
                    final String min = ((state.duration / 60) % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    final String sec = (state.duration % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    return Text(
                      '$min:$sec',
                      style: Timer.timerTextStyle,
                    );
                  }
              ),
              SizedBox(height: 25,),
              BlocBuilder<TimerBloc, TimerState>(
                  condition: (prevState, currentState) =>
                  currentState.runtimeType != prevState.runtimeType,
                  builder: (context, state) => Actions())
            ],
          ),
        ],
      ),
    );
  }
}

class Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _mapStateToActionButton(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }
}

List<Widget> _mapStateToActionButton({
  TimerBloc timerBloc,
}) {
  final TimerState currentState = timerBloc.state;
  if (currentState is Ready) {
    return [
      FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.play_arrow),
        onPressed: () {
          timerBloc.add(Start(duration: currentState.duration));
        },
      ),
    ];
  }
  if (currentState is Running) {
    return [
      FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.pause),
        onPressed: () {
          timerBloc.add(Pause());
        },
      ),
      FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.replay),
        onPressed: () {
          timerBloc.add(Reset());
        },
      ),
    ];
  }
  if (currentState is Paused) {
    return [
      FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.play_arrow),
        onPressed: () {
          timerBloc.add(Resume());
        },
      ),
      FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.replay),
        onPressed: () {
          timerBloc.add(Reset());
        },
      ),
    ];
  }
  if (currentState is Finished) {
    return [
      FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.replay),
        onPressed: () {
          timerBloc.add(Reset());
        },
      ),
    ];
  }
  return [];
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [Color(0xFF3A2DB3), Color(0xFF3A2DB1)],
          [Color(0xFFEC72EE), Color(0xFFFF7D9C)],
          [Color(0xFFfc00ff), Color(0xFF00dbde)],
          [Color(0xFF396afc), Color(0xFF2948ff)]
        ],
        durations: [35000, 19440, 10800, 6000],
        heightPercentages: [0.15, 0.18, 0.20, 0.23],
        blur: MaskFilter.blur(BlurStyle.inner, 0),
        gradientBegin: Alignment.centerLeft,
        gradientEnd: Alignment.centerRight,
      ),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 5.0,
      backgroundColor: Colors.deepPurple[50],
    );
  }
}
