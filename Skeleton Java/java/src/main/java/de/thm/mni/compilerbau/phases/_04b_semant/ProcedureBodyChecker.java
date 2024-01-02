package de.thm.mni.compilerbau.phases._04b_semant;

import de.thm.mni.compilerbau.CommandLineOptions;
import de.thm.mni.compilerbau.absyn.*;
import de.thm.mni.compilerbau.absyn.visitor.DoNothingVisitor;
import de.thm.mni.compilerbau.absyn.visitor.Visitor;
import de.thm.mni.compilerbau.phases._04a_tablebuild.TableBuilder;
import de.thm.mni.compilerbau.table.Entry;
import de.thm.mni.compilerbau.table.Identifier;
import de.thm.mni.compilerbau.table.ProcedureEntry;
import de.thm.mni.compilerbau.table.SymbolTable;
import de.thm.mni.compilerbau.types.Type;
import de.thm.mni.compilerbau.utils.NotImplemented;
import de.thm.mni.compilerbau.utils.SplError;

/**
 * This class is used to check if the currently compiled SPL program is semantically valid.
 * The body of each procedure has to be checked, consisting of {@link Statement}s, {@link Variable}s and {@link Expression}s.
 * Each node has to be checked for type issues or other semantic issues.
 * Calculated {@link Type}s can be stored in and read from the dataType field of the {@link Expression} and {@link Variable} classes.
 */
public class ProcedureBodyChecker extends DoNothingVisitor implements Visitor {

    private final CommandLineOptions options;

    public ProcedureBodyChecker(CommandLineOptions options) {
        this.options = options;
    }

    Program program;

    public void checkProcedures(Program program, SymbolTable globalTable) {
        //TODO (assignment 4b): Check all procedure bodies for semantic errors
        Entry entry = globalTable.lookup(new Identifier("main"));
        this.program = program;
        if(entry == null){
            throw SplError.MainIsMissing();
        }else if(entry.getClass() != ProcedureEntry.class){
            throw SplError.MainIsNotAProcedure();
        }else if(!((ProcedureEntry) entry).parameterTypes.isEmpty()){
            throw SplError.MainMustNotHaveParameters();
        }else{
            program.accept(this);
        }
    }

    @Override
    public void visit(ArrayAccess arrayAccess) {
        arrayAccess.array.accept(this);
        arrayAccess.index.accept(this);
    }

    @Override
    public void visit(ArrayTypeExpression arrayTypeExpression) {

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

    }

    @Override
    public void visit(NamedVariable namedVariable) {

    }

    @Override
    public void visit(ParameterDefinition parameterDefinition) {

    }

    @Override
    public void visit(ProcedureDefinition procedureDefinition) {

    }

    @Override
    public void visit(Program program) {
        program.definitions.forEach(globalDefinition -> globalDefinition.accept(this));
    }

    @Override
    public void visit(TypeDefinition typeDefinition) {

    }

    @Override
    public void visit(VariableDefinition variableDefinition) {

    }

    @Override
    public void visit(VariableExpression variableExpression) {

    }

    @Override
    public void visit(WhileStatement whileStatement) {

    }
}
