import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/pelicula_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';
  final peliculasProvider = new PeliculaProvider();
  
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: Acciones de nuevo appbar
  

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: Icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
    ),
    onPressed: (){
      close(context,null);
    },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: Crea los resultados que se mostraran

    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Sugerencias que aparecen cuando se escribe
    if(query.isEmpty || query.length==0){
      return Container();
    }else{
      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder: (BuildContext context,AsyncSnapshot<List<Pelicula>> snapshot){
          if(snapshot.hasData){


            final peliculas = snapshot.data;


            return ListView(
             children: peliculas.map((pelicula){
               return ListTile(
                 leading: FadeInImage(
                   image: NetworkImage(pelicula.getPoster()),
                   placeholder: AssetImage('assets/img/no-image.jpg'),
                   width: 50.0,
                   fit: BoxFit.contain,
                 ),
                 title: Text(pelicula.title),
                 subtitle: Text(pelicula.originalTitle),
                 onTap: (){
                   close(context,null);
                   pelicula.uniqueId = '';
                   Navigator.pushNamed(context,'detalle',arguments:pelicula);
                 },
               );
             }).toList()
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }



}