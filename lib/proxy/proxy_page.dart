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
  final TextEditingController _controller = TextEditingController();

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
          Expanded(
            child: FutureBuilder<MtgCard?>(
              future: card,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child:CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(i10n.proxy_error_more_specific);
                } else if (snapshot.hasData) {
                  var mtgCard = snapshot.data;
                  if (mtgCard?.imageUris?.borderCrop != null) {
                    return Padding(padding: const EdgeInsets.all(8) , child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        mtgCard!.imageUris!.borderCrop.toString(),
                      ),
                    ));
                  } else {
                    return Center(child:Padding(padding: const EdgeInsets.all(20), child: Text(i10n.proxy_error_not_supported)));
                  }
                } else {
                  return Center(child:Padding(padding: const EdgeInsets.all(20), child: Text(i10n.proxy_greeting)));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: i10n.proxy_search,
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0), child:
          ElevatedButton(
            onPressed: _searchCard,
            child: Text(i10n.proxy_search_button),
          ),)
        ],
      ),
    ),
    );
  }
}
