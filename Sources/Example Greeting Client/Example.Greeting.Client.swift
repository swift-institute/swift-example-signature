import Algebra_Derivation
import Client
public import Example
public import Example_Greeting

extension Example.Greeting {
    @Algebra
    package protocol Signature {
        func greet(_ name: Example.Greeting.Name) async -> Example.Greeting.Message
    }
}
