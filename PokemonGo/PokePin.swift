//
//  PokePin.swift
//  PokemonGo
//
//  Created by ricardo on 11/30/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PokePin:NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var pokemon:Pokemon
    init(coord: CLLocationCoordinate2D , pokemon:Pokemon){
        self.coordinate = coord
        self.pokemon = pokemon 
    }
}
