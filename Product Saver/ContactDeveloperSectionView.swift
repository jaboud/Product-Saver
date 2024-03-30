//
//  ContactDeveloperSectionView.swift
//  Product Saver
//
//  Created by Justin Aboud on 29/3/2024.
//

import SwiftUI

struct ContactDeveloperSectionView: View {

    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var isContactDeveloperOptionsActionSheetPresented = false
    @State private var isShowingCannotFindMailAppAlert = false

    var body: some View {
        Section(footer: Text("Your device details will be attached to the email for troubleshooting purposes if you choose to ask for application support. No personal data is collected or stored.")) {
            Button(action: {
                self.isContactDeveloperOptionsActionSheetPresented = true
            }) {
                Text("Contact Developer")
                    .foregroundColor(settingsViewModel.tintColors)
            }
        }
        .actionSheet(isPresented: $isContactDeveloperOptionsActionSheetPresented) {
            ActionSheet(title: Text("Contact Developer"), buttons: [
                .default(Text("Support")) {
                    self.sendEmail(includeDeviceDetails: true, subject: "Product Saver - Support")
                },
                .default(Text("Feedback")) {
                    self.sendEmail(includeDeviceDetails: false, subject: "Product Saver - Feedback")
                },
                .default(Text("Other")) {
                    self.sendEmail(includeDeviceDetails: false, subject: "")
                },
                .cancel()
            ])
        }
        .alert("Cannot find 'Mail' app", isPresented: $isShowingCannotFindMailAppAlert){
            Button("OK") {
                isShowingCannotFindMailAppAlert = false
            }
        }
    message:{
        Text("Alternatively, you can contact the developer at justin.aboud@icloud.com")
     }
    }

    func sendEmail(includeDeviceDetails: Bool, subject: String) {
        let email = "justin.aboud@icloud.com"
        var body = ""
        if includeDeviceDetails {
            let deviceDetails = getDeviceDetails()
            body = "\n\nDevice Details:\n\(deviceDetails)"
        }
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailURLString = "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)"
        guard let mailURL = URL(string: mailURLString) else {
            self.isShowingCannotFindMailAppAlert = true
            return
        }
        if !UIApplication.shared.canOpenURL(mailURL) {
            self.isShowingCannotFindMailAppAlert = true
        }
        UIApplication.shared.open(mailURL)
    }

    func getDeviceDetails() -> String {
        var details = ""

        let device = UIDevice.current
        let modelName = device.model
        let systemName = device.systemName
        let systemVersion = device.systemVersion
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"

        details += "Device Model: \(modelName)\n"
        details += "Operating System: \(systemName) \(systemVersion)\n"
        details += "Product Saver Version: \(appVersion)"
        return details
    }

}

#Preview {
    ContactDeveloperSectionView(settingsViewModel: SettingsViewModel())
}
