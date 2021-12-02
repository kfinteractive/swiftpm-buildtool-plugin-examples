import PackagePlugin
import Foundation

@main
struct SwiftGenPlugin: BuildToolPlugin {
    
    func createBuildCommands(context: TargetBuildContext) throws -> [Command] {
        // This example configures `swiftgen` to take inputs from a `swiftgen.yml` file.
        let swiftGenConfigFile = context.packageDirectory.appending("swiftgen.yml")

        // This example configures `swiftgen` to write to a "SwiftGenOutputs" directory.
        let swiftGenOutputsDir = context.pluginWorkDirectory.appending("SwiftGenOutputs")
        try FileManager.default.createDirectory(atPath: swiftGenOutputsDir.string, withIntermediateDirectories: true)

        // Create a command to run `swiftgen` as a prebuild command. It will be run before
        // every build and generates source files into an output directory provided by the
        // build context.
        return [.prebuildCommand(
            displayName: "Running SwiftGen",
            executable: try context.tool(named: "swiftgen").path,
            arguments: [
                "config",
                "run",
                "--verbose",
                "--config", "\(swiftGenConfigFile)"
            ],
            environment: [
                "PROJECT_DIR": "\(context.packageDirectory)",
                "TARGET_NAME": "\(context.targetName)",
                "DERIVED_SOURCES_DIR": "\(swiftGenOutputsDir)",
            ],
            outputFilesDirectory: swiftGenOutputsDir)
        ]
    }
}
