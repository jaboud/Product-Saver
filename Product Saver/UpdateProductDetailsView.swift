//
//  UpdateProductDetailsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 15/1/2024.
//

import SwiftUI
import SwiftData
import PhotosUI

struct UpdateProductDetailsView: View {

    @Bindable var product: Product
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settingsViewModel: SettingsViewModel
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
                .padding(.leading, 15)

            List {
                Section(header: Label("Product Information", systemImage: "note.text")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Item Name*", systemImage: "tag")
                            .foregroundColor(.gray)
                            TextField("Enter Item name...", text: $product.itemName)
                        Divider()
                        Label("Brand Name*", systemImage: "building")
                            .foregroundColor(.gray)
                        TextField("Enter Brand name...", text: $product.brandName)
                        Divider()
                        Label("Description", systemImage: "doc.plaintext")
                            .foregroundColor(.gray)
                            TextField("Enter Product Description...", text: Binding(
                                get: { self.product.desc ?? "" },
                                set: { self.product.desc = $0 }
                            ))
                        Divider()
                        Label("Notes", systemImage: "square.and.pencil")
                            .foregroundColor(.gray)
                            TextField("Enter Product Notes...", text: Binding(
                                get: { self.product.notes ?? "" },
                                set: { self.product.notes = $0 }
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
                    if product.image != nil {
                        if let selectedPhotoData = product.image,
                           let uiImage = UIImage(data: selectedPhotoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                        }
                    }
                    else{
                        Text("No photo selected")
                            .foregroundStyle(.gray)
                    }
                }

                Section(header: Label("Photo Options", systemImage: "camera")) {
                    Button(action: {
                        isActionSheetPresented = true
                    }) {
                        if product.image != nil{
                            Label("Re-upload Photo", systemImage: "camera")
                        }
                        else{
                            Label("Upload Photo", systemImage: "camera")
                        }
                    }
                    .foregroundStyle(settingsViewModel.tintColors)
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
                            CameraImage(imageData: $product.image)
                        }

                        .photosPicker(isPresented: $isPickerPresented, selection: $selectedPhoto)

                    if product.image != nil {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPhoto = nil
                                product.image = nil
                            }
                        } label: {
                            Label("Remove Photo", systemImage: "xmark")
                                .foregroundStyle(settingsViewModel.tintColors == .blue ? .red : settingsViewModel.tintColors)
                        }
                    }
                }

                Button("Update Product") {
                    withAnimation {
                        if !product.itemName.isEmpty && !product.brandName.isEmpty {
                            product.category = selectedCategory
                            dismiss()
                        } else {
                            showValidationAlert = true
                        }
                    }
                }
                .foregroundStyle(settingsViewModel.tintColors)
                .alert(isPresented: $showValidationAlert) {
                    Alert(title: Text("Missing required details"), message: Text("Please enter both item name and brand name."), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationTitle("Update Product Details")
        .onAppear(perform: {
            selectedCategory = product.category
        })
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                product.image = data
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(settingsViewModel.tintColors)
            }
        }
    }

}

#Preview {
    NavigationStack {
        let preview = PreviewContainer(Product.self)
        return UpdateProductDetailsView(product: Product.sampleProducts[4])
            .modelContainer(preview.container)
            .environmentObject(SettingsViewModel())
    }
}
