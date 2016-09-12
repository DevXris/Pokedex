//
//  Pokemon.swift
//  Pokedex
//
//  Created by Chris Huang on 9/10/16.
//  Copyright © 2016 Chris Huang. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoText: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLevel: String!
    private var _pokemonURL: String!
    
    var name: String { return _name ?? "" }
    var pokedexId: Int { return _pokedexId ?? 0 }
    var description: String { return _description ?? "" }
    var type: String { return _type ?? "" }
    var defense: String { return _defense ?? "" }
    var height: String { return _height ?? "" }
    var weight: String { return _weight ?? "" }
    var attack: String { return _attack ?? "" }
    var nextEvoText: String { return _nextEvoText ?? "" }
    var nextEvoName: String { return _nextEvoName ?? "" }
    var nextEvoId: String { return _nextEvoId ?? "" }
    var nextEvoLevel: String { return _nextEvoLevel ?? "" }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        _pokemonURL = URL_BASE + URL_POKEMON + "\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadCompleted) {
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let dict = response.result.value as? [String: AnyObject] {
                
                // parse weitght, height, attack, defense
                if let weight = dict["weight"] as? String,
                   let height = dict["height"] as? String,
                   let attack = dict["attack"] as? Int,
                   let defense = dict["defense"] as? Int {
                    self._weight = weight
                    self._height = height
                    self._attack = "\(attack)"
                    self._defense = "\(defense)"
                }
                
                // parse type
                if let types = dict["types"] as? [[String: String]], types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                // parse description
                if let descriptionArray = dict["descriptions"] as? [[String: String]], descriptionArray.count > 0 {
                    if let url = descriptionArray[0]["resource_uri"] {
                        let descriptionURL = URL_BASE + url
                        Alamofire.request(descriptionURL).responseJSON(completionHandler: { (response) in
                            if let descriptionDict = response.result.value as? [String: AnyObject] {
                                if let description = descriptionDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKEMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                // parse next evolutions info
                if let evolutions = dict["evolutions"] as? [[String: AnyObject]], evolutions.count > 0 {
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        if nextEvolution.range(of: "mega") == nil {
                            self._nextEvoName = nextEvolution
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon", with: "")
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                                self._nextEvoId = nextEvoId
                                
                                if let levelExist = evolutions[0]["level"] {
                                    if let level = levelExist as? Int {
                                        self._nextEvoLevel = "\(level)"
                                    }
                                } else {
                                    self._nextEvoLevel = ""
                                }
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
}
