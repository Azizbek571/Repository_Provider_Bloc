import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository_provider/bloc/user_bloc.dart';
import 'package:repository_provider/bloc/user_event.dart';
import 'package:repository_provider/bloc/user_state.dart';
import 'package:repository_provider/data/model/user_model.dart';
import 'package:repository_provider/data/provider/user_provider.dart';
import 'package:repository_provider/data/repository/user_repositroy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RepositoryProvider(
        create: (context) => UserRepository(UserProvider()),
        child: BlocProvider(
          create: (context) => UserBloc(context.read<UserRepository>()),
          child: const MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Repository Provider")),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is UserErrorState) {
            return Center(child: Text("Error"));
          }
          if (state is UserSuccessState) {
            List<User> userList = state.userModel.users;
            return userList.isNotEmpty
                ? ListView.builder(
                  itemCount:  userList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            "${userList[index].firstName}  ${userList[index].lastName}",
                          ),
                          subtitle: Text("${userList[index].email}"),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              userList[index].profilePicture.toString(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                : Center(child: Text("No users found"));
          }
          return SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserBloc>().add(LoadUserEvent());
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
