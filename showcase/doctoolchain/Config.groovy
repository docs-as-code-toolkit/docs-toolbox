outputPath = 'build/showcase/doctoolchain'

// docToolchain resolves inputPath relative to docDir. The showcase build script
// runs dtcw with docDir set to the repository root, so this adapter can publish
// the repository's real architecture sources without copying them.
inputPath = 'showcase/doctoolchain/src/docs'

inputFiles = [
    [file: 'docs-toolbox-architecture.adoc', formats: ['html', 'pdf']],
]

imageDirs = []
taskInputsDirs = []
taskInputsFiles = []

jbake.with {
    plugins = []
    asciidoctorAttributes = []
}
