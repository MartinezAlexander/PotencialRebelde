%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 1 (después del punto 4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 2
esDisidente(Alguien):-
    habilidadPeligrosa(Alguien),
    gustosRaros(Alguien),
    historialCriminal(Alguien).
% Se puede organizar diferente, pero esta forma se asemeja mas a cómo está contado el problema. 

habilidadPeligrosa(Alguien):-
    habilidad(Alguien, Habilidad),
    terrorista(Habilidad),
    not(trabajoMilitar(Alguien)).

trabajoMilitar(Alguien):-
    trabajo(Alguien,Trabajo),
    esMilitar(Trabajo).

historialCriminal(Alguien):- 
    masDeUnRegistroCriminal(Alguien).

historialCriminal(Alguien):-
    viveCon(Alguien,Otro),
    masDeUnRegistroCriminal(Otro).

viveCon(Alguien,Otro):-
    viveEn(Alguien,Vivienda),
    viveEn(Otro,Vivienda),
    Alguien \= Otro.

masDeUnRegistroCriminal(Alguien):-
    registroCriminal(Alguien,Registro),
    registroCriminal(Alguien,OtroRegistro),
    Registro\=OtroRegistro.

/* Variante (contando) 
masDeUnRegistroCriminal(Alguien):-
    cantidadRegistrosCriminales(Alguien,CantidadRegistros),
    CantidadRegistros > 1.
*/

gustosRaros(Alguien):-
    cantidadDeGustos(Alguien,Cant),
    Cant > 3.

gustosRaros(Alguien):-
    not(leGusta(Alguien,_)).
/* Variante
gustosRaros(Alguien):-
    cantidadDeGustos(Alguien,0).
*/

gustosRaros(Alguien):-
    habilidad(Alguien,Habilidad),
    leGusta(Alguien,Habilidad).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 3

% a)
viviendaSinHabitantes(Vivienda):-
    ambiente(Vivienda,_),
    not(viveEn(Vivienda,_)).
% Se deduce que la vivienda existe porque hay información de los ambientes que tiene
% En caso de poder existir viviendas sin información de sus habitantes ni ambientes, 
% se deberian agregar hechos como
% vivienda(laSerevino).

% b)
viviendaGustoEnComun(Vivienda):-
    viveEn(Alguien,Vivienda),
    leGusta(Alguien,Gusto),
    forall( viveEn(Otro,Vivienda), leGusta(Otro,Gusto) ).
% Se asume que debe haber al menos un persona que viva en la vivienda, con al menos un gusto.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 4
viviendaRebelde(Vivienda):-
    viveEn(Alguien,Vivienda),
    esDisidente(Alguien),
    superficieClandestina(Vivienda,Superficie),
    Superficie > 50 .

superficieClandestina(Vivienda,SuperficieTotal):-
    findall(Superficie,(ambiente(Vivienda,Ambiente),superficie(Ambiente,Superficie)),Superficies),
    sumlist(Superficies, SuperficieTotal).

superficie(pasadizo,1).
superficie(cuarto(Largo,Ancho),Superficie):-
    Superficie is Largo*Ancho.
superficie(tunel(Longitud),Superficie):-
    Superficie is Longitud*2.

% No es necesario agregar este caso, como tampoco cualquier otro tipo de ambiente que pueda existir y no deba ser considerado
% superficie(tunelEnConstruccion(_),0). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 1
% para mayor facilidad solo se usan los ultimos 4 digitos del nombre hasheado

% viveEn(Persona,Casa).
% Donde vive cada persona, conviene que sea independiente de la info de la persona y de la casa.
% Además permite que haya gente que no se sabe donde vive y viviendas sin habitantes
viveEn(b570,laSerevino).
viveEn(e234,laSerevino).
viveEn(a4d9,laSerevino).

% Ambientes de las viviendas
% ambiente(Vivienda,Ambiente).

% Opción sin listas
ambiente(laSerevino,cuarto(4,8)).
ambiente(laSerevino,pasadizo).
ambiente(laSerevino,tunel(8)).
ambiente(laSerevino,tunel(5)).
ambiente(laSerevino,tunelEnConstruccion(1)).

% Opción con listas
/*
ambiente(Vivienda, Ambiente):-
    vivienda(Vivienda, Ambientes),
    member(Ambiente,Ambientes).
vivienda(laSeverino, [cuarto(4,8),pasadizo,tunel(8),tunel(5),tunelEnConstruccion(1)]).
*/

% Habilidades consideradas terroristas

% Opción sin listas
terrorista(armarBombas).
terrorista(encontrarVulnerabilidades).

% Opción con listas
/*
terroristas([armarBombas,encontrarVulnerabilidades]).
terroristas(Habilidad):-
    terroristas(Habilidades),
    member(Habilidad,Habilidades).
*/

% Ocupaciones militares

% Opción con simbolos comunes
esMilitar(aviacionMilitar).
esMilitar(inteligenciaMilitar).

% Interesante variante con functores
% modelando con hechos del estilo de
% trabajo(e234,trabajo(aviacion, militar)).
/*
esMilitar(trabajo(_,militar)).
*/


% Los habitantes

