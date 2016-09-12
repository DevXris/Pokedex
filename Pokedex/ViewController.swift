//
//  ViewController.swift
//  Pokedex
//
//  Created by Chris Huang on 9/10/16.
//  Copyright © 2016 Chris Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collection: UICollectionView! {
        didSet {
            collection.delegate = self
            collection.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parsePokemonCSV()
    }
    
    // MARK: Properties
    
    var pokemon = [Pokemon]()
    
    // MARK: Functions
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows {
                guard let pokeId = Int(row["id"]!) else { return }
                guard let name = row["identifier"] else { return }
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            let poke = pokemon[indexPath.row]
            cell.configureCell(poke)
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }

}

