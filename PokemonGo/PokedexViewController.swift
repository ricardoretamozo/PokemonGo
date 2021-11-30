//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by ricardo on 11/29/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var pokemonsAtrapados:[Pokemon] = []
    var pokemonsNoAtrapados:[Pokemon] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonsAtrapados = obtenerPokemonsAtrapados()
        pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return pokemonsAtrapados.count
        }else{
            return pokemonsNoAtrapados.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        let pokemon:Pokemon
        if indexPath.section == 0 {
            pokemon = pokemonsAtrapados[indexPath.row]
        }else {
            pokemon = pokemonsNoAtrapados[indexPath.row]
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon.nombre! + "\(pokemon.cantidad)"
        cell.imageView?.image = UIImage(named: pokemon.imagenNombre!)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Atrapados"
        }else{
            return "No Atrapados"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath ) {
        if indexPath.section == 0 {
            if editingStyle == .delete{
                let pokemon = pokemonsAtrapados[indexPath.row]
                pokemon.cantidad -= 1
                if pokemon.cantidad == 0 {
                    pokemon.atrapado = false
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                print(pokemon)
                print("eliminando pokemon captudaro.")
                viewWillAppear(true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pokemonsAtrapados = obtenerPokemonsAtrapados()
        pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
        self.tableView.reloadData()
    }

}
