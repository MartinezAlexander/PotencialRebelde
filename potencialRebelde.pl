% Punto 1
%para mayor facilidad solo uso los ultimos 4 digitos del nombre hasheado
%fichaCiudadano(NombreHasheado,Profesion,Gustos,Habilidad,HistorialCriminal).
fichaCiudadano(b570,ingenieriaMecanica,[fuego,destruccion],armarBombas,[]).
fichaCiudadano(e234,aviacionMilitar,[],conducirAutos,[roboDeAeronaves,fraude,tenenciaDeCafeina]).
fichaCiudadano(a013,inteligenciaMilitar,[juegosDeAzar,ajedrez,tiroAlBlanco],tiroAlBlanco,[falsificacionDeVacunas,fraude]).
fichaCiudadano(2682,hacker,[phishing],encontrarVulnerabilidades,[vaciarCuentasBancarias]).
fichaCiudadano(a4d9,programador,[],_,[]).


%viveEn(NombreHasheado,NombreDeCasa).
viveEn(laSerevino,b570).
viveEn(laSerevino,e234).
viveEn(laSerevino,a4d9).

/*
EstructuraDeOcultamiento
    cuartoSecreto(Largo,Ancho).
    tunelSecreto(Longitud,EstadoDeConstruccion).
    pasadizo.
*/
% superficie(EstructuraDeOcultamiento,TamanioEnMetrosCuadrados). polimorfismo con functores
superficie(pasadizo,1).
superficie(cuartoSecreto(Largo,Ancho),MetrosCuadrados):-
    MetrosCuadrados is Largo*Ancho.
superficie(tunelSecreto(Longitud,terminado),MetrosCuadrados):-
    MetrosCuadrados is Longitud*2.
% superficie(tunelSecreto(_,enConstruccion),0). podria ponerse pero como suma cero es lo mismo a no ponerlo


% vivienda(NombreVivienda,EstructuraDeOcultamiento).
vivienda(laSerevino,cuartoSecreto(4,8)).
vivienda(laSerevino,pasadizo).
vivienda(laSerevino,tunelSecreto(8,terminado)).
vivienda(laSerevino,tunelSecreto(5,terminado)).
vivienda(laSerevino,tunelSecreto(1,enConstruccion)).

% Punto 4
viviendasConPotencialRebelde(Vivienda):-
    viveEn(Vivienda,Alguien),
    esDisidente(Alguien),
    superficieDestinadaAActividadClandestinas(Vivienda,SuperficieEnMetrosCuadrados),
    SuperficieEnMetrosCuadrados > 50,!.

superficieDestinadaAActividadClandestinas(Vivienda,SuperficieEnMetrosCuadrados):-
    findall(MetrosCuadrados,(vivienda(Vivienda,EstructuraDeOcultamiento),superficie(EstructuraDeOcultamiento,MetrosCuadrados)),ListaSuperficies),
    sumlist(ListaSuperficies, SuperficieEnMetrosCuadrados).
    
% Punto 2
esDisidente(Alguien):-
    fichaCiudadano(Alguien,Trabajo,Gustos,Habilidad,_),
    habilidadEsConsideradaTerrorista(Habilidad),
    not(esUnTrabajoMilitar(Trabajo)),
    sonGustosYHabilidadCaracteristicoDeUnDisidente(Gustos,Habilidad),
    viveEn(Vivienda,Alguien),
    viviendaTieneAlguienConMasDeUnRegistroCriminal(Vivienda),!.
    

habilidadEsConsideradaTerrorista(armarBombas).
habilidadEsConsideradaTerrorista(encontrarVulnerabilidades).

esUnTrabajoMilitar(aviacionMilitar).
esUnTrabajoMilitar(inteligenciaMilitar).

viviendaTieneAlguienConMasDeUnRegistroCriminal(Vivienda):-
    viveEn(Vivienda,Alguien),
    cantidadDeRegistrosCriminales(Alguien,CantidadRegistros),
    CantidadRegistros > 1.

cantidadDeRegistrosCriminales(Alguien,CantidadRegistros):-
    fichaCiudadano(Alguien,_,_,_,RegistrosCriminales),
    length(RegistrosCriminales, CantidadRegistros).

sonGustosYHabilidadCaracteristicoDeUnDisidente([],_).

sonGustosYHabilidadCaracteristicoDeUnDisidente(Gustos,_):-
    length(Gustos, CantidadDeGustos),
    CantidadDeGustos > 3.

sonGustosYHabilidadCaracteristicoDeUnDisidente(Gustos,Habilidad):-
    member(Gustos,Habilidad).


% Punto 3
viviendaSinHabitantes(Vivienda):-
    vivienda(Vivienda,_),
    not(viveEn(Vivienda,_)).

viviendaConHabitantesConUnGustoComun(Vivienda):-
    viveEn(Vivienda,Alguien),
    meGusta(Algo,Alguien),
    forall(( viveEn(Vivienda,Otro),meGusta(Algo2,Otro), Alguien\=Otro ), Algo == Algo2).

meGusta(Algo,Alguien):-
    fichaCiudadano(Alguien,_,Gustos,_,_),
    member(Gustos, Algo).

% Punto 5 - Ejemplos de consultas

% Punto 6 - Inversibilidad -> Total y parcial


% Punto 7 - Agregado de un nuevo ambiente
/*
    Para agregar un nuevo ambiente solo debo saber agregarlo a la base de conocimiento
    y saber como calcular el tamaño de su superficie y tambien agregarlo, conservando
    todo lo creado anteriormente, ejemplo:
    bunker(cantidadDeSecretrosGuardados).
    cuevas(cantidadDeEntradas,viajarEnElTiempo).

    calculo la superficie para el bunker como el triple de la cantidad de secretros que pueda guardar
    calculo la superficie para las cuevas como 5 metros cuadrados si la cantidad de entradas es mayor a 3 sino solo es un metro cuadrado

    lo que deberia hacer es lo siguiente:
    superficie(bunker(CantidadDeSecretosGuardados),SuperficienEnMetrosCuadrados):-
        SuperficienEnMetrosCuadrados is CantidadDeSecretosGuardados * 2.
    superficie(cueva(CantidadDeEntradas,viajarEnElTiempo),5):-
        CantidadDeEntradas > 3.
    superficie(cueva(cantidadDeEntradas,viajarEnElTiempo),1):-
        CantidadDeEntradas < 3.

    A la vivienda que tenga este tipo de ambiente se le deberia agregar dicho ambiente
    vivienda(laSerevino,cueva(5,viajarEnElTiempo)).
    vivienda(laSerevino,bunker(8)).

    Esto lo puedo hacer porque los tipos de ambientes son polimorficos, a todos les puedo
    consultar la superficie y de todos obtendre un resultado, aunque cada ambiente tenga 
    un calculo distinto, esto lo pude hacer usando functores y pattern matching para definir
    el calculo de superficie de cada ambiente.
*/