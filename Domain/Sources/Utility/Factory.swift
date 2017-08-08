public final class Factory<T> {
    public typealias FactoryMethod = () -> T
    public let create: FactoryMethod
    public init(factoryMethod: @escaping FactoryMethod) {
        self.create = factoryMethod
    }
}

extension Factory {
    public final class From<P1> {
        public typealias FactoryMethod = (P1) -> T
        public let create: FactoryMethod
        public init(factoryMethod: @escaping FactoryMethod) {
            self.create = factoryMethod
        }
    }
}

extension Factory.From {
    public final class With<P2> {
        public typealias FactoryMethod = (P1, P2) -> T
        public let create: FactoryMethod
        public init(factoryMethod: @escaping FactoryMethod) {
            self.create = factoryMethod
        }
    }
}

extension Factory.From.With {
    public final class With<P3> {
        public typealias FactoryMethod = (P1, P2, P3) -> T
        public let create: FactoryMethod
        public init(factoryMethod: @escaping FactoryMethod) {
            self.create = factoryMethod
        }
    }
}

extension Factory.From.With.With {
    public final class With<P4> {
        public typealias FactoryMethod = (P1, P2, P3, P4) -> T
        public let create: FactoryMethod
        public init(factoryMethod: @escaping FactoryMethod) {
            self.create = factoryMethod
        }
    }
}

extension Factory.From.With.With.With {
    public final class With<P5> {
        public typealias FactoryMethod = (P1, P2, P3, P4, P5) -> T
        public let create: FactoryMethod
        public init(factoryMethod: @escaping FactoryMethod) {
            self.create = factoryMethod
        }
    }
}
