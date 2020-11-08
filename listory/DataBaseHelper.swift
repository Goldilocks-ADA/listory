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
    
    func addNewStory(name: String, isWithAudio: Bool, image: Data, drawing: Data, audioPath: String) -> Story {
        let storyInstance = Story (context: context)
        do {
            storyInstance.name = name
            storyInstance.isWithAudio = isWithAudio
            storyInstance.image = image
            storyInstance.drawing = drawing
            storyInstance.audioPath = audioPath
            try context.save()
            print("Image is saved")
        } catch {
            print("Error saving data \(error)", error.localizedDescription)
        }
        return storyInstance
    }
    
    func retrieveAllStories() -> [Story]? {
        let request: NSFetchRequest<Story> = Story.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error retrieving data \(error)")
        }
        return nil
    }
    
    func updateStory(name: String, isWithAudio: Bool, image: Data, drawing: Data, audioPath: String) -> Story {
        let request: NSFetchRequest<Story> = Story.fetchRequest()
        
        request.predicate = NSPredicate(format: "name = %@", name)
        var storyInstance = Story (context: context)
        do {
            let fetch = try context.fetch(request)
            let storyToUpdate = fetch[0] as NSManagedObject
            storyToUpdate.setValue(name, forKey: "String")
            storyToUpdate.setValue(isWithAudio, forKey: "isWithAudio")
            storyToUpdate.setValue(image, forKey: "image")
            storyToUpdate.setValue(drawing, forKey: "drawing")
            storyToUpdate.setValue(audioPath, forKey: "audioPath")
            try context.save()
            storyInstance = storyToUpdate as! Story
        } catch  {
            print("Update fail")
        }
        return storyInstance
    }
}