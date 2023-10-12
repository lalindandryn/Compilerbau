package de.thm.mni.compilerbau.absyn.visitor

import de.thm.mni.compilerbau.absyn.*

/**
 * This interface is used to implement the visitor pattern.
 *
 *
 * You have to extend this class to implement your own visitor behavior.
 */
interface Visitor {
    fun visit(arrayAccess: ArrayAccess)
    fun visit(arrayTypeExpression: ArrayTypeExpression)
    fun visit(assignStatement: AssignStatement)
    fun visit(binaryExpression: BinaryExpression)
    fun visit(unaryExpression: UnaryExpression)
    fun visit(callStatement: CallStatement)
    fun visit(compoundStatement: CompoundStatement)
    fun visit(emptyStatement: EmptyStatement)
    fun visit(ifStatement: IfStatement)
    fun visit(intLiteral: IntLiteral)
    fun visit(namedTypeExpression: NamedTypeExpression)
    fun visit(namedVariable: NamedVariable)
    fun visit(parameterDefinition: ParameterDefinition)
    fun visit(procedureDefinition: ProcedureDefinition)
    fun visit(program: Program)
    fun visit(typeDefinition: TypeDefinition)
    fun visit(variableDefinition: VariableDefinition)
    fun visit(variableExpression: VariableExpression)
    fun visit(whileStatement: WhileStatement)
}