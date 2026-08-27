import Client_Derivation
import Call_Derivation
import Client
public import Example
public import Example_Greeting

extension Example.Greeting {
    @Client
    @Calls
    package protocol Signature {
        func greet(_ name: Name) async -> Message
    }
}
