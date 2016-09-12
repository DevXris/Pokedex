//
//  Pokemon.swift
//  Pokedex
//
//  Created by Chris Huang on 9/10/16.
//  Copyright © 2016 Chris Huang. All rights reserved.
//

import Foundation

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    
    var name: String { return _name ?? "" }
    var pokedexId: Int { return _pokedexId ?? 0 }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
    }
}
