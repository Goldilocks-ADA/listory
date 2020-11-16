//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Jogi Oktavianus on 16/11/20.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?

}
