import 'package:flutter/material.dart';
import 'package:scryfall_api/scryfall_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProxyPage extends StatefulWidget {
  const ProxyPage({super.key});

  @override
  State<ProxyPage> createState() => _ProxyPageState();
}

class _ProxyPageState extends State<ProxyPage> {
  final apiClient = ScryfallApiClient();
  Future<MtgCard?>? card;
  TextEditingController _controller = TextEditingController();

  void _searchCard() {
    setState(() {
      card = apiClient.getCardByName(_controller.text,
          searchType: SearchType.fuzzy);
    });
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
      title: Text(i10n.proxy_title),
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: i10n.proxy_search,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _searchCard,
            child: Text(i10n.proxy_search_button),
          ),
          Expanded(
            child: FutureBuilder<MtgCard?>(
              future: card,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(i10n.proxy_error_more_specific);
                } else if (snapshot.hasData) {
                  var mtgCard = snapshot.data;
                  if (mtgCard?.imageUris?.borderCrop != null) {
                    return Image.network(
                        mtgCard!.imageUris!.borderCrop.toString());
                  } else {
                    return Text(i10n.proxy_error_not_supported);
                  }
                } else {
                  return Text(i10n.proxy_greeting);
                }
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}
