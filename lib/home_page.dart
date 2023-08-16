import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutteract/model/team.dart';

class nbaAct extends StatelessWidget {
  nbaAct({super.key});


  List<Team> teams = [];

  //get teams
  Future getTeams() async {
    var response = await http.get(Uri.https('www.balldontlie.io', 'api/v1/teams'));
    var jsonData = jsonDecode(response.body);
    
    print(jsonData);
    for(var eachTeam in jsonData['data'])
    {
      final team = Team(abbreviation: eachTeam['abbreviation'],
       city: eachTeam['city'],
      );

      teams.add(team);
    }

    print(teams.length);
  }


  @override
  Widget build(BuildContext context) {
    //getTeams();
    return Scaffold(
      body: FutureBuilder(
        future: getTeams(),

        builder: (context, snapshot) {
          //if is it done loading? then show team data
          if(snapshot.connectionState == ConnectionState.done){
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder:(context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 235, 181, 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(teams[index].abbreviation),
                      subtitle: Text(teams[index].city),
                    ),
                  ),
                );
              },
            );
          }
          //loading circle=
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}