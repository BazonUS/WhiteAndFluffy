//
//  FavoriteKeeper.swift
//  WhiteAndFluffy
//
//  Created by Aleksei Omelchenko on 30.10.2023.
//

import Foundation

final class FavoriteKeeper {
    
    // MARK: - Public Methods
    
    func loadAll() -> [FavoriteModel] {
        guard let models = UserDefaults.standard.data(forKey: ".FavoriteModel") else { return [] }
        do {
            return try JSONDecoder().decode([FavoriteModel].self, from: models)
        } catch {
            return []
        }
    }
    
    func save(_ model: FavoriteModel) {
        var newAll = loadAll()
        newAll.append(model)
        let data = try? JSONEncoder().encode(newAll)
        UserDefaults.standard.set(data, forKey: ".FavoriteModel")
    }
    
    func delete(_ model: FavoriteModel) {
        let data = try? JSONEncoder().encode(loadAll().filter({ $0.id != model.id }))
        UserDefaults.standard.set(data, forKey: ".FavoriteModel")
    }
}
