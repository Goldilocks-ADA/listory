//
//  DataBaseHelper.swift
//  listory
//
//  Created by Jogi Oktavianus on 05/11/20.
//

import UIKit
import CoreData

class DataBaseHelper {
    
    static let shareInstance = DataBaseHelper()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addNewImage(name: String, isWithoutAudio: Bool, imgDefault: Data, imgEdited: Data) -> Image {
        let imageInstance = Image(context: context)
        do {
            imageInstance.name = name
            imageInstance.isWithAudio = isWithoutAudio
            imageInstance.imgDefault = imgDefault
            imageInstance.imgEdited = imgEdited
            try context.save()
            print("Image is saved")
        } catch {
            print("Error saving data \(error)", error.localizedDescription)
        }
        return imageInstance
    }
    
    func retrieveAllImage() -> [Image]? {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error retrieving data \(error)")
        }
        return nil
    }
}
