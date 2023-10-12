package de.thm.mni.compilerbau;

import java.io.*;

import static java.lang.System.exit;

public class CommandLineOptions {
    public enum PhaseOption {
        TOKENS, PARSE, ABSYN, TABLES, SEMANT, VARS;
    }

    public PhaseOption phaseOption = null;
    public String inFilename = "";
    public String outFilename = "";

    private static void usageError(String format, Object... args) {
        System.err.printf("Usage error: " + format, args);
        System.err.println();
        showUsage(System.err);
        exit(1);
    }

    private static void showUsage(PrintStream out) {
        out.println("Usage: 'java -jar spl.jar' [OPTION] INPUT_FILE [OUTPUT_FILE]");
        out.println();
        out.println("Executes all compiler phases up to (and including) the specified one.");
        out.println("If no flag is specified, all phases are run and code is written to the output file.");
        out.println("Options:");
        out.println("  --tokens            Phase 1: Scans for tokens and prints them.");
        out.println("  --parse             Phase 2: Parses the stream of tokens to check for syntax errors.");
        out.println("  --absyn             Phase 3: Creates an abstract syntax tree from the input tokens and prints it.");
        out.println("  --tables            Phase 4a: Builds a symbol table and prints its entries.");
        out.println("  --semant            Phase 4b: Performs the semantic analysis.");
        out.println("  --vars              Phase 5: Allocates memory space for variables and prints the amount of allocated memory.");
        out.println("  --help              Show this help.");
    }

    void setPhaseOption(PhaseOption phaseOption) {
        if (this.phaseOption != null) usageError("More than one phase option specified.");
        this.phaseOption = phaseOption;
    }


    static CommandLineOptions parse(String[] args) {
        CommandLineOptions options = new CommandLineOptions();

        for (String name : args) {
            switch (name) {
                case "--tokens" -> options.setPhaseOption(PhaseOption.TOKENS);
                case "--parse" -> options.setPhaseOption(PhaseOption.PARSE);
                case "--absyn" -> options.setPhaseOption(PhaseOption.ABSYN);
                case "--tables" -> options.setPhaseOption(PhaseOption.TABLES);
                case "--semant" -> options.setPhaseOption(PhaseOption.SEMANT);
                case "--vars" -> options.setPhaseOption(PhaseOption.VARS);
                case "--help" -> {
                    showUsage(System.out);
                    exit(0);
                }
                default -> {
                    if (!name.startsWith("--")) {
                        if (options.inFilename.isEmpty()) options.inFilename = name;
                        else if (options.outFilename.isEmpty()) options.outFilename = name;
                        else usageError("Too many positional arguments!");
                    } else {
                        usageError("Unknown option '%s'!", name);
                    }
                }
            }
        }

        if (options.inFilename.isEmpty()) usageError("No input file!");

        return options;
    }

    public PrintWriter getOutputWriter() throws IOException {
        // Unclosable stream to avoid closing stdout when no output file is given.
        // Source: https://stackoverflow.com/a/23791138
        class UnclosableOutputStream extends FilterOutputStream {
            public UnclosableOutputStream(OutputStream out) {
                super(out);
            }

            @Override
            public void close() throws IOException {
                out.flush();
            }
        }

        if (this.outFilename.isEmpty()) return new PrintWriter(new UnclosableOutputStream(System.out));
        return new PrintWriter(new FileWriter(this.outFilename));
    }
}

