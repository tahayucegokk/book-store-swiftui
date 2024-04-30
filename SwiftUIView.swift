//
//  SwiftUIView.swift
//  test4
//
//  Created by Taha Yücegök on 29.04.2024.
//

import SwiftUI

// MARK: - Ana Sayfa
/// Ürün detaylarının bulunduğu ana ekran
struct ShoppingPage: View {
    @State private var cartCount = 0
    @State private var selectedImageIndex = 0
    @State private var isCartPagePresented = false
    
    let productImages = ["goruntu1", "goruntu2", "goruntu3"] // Array of product images
    let KitapColor = Color.blue
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // Background color
            
            VStack {
                AppBar(cartCount: $cartCount, isCartPagePresented: $isCartPagePresented)
                ProductSlider(images: productImages, selectedIndex: $selectedImageIndex)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Elon Musk: Elon Musk's Best Lessons for Life, Business, Success and Entrepreneurship")
                        .font(.title)
                        .foregroundColor(Color.black)
                    
                    Text("100 TL")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                    
                    HStack {
                        ForEach(0..<5) { index in
                            Image(systemName: index < 5 ? "star.fill" : "star.leadinghalf.fill") // Star rating
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(index < 4 ? Color.yellow : Color.gray)
                        }
                    }
                    
                    Text("Yazan: Andrew Knight ")
                        .foregroundColor(Color.gray)
                        .lineLimit(3)
                        .font(.body)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 4)
                )
                .padding()
                Button(action: {
                    self.cartCount += 1
                }) {
                    Text("Sepete ekle")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(KitapColor)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding()
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isCartPagePresented) {
            CartPage(isCartPagePresented: $isCartPagePresented, cartCount: $cartCount)
        }
    }
}

// MARK: - Kategori ve Sepet
/// Kategori ve sepet için view
struct AppBar: View {
    @Binding var cartCount: Int
    @Binding var isCartPagePresented: Bool
    @State private var selectedCategoryIndex = 0
    @State private var categories = ["Kategoriler", "Kitap"]

    var body: some View {
        HStack {
            Picker("Categories", selection: $selectedCategoryIndex) {
                ForEach(categories.indices, id: \.self) { index in
                    Text(categories[index])
                        .foregroundColor(.black)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Spacer()
            
            Button(action: {
                isCartPagePresented.toggle()
            }) {
                Image(systemName: "cart")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .badge(count: cartCount)
        }
          .padding()
          Text("Ürünler")
          .font(.title)
          .bold()
          .foregroundColor(.black)
    }
}
// MARK: - Resim Kaydırma
/// Resimler arasında geçiş yapmamızı sağlar
struct ProductSlider: View {
    let images: [String]
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(0..<images.count) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 300)
            .padding(.horizontal)
            
            PageControl(numberOfPages: images.count, currentPage: $selectedIndex)
                .padding(.top, -20)
        }
    }
}

// MARK: - Resim Kontolcüsü
/// Hangi resimde olduğumuzu mavi yaparak göstermini sağlar
struct PageControl: View {
    let numberOfPages: Int
    @Binding var currentPage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(index == currentPage ? Color.blue : Color.gray)
            }
        }
        .padding(.bottom, 10)
    }
}

// MARK: - Sepet için bage oluşumu
/// Bu alan içerisinde her Sepete ekle butonuna tıklandığında
extension View {
    func badge(count: Int) -> some View {
        self.overlay(
            ZStack {
                if count > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 20, height: 20)
                        .offset(x: 15, y: -10)
                    
                    Text("\(count)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .offset(x: 15, y: -10)
                }
            }
        )
    }
}

// MARK: - Sepet Görünümü

/// Bu Alan içerisinde sepetin görünümü ayarlıyoruz
struct CartPage: View {
    @Binding var isCartPagePresented: Bool
    @State private var isOrderConfirmed = false
    @Binding var cartCount: Int
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sepetinizdeki Ürünler")
                    .font(.title3)
                    .padding()
                
              VStack(alignment: .leading, spacing: 8) {
                  Text("Elon Musk: Elon Musk's Best Lessons for Life, Business, Success and Entrepreneurship")
                      .font(.title3)
                      .foregroundColor(Color.black)
                  
                  Text("100 TL")
                      .font(.headline)
                      .foregroundColor(Color.gray)
                  
                  HStack {
                      ForEach(0..<5) { index in
                          Image(systemName: index < 5 ? "star.fill" : "star.leadinghalf.fill")
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 20, height: 20)
                              .foregroundColor(index < 4 ? Color.yellow : Color.gray)
                      }
                  }
                  
                  Text("Yazan: Andrew Knight ")
                      .foregroundColor(Color.gray)
                      .lineLimit(3)
                      .font(.body)
                  
                  HStack {
                      Text("Adet: \(cartCount)")
                          .foregroundColor(.white)
                          .padding(.vertical, 4)
                          .padding(.horizontal, 8)
                          .background(Color.blue)
                          .cornerRadius(8)
                      
                      Spacer()
                      
                      Button(action: {
                        cartCount += 1
                      }) {
                          Image(systemName: "plus.circle.fill")
                              .font(.title)
                              .foregroundColor(.blue)
                      }
                      .padding(.leading, 8)
                      
                      Button(action: {
                        cartCount -= 1
                      }) {
                          Image(systemName: "minus.circle.fill")
                              .font(.title)
                              .foregroundColor(.blue)
                      }
                      .padding(.trailing, 8)
                  }
              }
              .padding()
              .background(Color.gray.opacity(0.1))
              .cornerRadius(10)
              .shadow(color: Color.gray.opacity(0.4), radius: 5)
              .padding()
                Spacer()
                Button(action: {
                  isOrderConfirmed = true
                }) {
                    Text("Satın Al (\(cartCount) adet)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 50)
                .fullScreenCover(isPresented: $isOrderConfirmed, content: {
                  OrderConfirmationView(cartCount: $cartCount)
                })
            }
            .navigationBarTitle("Sepetim")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                isCartPagePresented = false
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Geri")
                }
            })
        }
    }
}

// MARK: - Onay Görünümü
struct OrderConfirmationView: View {
    @Binding var cartCount: Int
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.green)
                    .padding()
                
                Text("Siparişiniz Onaylandı")
                    .font(.title)
                    .padding()
                
                Text("Teşekkür ederiz! Siparişiniz başarıyla alındı.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                NavigationLink(destination: ShoppingPage()) {
                    Text("Anasayfa'ya Dön")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 50)
            }
        }
    }
}



// MARK: - Önizleme Yapısı
struct ShoppingPage_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingPage()
    }
}

