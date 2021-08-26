//
//  PersistanceManager.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 26.08.2021.
//

import UIKit
import CoreData

class FoodPersistanceManager{
    
    static let shared = FoodPersistanceManager()
    
    private init() {
    }
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    func fetchAddresses(completion: @escaping (Result<[FoodOrderMO], Error>) -> Void){
        do {
            let addresses = try! context.fetch(FoodOrderMO.fetchRequest()) as [FoodOrderMO]
            completion(.success(addresses))
        }
    }
    
    func saveCoreDataInstance(product: Product?, qty: Int){
        let saveContext = FoodPersistanceManager.shared.context
        guard qty != 0 else {
            print("qty should not be 0")
            return
        }
        guard let data = product else {
            print("invalid data")
            return
        }
        let foodCoreDataInstance            = FoodOrderMO(context: saveContext)
        foodCoreDataInstance.qty            = Int64(qty)
        foodCoreDataInstance.id             = Int64(data.id ?? 0)
        foodCoreDataInstance.name           = data.name
        foodCoreDataInstance.price          = Int64(data.price ?? 0)
        foodCoreDataInstance.hit            = Int64(data.hit ?? 0)
        foodCoreDataInstance.composition    = data.composition
        foodCoreDataInstance.weight         = Int64(data.weight ?? 0)
        foodCoreDataInstance.unit           = data.unit
        foodCoreDataInstance.producing      = data.producing
        foodCoreDataInstance.image          = data.icon
        
        FoodPersistanceManager.shared.saveContext()
        
        
        
    }
    
    
    
    func saveContext(){
        do {
            try self.context.save()
        } catch let error {
            print(error)
        }
    }
}

