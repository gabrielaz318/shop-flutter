import 'package:flutter/material.dart';

import '../providers/counter.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({
    super.key,
  });

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo contador'),
      ),
      body: Column(
        children: [
          Text('${provider?.state.value.toString() ?? 0}'),
          IconButton(
            onPressed: () => setState(() => provider?.state.inc()),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => setState(() => provider?.state.dec()),
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
