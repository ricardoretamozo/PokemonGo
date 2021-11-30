//
//  ViewController.swift
//  PokemonGo
//
//  Created by ricardo on 11/29/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    var ubicacion = CLLocationManager()
    
    var conActualizaciones = 0
    var pokemons:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ubicacion.delegate = self
        pokemons = obtenerPokemon()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setup()
        }else{
            ubicacion.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if conActualizaciones<1{
            let region = MKCoordinateRegion.init(center: ubicacion.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            conActualizaciones += 1
            
        } else {
            ubicacion.stopUpdatingLocation()
        }
        //print("ubicacion actulizada")
    }
    
    

    @IBAction func centrarTapped(_ sender: Any) {
        if let coord = ubicacion.location?.coordinate{
                   let region = MKCoordinateRegion.init(center: ubicacion.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                   mapView.setRegion(region, animated: true)
                   conActualizaciones += 1
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            let pinview = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinview.image = UIImage(named: "player")
            var frame = pinview.frame
            frame.size.height = 50
            frame.size.width = 50
            pinview.frame = frame
            return pinview
        }
        
        let pinview = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        //pinview.image = UIImage(named: "mew")
        let pokemon = (annotation as! PokePin).pokemon
        pinview.image = UIImage(named: pokemon.imagenNombre!)
        var frame = pinview.frame
        frame.size.height = 50
        frame.size.width = 50
        pinview.frame = frame
        return pinview
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation{
            return
        }
        let region = MKCoordinateRegion.init(center:(view.annotation?.coordinate)!, latitudinalMeters: 500,longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in
            if let coord = self.ubicacion.location?.coordinate{
                let pokemon = (view.annotation as! PokePin).pokemon
                
                if mapView.visibleMapRect.contains(MKMapPoint(coord)){
                    if pokemon.cantidad == 0 {
                        print("Puede atrapar el pokemon")
                        //let pokemon = (view.annotation as! PokePin).pokemon
                        pokemon.atrapado = true
                        pokemon.cantidad += 1
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        mapView.removeAnnotation(view.annotation!)
                        //mensaje al atrapar pokemon
                        let alertVC = UIAlertController(title: "Felicidades!!!", message: "Atrapaste el pokemon (\(pokemon.nombre!))", preferredStyle: .alert)
                        let pokedexAccion = UIAlertAction(title: "ver Pokedex", style: .default, handler: {(action) in
                            self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                        })
                        alertVC.addAction(pokedexAccion)
                        let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertVC.addAction(okAccion)
                        self.present(alertVC, animated: true, completion: nil)
                    }else{
                        //mensaje al atrapar pokemon repetido
                        let alertVC = UIAlertController(title: "Ya tienes a ese pokemon(\(pokemon.nombre!))!!!", message: "¿aún así deseas capturarlo?", preferredStyle: .alert)
                        let pokedexAccion = UIAlertAction(title: "Si", style: .default, handler: {(action) in
                            pokemon.cantidad += 1
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            mapView.removeAnnotation(view.annotation!)
                        })
                        alertVC.addAction(pokedexAccion)
                        let okAccion = UIAlertAction(title: "No", style: .default, handler: nil)
                        alertVC.addAction(okAccion)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                    
                }else{
                    print ("No se puede atrapar el pokemon")
                    let alertaVC = UIAlertController(title: "Upss. Esta muy lejos", message: "No puedo atrapar el pokemon(\(pokemon.nombre!)).", preferredStyle: .alert)
                    let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertaVC.addAction(okAccion)
                    self.present(alertaVC, animated: true, completion: nil)
                    
                }
            }
        }
        //print("PIN presionado!")
    }
    
    func setup(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        ubicacion.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {  (timer) in
            if let coord = self.ubicacion.location?.coordinate{
                //let pin = MKPointAnnotation()
                //pin.coordinate = coord
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let pin = PokePin(coord: coord, pokemon: pokemon)
                let randomLat = (Double(arc4random_uniform(200))-100.0)/5000.0
                let randomLon = (Double(arc4random_uniform(200))-100.0)/5000.0
                pin.coordinate.latitude += randomLat
                pin.coordinate.longitude += randomLon
                self.mapView.addAnnotation(pin)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            setup()
        }
    }
    
}

