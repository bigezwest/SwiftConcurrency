//
//  StructClassActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/3/25.
//

/*
 Links:
 https://blog.onewayfirst.com/ios/post...
 https://stackoverflow.com/questions/2...
   / swift-basics-struct-vs-class
 https://stackoverflow.com/questions/2...
 https://stackoverflow.com/questions/2...
 https://stackoverflow.com/questions/2...
 https://www.backblaze.com/blog/whats-...
   / automatic-reference-counting-in-swift-arc-...
 
 VALUE TYPES:
 - Struct, Enum, String, Int, etc
 - Stored in the Stack
 - Faster
 - Thread safe!
 - When you assign or pass value type, a new copy of the data is created.
 
 REFERNCE TYPES:
 - Class, Function, Actor
 - Stored in the Heap
 - Slower, but synchronized
 - NOT Thread Safe
 - When you assign or pass a reference type, a new refeerence to the original instance will be created (pointer)
 
 - - - - - - - - - - - - - - -
 
 STACK:
 - Stores Value types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
 - Each Threa has its own Stack
 
 HEAP:
 - Stores reference types
 - Shared across threads
 
 - - - - - - - - - - - - - - -
 
 STRUCT:
 - Based on VALUES
 - Can be mutated
 - Stored in the Stack
 
 CLASSES:
 - Based on REFERENCES (INSTANCES)
 - Stored in the HEAP
 - Inherit from other Classes
 
 ACTORS:
 - Same as Class, but thread safe
 
 - - - - - - - - - - - - - - -
 
 WHEN TO USE
 Structs: Data Models, Views
 Classes: ViewModels
 Actors: Shared (Manager) Classes and Data Stores
 
 
 
 */

import SwiftUI

class StructClassActorBootcampViewModel: ObservableObject {
    @Published var title: String = ""
    init() {
        print("ViewModel Init")
    }
}

struct StructClassActorBootcamp: View {
    
    @StateObject private var viewModel = StructClassActorBootcampViewModel()
    let isActive: Bool
    
    init (isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue)
            .onAppear {
//                runTest()
            }
    }
}

struct StructClassActorBootcampHomeView: View {
    @State private var isActive: Bool = false
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

#Preview {
    StructClassActorBootcamp(isActive: true)
}

struct MyStruct {
    var title: String
}

extension StructClassActorBootcamp {
    private func runTest() {
        print("Test Started! ")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
//        structTest2()
//        printDivider()
//        classTest2()
    }
    private func printDivider() {
        print("""
                
                -----------------------
                
                """)
    }
    private func structTest1() {
        print("structTest1")
        let objectA = MyStruct(title: "Starting Title!")
        print("Object A: ", objectA.title)
        
        print("Pass the values of Object A to Object B")
        var objectB = objectA
        print("Object B: ", objectB.title)
        
        objectB.title = "Second Title!"
        
        print("Object B Title Changed")
        print("Object A: ", objectA.title)
        print("Object B: ", objectB.title)
    }
    
    private func classTest1() {
        print("classTest1")
        let objectA = MyClass(title: "Starting Title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the reference of ObjectA to ObjectB")
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second Title!"
        print("ObjectB Title Changed")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    private func actorTest1() {
        Task {
            print("actorTest1")
            let objectA = MyActor(title: "Starting Title!")
            print("ObjectA: ", objectA.title)
            
            print("Pass the reference of ObjectA to ObjectB")
            let objectB = objectA
            print("ObjectB: ", objectB.title)
            
            
            objectB.updateTitle(newTitle: "Second Title")
            print("ObjectB Title Changed")
            
            print("ObjectA: ", objectA.title)
            print("ObjectB: ", objectB.title)
        }
    }
}
// Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}
struct MutatingStruct {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}
extension StructClassActorBootcamp {
    private func structTest2() {
        print("StructTest2")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        
        struct1.title = "Title2"
        print("Struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: ", struct4.title)
    }
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

class MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1: ", class1.title)
        class1.title = "Title2"
        print("Class1: ", class1.title)
        
        let class2 = MyClass(title: "Title1")
        print("Class2: ", class2.title)
        class2.title = "Title2"
        print("Class2: ", class2.title)
    }
}
