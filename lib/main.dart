
import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TableWidget(),
    );
  }
}

class TableWidget extends StatefulWidget {
  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  bool _isBorderEnabled = false;
  var _actionIcon = Icons.border_all;
  int numMarcos;
  int sizeMemory;
  int numPaguinas;
  int sizeMarcos;
  int sizeNewProceso;
  String nombreNewProceso;
  List<List<procesos>> registro;
  List<procesos>  espera;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numPaguinas=2;
    numMarcos=2;
    sizeMemory=128;
    createArray(2,4);
  }
  @override
  Widget build(BuildContext context) {


//       int marcosPorProceso(int size){
//   int defMarcos;
//   double marcos=(size/sizeMarcos);
//   if(marcos> marcos.roundToDouble())
//     defMarcos=marcos.round()+1;
//     else
//     defMarcos=marcos.toInt();
//     return defMarcos;
// }

      // int prueba=24;
      // print(marcosPorProceso(prueba).toString() + "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE" );
      // print(prueba/16);
      // print((1.5).roundToDouble());
    
    // delProceso("quinto");

    for(int i=0;i<registro.length;i++){
      for (int k=0;k<registro[i].length;k++){
        if(registro[i][k]!=null)
        print(registro[i][k].nombre + "  "+k.toString());
      }
    }
    // print(registro.toString());
    // print(espera.toString());

   return Scaffold(
      appBar: AppBar(
        title: Text("Simulador de memoria"),
        centerTitle: true,
      ),
      body: Container(
        child: Container(
          height: 300.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                 height: 300.0,
                width: 100.0,
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CupertinoButton(
                      child: Icon(Icons.add),
                      onPressed: (){
                    //     showDialog(
                    //     context: context,
                    //     builder: (context){
                          
                        
                    //   }
                    // );
                    _showDialog();
                    
                    }),
                    CupertinoButton(
                      child: Icon(Icons.remove),
                      onPressed: (){
                        _showDialogremove();
                      },
                    )
                  ],
                ),
              ),
              Container(
                height: 300.0,
                width: 100.0,
                child: ListView(
                  children:procesosEspera() ,
                ),
              ),
              Container(
                height: 300.0,
                width: 110.0,
                child: ListView(
                  children:procesosForma1() ,
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }


void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Agregando un proceso"),
          content:ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text("Nombre del Proceso:"),
              TextField(
                onChanged: (val){
                nombreNewProceso=val;
                },
              
              ),
              Text("Size del proceso"),
              TextField(
               keyboardType: TextInputType.number,
                onChanged: (val){
                  sizeNewProceso=int.parse(val);
                },
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                if(espaciosSuficientesParaProceso(marcosPorProceso(sizeNewProceso))!=-1)
                  addProceso(new procesos(nombreNewProceso,1,sizeNewProceso));
                  else
                  espera.add(new procesos(nombreNewProceso,1,sizeNewProceso));
                  setState(() {
                    
                  });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

void _showDialogremove() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Borrando un proceso"),
          content:ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text("Nombre del Proceso:"),
              TextField(
                onChanged: (val){
                nombreNewProceso=val;
                },
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                delProceso(nombreNewProceso);
                updateProcesos();
                  setState(() {
                    
                  });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

createArray(int numPaguinas, int numMarcos){
  registro=new List(numPaguinas);
  for (int i=0;i<registro.length;i++) {
    registro[i]=new List(numMarcos);
  }
  // print(registro.toString());
  espera= new List();
  sizeMarcos=(sizeMemory/(numPaguinas*numMarcos)).round();
}

int marcosPorProceso(int size){
  int defMarcos;
  double marcos=(size/sizeMarcos);
  if(marcos> marcos.roundToDouble())
    defMarcos=marcos.round()+1;
    else
    defMarcos=marcos.round().toInt();
    return defMarcos;
}
int espaciosSuficientesParaProceso(int numerosdeMarcosporProceso){
for(int i=0;i<registro.length;i++){
      int marcosDisponibles=0;
      for(int k=0;k<registro[i].length;k++){
        if(registro[i][k]==null){
          marcosDisponibles++;
        }
      }
      if(marcosDisponibles>=numerosdeMarcosporProceso){
        return i;
      }
    }
    return -1;
}

bool addProceso(procesos pro){
  bool saberSiEntro=false;
  int marcosaUtilizar=marcosPorProceso(pro.size);
  int paguinaAUsar=espaciosSuficientesParaProceso(marcosaUtilizar);
  int sizeOcupadoProceso;
  if(paguinaAUsar!=-1)
  for(int k=0;k<marcosaUtilizar;k++){
         if(pro.sizeTemp-sizeMarcos>0){
      pro.sizeTemp-=sizeMarcos;
      sizeOcupadoProceso=sizeMarcos;
    }
    else{
      sizeOcupadoProceso=pro.sizeTemp;
    }
    for(int i=0;i<registro[paguinaAUsar].length;i++){
      if(registro[paguinaAUsar][i]==null){
        // pro.sizeOcupado=sizeOcupadoProceso;
        registro[paguinaAUsar][i]=new procesos(pro.nombre, pro.color, pro.size);
        registro[paguinaAUsar][i].sizeOcupado=sizeOcupadoProceso;
        print(registro[paguinaAUsar][i].sizeOcupado.toString());
        print("Se agrego el proceso " + pro.nombre + " Con un tamano de "+ pro.size.toString() + " que uso " + marcosaUtilizar.toString() +" numero de marcos");
        i=registro[paguinaAUsar].length+1;
        saberSiEntro=true;
      }
    }
    }
    return saberSiEntro;
}

delProceso(String nombre){
for(int i=0;i<registro.length;i++){
  for(int k=0;k<registro[i].length;k++){
    if(registro[i][k]!=null)
    if(registro[i][k].nombre==nombre){   
      print("se saco el proceso " + nombre);   
      registro[i][k]=null;
    }
  }
}
}

updateProcesos(){
  for(int i=0;i<espera.length;i++){
    if(espera[i]!=null)
    if(addProceso(espera[i])){
      espera[i]=null;
    }
  }
}

List<Widget> procesosForma1(){

  List<Widget> procesosList= new List();

  for(int i=0;i<registro.length;i++){
    for(int k=0;k<registro[i].length;k++){
      if(registro[i][k]!=null){
      procesosList.add(
        ListTile(
          title: Text("Paguina " + (i+1).toString() +"  "+ registro[i][k].nombre+" Size   "+registro[i][k].sizeOcupado.toString()),
        )
      );}
      else {
        procesosList.add(
      ListTile(
          title: Text("Paguina " + (i+1).toString() +"  "+ "No hay proceso"),
        )
        );
      }

    }
    procesosList.add(
      Divider(color: Colors.black, height: 0.0,)
    );
  }
  return procesosList;

}

List<Widget> procesosEspera(){
  List<Widget> procesosWidget= new List();
  for(int i=0;i<espera.length;i++){
    if(espera[i]!=null){
      procesosWidget.add(
        ListTile(
          title: Text(espera[i].nombre),
          subtitle: Text("Tamano: "+ espera[i].size.toString()),
        )
      );
    }
  }
  return procesosWidget;
}






}







class procesos{

  String nombre;
  int color;
  int size;
  int sizeTemp;
  int sizefree;
  int sizeOcupado;
  procesos(this.nombre,this.color,this.size){
    sizeTemp=size;
  }


}

