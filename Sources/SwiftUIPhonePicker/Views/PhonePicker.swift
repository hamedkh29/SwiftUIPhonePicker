
//
//  File.swift
//
//
//  Created by Hamed Khosravi on 1/17/20.
//

import SwiftUI

public struct PhonePicker: View {
    @State var baseHeight: CGFloat = 30
    @State var baseHeightDelta: CGFloat = 1
    @State var countryIndex = 0
    @State var showingCountry = false
    @Binding var phoneCode: String
    @Binding var abbr: String?
    @Binding var countryName: String?
    @Binding var phone:String
    @ObservedObject var countryViewModel = SwiftUIPhonePickerCountryViewModel()
    var header:String = ""
    var placeHolder:String = ""
    public init(phoneCode: Binding<String>,phone: Binding<String>, abbr: Binding<String?>? = .constant(""), countryName: Binding<String?>? = .constant(""),header:String = "Pick",placeHolder:String = "Phone"){
        _phoneCode = phoneCode
        _phone = phone
        self.header = header
        self.placeHolder = placeHolder
        if abbr != nil {
            self._abbr = abbr!
        } else {
            self._abbr = Binding.constant(nil)
        }
        if countryName != nil {
            self._countryName = countryName!
        } else {
            self._countryName = Binding.constant(nil)
        }
        var index = 0
        if (abbr != nil){
        for item in self.countryViewModel.countries {
            if (self.abbr == item.code ){
                self._countryIndex = State(initialValue: index)
            }
            index = index + 1
        }
        }
    }
    public var body: some View {
                GeometryReader { geometry in
        ZStack {
            VStack{
                HStack {
                    Image(uiImage:self.countryViewModel.countries[self.countryIndex].flag).resizable().onTapGesture {
                             self.baseHeightDelta = 10
                              self.showingCountry = true
                         }.frame(minWidth: 0, maxWidth: 32)
                    Text(self.phoneCode).onTapGesture {
                        self.baseHeightDelta = 10
                         self.showingCountry = true
                    }
                    TextField(self.placeHolder, text: self.$phone).keyboardType(.phonePad)
                }
                
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: self.baseHeight, maxHeight: self.baseHeight,alignment: .top)
            if (self.showingCountry){
            SwiftUIBottomSheet(
                isOpen: self.$showingCountry,
                maxHeight: self.baseHeight * self.baseHeightDelta,
                onClose: self.onClose
            ) {
                VStack {
                    Button(action: {
                       withAnimation(.spring()){
                        self.onClose()
                       }
                    }
                       ) {
                        Text(self.header)
                    }
                    Picker(selection: self.$countryIndex,label:EmptyView()){
                        ForEach(0 ..< self.countryViewModel.countries.count){
                            Text(self.countryViewModel.countries[$0].name).tag($0)
                    }
                   }.labelsHidden() .pickerStyle(WheelPickerStyle())
                }
            }
            }
        }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: self.baseHeight * self.baseHeightDelta, maxHeight: self.baseHeight * self.baseHeightDelta)
//        .sheet(isPresented: $showingCountry) {
//            CountryDetails()
//        }
    }
    func onClose(){
        self.baseHeightDelta = 1
        self.showingCountry = false
        self.phoneCode = self.countryViewModel.countries[self.countryIndex].phoneCode
        self.abbr = self.countryViewModel.countries[self.countryIndex].code
        self.countryName = self.countryViewModel.countries[self.countryIndex].name
    }
}

public struct SwiftUIPhonePicker_Previews: PreviewProvider {
    public static var previews: some View {
        PhonePicker(phoneCode: .constant(""),phone: .constant(""), abbr: .constant(""), countryName: .constant(""))
    }
}
