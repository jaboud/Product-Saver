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
                        TextEditor(text: Binding(
                            get: { self.storedData.desc ?? "" },
                            set: { self.storedData.desc = $0 }
                        ))
                        Text("Update Notes")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextEditor(text: Binding(
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

                Section(header: Text("Image")) {
                    if let selectedPhotoData = storedData.image,
                       let uiImage = UIImage(data: selectedPhotoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    }

                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        if storedData.image != nil {
                            Label("Re-upload Image", systemImage: "photo")
                        }
                        else{
                            Label("Upload Image", systemImage: "photo")
                        }
                    }

                    if storedData.image != nil {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPhoto = nil
                                storedData.image = nil
                            }
                        } label: {
                            Label("Remove Image", systemImage: "xmark")
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
        let preview = PreviewContainer(StoredData.self)
        return UpdateProductDetailsView(storedData: StoredData.sampleProducts[4])
            .modelContainer(preview.container)
}
