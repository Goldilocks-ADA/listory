//
//  DataBaseHelper.swift
//  listory
//
//  Created by Jogi Oktavianus on 04/11/20.
//

import Foundation
import UIKit
import CoreData

class DataBaseHelper{
    static let instance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImageInCoreData(at imgData: Data){
        let foto = NSEntityDescription.insertNewObject(forEntityName: "Foto", into: context) as! Foto
        foto.image = imgData
        do{
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getAllImages() -> [Foto]{
        var listoryContoller = [Foto]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Foto")
        do {
            listoryContoller = try context.fetch(fetchRequest) as! [Foto]
        } catch let error {
            print(error.localizedDescription)
        }
        return listoryContoller
    }
}
