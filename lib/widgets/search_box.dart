import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import 'product_card.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
    this.category,
  }) : super(key: key);

  final Category? category;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
        if (state is SearchLoaded) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 10,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          hintText: 'Search for a Product...',
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(right: 10),
                            constraints: const BoxConstraints(minWidth: 50),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5)),
                                color: Colors.red.withOpacity(0.5),
                                border: Border.all(color: Colors.grey)),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200)),
                          contentPadding: const EdgeInsets.all(10),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        onChanged: (value) {
                          context.read<SearchBloc>().add(SearchProduct(
                                productName: value,
                                category: category,
                              ));
                        },
                      ),
                    ),
                  ],
                ),
                state.products.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ProductCard.catalog(
                              product: state.products[index],
                              widthFactor: 1.1,
                            ),
                          );
                        })
                    : const SizedBox(),
              ],
            ),
          );
        } else {
          return const Text('Something went wrong.');
        }
      },
    );
  }
}
//