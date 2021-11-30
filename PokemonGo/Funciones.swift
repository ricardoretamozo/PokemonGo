//
//  Funciones.swift
//  PokemonGo
//
//  Created by ricardo on 11/29/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func crearPokemon(xnombre:String, ximagenNombre:String){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.nombre = xnombre
    pokemon.imagenNombre = ximagenNombre
}

func agregarPokemons(){
    crearPokemon(xnombre: "Mew", ximagenNombre: "mew")
    crearPokemon(xnombre: "Meowth", ximagenNombre: "meowth")
    crearPokemon(xnombre: "Abra", ximagenNombre: "abra")
    crearPokemon(xnombre: "Bullbasaur", ximagenNombre: "bullbasaur")
    crearPokemon(xnombre: "Dratini", ximagenNombre: "dratini")
    crearPokemon(xnombre: "Eevee", ximagenNombre: "eevee")
    crearPokemon(xnombre: "Mankey", ximagenNombre: "mankey")
    crearPokemon(xnombre: "Pikachu", ximagenNombre: "pikachu")
    crearPokemon(xnombre: "Psyduck", ximagenNombre: "psyduck")
    crearPokemon(xnombre: "Rattata", ximagenNombre: "rattata")
    crearPokemon(xnombre: "Snorlax", ximagenNombre: "snorlax")
    crearPokemon(xnombre: "Squirtle", ximagenNombre: "squirtle")
    crearPokemon(xnombre: "Venonat", ximagenNombre: "venonat")
    crearPokemon(xnombre: "Weedle", ximagenNombre: "weedle")
    crearPokemon(xnombre: "Zubat", ximagenNombre: "zubat")
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func obtenerPokemon()-> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do{
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0{
            agregarPokemons()
            return obtenerPokemon()
        }
        return pokemons
    }catch{}
    return[]
}

func obtenerPokemonsAtrapados() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConwhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryConwhere.predicate = NSPredicate(format: "atrapado == %@", NSNumber (value: true))
    do{
        let pokemons = try context.fetch(queryConwhere) as [Pokemon]
        return pokemons
    }catch{}
    return []
}

func obtenerPokemonsNoAtrapados() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConwhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    print(queryConwhere)
    queryConwhere.predicate = NSPredicate(format: "atrapado == %@", NSNumber (value: false))
    print(queryConwhere)
    do{
        let pokemons = try context.fetch(queryConwhere) as [Pokemon]
        print(pokemons)
        return pokemons
    }catch{}
    return []
}
