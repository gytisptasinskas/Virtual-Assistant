//
//  PhotosPickerHelper.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 26/11/2023.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotosPickerHelper {
    static func loadImage(fromItem item: PhotosPickerItem?) async throws -> UIImage? {
        guard let item = item else { return nil }
        guard let data = try await item.loadTransferable(type: Data.self) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        return uiImage
    }
}
