//
//  ProductDetailView.swift
//  Product Saver
//
//  Created by Justin Aboud on 10/2/2024.
//

import SwiftUI
import SwiftData

struct ProductDetailView: View {
    var product: Product
    @Environment(\.modelContext) var context
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var isFullScreen = false
    @State private var lastOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var editProduct: Product?
    @State private var confirmProductDeletion = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                List {
                    Section(header: Label("Product Information", systemImage: "note.text")) {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Item Name", systemImage: "tag")
                                .foregroundColor(.gray)
                            Text(product.itemName.isEmpty ? "Mandatory item name is blank" : product.itemName)
                                .foregroundColor(product.itemName.isEmpty ? .red : .primary)
                            Divider()
                            Label("Brand Name", systemImage: "building")
                                .foregroundColor(.gray)
                            Text(product.brandName.isEmpty ? "Mandatory brand name is blank" : product.brandName)
                            Divider()
                                .foregroundColor(product.brandName.isEmpty ? .red : .primary)
                            Label("Category", systemImage: "folder")
                                .foregroundColor(.gray)
                            Text(product.category?.categoryName ?? "None")
                            Divider()
                            if !(product.desc?.isEmpty == true) || !settingsViewModel.isHidingBlankData {
                                Label("Description", systemImage: "doc.plaintext")
                                    .foregroundColor(.gray)
                                Text((product.desc?.isEmpty == true) ? "N/A" : (product.desc ?? "N/A"))
                                    .lineLimit(nil)
                                Divider()
                            }
                            if !(product.notes?.isEmpty == true) || !settingsViewModel.isHidingBlankData {
                                Label("Notes", systemImage: "square.and.pencil")
                                    .foregroundColor(.gray)
                                Text((product.notes?.isEmpty == true) ? "N/A" : (product.notes ?? "N/A"))
                                Text(product.notes ?? "")
                                    .lineLimit(nil)
                            }
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
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .onTapGesture {
                                        isFullScreen.toggle()
                                    }
                                    .fullScreenCover(isPresented: $isFullScreen) {
                                        ZStack {
                                            Color.black
                                                .ignoresSafeArea()

                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .edgesIgnoringSafeArea(.all)
                                                .gesture(DragGesture()
                                                    .onEnded { value in
                                                        let threshold: CGFloat = 100
                                                        if value.translation.height > threshold {
                                                            isFullScreen = false
                                                        }
                                                    }
                                                )
                                                .onTapGesture {
                                                    isFullScreen.toggle()
                                                }
                                        }
                                    }
                            }
                        }
                        else{
                            Text("No photo selected")
                                .foregroundStyle(.gray)
                        }
                    }

                    Section(header: Label("Modify Product", systemImage: "pencil")) {
                        Button("Edit Product") {
                            withAnimation {
                                editProduct = product
                            }
                        }
                        .foregroundColor(settingsViewModel.tintColors)
                        Button("Delete Product") {
                            confirmProductDeletion = true
                        }
                        .foregroundStyle(settingsViewModel.tintColors == .blue ? .red : settingsViewModel.tintColors)
                        .alert(isPresented: $confirmProductDeletion) {
                            Alert(title: Text("Delete Product"),
                                  message: Text("Are you sure you want to delete this product?"),
                                  primaryButton: .destructive(Text("Delete")) {
                                      withAnimation {
                                          context.delete(product)
                                          presentationMode.wrappedValue.dismiss()
                                      }
                                  },
                                  secondaryButton: .cancel())
                        }                    }

                }
                .sheet(item: $editProduct,
                       onDismiss: {
                    editProduct = nil
                },
                       content: { editData in
                    NavigationStack {
                        UpdateProductDetailsView(product: editData)
                            .interactiveDismissDisabled()
                    }
                })
                .navigationTitle("Product Details")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(Product.self)
    return ProductDetailView(product: Product.sampleProducts[4])
        .modelContainer(preview.container)
        .environmentObject(SettingsViewModel())
}
