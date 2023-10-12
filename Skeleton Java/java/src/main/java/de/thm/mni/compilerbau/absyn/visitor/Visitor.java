package de.thm.mni.compilerbau.absyn.visitor;

import de.thm.mni.compilerbau.absyn.*;

/**
 * This interface is used to implement the visitor pattern.
 * <p>
 * You have to extend this class to implement your own visitor behavior.
 */
public interface Visitor {
    void visit(ArrayAccess arrayAccess);

    void visit(ArrayTypeExpression arrayTypeExpression);

    void visit(AssignStatement assignStatement);

    void visit(BinaryExpression binaryExpression);

    void visit(UnaryExpression unaryExpression);

    void visit(CallStatement callStatement);

    void visit(CompoundStatement compoundStatement);

    void visit(EmptyStatement emptyStatement);

    void visit(IfStatement ifStatement);

    void visit(IntLiteral intLiteral);

    void visit(NamedTypeExpression namedTypeExpression);

    void visit(NamedVariable namedVariable);

    void visit(ParameterDefinition parameterDefinition);

    void visit(ProcedureDefinition procedureDefinition);

    void visit(Program program);

    void visit(TypeDefinition typeDefinition);

    void visit(VariableDefinition variableDefinition);

    void visit(VariableExpression variableExpression);

    void visit(WhileStatement whileStatement);
}
