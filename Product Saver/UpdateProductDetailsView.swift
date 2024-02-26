//
//  UpdateDetailsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 15/1/2024.
//

import SwiftUI
import SwiftData
import PhotosUI

struct UpdateProductDetailsView: View {

    @Bindable var storedData: StoredData
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query private var categories: [Category]
    @State var selectedCategory: Category?
    @State var selectedPhoto: PhotosPickerItem?
    @State private var showValidationAlert = false
    @State private var isCameraPresented = false
    @State private var cameraImage: UIImage?
    @State private var isActionSheetPresented = false
    @State private var isPickerPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Required *")
                .foregroundColor(.gray)
                .font(.footnote)
                .padding(.leading, 15)

            List {
                Section(header: Text("Item and Brand Name")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Update Item Name*")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextField("Item Name", text: $storedData.itemName)
                        Text("Update Brand Name*")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextField("Brand Name", text: $storedData.brandName)
                        Text("Update Description")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextField("Description", text: Binding(
                            get: { self.storedData.desc ?? "" },
                            set: { self.storedData.desc = $0 }
                        ))
                        Text("Update Notes")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextField("Notes", text: Binding(
                            get: { self.storedData.notes ?? "" },
                            set: { self.storedData.notes = $0 }
                        ))
                    }
                }

                Section(header: Text("Category")) {
                    if categories.isEmpty {
                        ContentUnavailableView("No Categories", systemImage: "archivebox")
                    } else {
                        Picker("Category", selection: $selectedCategory) {
                            Text("None")
                                .tag(nil as Category?)
                            ForEach(categories) { category in
                                Text(category.categoryName)
                                    .tag(category as Category?)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.inline)
                    }
                }

                Section(header: Text("Photo")) {
                    if let selectedPhotoData = storedData.image,
                       let uiImage = UIImage(data: selectedPhotoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    }

                    Button(action: {
                        isActionSheetPresented = true
                    }) {
                        if storedData.image != nil{
                            Label("Re-upload Photo", systemImage: "camera")
                        }
                        else{
                            Label("Upload Photo", systemImage: "camera")
                        }
                    }
                    .actionSheet(isPresented: $isActionSheetPresented) {
                            ActionSheet(title: Text("Upload product photo"), buttons: [
                                .default(Text("Take Photo")) {
                                    isCameraPresented.toggle()
                                },
                                .default(Text("Choose Photo")) {
                                    isPickerPresented.toggle()
                                },
                                .cancel()
                            ])
                        }

                        .sheet(isPresented: $isCameraPresented) {
                            CameraImage(imageData: $storedData.image)
                        }

                        .photosPicker(isPresented: $isPickerPresented, selection: $selectedPhoto)

                    if storedData.image != nil {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPhoto = nil
                                storedData.image = nil
                            }
                        } label: {
                            Label("Remove Photo", systemImage: "xmark")
                                .foregroundStyle(.red)
                        }
                    }
                }

                Button("Update") {
                    withAnimation {
                        if !storedData.itemName.isEmpty && !storedData.brandName.isEmpty {
                            storedData.category = selectedCategory
                            dismiss()
                        } else {
                            showValidationAlert = true
                        }
                    }
                }
                .alert(isPresented: $showValidationAlert) {
                    Alert(title: Text("Missing required details"), message: Text("Please enter both item name and brand name."), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationTitle("Update Details")
        .onAppear(perform: {
            selectedCategory = storedData.category
        })
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                storedData.image = data
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }

}

#Preview {
    NavigationStack {
        let preview = PreviewContainer(StoredData.self)
        return UpdateProductDetailsView(storedData: StoredData.sampleProducts[4])
            .modelContainer(preview.container)
    }
}
