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

    public void checkProcedures(Program program, SymbolTable globalTable) {
        //TODO (assignment 4b): Check all procedure bodies for semantic errors
        Entry entry = globalTable.lookup(new Identifier("main"));
        if(entry == null){
            throw SplError.MainIsMissing();
        }

        if(entry.getClass() != ProcedureEntry.class){
            throw SplError.MainIsNotAProcedure();
        }

        if(!(((ProcedureEntry) entry).parameterTypes.isEmpty())){
            throw SplError.MainMustNotHaveParameters();
        }

        for(var globalDeclaration : program.definitions){
            switch (globalDeclaration){
                case ProcedureDefinition procedureDefinition -> {
                    /*
                    for(var variableDef : procedureDefinition.variables){
                       switch (variableDef.typeExpression) {

                           case ArrayTypeExpression arrayTypeExpression -> {
                           }
                           case NamedTypeExpression namedTypeExpression -> {

                               entry = globalTable.lookup(namedTypeExpression.name);
                               //masih error yang ini karena masuknya masih ke undefined
                               if(entry == null) {
                                   throw SplError.UndefinedIdentifier(namedTypeExpression.position, namedTypeExpression.name);
                               }
                               if(entry.getClass() != TypeEntry.class) {
                                   throw SplError.NotAType(namedTypeExpression.position, namedTypeExpression.name);
                               }
                           }
                       }
                    }*/
                    for(var statement : procedureDefinition.body){
                        switch (statement){
                            case AssignStatement assignStatement -> {
                                switch (assignStatement.target){
                                    case ArrayAccess arrayAccess -> {
                                    }
                                    case NamedVariable namedVariable -> {
                                        entry = globalTable.lookup(namedVariable.name);
                                        if(entry == null) {
                                            throw SplError.UndefinedIdentifier(namedVariable.position, namedVariable.name);
                                        }
                                    }
                                }
                            }
                            case CallStatement callStatement -> {
                                entry = globalTable.lookup(callStatement.procedureName);
                                if(entry == null){
                                    throw SplError.CallOfNonProcedure(callStatement.position, callStatement.procedureName);
                                }
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
                }
                case TypeDefinition typeDefinition -> {
                    //dataTypeSwitcher(typeDefinition.typeExpression, globalTable);
                }
            }
        }
    }

    private Type dataTypeSwitcher(TypeExpression typeExpression, SymbolTable globalTable){
        switch (typeExpression){
            case ArrayTypeExpression arrayTypeExpression -> {
                baseType = determineBaseType(arrayTypeExpression.baseType, globalTable);
                dataType = new ArrayType(baseType, arrayTypeExpression.arraySize);
            }
            case NamedTypeExpression namedTypeExpression -> {
                Entry entry = globalTable.lookup(namedTypeExpression.name);
                if(!(entry instanceof TypeEntry)){
                    throw SplError.NotAType(namedTypeExpression.position, namedTypeExpression.name);
                }
                dataType = ((TypeEntry) entry).type;
            }
        }
        return  dataType;
    }

    private Type determineBaseType(TypeExpression baseType, SymbolTable globalTable) {
        switch (baseType){
            case ArrayTypeExpression arrayTypeExpression -> {
                Type base = determineBaseType(arrayTypeExpression.baseType, globalTable);
                return new ArrayType(base, arrayTypeExpression.arraySize);
            }
            case NamedTypeExpression namedTypeExpression -> {
                Entry entry = globalTable.lookup(namedTypeExpression.name);
                return ((TypeEntry) entry).type;
            }
        }
    }

}
