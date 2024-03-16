//
//  SettingsView.swift
//  Producg Saver
//
//  Created by Justin Aboud on 22/1/2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {

    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var showingAlert = false
    @State private var isActionSheetPresented = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: AppearanceSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Appearance", systemImage: "paintbrush")
                    }
                }
                Section {
                    NavigationLink(destination: ContentSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Content", systemImage: "list.bullet.rectangle")
                    }
                }
                Section {
                    NavigationLink(destination: DataSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Data", systemImage: "externaldrive")
                    }
                }

                Section(header: Label("About", systemImage: "info.circle")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Product Saver")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                        Image("Settings")
                            .frame(maxWidth: .infinity, alignment: .center)
                        VStack {
                            Text("Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown")")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                            Text("Est. 2024")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        Text("Designed and Developed by")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Justin Aboud")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                    }

                }
                Section(footer: Text("Your device details will be attached to the email for troubleshooting purposes if you choose to ask for application support. No personal data is collected or stored.")) {
                    Button(action: {
                        self.isActionSheetPresented = true
                    }) {
                        Text("Contact Developer")
                            .foregroundColor(settingsViewModel.tintColors)
                    }
                }
                .actionSheet(isPresented: $isActionSheetPresented) {
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

            }
            .navigationTitle("Settings")
            .accentColor(settingsViewModel.tintColors)
            .alert("Cannot find 'Mail' app", isPresented: $showingAlert){
                Button("OK") {
                    showingAlert = false
                }
            }
        message:{
            Text("Alternatively, you can contact the developer at justin.aboud@icloud.com")
         }
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
            self.showingAlert = true
            return
        }
        if !UIApplication.shared.canOpenURL(mailURL) {
            self.showingAlert = true
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
    SettingsView(settingsViewModel: SettingsViewModel())
}
