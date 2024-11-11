# `Agenda`

## Información
 `Agenda` es un proyecto desarrollado en el lenguaje de programación Motoko, se busca indagar y sacar provecho a las herramientas proporcionadas por este lenguaje y las tecnologías de ICP.

## Comienzo
Si usted desea instalar este proyecto en su computador solo tiene que clonar el repositorio en el lugar donde desee tenerlo a la mano:

```bash
git clone https://github.com/Edu4rd02/proyecto-motoko.git
```



## Preparar el ambiente de trabajo (primera vez)
Una vez instalado el repositorio localmente, si es tu primera vez trabajando con proyectos de este estilo, es necesario prepara el ambiente para la correcta ejecucción del proyecto.

- Instala dfx `sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"`

- Instala NodeJs `sudo apt install nodejs`
- Instala NPM `sudo apt-get install npm`
- Instala MOPS (es necesaria una versión de NodeJs mayor a 18) `sudo npm i -g ic-mops`

Una vez instalado todo lo anterior, es necesario que te dirigas al espacio en donde clonaste el proyecto y en esa dirección ejecutes `mops install` para instalar las dependencias o bibliotecas necesarias para el funcionamiento del proyecto.

## Ejecutar el proyecto localmente

Una vez preparado todo el ambiente ahora es posible ejecutar localmente el proyecto, solo se tienen que seguir los siguientes comandos:

```bash
# Iniciar el servicio y borrar el cache
dfx start --background --clean

# Desplegar para generar la interfaz candid
dfx deploy
```
En consola serán mostrados varios links, únicamente son necesarios 2, para acceder a la interfaz del candid. Ingresamos el link que acompaña al **Agenda_backend** en la sección `Backend canister via Candid interface`. Se debe copiar y pegar esa URL en cualquier navegador de su preferencia.

Posterior a eso, se necesita incluir el internet identity para el funcionamiento del proyecto, por lo que se necesita agregar una segunda URL, esta se encuentra en la sección de `internet_identity` y debemos copiar el segundo enlace.

Ahora debemos juntar ambos enlaces, a la URL que se encuentra en el navegador le debemos añadir al final `&ii=URL del internet identity`, esto da como resultado `URl(Agenda_backend)&ii=URL(internet_identity)`.

Eso sería suficiente para mostrar la interfaz en el navegador y activar el botón de login del internet identity.

## Funcionamiento

Esta aplicación sirve como una agenda para organizar tus tareas del día, primeramente debes iniciar sesión con el ***Internet Identity*** para agregar tareas al programa. A continuación se explicará el funcionamiento de cada función dentro del programa:

- ***aAgregarTarea***. Función principal que permite agregar tareas, se debe introducir un text (nombre de la tarea) y un nat (minutos que tendrá dicha tarea y que marcaran el tiempo limite).

- ***bObtenerTodos***. Permite mostrar una lista de las tareas que siguen disponibles y a las cuales aún no se les vence el tiempo, el tiempo es mostrado en la hora y minutos de cuando terminará la tarea.

- ***cCompletarTarea***. Sirve para seleccionar una sola tarea y marcarla como finalizada, se debe introducir un text (Nombre de la tarea que se terminó).

- ***dLimpiar_actuales***. Elimina toda la lista de tareas que se encuentran aún disponibles.

- ***eObtenerTodos_fin***. Muestra una lista de todas las tareas que se han vencido o han sido terminadas.

- ***fLimpiar_finalizadas***. Limpia la lista de todas las tareas vencidas o completadas.

## Finalización
Si se quiere terminar con el servicio simplemente se debe ejecutar el comando: 

```bash
#Finaliza el servicio
dfx stop
```
