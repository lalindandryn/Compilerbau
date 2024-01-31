package de.thm.mni.compilerbau.phases._04b_semant;

import de.thm.mni.compilerbau.CommandLineOptions;
import de.thm.mni.compilerbau.absyn.*;
import de.thm.mni.compilerbau.absyn.visitor.DoNothingVisitor;
import de.thm.mni.compilerbau.absyn.visitor.Visitor;
import de.thm.mni.compilerbau.phases._04a_tablebuild.TableBuilder;
import de.thm.mni.compilerbau.table.*;
import de.thm.mni.compilerbau.types.ArrayType;
import de.thm.mni.compilerbau.types.PrimitiveType;
import de.thm.mni.compilerbau.types.Type;
import de.thm.mni.compilerbau.utils.NotImplemented;
import de.thm.mni.compilerbau.utils.SplError;

import java.lang.annotation.Target;
import java.security.spec.ECField;
import java.util.*;
import java.util.stream.StreamSupport;

/**
 * This class is used to check if the currently compiled SPL program is semantically valid.
 * The body of each procedure has to be checked, consisting of {@link Statement}s, {@link Variable}s and {@link Expression}s.
 * Each node has to be checked for type issues or other semantic issues.
 * Calculated {@link Type}s can be stored in and read from the dataType field of the {@link Expression} and {@link Variable} classes.
 */
public class ProcedureBodyChecker {

    private final CommandLineOptions options;

    public ProcedureBodyChecker(CommandLineOptions options) {
        this.options = options;
    }

    Program program;
    private Type dataType, baseType;
    private SymbolTable localTable, globalTable;

    public void checkProcedures(Program program, SymbolTable globalTable) {
        //TODO (assignment 4b): Check all procedure bodies for semantic errors
        this.globalTable = globalTable;
        Entry entry = globalTable.lookup(new Identifier("main"));

        if(entry == null){ //Error Code 125
            throw SplError.MainIsMissing();
        }

        if(entry.getClass() != ProcedureEntry.class){ //Error Code 126
            throw SplError.MainIsNotAProcedure();
        }

        if(!(((ProcedureEntry) entry).parameterTypes.isEmpty())){ //Error Code 127
            throw SplError.MainMustNotHaveParameters();
        }

        for(var globalDeclaration : program.definitions){
            switch (globalDeclaration){
                case ProcedureDefinition procedureDefinition -> {
                    entry = globalTable.lookup(procedureDefinition.name);
                    SymbolTable temp = localTable;
                    localTable = new SymbolTable(((ProcedureEntry) entry).localTable);
                    for(var statement : procedureDefinition.body){
                        checkStatement(statement);
                    }

                    localTable = temp;
                }
                case TypeDefinition typeDefinition -> {
                }
            }
        }
    }

