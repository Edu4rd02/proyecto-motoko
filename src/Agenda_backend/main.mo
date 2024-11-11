//Becerra Flores Jose Eduardo
//Archivo principal donde la mayoria son funciones que aparecen en el main

import Principal "mo:base/Principal";
import { now } = "mo:base/Time";
import Int "mo:base/Int";
import Components "mo:datetime/Components";
import Time "mo:base/Time";
import TimeZone "mo:datetime/TimeZone";
import Map "mo:map/Map";
import Option "mo:base/Option";
import { nhash } "mo:map/Map";
import { thash } "mo:map/Map";
import Funciones "funciones"

actor {
  stable var map = Map.new<Text, Time.Time>(); //Contiene las tareas pendientes y en que tiempo es su vencimiento
  stable var tareas_finales = Map.new<Text, Time.Time>(); //Contiene las tareas finalizadas y en que tiempo es su vencimiento

  var futureTimeNanos:Components.Components = {year = 2020; month = 1; day = 1; hour = 0; minute = 0; nanosecond = 0};
  
  //*Funcion encargada de añadir el tiempo necesario para la tarea
  func agregarTiempo(min:Nat):async Components.Components{
    let currentTimeNanos = Time.now(); //Extraemos el tiempo actual
    let uno = min*60*(1000*1000*1000); //Agregamos los minutos especificados por el usuario
    let newcurrentTimeNanos = currentTimeNanos+uno;
    
    //Transformamos los nanosegundos a una variable tipo componente para facilitar el trabajo en otras partes del codigo
    let newcurrentComponents = Components.fromTime(newcurrentTimeNanos);

    //La variable global que almacena el tiempo futuro ahora obtiene el valor del nuevo tiempo creado
    futureTimeNanos := newcurrentComponents;
    return futureTimeNanos;
  };

  //*Funcion que añade las tareas a realizar
  public shared ({caller}) func aAgregarTarea(nom:Text, minutos:Nat): async Text{
    //Esta tarea solo funciona al estar registrado con el internet identity y al introducir correctamente los datos
    if(Principal.isAnonymous(caller)){
      return "Necesitas iniciar sesión para agregar tareas";
    };
    
    if(nom != "")
    {
      if (minutos > 0){
        //Si funciona todo se agrega el tiempo de la tarea y es guardado en el map que contiene las tareas a realizar
        let hora_finalizar = await agregarTiempo(minutos);
        Map.set(map,thash,nom,Components.toTime(hora_finalizar));
        return "La tarea ha sido agregada con éxito";
      }else{
        return "Solo se permiten numeros enteros y positivos para el tiempo de la tarea";
      }
    }else{
      return "Favor de introducir correctamente el nombre de la tarea";
    };
  };

  //*Funcion para obtener todas las tareas que se van a completar
  public shared func bObtenerTodos():async Text{
    //Cada vez que se muestren las tareas a hacer, se actualizara la tabla para que no salgan las tareas vencidas
    await Funciones.actualizar(map,tareas_finales);

    var resultado = ""; // Lista para almacenar los pares (tarea, tiempo)
    
    // Obtenemos todas las tareas (llaves) contenidas en nuestro map
    let keys = Map.keys(map);
    
    // Recorremo cada tarea y obtenemos el tiempo que tiene destinado
    //El bloque switch se asegura que la tarea tenga un valor asignado
    for (key in keys) {
      switch (Map.get(map,thash,key)) {
        case (?value) {
          //Generamos extraemos el tiempo de nuestra tarea para imprimir la hora y minuto de su entrega
          let horaTexto = await Funciones.obtenerTiempo(value);
          resultado #= "Actividad: " # key # ", Termina a las: " # horaTexto # "\n";
        };
        case null {
          resultado #= "La tarea " # key # " no tiene valor asociado." # "\n";
        };
      };
    };
    return resultado;
  };

  //Funcion que marca una unica tarea como completada
  public shared func cCompletarTarea(key:Text):async Text{
    
    //Nos aseguramos de que la tarea a completar si exista dentro de nuestro map
    switch (Map.get(map,thash,key)){
      case(?value){
        //Agregamos la tarea como finalizada y la removemos de la lista de pendientes
        Map.set(tareas_finales,thash,key,value);
        Map.delete(map,thash,key);
        return "La tarea "# key # " ha sido finalizada con éxito.";
      };
      case null{
        return "La tarea "# key # " no ha sido encontrada.";
      };
    };
  };

  //*Funcion para eliminar todos las tareas pendientes 
  public shared func dLimpiar_actuales():async(){
    //Actualizamos para evitar errores en las tareas
    await Funciones.actualizar(map,tareas_finales);

    await Funciones.borrarTodos(map);
  };

  //*Funcion para mostrar todas las tareas hechas o vencidas
  public shared func eObtenerTodos_fin():async Text{
    //Actualizamos por si ocurre el caso de que haya una tarea vencida y aun no sea agregada a el map de tareas finalizadas
    await Funciones.actualizar(map,tareas_finales);

    var resultado = ""; // Lista para almacenar los pares (tarea, tiempo)
    
    // Obtén todas las tareas del map
    let keys = Map.keys(tareas_finales);
    
    // Recorremos cada tarea y Extraemos el tiempo en que se vence esta
    //Para cada tarea obtenemos su tiempo en el formato hh:mm y lo imprimimos al final
    for (key in keys) {
      switch (Map.get(tareas_finales,thash,key)) {
        case (?value) {
          let horaTexto = await Funciones.obtenerTiempo(value);
          resultado #= "Actividad: " # key # ", Finalizo a las: " # horaTexto # "\n";
        };
        case null {
          resultado #= "La tarea " # key # " no tiene valor asociado." # "\n";
        };
      };
    };
    return resultado;
  };
  
  //*Funcion para eliminar todos las tareas ya hechas o vencidas 
  public shared func fLimpiar_finalizadas():async(){
    //Actualizamos para evitar errores en las tareas
    await Funciones.actualizar(map,tareas_finales);

    await Funciones.borrarTodos(tareas_finales);
  };
};