% Opción sin listas (con todas relaciones independientes)
%
% Permite que para cada característica (trabajo, gustos, habilidad o registro criminal) 
% cada habitante tenga uno, muchos o ningun dato.
% En el historial y los gustos está explícitamente indicado que la cantidad es variable. 
% En los trabajos y habilidades los ejemplos solo muestran un dato,
% por lo que si bien podría asumirse que siempre es así,
% también es valido pensar que la cantidad podria ser otra. 

trabajo(b570,ingenieriaMecanica).
trabajo(e234,aviacionMilitar).
trabajo(a013,inteligenciaMilitar).
trabajo(2682,hacker).

leGusta(b570,fuego).
leGusta(b570,destruccion).
leGusta(a013,juegosDeAzar).
leGusta(a013,ajedrez).
leGusta(a013,tiroAlBlanco).
leGusta(2682,phishing).

registroCriminal(e234,roboDeAeronaves).
registroCriminal(e234,fraude).
registroCriminal(e234,tenenciaDeCafeina).
registroCriminal(a013,falsificacionDeVacunas).
registroCriminal(a013,fraude).
registroCriminal(2682,vaciarCuentasBancarias).

habilidad(b570,armarBombas).
habilidad(e234,conducirAutos).
habilidad(a013,tiroAlBlanco).
habilidad(2682,encontrarVulnerabilidades).

% En esta opción es necesario armar una lista para obtener la cantidad de gustos
cantidadDeGustos(Alguien,Cant):-
    findall(_, leGusta(Alguien,_), Lista),
    length(Lista,Cant).


% Opción con listas (para actividad criminal y gustos) 
% 
% Asumiendo que todo habitante tiene un unico trabajo y habilidad,
% sólo se usan listas para las caracteristicas que puede haber muchos datos
% Hay un solo hecho con toda la info del habitante

/*
habitante(b570,ingenieriaMecanica,[fuego,destruccion],armarBombas,[]).
habitante(e234,aviacionMilitar,[],conducirAutos,[roboDeAeronaves,fraude,tenenciaDeCafeina]).
habitante(a013,inteligenciaMilitar,[juegosDeAzar,ajedrez,tiroAlBlanco],tiroAlBlanco,[falsificacionDeVacunas,fraude]).
habitante(2682,hacker,[phishing],encontrarVulnerabilidades,[vaciarCuentasBancarias]).

% Para las caraterísticas únicas queda muy simple 
% y se podría haber utilizado directamente el predicado habitante/5
trabajo(Alguien,Trabajo):-habitante(Alguien,Trabajo,_,_,_).
habilidad(Alguien,Habilidad):-habitante(Alguien,_,_,Habilidad,_).

% Para las caraterísticas multiples, agrega un manejo básico de listas
leGusta(Alguien,Gusto):-
    habitante(Alguien,_,Gustos,_,_),
    member(Gusto,Gustos).
registroCriminal(Alguien,RegistroCriminal):-
    habitante(Alguien,_,_,_,RegistrosCriminales),
    member(RegistroCriminal,RegistrosCriminales).

% En esta opción hay que averiguar la longitud la lista de gustos que ya se tiene
cantidadDeGustos(Alguien,Cant):-
    habitante(Alguien,_,Gustos,_,_),
    length(Gustos,Cant).
*/

% En un extremo, podría plantearse una tercera opción con listas para todas las características, 
% con sus correspondientes predicados auxiliares. 
/*
habitante(b570,[ingenieriaMecanica],[fuego,destruccion],[armarBombas],[]).
*/

% Otra opción es no usar listas, pero con menos predicados, asumiendo que trabajo, habilidad e incluso la vivienda es única. 
/*
habitante(b570,ingenieriaMecanica,armarBombas,laSeverina).
gustos(b570,fuego).
gustos(b570,destruccion).
registroCriminal(a013,falsificacionDeVacunas).
registroCriminal(a013,fraude).
*/

% Y otras posibles combinaciones de las variantes anteriores

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 5 - Ejemplos de consultas

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 6 - Inversibilidad 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 7 - Agregado de nuevos tipos de ambientes
/*
    Para agregar un nuevo ambiente solo debo saber agregarlo a la base de conocimiento
    y saber como calcular el tamaño de su superficie, conservando todo lo creado anteriormente.
    Por ejemplo:
    bunker(cantidadDeSecretrosGuardados).
    cuevas(cantidadDeEntradas,viajarEnElTiempo).

    calculo la superficie para el bunker como el triple de la cantidad de secretros que pueda guardar
    calculo la superficie para las cuevas como 5 metros cuadrados si la cantidad de entradas es mayor a 3 sino solo es un metro cuadrado
*/

superficie(bunker(Secretos),Superficie):-
    Superficie is Secretos * 2.
superficie(cueva(Entradas,viajarEnElTiempo),5):-
    Entradas > 3.
superficie(cueva(Entradas,viajarEnElTiempo),1):-
    Entradas =< 3.
    
% A las viviendas que tengan este tipo de ambiente se le deberia agregar la información
ambiente(laSerevino,cueva(5,viajarEnElTiempo)).
ambiente(laSerevino,bunker(8)).
    
/*
    Esto lo puedo hacer porque los tipos de ambientes son polimórficos, a todos les puedo
    consultar la superficie y de todos deducir un resultado, aunque cada ambiente tenga 
    un cálculo distinto, esto lo pude hacer usando functores y pattern matching para definir
    el cálculo de superficie de cada ambiente.
*/
    
