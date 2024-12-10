//
//  PhotoModel.swift
//  sem7project
//
//  Created by Mary Grishchenko on 18.09.2024.
//

import Foundation
import SwiftUI

struct PhotoTag: Identifiable, Codable {
    var id: Int
    var Name: String
}

struct Photo: Identifiable {
    let id = UUID()
    var Meta: MetaPhoto
    var Image: UIImage?
}

struct MetaPhoto: Identifiable, Codable {
    var id: Int
    var FileURL: URL
    var Name: String
    var Description: String
    var Tags: [PhotoTag]
    
    init(sURL: URL, name: String?, desc: String?, tags: [PhotoTag]) {
        self.id = 0
        self.FileURL = sURL
        self.Name = name ?? ""
        self.Description = desc ?? ""
        self.Tags = []
        tags.forEach {
            self.Tags.append($0)
        }
    }
    
    init(tmplt: tempPhoto, img: UIImage) {
        self.id = 0
        self.FileURL = tmplt.fileURL
        self.Name = tmplt.Name
        self.Description = tmplt.Description
        self.Tags = tmplt.Tags
    }
}

struct tempPhoto {
    var fileURL: URL
    var Name: String
    var Description: String
    var Tags: [PhotoTag]
    
    init(fileURL: URL, Name: String?, Description: String?, Tags: [PhotoTag]) {
        self.fileURL = fileURL
        self.Name = Name ?? ""
        self.Description = Description ?? ""
        self.Tags = []
        Tags.forEach {
            self.Tags.append($0)
        }
    }
    
    init() throws {
        self.fileURL = try tempPhoto.generateFilename()
        self.Name = ""
        self.Description = ""
        self.Tags = []
    }
    
    private static func generateFilename() throws -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let dateString = dateFormatter.string(from: Date())
        let filename = "file_\(dateString).png"
        return try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("images/\(filename)")
    }
}
