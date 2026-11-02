// SPDX-License-Identifier: GPL-3.0-or-later
// Safe, bounded recovery guidance shared by Playport / StrataForge.
// Never changes user games, Steam credentials, or debugger entitlements.
import Foundation

public enum StrataForgeRecovery: Equatable, Sendable {
    case jit, memory, graphics, steam, wine, unknown

    public init(message: String) {
        let text = message.lowercased()
        if text.contains("jit") || text.contains("debugger") || text.contains("tracer") {
            self = .jit
        } else if text.contains("jetsam") || text.contains("out of memory") || text.contains("allocation failed") {
            self = .memory
        } else if text.contains("metal") || text.contains("dxmt") || text.contains("vulkan") || text.contains("shader") {
            self = .graphics
        } else if text.contains("steam") || text.contains("depot") {
            self = .steam
        } else if text.contains("wine") || text.contains("wineserver") || text.contains("socket") {
            self = .wine
        } else {
            self = .unknown
        }
    }

    public var guidance: String {
        switch self {
        case .jit:
            "Inside Strata or LiveContainer, select external JIT and launch with its compatible debugger. Do not run the built-in helper."
        case .memory:
            "Reduce the game's graphics and resolution settings; verify Increased Memory Limit is retained by the sideloader."
        case .graphics:
            "Try a lower rendering resolution or the other supported Direct3D backend. Keep diagnostic logs for the failing game."
        case .steam:
            "Check account sign-in, game ownership, and the install queue; use Verify before downloading again."
        case .wine:
            "Close the game session and retry once. Export the diagnostic log if the server cannot initialize."
        case .unknown:
            "Export the diagnostic log and retry once. Do not repeatedly restart a failing game."
        }
    }
}
