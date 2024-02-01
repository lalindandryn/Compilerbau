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

import javax.naming.Name;
import java.lang.annotation.Target;
import java.lang.reflect.Array;
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
            case CompoundStatement compoundStatement -> {}
            case EmptyStatement emptyStatement -> { }
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
        Type valueType = null, targetType = null;
        isNullVarEntry(assignStatement.target);
        switch (assignStatement.target){
            case ArrayAccess arrayAccess -> {
                targetEntry = arrayAccessEntry(arrayAccess);
                targetType = getType(arrayAccess);
            }
            case NamedVariable namedVariable -> {
                targetEntry = localTable.lookup(namedVariable.name);
                targetType = ((VariableEntry) targetEntry).type;
                if(!(targetEntry instanceof VariableEntry)) {
                    //Error Code 122
                    throw SplError.NotAVariable(namedVariable.position, namedVariable.name);
                }
            }
        }
        switch (assignStatement.value){
            case BinaryExpression binaryExpression -> {
                valueType = operandType(binaryExpression);
            }
            case IntLiteral intLiteral -> {
                valueType = PrimitiveType.intType;
            }
            case UnaryExpression unaryExpression -> {
                valueType = PrimitiveType.intType;
                checkUnaryExpression(unaryExpression, ((VariableEntry) targetEntry).type);
            }
            case VariableExpression variableExpression -> {
                isNullVarEntry(variableExpression.variable);
                switch (variableExpression.variable){
                    case ArrayAccess arrayAccess -> {
                        valueEntry =arrayAccessEntry(arrayAccess);
                        valueType = ((VariableEntry) valueEntry).type;
                        if(!(((VariableEntry) targetEntry).type != valueType)){//Error Code 123
                            throw SplError.IndexingNonArray(getPosition(arrayAccess), ((VariableEntry) targetEntry).type);
                        }
                    }
                    case NamedVariable namedVariable -> {
                        valueEntry = localTable.lookup(namedVariable.name);
                        valueType = ((VariableEntry) valueEntry).type;
                    }
                }
            }
        }

        if(targetType instanceof ArrayType && valueType instanceof ArrayType){ //Error Code 108
            if(targetType == valueType){
                System.out.println(targetType);
                throw SplError.IllegalAssignment(assignStatement.position, targetType, valueType);
            }
        }

        if(targetType != valueType || targetType != PrimitiveType.intType){ //Error Code 108
            /*if(targetType instanceof ArrayType){
                int loop = countValueArray(targetType, 1);
                targetType = reduceArrayIndex(targetType, loop);
            }else if(valueType instanceof ArrayType){
                valueType = reduceArrayIndex(valueType, countValueArray(targetType, 1));
            }

            if(targetType != valueType){
                throw SplError.IllegalAssignment(assignStatement.position, targetType, valueType);
            }*/

        }
    }

    private int countValueArray(Type type, int loop){
        while(loop > 0){
            if(type instanceof ArrayType){
                loop++;
                return countValueArray(((ArrayType) type).baseType, loop);
            }else{
                return loop;
            }
        }
        return 0;
    }

    private Type reduceArrayIndex(Type type, int loop){
        while(loop > 0){
            if(type instanceof ArrayType){
                loop--;
                return reduceArrayIndex(((ArrayType) type).baseType, loop);
            }
        }
        return type;
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
        args = callStatement.arguments.iterator();
        params = ((ProcedureEntry) global).parameterTypes.iterator();
        while(args.hasNext() && params.hasNext()){
            Expression expression = args.next();
            ParameterType parameterType = params.next();
            if(parameterType.isReference && !(expression instanceof  VariableExpression)){
                throw SplError.ArgumentMustBeAVariable(expression.position, callStatement.procedureName, i);
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
        Expression condition = ifStatement.condition;
        int conditionCounter = 0;
        while (condition != null){
            switch (condition){
                case BinaryExpression binaryExpression -> {
                    if(operandType(binaryExpression.leftOperand) != operandType(binaryExpression.rightOperand)){// Error Code 118
                        throw SplError.OperandTypeMismatch(binaryExpression.position, binaryExpression.operator, operandType(binaryExpression.leftOperand), operandType(binaryExpression.rightOperand));
                    }
                    if(conditionCounter < 1 && binaryExpression.operator.isArithmetic()){ //Error Code 110
                        throw SplError.IfConditionMustBeBoolean(ifStatement.position, PrimitiveType.intType);
                    }

                    if(binaryExpression.leftOperand instanceof BinaryExpression){
                        condition = binaryExpression.leftOperand;
                    }else if(binaryExpression.rightOperand instanceof BinaryExpression){
                        condition = binaryExpression.rightOperand;
                    }else{
                        condition = null;
                    }
                    conditionCounter++;
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

    }
    private void checkStatement(WhileStatement statement){
        Expression condition = statement.condition;
        int conditionCounter = 0;
        while (condition != null){
            switch (condition){
                case BinaryExpression binaryExpression -> {
                    if(operandType(binaryExpression.leftOperand) != operandType(binaryExpression.rightOperand)){// Error Code 118
                        throw SplError.OperandTypeMismatch(binaryExpression.position, binaryExpression.operator, operandType(binaryExpression.leftOperand), operandType(binaryExpression.rightOperand));
                    }
                    if(conditionCounter < 1 && binaryExpression.operator.isArithmetic()){ //Error Code 110
                        throw SplError.WhileConditionMustBeBoolean(statement.position, PrimitiveType.intType);
                    }

                    if(binaryExpression.leftOperand instanceof BinaryExpression){
                        condition = binaryExpression.leftOperand;
                    }else if(binaryExpression.rightOperand instanceof BinaryExpression){
                        condition = binaryExpression.rightOperand;
                    }else{
                        condition = null;
                    }
                    conditionCounter++;
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
                            throw SplError.IfConditionMustBeBoolean(statement.position, PrimitiveType.intType);
                        }
                        case NamedVariable namedVariable -> {
                            throw SplError.IfConditionMustBeBoolean(statement.position, ((VariableEntry) localTable.lookup(namedVariable.name)).type);
                        }
                    }
                }
            }
        }
    }

    private void checkUnaryExpression(UnaryExpression expression, Type targetType){
        Entry entry = null;
        switch(expression.operand){

            case BinaryExpression binaryExpression -> {
            }
            case IntLiteral intLiteral -> {
            }
            case UnaryExpression unaryExpression -> {
                checkUnaryExpression(unaryExpression, targetType);
            }
            case VariableExpression variableExpression -> {
                isNullVarEntry(variableExpression.variable);
                switch (variableExpression.variable){
                    case ArrayAccess arrayAccess -> {
                        if(!(targetType instanceof ArrayType)){
                            throw SplError.IndexingNonArray(getPosition(arrayAccess), targetType);
                        }
                    }
                    case NamedVariable namedVariable -> {
                        if(((VariableEntry)localTable.lookup(namedVariable.name)).type != PrimitiveType.intType){ //Error Code 119
                            throw SplError.OperandTypeMismatch(expression.position, expression.operator, ((VariableEntry)localTable.lookup(namedVariable.name)).type);
                        }
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
                if(expression.operator.isEqualityOperator() || expression.operator.isComparison()){
                    type = PrimitiveType.boolType;
                }else if (expression.operator.isArithmetic()){
                    type = PrimitiveType.intType;
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

    private Position getPosition(ArrayAccess arrayAccess){
        if(arrayAccess.array instanceof ArrayAccess){
            return getPosition((ArrayAccess) arrayAccess.array);
        }else if(arrayAccess.array instanceof NamedVariable){
            return ((NamedVariable) arrayAccess.array).position;
        }
        return null;
    }

    private Type getType(ArrayAccess arrayAccess){
        if(arrayAccess.array instanceof ArrayAccess){
            return getType((ArrayAccess) arrayAccess.array);
        }else if(arrayAccess.array instanceof NamedVariable){
            return ((VariableEntry) localTable.lookup(((NamedVariable) arrayAccess.array).name)).type;
        }
        return null;
    }

    private Entry arrayAccessEntry(ArrayAccess arrayAccess){
        if(arrayAccess.array instanceof ArrayAccess){
            return arrayAccessEntry((ArrayAccess) arrayAccess.array);
        }else if(arrayAccess.array instanceof NamedVariable){
            return ((VariableEntry) localTable.lookup(((NamedVariable) arrayAccess.array).name));
        }
        return null;
    }

}

