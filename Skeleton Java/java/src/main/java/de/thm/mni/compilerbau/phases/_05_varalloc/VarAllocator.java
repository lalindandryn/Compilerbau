package de.thm.mni.compilerbau.phases._05_varalloc;

import de.thm.mni.compilerbau.CommandLineOptions;
import de.thm.mni.compilerbau.absyn.*;
import de.thm.mni.compilerbau.phases._02_03_parser.Sym;
import de.thm.mni.compilerbau.table.ParameterType;
import de.thm.mni.compilerbau.table.ProcedureEntry;
import de.thm.mni.compilerbau.table.SymbolTable;
import de.thm.mni.compilerbau.table.VariableEntry;
import de.thm.mni.compilerbau.utils.*;

import javax.swing.plaf.nimbus.State;
import java.sql.Ref;
import java.util.*;
import java.util.stream.IntStream;

/**
 * This class is used to calculate the memory needed for variables and stack frames of the currently compiled SPL program.
 * Those value have to be stored in their corresponding fields in the {@link ProcedureEntry}, {@link VariableEntry} and
 * {@link ParameterType} classes.
 */
public class VarAllocator {
    public static final int REFERENCE_BYTESIZE = 4;

    private final CommandLineOptions options;

    /**
     * @param options The options passed to the compiler
     */
    private SymbolTable globalTable, localTable;
    private boolean showVarAlloc;
    public VarAllocator(CommandLineOptions options) {
        this.options = options;
        this.showVarAlloc = true;
    }


    public void allocVars(Program program, SymbolTable table) {
        //TODO (assignment 5): Allocate stack slots for all parameters and local variables
        int count = 0;
        while(count < 2){
            int ast_durchgang = 0;
            while(ast_durchgang < 2){
                for(var globalDec : program.definitions){
                    switch (globalDec){
                        case ProcedureDefinition procedureDefinition -> {
                            ProcedureEntry procEntry = (ProcedureEntry) table.lookup(procedureDefinition.name);
                            if(ast_durchgang == 0){
                                int offset = 0, i = 0;
                                for(var paramDec : procedureDefinition.parameters){
                                    VariableEntry paramEntry = (VariableEntry) procEntry.localTable.lookup(paramDec.name);
                                    paramEntry.offset = i * REFERENCE_BYTESIZE;
                                    procEntry.parameterTypes.get(i).offset = i * REFERENCE_BYTESIZE;
                                    i++;
                                }
                                procEntry.stackLayout.argumentAreaSize = i * REFERENCE_BYTESIZE;
                                offset = 0;
                                for(var varDec : procedureDefinition.variables){
                                    VariableEntry varEntry = (VariableEntry) procEntry.localTable.lookup(varDec.name);
                                    if(varEntry.isReference){
                                        offset -= REFERENCE_BYTESIZE;
                                    }else{
                                        offset -= varEntry.type.byteSize;
                                    }
                                    varEntry.offset = offset;
                                }
                                procEntry.stackLayout.localVarAreaSize = -offset;
                            }
                            if(ast_durchgang == 1){
                                procEntry.stackLayout.outgoingAreaSize = outgoing(procedureDefinition.body, procEntry.localTable);
                            }
                        }
                        case TypeDefinition typeDefinition -> {
                        }
                    }
                }
                ast_durchgang++;
            }

            count++;
        }
        //TODO: Uncomment this when the above exception is removed!
        if (showVarAlloc) formatVars(program, table);
    }

    private int statements(Statement statement, SymbolTable symbolTable){
        switch (statement){
            case AssignStatement assignStatement -> {
            }
            case CallStatement callStatement -> {
                ProcedureEntry procEntry = (ProcedureEntry) symbolTable.lookup(((CallStatement) statement).procedureName);
                return procEntry.stackLayout.argumentAreaSize;
            }
            case CompoundStatement compoundStatement -> {
                return outgoing(((CompoundStatement) statement).statements, symbolTable);
            }
            case EmptyStatement emptyStatement -> {
            }
            case IfStatement ifStatement -> {
                return Math.max(statements(((IfStatement) statement).thenPart, symbolTable), statements(((IfStatement) statement).elsePart, symbolTable));
            }
            case WhileStatement whileStatement -> {
                return statements(((WhileStatement) statement).body, symbolTable);
            }
        }
        return -1;
    }

    private int outgoing(List<Statement> statementList, SymbolTable symbolTable){
        int countOutgoing = 0;
        for(var statement : statementList){
            countOutgoing = Math.max(countOutgoing, statements(statement, symbolTable));
        }
        return countOutgoing;
    }

