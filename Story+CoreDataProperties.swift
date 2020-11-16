//
//  Story+CoreDataProperties.swift
//  
//
//  Created by Jogi Oktavianus on 16/11/20.
//
//

import Foundation
import CoreData


extension Story {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Story> {
        return NSFetchRequest<Story>(entityName: "Story")
    }

    @NSManaged public var audioDuration: Double
    @NSManaged public var audioPath: String?
    @NSManaged public var drawing: Data?
    @NSManaged public var id: String?
    @NSManaged public var image: Data?
    @NSManaged public var isWithAudio: Bool
    @NSManaged public var name: String?

}
