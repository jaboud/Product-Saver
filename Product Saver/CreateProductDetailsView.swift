//
//  CreateView.swift
//  Product Saver
//
//  Created by Justin Aboud on 15/1/2024.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreateProductDetailsView: View {

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query private var categories: [Category]
    @State var selectedCategory: Category?
    @State var selectedPhoto: PhotosPickerItem?
    @State private var storedData = StoredData()
    @State private var showValidationAlert = false
    @State private var isCameraPresented = false
    @State private var image: UIImage?
    @State private var isActionSheetPresented = false
    @State private var isPickerPresented = false


    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Required *")
                .foregroundColor(.gray)
                .padding(.leading, 15)
            List {
                Section(header: Label("Product Details", systemImage: "info.circle")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Item Name*", systemImage: "tag")
                            .foregroundColor(.gray)
                            TextField("Enter Item name...", text: $storedData.itemName)
                        Divider()
                        Label("Brand Name*", systemImage: "building")
                            .foregroundColor(.gray)
                        TextField("Enter Brand name...", text: $storedData.brandName)
                        Divider()
                        Label("Description", systemImage: "doc.text")
                            .foregroundColor(.gray)
                            TextField("Enter Product Description...", text: Binding(
                                get: { self.storedData.desc ?? "" },
                                set: { self.storedData.desc = $0 }
                            ))
                        Divider()
                        Label("Notes", systemImage: "square.and.pencil")
                            .foregroundColor(.gray)
                            TextField("Enter Product Notes...", text: Binding(
                                get: { self.storedData.notes ?? "" },
                                set: { self.storedData.notes = $0 }
                            ))
                            .lineLimit(nil)
                    }
                }

                Section(header: Label("Category", systemImage: "folder")) {
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

                Section(header: Label("Photo", systemImage: "photo")) {
                    if let selectedPhotoData = storedData.image,
                       let uiImage = UIImage(data: selectedPhotoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    }
                }

                Section(header: Label("Photo Options", systemImage: "camera")) {
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

                Button("Create Product") {
                    withAnimation {
                        if !storedData.itemName.isEmpty && !storedData.brandName.isEmpty {
                            save()
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
        .navigationTitle("Create Product Details")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                storedData.image = data
            }
        }
    }

    
}

private extension CreateProductDetailsView {
    func save() {
        guard !storedData.itemName.isEmpty && !storedData.brandName.isEmpty else {
            showValidationAlert = true
            return
        }

        context.insert(storedData)
        storedData.category = selectedCategory
        selectedCategory?.storedDatas?.append(storedData)
    }
}

#Preview {
    NavigationStack{
        let preview = PreviewContainer(StoredData.self)
        return CreateProductDetailsView()
            .modelContainer(preview.container)
    }
}
