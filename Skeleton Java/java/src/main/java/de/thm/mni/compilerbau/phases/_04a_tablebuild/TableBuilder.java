package de.thm.mni.compilerbau.phases._04a_tablebuild;

import java.util.ArrayList;
import java.util.List;
import de.thm.mni.compilerbau.CommandLineOptions;
import de.thm.mni.compilerbau.absyn.*;
import de.thm.mni.compilerbau.absyn.visitor.DoNothingVisitor;
import de.thm.mni.compilerbau.absyn.visitor.Visitor;
import de.thm.mni.compilerbau.table.*;
import de.thm.mni.compilerbau.types.ArrayType;
import de.thm.mni.compilerbau.types.Type;
import de.thm.mni.compilerbau.utils.NotImplemented;
import de.thm.mni.compilerbau.utils.SplError;

import javax.naming.Name;

/**
 * This class is used to create and populate a {@link SymbolTable} containing entries for every symbol in the currently
 * compiled SPL program.
 * Every declaration of the SPL program needs its corresponding entry in the {@link SymbolTable}.
 * <p>
 * Calculated {@link Type}s can be stored in and read from the dataType field of the {@link Expression},
 * {@link TypeExpression} or {@link Variable} classes.
 */
public class TableBuilder extends DoNothingVisitor implements Visitor {
    private final CommandLineOptions options;

    public TableBuilder(CommandLineOptions options) {
        this.options = options;
    }

    private SymbolTable mySymbolTable = new SymbolTable();//create new symbol table
    private SymbolTable globalSymTab;
    private List<ParameterType> listOfParams;
    public SymbolTable buildSymbolTable(Program program) {
        //TODO (assignment 4a): Initialize a symbol table with all predefined symbols and fill it with user-defined symbols

        mySymbolTable = TableInitializer.initializeGlobalTable();
        visit(program);
        return mySymbolTable;
    }

    @Override
    public void visit(ArrayAccess arrayAccess) {

    }

    @Override
    public void visit(ArrayTypeExpression arrayTypeExpression) {
        arrayTypeExpression.baseType.accept(this);
        arrayTypeExpression.typeName = new ArrayType(arrayTypeExpression.baseType.typeName, arrayTypeExpression.arraySize);
    }

    @Override
    public void visit(AssignStatement assignStatement) {

    }

    @Override
    public void visit(BinaryExpression binaryExpression) {

    }

    @Override
    public void visit(UnaryExpression unaryExpression) {

    }

    @Override
    public void visit(CallStatement callStatement) {

    }

    @Override
    public void visit(CompoundStatement compoundStatement) {

    }

    @Override
    public void visit(EmptyStatement emptyStatement) {

    }

    @Override
    public void visit(IfStatement ifStatement) {

    }

    @Override
    public void visit(IntLiteral intLiteral) {

    }

    @Override
    public void visit(NamedTypeExpression namedTypeExpression) {
        Entry entry = mySymbolTable.lookup(namedTypeExpression.name);
        if(!(entry instanceof TypeEntry)){
            throw SplError.NotAType(namedTypeExpression.position, namedTypeExpression.name);
        }
        namedTypeExpression.typeName = ((TypeEntry) entry).type;
    }

    @Override
    public void visit(NamedVariable namedVariable) {

    }

    @Override
    public void visit(ParameterDefinition parameterDefinition) {
        parameterDefinition.typeExpression.accept(this);
        globalSymTab.enter(parameterDefinition.name, new VariableEntry(parameterDefinition.typeExpression.typeName, parameterDefinition. isReference));

        if((parameterDefinition.typeExpression.typeName instanceof ArrayType) && !(parameterDefinition.isReference)){
            throw SplError.ParameterMustBeReference(parameterDefinition.position, parameterDefinition.name, parameterDefinition.typeExpression.typeName);
        }

        listOfParams.add(new ParameterType(parameterDefinition.typeExpression.typeName, parameterDefinition.isReference));
    }

    @Override
    public void visit(ProcedureDefinition procedureDefinition) {
        globalSymTab = new SymbolTable(mySymbolTable);
        listOfParams = new ArrayList<>();
        procedureDefinition.parameters.forEach(parameterDefinition -> parameterDefinition.accept(this));
        procedureDefinition.variables.forEach(variableDefinition -> variableDefinition.accept(this));
        mySymbolTable.enter(procedureDefinition.name, new ProcedureEntry(globalSymTab, listOfParams));
        printSymbolTableAtEndOfProcedure(procedureDefinition.name, new ProcedureEntry(globalSymTab, listOfParams));
    }

    @Override
    public void visit(Program program) {
        program.definitions.forEach(globalDefinition -> globalDefinition.accept(this));
    }

    @Override
    public void visit(TypeDefinition typeDefinition) { //type myInt = int
        typeDefinition.typeExpression.accept(this);
        mySymbolTable.enter(typeDefinition.name, new TypeEntry(typeDefinition.typeExpression.typeName));
    }

    @Override
    public void visit(VariableDefinition variableDefinition) {
        variableDefinition.typeExpression.accept(this);
        globalSymTab.enter(variableDefinition.name, new VariableEntry(variableDefinition.typeExpression.typeName, false));
    }

    @Override
    public void visit(VariableExpression variableExpression) {

    }

    @Override
    public void visit(WhileStatement whileStatement) {

    }

    /**
     * Prints the local symbol table of a procedure together with a heading-line
     * NOTE: You have to call this after completing the local table to support '--tables'.
     *
     * @param name  The name of the procedure
     * @param entry The entry of the procedure to print
     */
    static void printSymbolTableAtEndOfProcedure(Identifier name, ProcedureEntry entry) {
        System.out.format("Symbol table at end of procedure '%s':\n", name);
        System.out.println(entry.localTable.toString());
    }
}
