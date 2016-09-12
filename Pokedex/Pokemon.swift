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
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoText: String!
    
    var name: String { return _name ?? "" }
    var pokedexId: Int { return _pokedexId ?? 0 }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
    }
}
