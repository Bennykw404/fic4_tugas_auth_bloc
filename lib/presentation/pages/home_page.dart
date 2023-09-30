import 'package:fic4_flutter_auth_bloc/bloc/product/get_all_product/get_all_product_bloc.dart';
import 'package:fic4_flutter_auth_bloc/bloc/profile/profile_bloc.dart';
import 'package:fic4_flutter_auth_bloc/data/localsources/auth_local_storage.dart';
import 'package:fic4_flutter_auth_bloc/presentation/pages/create_new_product_screen.dart';
import 'package:fic4_flutter_auth_bloc/presentation/pages/detail_product_screen.dart';
import 'package:fic4_flutter_auth_bloc/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final menus = [
    'Home',
    'Create New Product',
    'Bookmarks',
    'Settings',
  ];

  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfileEvent());
    context.read<GetAllProductBloc>().add(DoGetAllProductEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home - Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await AuthLocalStorage().removeToken();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }));
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoaded) {
                    return DrawerHeader(
                      margin: const EdgeInsets.all(0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(state.profile.avatar ??
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                        ),
                        title: Text(
                          state.profile.name ?? "Name Not Available",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          "View Profile",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ProfileScreen();
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: menus.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      if (index == 1) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const CreateNewProductScreen();
                        }));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        menus[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<GetAllProductBloc, GetAllProductState>(
        builder: (context, state) {
          if (state is GetAllProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetALlProductLoaded) {
            return ListView.separated(
              itemCount: state.listProduct.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.all(16),
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                final product = state.listProduct.reversed.toList()[index];
                final imageUrl = product.images?.isNotEmpty == true
                    ? product.images![0]
                    : 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/310px-Placeholder_view_vector.svg.png';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const DetailProductScreen();
                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.category?.name ?? '-',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text(
                              product.title ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              maxLines: 3,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              product.formattedCreationAt(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            imageUrl,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Text("No Data");
        },
      ),
    );
  }
}
