// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:fic4_flutter_auth_bloc/bloc/product/get_all_product/get_all_product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Category",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        centerTitle: true,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: BlocBuilder<GetAllProductBloc, GetAllProductState>(
          builder: (context, state) {
            if (state is GetAllProductLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetALlProductLoaded) {
              return GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final product = state.listProduct[index];
                  final imageUrl = product.images?.isNotEmpty == true
                      ? product.images![0]
                      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/310px-Placeholder_view_vector.svg.png';
                  return GestureDetector(
                    onTap: () {},
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            imageUrl,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            product.category?.name ?? '-',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(
              child: Text("Failed to load categories."),
            );
          },
        ),
      ),
    );
  }
}
