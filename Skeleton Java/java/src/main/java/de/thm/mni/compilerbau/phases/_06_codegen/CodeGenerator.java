package de.thm.mni.compilerbau.phases._06_codegen;

import de.thm.mni.compilerbau.CommandLineOptions;
import de.thm.mni.compilerbau.absyn.*;
import de.thm.mni.compilerbau.table.Entry;
import de.thm.mni.compilerbau.table.ProcedureEntry;
import de.thm.mni.compilerbau.table.SymbolTable;
import de.thm.mni.compilerbau.utils.NotImplemented;
import de.thm.mni.compilerbau.utils.SplError;
import java_cup.runtime.Symbol;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * This class is used to generate the assembly code for the compiled program.
 * This code is emitted via the {@link CodePrinter} in the output field of this class.
 */
public class CodeGenerator {
    final CommandLineOptions options;
    final CodePrinter output;

    /**
     * Initializes the code generator.
     *
     * @param options The command line options passed to the compiler
     * @param output  The PrintWriter to the output file.
     */
    public CodeGenerator(CommandLineOptions options, PrintWriter output) throws IOException {
        this.options = options;
        this.output = new CodePrinter(output);
    }

    private SymbolTable globalTable, localTable;
    private int firstFree = 8, lastFree = 9;

    public void generateCode(Program program, SymbolTable table) {
        assemblerProlog();
        //TODO (assignment 6): generate eco32 assembler code for the spl program
        globalTable = table;
        for(var globalDec : program.definitions){
            switch (globalDec){
                case ProcedureDefinition procedureDefinition -> {
                    ProcedureEntry procedureEntry = (ProcedureEntry) globalTable.lookup(procedureDefinition.name);
                    localTable = procedureEntry.localTable;
                    for(var statements : procedureDefinition.body){
                        genStatement(statements);
                    }
                }
                case TypeDefinition typeDefinition -> {
                    switch (typeDefinition.typeExpression){
                        case ArrayTypeExpression arrayTypeExpression -> {
                        }
                        case NamedTypeExpression namedTypeExpression -> {
                        }
                    }
                }
            }
        }
    }

    private void genStatement(Statement statement){
        Entry entry1 = null, entry2 = null, entry = null;
        switch (statement){
            case AssignStatement assignStatement -> {
                switch (assignStatement.value){
                    case BinaryExpression binaryExpression -> {
                        genExpr(binaryExpression.leftOperand, firstFree);
                        firstFree++;
                        Register rightOP = new Register(firstFree);
                        if(rightOP.number > lastFree){
                            throw SplError.RegisterOverflow();
                        }
                        genExpr(binaryExpression.rightOperand, firstFree);
                        firstFree--;
                        switchOP(binaryExpression.operator, firstFree, rightOP);
                    }

                    case IntLiteral intLiteral -> {
                        genIntLit(intLiteral);
                    }
                    case UnaryExpression unaryExpression -> {
                    }
                    case VariableExpression variableExpression -> {
                    }
                }
            }
            case CallStatement callStatement -> {
            }
            case CompoundStatement compoundStatement -> {
            }
            case EmptyStatement emptyStatement -> {
            }
            case IfStatement ifStatement -> {
            }
            case WhileStatement whileStatement -> {
            }
        }
    }

    private void switchOP(BinaryExpression.Operator operator, int reg, Register rightOP){
        switch (operator){
            case BinaryExpression.Operator.ADD -> { output.emitInstruction("add", new Register(reg), new Register(reg), rightOP); }
            case BinaryExpression.Operator.SUB -> { output.emitInstruction("sub", new Register(reg), new Register(reg), rightOP); }
            case BinaryExpression.Operator.MUL -> { output.emitInstruction("mul", new Register(reg), new Register(reg), rightOP); }
            case BinaryExpression.Operator.DIV -> { output.emitInstruction("div", new Register(reg), new Register(reg), rightOP); }
            case BinaryExpression.Operator.EQU -> { output.emitInstruction("beq", new Register(reg), new Register(reg).next(), "Label"); }
            case BinaryExpression.Operator.NEQ -> { output.emitInstruction("bne", new Register(reg), new Register(reg).next(), "Label"); }
            case BinaryExpression.Operator.LSE -> { output.emitInstruction("ble", new Register(reg), new Register(reg).next(), "Label"); }
            case BinaryExpression.Operator.LST -> { output.emitInstruction("blt", new Register(reg), new Register(reg).next(), "Label"); }
            case BinaryExpression.Operator.GRE -> { output.emitInstruction("bge", new Register(reg), new Register(reg).next(), "Label"); }
            case BinaryExpression.Operator.GRT -> { output.emitInstruction("bgt", new Register(reg), new Register(reg).next(), "Label"); }
        }
    }

    private void genExpr(Expression expression, int reg){
        switch (expression){
            case BinaryExpression binaryExpression -> {
                genExpr(binaryExpression.leftOperand, reg);
                reg++;
                Register rightOP = new Register(reg);
                genExpr(binaryExpression.rightOperand, reg);
                reg--;
                switchOP(binaryExpression.operator, reg, rightOP);
            }
            case IntLiteral intLiteral -> {
                genIntLit(intLiteral);
            }
            case UnaryExpression unaryExpression -> {
            }
            case VariableExpression variableExpression -> {
            }
        }
    }

    private void genIntLit(IntLiteral intLiteral){
        if(new Register(firstFree).isFreeUse()){
            output.emitInstruction("add", new Register(0), intLiteral.value, "");
        }
    }

    /**
     * Emits needed import statements, to allow usage of the predefined functions and sets the correct settings
     * for the assembler.
     */
    private void assemblerProlog() {
        output.emitImport("printi");
        output.emitImport("printc");
        output.emitImport("readi");
        output.emitImport("readc");
        output.emitImport("exit");
        output.emitImport("time");
        output.emitImport("clearAll");
        output.emitImport("setPixel");
        output.emitImport("drawLine");
        output.emitImport("drawCircle");
        output.emitImport("_indexError");
        output.emit("");
        output.emit("\t.code");
        output.emit("\t.align\t4");
    }
}
