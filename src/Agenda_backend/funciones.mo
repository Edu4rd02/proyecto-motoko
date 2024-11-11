//Becerra Flores Jose Eduardo

import Map "mo:map/Map";
import Option "mo:base/Option";
import { nhash } "mo:map/Map";
import { thash } "mo:map/Map";
import DateTime "mo:datetime/DateTime";
import Components "mo:datetime/Components";
import Time "mo:base/Time";
import Int "mo:base/Int";

module Funciones {

    //*Funcion encargada de eliminar todos los elementos de un mapa
    public func borrarTodos(map:Map.Map<Text, Time.Time>):async(){  
        // Obtén todas las claves del map
        let keys = Map.keys(map);
        
        for (key in keys) {
            Map.delete(map,thash,key);
        };
    };

    //*Funcion para mostrar la hora y minutos (hh:mm) de un tiempo en especifico
    public func obtenerTiempo(tiempo:Time.Time): async Text {
        //Sacamos los componentes de los nanosegundos enviados como parametro
        let components = Components.fromTime(tiempo);
        
        //Extramos la hora y minutos de la fecha
        let hora:Int = (components.hour);
        let minutos:Int = (components.minute);

        var hora_local:Int = hora-8; //Ajustamos la hora a la zona horaria en la que estoy ubicado
        var minutos_local = Int.toText(components.minute); 

        //Si la hora presentada luego de restar 8 es menor a 0, sumamos 24 horas para solucionar el problema
        if (hora_local < 0){
            hora_local := 24+hora_local;
        };

        //Para agregar formato en caso que solo haya un digito en los minutos de la hora
        if (minutos <= 9){
            minutos_local := "0"#Int.toText(components.minute)
        };

        //Retorna en forma de texto la hora y minutos de vencimiento para la tarea
        return Int.toText(hora_local)#":"#minutos_local;
    };

    //*Funcion encargada de actualizar las tareas, en caso de que no este vencida, la eliminamos de las tareas pendientes para agregarla a los vencidas
    public func actualizar(map:Map.Map<Text, Time.Time>,tareas_finales:Map.Map<Text, Time.Time>):async(){
        let keys = Map.keys(map);
    
        // Recorre cada tarea y obtiene su hora de vencimiento
        for (key in keys) {
            switch (Map.get(map,thash,key)) {
                case (?value) {
                    if(value < Time.now()){
                        Map.set(tareas_finales,thash,key,value);
                        Map.delete(map,thash,key);
                    }
                };
                case null {};
            };
        };
    };
};