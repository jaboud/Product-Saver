//
//  ProductDetailView.swift
//  Product Saver
//
//  Created by Justin Aboud on 10/2/2024.
//

import SwiftUI
import SwiftData

struct ProductDetailView: View {
    var storedProduct: StoredProduct
    @Environment(\.modelContext) var context
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var isFullScreen = false
    @State private var lastOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var editStoredProduct: StoredProduct?
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
                            Text(storedProduct.itemName.isEmpty ? "Mandatory item name is blank" : storedProduct.itemName)
                                .foregroundColor(storedProduct.itemName.isEmpty ? .red : .primary)
                            Divider()
                            Label("Brand Name", systemImage: "building")
                                .foregroundColor(.gray)
                            Text(storedProduct.brandName.isEmpty ? "Mandatory brand name is blank" : storedProduct.brandName)
                            Divider()
                                .foregroundColor(storedProduct.brandName.isEmpty ? .red : .primary)
                            Label("Category", systemImage: "folder")
                                .foregroundColor(.gray)
                            Text(storedProduct.category?.categoryName ?? "None")
                            Divider()
                            if !(storedProduct.desc?.isEmpty == true) || !settingsViewModel.isHidingBlankData {
                                Label("Description", systemImage: "doc.plaintext")
                                    .foregroundColor(.gray)
                                Text((storedProduct.desc?.isEmpty == true) ? "N/A" : (storedProduct.desc ?? "N/A"))
                                    .lineLimit(nil)
                                Divider()
                            }
                            if !(storedProduct.notes?.isEmpty == true) || !settingsViewModel.isHidingBlankData {
                                Label("Notes", systemImage: "square.and.pencil")
                                    .foregroundColor(.gray)
                                Text((storedProduct.notes?.isEmpty == true) ? "N/A" : (storedProduct.notes ?? "N/A"))
                                Text(storedProduct.notes ?? "")
                                    .lineLimit(nil)
                            }
                        }
                    }
                    Section(header: Label("Photo", systemImage: "photo")) {
                        if let selectedPhotoData = storedProduct.image,
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

                    Section(header: Label("Modify Product", systemImage: "pencil")) {
                        Button("Edit Product") {
                            withAnimation {
                                editStoredProduct = storedProduct
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
                                          context.delete(storedProduct)
                                          presentationMode.wrappedValue.dismiss()
                                      }
                                  },
                                  secondaryButton: .cancel())
                        }                    }

                }
                .sheet(item: $editStoredProduct,
                       onDismiss: {
                    editStoredProduct = nil
                },
                       content: { editData in
                    NavigationStack {
                        UpdateProductDetailsView(storedProduct: editData)
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
    let preview = PreviewContainer(StoredProduct.self)
    return ProductDetailView(storedProduct: StoredProduct.sampleProducts[4])
        .modelContainer(preview.container)
        .environmentObject(SettingsViewModel())
}
