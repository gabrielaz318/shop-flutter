import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if(_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if(arg == null) {
        return;
      }

      final product = arg as Product;
      _formData['id'] = product.id;
      _formData['name'] = product.name;
      _formData['price'] = product.price;
      _formData['description'] = product.description;
      _formData['imageUrl'] = product.imageUrl;

      _imageUrlController.text = product.imageUrl;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageFocus.removeListener(updateImage);
    _imageFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endsWithFile;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    Provider.of<ProductList>(context, listen: false).saveProduct(_formData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: (_formData['name'] as String? ?? '').toString(),
                decoration: const InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (_name) {
                  final name = _name ?? '';

                  if (name.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (name.trim().length < 3) {
                    return 'Nome precisa no mínimo de 3 letras';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: (_formData['price'] as double? ?? '').toString(),
                focusNode: _priceFocus,
                decoration: const InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) =>
                    _formData['price'] = double.parse(price ?? '0.0'),
                validator: (_price) {
                  final priceString = _price ?? '-1';
                  final price = double.tryParse(priceString) ?? -1;

                  if(price <= 0) {
                    return 'Informe um preço válido';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: (_formData['description'] as String? ?? '').toString(),
                focusNode: _descriptionFocus,
                decoration: const InputDecoration(labelText: 'Descrição'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageFocus);
                },
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
                validator: (_description) {
                  final description = _description ?? '';

                  if (description.trim().isEmpty) {
                    return 'Descrição é obrigatório';
                  }

                  if (description.trim().length < 3) {
                    return 'Descrição precisa no mínimo de 3 letras';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _imageFocus,
                      decoration:
                          const InputDecoration(labelText: 'Url da Imagem'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _submitForm,
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '',
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? '';

                        if (!isValidImageUrl(imageUrl)) {
                          return 'Informe uma url válida';
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        )),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty ||
                            !isValidImageUrl(_imageUrlController.text)
                        ? const Text('Informe a url')
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(
                              _imageUrlController.text,
                              width: 100,
                              height: 100,
                            ),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
