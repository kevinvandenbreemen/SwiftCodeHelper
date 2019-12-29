class SomeObject {

}

class ClassWithOneField {

    var someProperty: SomeObject

    init(field: SomeObject) {
        self.someProperty = field
    }

}