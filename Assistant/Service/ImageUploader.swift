//
//  ImageUploader.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 26/11/2023.
//

import UIKit
import Firebase
import FirebaseStorage

enum ImageUploadType {
    case profile
    
    var filePath: StorageReference {
        let filename = NSUUID().uuidString
        
        switch self {
        case .profile:
            return Storage.storage().reference(withPath: "/profile_images/\(filename)")
        }
    }
}
    
    struct ImageUploader {
        static func uploadImage(image: UIImage, type: ImageUploadType) async throws -> String? {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
            let filename = NSUUID().uuidString
            let ref = type.filePath
            
            do {
                let _ = try await ref.putDataAsync(imageData)
                let url = try await ref.downloadURL()
                return url.absoluteString
            } catch {
                print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
                return nil
            }
        }
    }