    private void checkStatement(Statement statement){
        switch (statement){
            case AssignStatement assignStatement -> {
                checkStatement(assignStatement);
            }
            case CallStatement callStatement -> {
                checkStatement(callStatement);
            }
            case CompoundStatement compoundStatement -> {
            }
            case EmptyStatement emptyStatement -> {
            }
            case IfStatement ifStatement -> {
                checkStatement(ifStatement);
                checkStatement(ifStatement.thenPart);
                if(ifStatement.elsePart != null){
                    checkStatement(ifStatement.elsePart);
                }
            }
            case WhileStatement whileStatement -> {
                checkStatement(whileStatement);
            }
        }
    }
    private void checkStatement(AssignStatement assignStatement){
        Entry targetEntry = null, valueEntry = null;
        isNullVarEntry(assignStatement.target);
        switch (assignStatement.target){
            case ArrayAccess arrayAccess -> {}
            case NamedVariable namedVariable -> {
                targetEntry = localTable.lookup(namedVariable.name);
                if(!(targetEntry instanceof VariableEntry)){
                    //Error Code 122
                    throw SplError.NotAVariable(namedVariable.position, namedVariable.name);
                }
            }
        }
        switch (assignStatement.value){
            case BinaryExpression binaryExpression -> {
            }
            case IntLiteral intLiteral -> {
                if(((VariableEntry) targetEntry).type != PrimitiveType.intType){
                    throw SplError.IllegalAssignment(assignStatement.position, ((VariableEntry) targetEntry).type, PrimitiveType.intType);
                }
            }
            case UnaryExpression unaryExpression -> {
            }
            case VariableExpression variableExpression -> {
                isNullVarEntry(variableExpression.variable);
                switch (variableExpression.variable){
                    case ArrayAccess arrayAccess -> {}
                    case NamedVariable namedVariable -> {
                        valueEntry = localTable.lookup(namedVariable.name);
                        if(((VariableEntry) valueEntry).type != ((VariableEntry) targetEntry).type){ //Error Code 108
                            throw SplError.IllegalAssignment(assignStatement.position, ((VariableEntry) targetEntry).type, ((VariableEntry) valueEntry).type);
                        }
                    }
                }
            }
        }
    }
    private void checkStatement(CallStatement callStatement){
        //TODO Setengah jadi need code refactor?
        Entry global = globalTable.lookup(callStatement.procedureName), local = localTable.lookup(callStatement.procedureName);
        Iterator<Expression> args = callStatement.arguments.iterator();
        Iterator<ParameterType> params = ((ProcedureEntry) global).parameterTypes.iterator();
        int countArgs = 0, countParams = 0;
        int i = 1;
        if(local != null && !(local instanceof ProcedureEntry)){ //Error Code 113
            throw SplError.CallOfNonProcedure(callStatement.position, callStatement.procedureName);
        }else if(global != null && !(global instanceof ProcedureEntry)){
            throw SplError.CallOfNonProcedure(callStatement.position, callStatement.procedureName);
        }else if(local == null || global == null){
            throw SplError.UndefinedIdentifier(callStatement.position, callStatement.procedureName);
        }

        while(args.hasNext()){
            args.next();
            countArgs++;
        }

        while(params.hasNext()){
            params.next();
            countParams++;
        }
        while(args.hasNext() && params.hasNext()){
            Expression expression = args.next();
            ParameterType parameterType = params.next();
            if(parameterType.isReference && !(expression instanceof  VariableExpression)){
                throw SplError.ArgumentMustBeAVariable(callStatement.position, callStatement.procedureName, i);
            }else if(expression instanceof VariableExpression){
                if(parameterType.type != operandType(expression)){ //Error Code 114
                    throw SplError.ArgumentTypeMismatch(expression.position, callStatement.procedureName, i,parameterType.type, operandType(expression));
                }
            }

            i++;
        }
        if(countArgs != countParams){ //Error Code 116
            throw SplError.ArgumentCountMismatch(callStatement.position, callStatement.procedureName, countParams, countArgs);
        }
    }
    private void checkStatement(IfStatement ifStatement){
        Type leftDataType = null, rightDataType = null;
        switch (ifStatement.condition){
            case BinaryExpression binaryExpression -> {
                leftDataType = operandType(binaryExpression.leftOperand);
                rightDataType = operandType(binaryExpression.rightOperand);
                if(leftDataType != rightDataType){// Error Code 118
                    throw SplError.OperandTypeMismatch(binaryExpression.position, binaryExpression.operator, leftDataType, rightDataType);
                }
                if(binaryExpression.operator.isArithmetic()){ //Error Code 110
                    throw SplError.IfConditionMustBeBoolean(ifStatement.position, PrimitiveType.intType);
                }
            }
            case IntLiteral intLiteral -> {
                throw SplError.IfConditionMustBeBoolean(ifStatement.position, PrimitiveType.intType);
            }
            case UnaryExpression unaryExpression -> {
                throw SplError.IfConditionMustBeBoolean(ifStatement.position, PrimitiveType.intType);
            }
            case VariableExpression variableExpression -> {
                isNullVarEntry(variableExpression.variable);
                switch (variableExpression.variable){
                    case ArrayAccess arrayAccess -> {
                        throw SplError.IfConditionMustBeBoolean(ifStatement.position, PrimitiveType.intType);
                    }
                    case NamedVariable namedVariable -> {
                        throw SplError.IfConditionMustBeBoolean(ifStatement.position, ((VariableEntry) localTable.lookup(namedVariable.name)).type);
                    }
                }
            }
        }
    }
    private void checkStatement(WhileStatement statement){
        Type leftDataType = null, rightDataType = null;
        switch (statement.condition){
            case BinaryExpression binaryExpression -> {
                leftDataType = operandType(binaryExpression.leftOperand);
                rightDataType = operandType(binaryExpression.rightOperand);
                if(leftDataType != rightDataType){// Error Code 118
                    throw SplError.OperandTypeMismatch(binaryExpression.position, binaryExpression.operator, leftDataType, rightDataType);
                }
                if(binaryExpression.operator.isArithmetic()){ //Error Code 111
                    throw SplError.WhileConditionMustBeBoolean(statement.position, PrimitiveType.intType);
                }
            }
            case IntLiteral intLiteral -> {
                throw SplError.WhileConditionMustBeBoolean(statement.position, PrimitiveType.intType);
            }
            case UnaryExpression unaryExpression -> {
                throw SplError.WhileConditionMustBeBoolean(statement.position, PrimitiveType.intType);
            }
            case VariableExpression variableExpression -> {
                isNullVarEntry(variableExpression.variable);
                switch (variableExpression.variable){
                    case ArrayAccess arrayAccess -> {
                        throw SplError.WhileConditionMustBeBoolean(statement.position, PrimitiveType.intType);
                    }
                    case NamedVariable namedVariable -> {
                        throw SplError.WhileConditionMustBeBoolean(statement.position, ((VariableEntry) localTable.lookup(namedVariable.name)).type);
                    }
                }
            }
        }
    }
    private void isNullVarEntry(Variable variable){
        switch (variable){
            case ArrayAccess arrayAccess -> {
                isNullVarEntry(arrayAccess.array);
            }
            case NamedVariable namedVariable -> {
                if(localTable.lookup(namedVariable.name) == null){
                    throw SplError.UndefinedIdentifier(namedVariable.position, namedVariable.name);
                }

            }
        }
    }
    private Type operandType(Expression operand){
        Type type = null;
        switch (operand){
            case BinaryExpression expression -> {
                //TODO multiple binary Expression
                if(expression.operator.isEqualityOperator() || expression.operator.isComparison()){
                    type = PrimitiveType.boolType;
                }
            }
            case IntLiteral intLiteral -> {
                type = PrimitiveType.intType;
            }
            case UnaryExpression unaryExpression -> {
                type = PrimitiveType.intType;
            }
            case VariableExpression variableExpression -> {
                isNullVarEntry(variableExpression.variable);
                switch (variableExpression.variable){
                    case ArrayAccess arrayAccess -> {
                        type = PrimitiveType.intType;
                    }
                    case NamedVariable namedVariable -> {
                        type = ((VariableEntry) localTable.lookup(namedVariable.name)).type;
                    }
                }
            }
        }
        return type;
    }
}
