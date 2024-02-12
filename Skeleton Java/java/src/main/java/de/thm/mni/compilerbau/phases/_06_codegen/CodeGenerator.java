package de.thm.mni.compilerbau.phases._06_codegen;

import de.thm.mni.compilerbau.CommandLineOptions;
import de.thm.mni.compilerbau.absyn.*;
import de.thm.mni.compilerbau.table.*;
import de.thm.mni.compilerbau.types.ArrayType;
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
    private Register register = Register.FIRST_FREE_USE;
    private int labelCounter = 0;

    public void generateCode(Program program, SymbolTable table) {
        assemblerProlog();
        //TODO (assignment 6): generate eco32 assembler code for the spl program
        globalTable = table;
        for(var globalDec : program.definitions){
            switch (globalDec){
                case ProcedureDefinition procedureDefinition -> {
                    ProcedureEntry procedureEntry = (ProcedureEntry) globalTable.lookup(procedureDefinition.name);
                    localTable = procedureEntry.localTable;

                    output.emit("");
                    output.emitExport(procedureDefinition.name.toString());
                    output.emitLabel(procedureDefinition.name.toString());
                    //Prepare the register for current procedure
                    output.emitInstruction("sub", Register.STACK_POINTER, Register.STACK_POINTER, procedureEntry.stackLayout.frameSize(), "allocate frame");
                    output.emitInstruction("stw", Register.FRAME_POINTER, Register.STACK_POINTER, procedureEntry.stackLayout.oldFramePointerOffset(), "save old frame pointer");
                    output.emitInstruction("add", Register.FRAME_POINTER, Register.STACK_POINTER, procedureEntry.stackLayout.frameSize(), "setup new frame pointer");
                    output.emitInstruction("stw", Register.RETURN_ADDRESS, Register.FRAME_POINTER, procedureEntry.stackLayout.oldReturnAddressOffset(), "save return register");

                    for(var statements : procedureDefinition.body){
                        genStatement(statements);
                    }

                    //Clean current procedure's stack
                    output.emitInstruction("ldw", Register.RETURN_ADDRESS, Register.FRAME_POINTER, procedureEntry.stackLayout.oldReturnAddressOffset(), "restore return register");
                    output.emitInstruction("ldw", Register.FRAME_POINTER, Register.STACK_POINTER, procedureEntry.stackLayout.oldFramePointerOffset(), "restore old frame pointer");
                    output.emitInstruction("add", Register.STACK_POINTER, Register.STACK_POINTER, procedureEntry.stackLayout.frameSize(), "release frame");
                    output.emitInstruction("jr", Register.RETURN_ADDRESS, "return");
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
                switch (assignStatement.target){
                    case ArrayAccess arrayAccess -> {
                        switch (arrayAccess.array){
                            case ArrayAccess access -> {
                            }
                            case NamedVariable namedVariable -> {
                                VariableEntry namedEntry = (VariableEntry) localTable.lookup(namedVariable.name);
                                output.emitInstruction("add", register, Register.FRAME_POINTER, namedEntry.offset);
                            }
                        }
                        register = register.next();
                        switch (arrayAccess.index){
                            case BinaryExpression binaryExpression -> {
                                genExpr(binaryExpression);
                            }
                            case IntLiteral intLiteral -> {
                                genExpr(intLiteral);
                            }
                            case UnaryExpression unaryExpression -> {
                                genExpr(unaryExpression);
                            }
                            case VariableExpression variableExpression -> {
                                genExpr(variableExpression);
                            }
                        }
                        register = register.next();
                        //output.emitInstruction("add", register, Register.NULL, ((ArrayType)arrayAccess.array.).arraySize); // mesti nyari besar dari arraynya TODO!
                        output.emitInstruction("bgeu", register.previous(), register, "_indexError");
                        register = register.previous();
                        output.emitInstruction("mul", register, register, 4);
                        output.emitInstruction("add", register.previous(), register.previous(), register);

                    }
                    case NamedVariable namedVariable -> {
                        VariableEntry namedEntry = (VariableEntry) localTable.lookup(namedVariable.name);
                        if(register.isFreeUse()){
                            output.emitInstruction("add", register, Register.FRAME_POINTER, namedEntry.offset);
                            if(namedEntry.isReference){
                                output.emitInstruction("ldw", register, register, 0);
                            }
                            register = register.next();
                        }else {
                            throw SplError.RegisterOverflow();
                        }
                    }
                }
                switch (assignStatement.value){
                    case BinaryExpression binaryExpression -> {
                        genExpr(binaryExpression.leftOperand);
                        register = register.next();

                        genExpr(binaryExpression.rightOperand);
                        register = register.previous();
                        switchOP(binaryExpression.operator, register);
                    }

                    case IntLiteral intLiteral -> {
                        genIntLit(intLiteral);
                    }
                    case UnaryExpression unaryExpression -> {
                        genExpr(unaryExpression);
                    }
                    case VariableExpression variableExpression -> {
                        genExpr(variableExpression);
                    }
                }
                output.emitInstruction("stw", register, register.previous(), 0);
                register = register.previous();
            }
            case CallStatement callStatement -> {
                ProcedureEntry procedureEntry = (ProcedureEntry) localTable.lookup(callStatement.procedureName);
                int counter = 0;
                for(var argument : procedureEntry.parameterTypes) {

                    switch (callStatement.arguments.get(counter)){
                        case BinaryExpression binaryExpression -> {
                            genExpr(binaryExpression);
                        }
                        case IntLiteral intLiteral -> {
                            genIntLit(intLiteral);
                        }
                        case UnaryExpression unaryExpression -> {
                            genExpr(unaryExpression);
                        }
                        case VariableExpression variableExpression -> {
                            genExpr2(variableExpression, argument);
                        }
                    }
                    output.emitInstruction("stw", register, Register.STACK_POINTER, argument.offset, "store argument #" + counter);

                    counter ++;
                }
                output.emitInstruction("jal", callStatement.procedureName.toString());
            }
            case CompoundStatement compoundStatement -> {
                genStatement(compoundStatement);
            }
            case EmptyStatement emptyStatement -> {
            }
            case IfStatement ifStatement -> {

                switch (ifStatement.condition){
                    case BinaryExpression binaryExpression -> {
                        genExpr(binaryExpression);
                    }
                    case IntLiteral intLiteral -> {
                    }
                    case UnaryExpression unaryExpression -> {
                    }
                    case VariableExpression variableExpression -> {
                    }
                }
                switch (ifStatement.thenPart){
                    case AssignStatement assignStatement -> {
                        genStatement(assignStatement);
                    }
                    case CallStatement callStatement -> {
                        genStatement(callStatement);
                    }
                    case CompoundStatement compoundStatement -> {
                        for(var compoundStm : compoundStatement.statements){
                            genStatement(compoundStm);
                        }

                    }
                    case EmptyStatement emptyStatement -> {
                    }
                    case IfStatement ifStatement1 -> {
                        genStatement(ifStatement1);
                    }
                    case WhileStatement whileStatement -> {
                        genStatement(whileStatement);
                    }
                }
                int elseLabel = labelCounter ++;
                if(!(ifStatement.elsePart instanceof EmptyStatement)){
                    int thenLabel = labelCounter ++;
                    //output.emit(String.valueOf(labelCounter));
                    output.emitInstruction("j", "L" + thenLabel);

                    output.emitLabel("L" + elseLabel);

                    switch (ifStatement.elsePart) {
                        case AssignStatement assignStatement -> {
                            genStatement(assignStatement);
                        }
                        case CallStatement callStatement -> {
                            genStatement(callStatement);
                        }
                        case CompoundStatement compoundStatement -> {
                            for(var compoundStm : compoundStatement.statements){
                                genStatement(compoundStm);
                            }

                        }
                        case EmptyStatement emptyStatement -> {
                        }
                        case IfStatement ifStatement1 -> {
                            genStatement(ifStatement1);
                        }
                        case WhileStatement whileStatement -> {
                            genStatement(whileStatement);
                        }
                    }
                    if(!(ifStatement.elsePart instanceof EmptyStatement)){
                        output.emitLabel("L" + thenLabel);
                    }

                }else {
                    output.emitLabel("L" + elseLabel);
                }
            }
            case WhileStatement whileStatement -> {
                int branchtrue = labelCounter ++;
                output.emitLabel("L" + branchtrue);
                switch (whileStatement.condition){
                    case BinaryExpression binaryExpression -> {
                        genExpr(binaryExpression);
                    }
                    case IntLiteral intLiteral -> {
                    }
                    case UnaryExpression unaryExpression -> {
                    }
                    case VariableExpression variableExpression -> {
                    }
                }
                int branchfalse = labelCounter ++;
                switch (whileStatement.body){
                    case AssignStatement assignStatement -> {
                        genStatement(assignStatement);
                    }
                    case CallStatement callStatement -> {
                        genStatement(callStatement);
                    }
                    case CompoundStatement compoundStatement -> {
                        for(var compound : compoundStatement.statements){
                            genStatement(compound);
                        }
                    }
                    case EmptyStatement emptyStatement -> {
                    }
                    case IfStatement ifStatement -> {
                        genStatement(ifStatement);
                    }
                    case WhileStatement whileStatement1 -> {
                        genStatement(whileStatement1);
                    }
                }
                output.emitInstruction("j", "L" + branchtrue);
                output.emitLabel("L" + branchfalse);
            }
        }
    }

    private void switchOP(BinaryExpression.Operator operator, Register register){
        switch (operator){
            case BinaryExpression.Operator.ADD -> { output.emitInstruction("add", register, register, register.next()); }
            case BinaryExpression.Operator.SUB -> { output.emitInstruction("sub", register, register, register.next()); }
            case BinaryExpression.Operator.MUL -> { output.emitInstruction("mul", register, register, register.next()); }
            case BinaryExpression.Operator.DIV -> { output.emitInstruction("div", register, register, register.next()); }
            case BinaryExpression.Operator.EQU -> { output.emitInstruction("bne", register, register.next(), "L" + labelCounter); }
            case BinaryExpression.Operator.NEQ -> { output.emitInstruction("beq", register, register.next(), "L" + labelCounter); }
            case BinaryExpression.Operator.LSE -> { output.emitInstruction("bgt", register, register.next(), "L" + labelCounter); }
            case BinaryExpression.Operator.LST -> { output.emitInstruction("bge", register, register.next(), "L" + labelCounter); }
            case BinaryExpression.Operator.GRE -> { output.emitInstruction("blt", register, register.next(), "L" + labelCounter); }
            case BinaryExpression.Operator.GRT -> { output.emitInstruction("ble", register, register.next(), "L" + labelCounter); }
        }
    }



    private void genExpr(Expression expression){
        switch (expression){
            case BinaryExpression binaryExpression -> {
                genExpr(binaryExpression.leftOperand);
                register = register.next();

                genExpr(binaryExpression.rightOperand);
                register = register.previous();
                switchOP(binaryExpression.operator, register);
            }
            case IntLiteral intLiteral -> {
                genIntLit(intLiteral);
            }
            case UnaryExpression unaryExpression -> {
                if( register.isFreeUse()) {
                    if(unaryExpression.operator == UnaryExpression.Operator.MINUS){
                        genExpr(unaryExpression.operand);
                        output.emitInstruction("sub", register, Register.NULL, register);
                    }else{
                        throw new UnsupportedOperationException("Unary operator not supported: " + unaryExpression.operator);
                    }

                }else {
                    throw SplError.RegisterOverflow();
                }
            }
            case VariableExpression variableExpression -> {
                switch (variableExpression.variable){
                    case ArrayAccess arrayAccess -> {
                    }
                    case NamedVariable namedVariable -> {
                        VariableEntry namedEntry = (VariableEntry) localTable.lookup(namedVariable.name);
                        //output.emit(String.valueOf(namedEntry.isReference));
                        if(register.isFreeUse()){
                            output.emitInstruction("add", register, Register.FRAME_POINTER, namedEntry.offset);
                            /*if((namedEntry.isReference)){
                                output.emitInstruction("ldw", register, register, 0);
                            }*/
                            output.emitInstruction("ldw", register, register, 0);

                        }else {
                            throw SplError.RegisterOverflow();
                        }
                    }
                }
            }
        }
    }
    private void genExpr2(Expression expression, ParameterType argument){
        switch (expression){
            case BinaryExpression binaryExpression -> {
                genExpr(binaryExpression.leftOperand);
                register = register.next();

                genExpr(binaryExpression.rightOperand);
                register = register.previous();
                switchOP(binaryExpression.operator, register);
            }
            case IntLiteral intLiteral -> {
                genIntLit(intLiteral);
            }
            case UnaryExpression unaryExpression -> {
                if( register.isFreeUse()) {
                    if(unaryExpression.operator == UnaryExpression.Operator.MINUS){
                        genExpr(unaryExpression.operand);
                        output.emitInstruction("sub", register, Register.NULL, register);
                    }else{
                        throw new UnsupportedOperationException("Unary operator not supported: " + unaryExpression.operator);
                    }

                }else {
                    throw SplError.RegisterOverflow();
                }
            }
            case VariableExpression variableExpression -> {
                switch (variableExpression.variable){
                    case ArrayAccess arrayAccess -> {
                    }
                    case NamedVariable namedVariable -> {
                        VariableEntry namedEntry = (VariableEntry) localTable.lookup(namedVariable.name);
                        if(register.isFreeUse()){
                            output.emitInstruction("add", register, Register.FRAME_POINTER, namedEntry.offset);
                            if(argument.isReference){
                                if (namedEntry.isReference){
                                    output.emitInstruction("ldw", register, register, 0);
                                }
                            }else{
                                output.emitInstruction("ldw", register, register, 0);
                            }

                        }else {
                            throw SplError.RegisterOverflow();
                        }
                    }
                }
            }
        }
    }

    private void genIntLit(IntLiteral intLiteral){
        if( register.isFreeUse()) {
            output.emitInstruction("add", register, Register.NULL, intLiteral.value);
        }else {
            throw SplError.RegisterOverflow();
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
