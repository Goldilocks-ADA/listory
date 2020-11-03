//
//  Foto+CoreDataProperties.swift
//  
//
//  Created by Jogi Oktavianus on 04/11/20.
//
//

import Foundation
import CoreData


extension Foto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Foto> {
        return NSFetchRequest<Foto>(entityName: "Foto")
    }

    @NSManaged public var image: Data?
    @NSManaged public var isWithAudio: Bool
    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}
