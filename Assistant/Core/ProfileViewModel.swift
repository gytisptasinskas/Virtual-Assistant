//
//  ProfileViewModel.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 26/11/2023.
//

import SwiftUI
import PhotosUI

class ProfileViewModel: ObservableObject {
    @Published var profileImage: Image?
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                try await loadImage()
            }
        }
    }
    
    @MainActor
    func loadImage() async throws {
        guard let uiImage = try await PhotosPickerHelper.loadImage(fromItem: selectedItem) else { return }
        profileImage = Image(uiImage: uiImage)
        try await updateUserProfileImage(uiImage)
    }
    
    func updateUserProfileImage(_ uiImage: UIImage) async throws {
        guard let imageUrl = try? await ImageUploader.uploadImage(image: uiImage, type: .profile) else { return }
        try await UserService.shared.updateUserProfileImageUrl(imageUrl)
    }
}

enum AboutSection: Int, CaseIterable, Identifiable {
    case helpCenter
    case termsOfUse
    case privacyPolicy
    case licenses
    case appVersion
    case buildVersion
    var id: Int { return self.rawValue }
    
    var title: String {
        switch self {
        case .helpCenter:
            return "Help Center"
        case .termsOfUse:
            return "Terms of Use"
        case .privacyPolicy:
            return "Privacy Policy"
        case .licenses:
            return "Licenses"
        case .appVersion:
            return "App Version:"
        case .buildVersion:
            return "Build Version:"
            
        }
    }
    
    var imageName: String {
        switch self {
        case .helpCenter:
            return "questionmark.circle.fill"
        case .termsOfUse:
            return "newspaper.fill"
        case .privacyPolicy:
            return "lock.fill"
        case .licenses:
            return "book.closed.fill"
        case .appVersion:
            return "app.badge.fill"
        case .buildVersion:
            return "hammer.fill"
        }
    }
    
    var description: String {
        switch self {
        case .appVersion:
            return "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown")"
        case .buildVersion:
            return "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown")"
        default:
            return ""
        }
    }
    
    var url: URL? {
        switch self {
        case .helpCenter:
            return URL(string: "https://help.openai.com/en/")
        case .termsOfUse:
            return URL(string: "https://openai.com/policies/terms-of-use")
        case .privacyPolicy:
            return URL(string: "https://openai.com/policies/privacy-policy")
        case .licenses:
            return URL(string: "https://github.com/gytisptasinskas")
        default:
            return nil
        }
    }
}