    /**
     * Formats and prints the variable allocation to a human-readable format
     * The stack layout
     *
     * @param program The abstract syntax tree of the program
     * @param table   The symbol table containing all symbols of the spl program
     */
    private static void formatVars(Program program, SymbolTable table) {
        program.definitions.stream().filter(dec -> dec instanceof ProcedureDefinition).map(dec -> (ProcedureDefinition) dec).forEach(procDec -> {
            ProcedureEntry entry = (ProcedureEntry) table.lookup(procDec.name);

            var isLeafOptimized = false; // This is a remainder from a bonus assignment, but I refuse to adjust this entire mess of a method
            var varparBasis = (isLeafOptimized ? "SP" : "FP");

            AsciiGraphicalTableBuilder ascii = new AsciiGraphicalTableBuilder();
            ascii.line("...", AsciiGraphicalTableBuilder.Alignment.CENTER);

            {
                final var zipped = IntStream.range(0, procDec.parameters.size()).boxed()
                        .map(i -> new Pair<>(procDec.parameters.get(i), new Pair<>(((VariableEntry) entry.localTable.lookup(procDec.parameters.get(i).name)), entry.parameterTypes.get(i))))
                        .sorted(Comparator.comparing(p -> Optional.ofNullable(p.second.first.offset).map(o -> -o).orElse(Integer.MIN_VALUE)));

                zipped.forEach(v -> {
                    boolean consistent = Objects.equals(v.second.first.offset, v.second.second.offset);

                    ascii.line("par " + v.first.name.toString(), "<- " + varparBasis + " + " +
                                    (consistent
                                            ? Objects.toString(v.second.first.offset, "NULL")
                                            : String.format("INCONSISTENT(%s/%s)", Objects.toString(v.second.first.offset, "NULL"), Objects.toString(v.second.second.offset, "NULL"))),
                            AsciiGraphicalTableBuilder.Alignment.LEFT);
                });
            }

            ascii.sep("BEGIN", "<- " + varparBasis);
            if (!procDec.variables.isEmpty()) {
                procDec.variables.stream()
                        .map(v -> new AbstractMap.SimpleImmutableEntry<>(v, ((VariableEntry) entry.localTable.lookup(v.name))))
                        .sorted(Comparator.comparing(e -> Try.execute(() -> -e.getValue().offset).getOrElse(0)))
                        .forEach(v -> ascii.line("var " + v.getKey().name.toString(),
                                "<- " + varparBasis + " - " + Optional.ofNullable(v.getValue().offset).map(o -> -o).map(Objects::toString).orElse("NULL"),
                                AsciiGraphicalTableBuilder.Alignment.LEFT));

                if (!isLeafOptimized) ascii.sep("");
            }

            if (isLeafOptimized) ascii.close("END");
            else {
                ascii.line("Old FP",
                        "<- SP + " + Try.execute(entry.stackLayout::oldFramePointerOffset).map(Objects::toString).getOrElse("UNKNOWN"),
                        AsciiGraphicalTableBuilder.Alignment.LEFT);

                ascii.line("Old Return",
                        "<- FP - " + Try.execute(() -> -entry.stackLayout.oldReturnAddressOffset()).map(Objects::toString).getOrElse("UNKNOWN"),
                        AsciiGraphicalTableBuilder.Alignment.LEFT);

                if (entry.stackLayout.outgoingAreaSize == null || entry.stackLayout.outgoingAreaSize > 0) {

                    ascii.sep("outgoing area");

                    if (entry.stackLayout.outgoingAreaSize != null) {
                        var max_args = entry.stackLayout.outgoingAreaSize / 4;

                        for (int i = 0; i < max_args; ++i) {
                            ascii.line(String.format("arg %d", max_args - i),
                                    String.format("<- SP + %d", (max_args - i - 1) * 4),
                                    AsciiGraphicalTableBuilder.Alignment.LEFT);
                        }
                    } else {
                        ascii.line("UNKNOWN SIZE", AsciiGraphicalTableBuilder.Alignment.LEFT);
                    }
                }

                ascii.sep("END", "<- SP");
                ascii.line("...", AsciiGraphicalTableBuilder.Alignment.CENTER);
            }

            System.out.printf("Variable allocation for procedure '%s':\n", procDec.name);
            System.out.printf("  - size of argument area = %s\n", Objects.toString(entry.stackLayout.argumentAreaSize, "NULL"));
            System.out.printf("  - size of localvar area = %s\n", Objects.toString(entry.stackLayout.localVarAreaSize, "NULL"));
            System.out.printf("  - size of outgoing area = %s\n", Objects.toString(entry.stackLayout.outgoingAreaSize, "NULL"));
            System.out.printf("  - frame size = %s\n", Try.execute(entry.stackLayout::frameSize).map(Objects::toString).getOrElse("UNKNOWN"));
            System.out.println();
            if (isLeafOptimized) System.out.println("  Stack layout (leaf optimized):");
            else System.out.println("  Stack layout:");
            System.out.println(ascii.toString().indent(4));
            System.out.println();
        });
    }
}
