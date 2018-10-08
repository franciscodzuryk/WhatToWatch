# Introducción.

Esta es una aplicación de ejemplo que pretende explicar con fines educativos los siguientes temas:
Arquitecturas MVC y Clean Swift.
Capas de abstracción (acceso por red, acceso a datos persistidos localmente).
Alamofire.
CoreData.
Unit Test.

Esta primer versión no tiene suficientes tests y en la capa de datos los objetos no están modelados, en una próxima versión se completarán estos dos puntos. Sin embargo tanto los tests como el acceso a datos están lo suficientemente completos para servir como guía de estudio (intención de este proyecto).

### Arquitectura.

#### MVC:
Las escenas de Movies, Shows y sus respectivos detalles implementan el patrón MVC. Donde MoviesVC, MovieDetailVC, ShowsVC y ShowsDetailVC controlan la vista. Es decir, lo que se presenta en pantalla. Estas clases no deben, bajo ningún punto de vista, contener lógica de negocio; solo deben pedirle información a su controlador y mostrar lo que este les devuelva. El controlador va a informar a la vista cuando y que datos actualizar.

Los controladores MoviesCtrler, MovieDetailCtrler, ShowsCtrler y ShowsDetailCtrler contienen la lógica de negocio, es decir las funcionalidades. La tarea de un controlador es buscar los datos (a través de la red, de una DB, de un archivo o de donde fuera) y enviarselos a la vista ya modelados y listos para mostrar.

Los modelos MoviesVM y ShowsVM tiene como objetivo y único fin modelar los datos (transformarlos) para que la vista solo deba mostrarlos.

Por último, el patrón MVC se vale de capas para obtener los datos. En este ejemplo tenemos dos claramente definidas:
Network: Realiza los request a la API y transforma las respuestas (objetos JSON) en objetos (instancias de clases que modelan las respuestas).
CoreData: Es la capa de acceso a datos, en este caso pretende ser una caché NO una DB relacional. Esta capa nos abstrae las tareas de guardado y accesos a los datos que se guardan localmente. En este ejemplo guarda los requests de Movies y Shows en tres entidades (a los fines prácticos las podemos considerar como tablas) por cada recurso. Estas entidades son: MoviePopularModel, MovieUpcomingModel, MovieTopRatedModel, ShowPopularModel, ShowOnTheAirModel, ShowTopRatedModel.

##### Interacciones.

Vista -> solicita datos al -> Controlador -> Busca la información a través de las Capas -> las Capas -> devuelven los datos -> al Controlador -> el Controlador crea -> los View Models -> el Controlador -> le envía los View Models -> a la Vista.


## ¡MUY IMPORTANTE!
La capa de acceso a datos debe modelar sus objetos. En este ejemplo eso aún NO se hace, será agregado en la próxima versión.

### Clean Swift:
La escena Search implementa este patrón. Sus componentes son:
###### SearchVC: 
controla la Vista (al igual que MVC solo controla la vista).
###### SearchRouter:
abre las vistas que continúan el flujo de la aplicación. En este caso los detalles de Movies o Shows.
###### SearchInteractor: 
contiene la lógica de negocio, solicita los datos al Worker, genera los View Models e interacciona con el Preseter para actualizar la Vista.
###### SearchWorker:
realiza la búsqueda de los datos, ya sea por red, buscando en una DB, en un archivo o cualquier otro contenedor de datos.
###### SearchPresenter: 
se ocupa de informar a la Vista que debe actualizarse y enviarle los View Models que el Interactor creó.
###### SearchModels: 
modela los datos de manera que la Vista pueda mostrarlos sin hacer ningún tipo de transformación o aplicar lógica alguna.
###### SearchConfigurator: 
el configurator instancia y setea todos los objetos anteriores a excepción de la Vista. Es la Vista quien pide a este objeto que cree e inicialice todos los objetos anteriores necesarios para la arquitectura.

##### Iteracciones.

Vista -> Solicita al Configurator que cree los objetos necesarios.
Vista -> Solicita los datos que necesita -> al Interactor -> solicita que busque la información -> al Worker -> que devuelve los datos al Interactor -> crea los VM -> solicita -> al Preseter -> que notifique a la Vista que tiene datos para mostrar -> la Vista actualiza los datos.

Vista -> ante un evento del usuario le solicita -> al Router que navegue a la siguiente Vista.

### Swift:
Debido a que este proyecto ha sido programado en Swift, lenguaje que carece de Reflección, es necesario implementar las interfaces de los distintos objetos para poder luego generar los Mocks necesarios en los tests. Esto es independiente de la arquitectura que se utilice.

### ¿En qué consiste el principio de responsabilidad única? ¿Cuál es su propósito?
Consiste en encapsular el comportamiento dentro de módulos con una única responsabilidad. Su propósito es desacoplar los comportamientos dando una y solo una responsabilidad a cada capa, módulo o clase del sistema.

### ¿Qué características tiene, según su opinión, un “buen” código o código limpio?
El código debe:
Ser 100% testeable.
Estar encapsulado.
Seguir algún estandar de sintaxis. No importa cual, lo importante es que se mantenga a lo largo de todo el código.
Esta documentado. Considero que comentando correctamente las interfaces de las funciones es suficiente. Esto quiere decir explicar los valores de entrada y losvalores de salida.
Reutilizar siempre el código genérico.
