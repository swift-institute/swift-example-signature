public import Client_Derivation
public import Call_Derivation
public import Client
public import Example
public import Example_Greeting

extension Example.Greeting {
    @Client
    @Calls
    package protocol Signature {
        func greet(_ name: Name) async -> Message
    }
}
