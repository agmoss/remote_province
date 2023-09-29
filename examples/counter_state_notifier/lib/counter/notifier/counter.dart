import 'package:remote_province/remote_province.dart';
import 'package:state_notifier/state_notifier.dart';

import '../clients/counter.dart';

class CounterNotifier extends StateNotifier<RemoteState<int>> {
  var _counterClient = CounterClient();

  CounterNotifier() : super(RemoteState.initial()) {
    getCount();
  }

  getCount() async {
    state = RemoteState.loading();

    state = await RemoteState.guard(() => _counterClient.getCount());
  }

  increment() async {
    state = await RemoteState.guard(() => _counterClient.increment());
  }

  decrement() async {
    state = await RemoteState.guard(() => _counterClient.decrement());
  }
}
