//
//  Image+CoreDataProperties.swift
//  
//
//  Created by Jogi Oktavianus on 05/11/20.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var imgDefault: Data?
    @NSManaged public var isWithAudio: Bool
    @NSManaged public var name: String?
    @NSManaged public var imgEdited: Data?

}
