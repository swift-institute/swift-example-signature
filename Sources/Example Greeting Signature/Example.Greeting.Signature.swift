public import Client_Derivation
public import Example
public import Example_Greeting
public import Signature_Derivation

extension Example.Greeting {
    @Signature
    @Client
    public protocol `Protocol` {
        func greet(_ name: Name) async -> Message
    }
}
