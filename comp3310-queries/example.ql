/**
 * @name Comp3310 workshop 6 query
 * @kind problem
 * @problem.severity warning
 * @id java/example/empty-block
 */


 import java
 import semmle.code.java.dataflow.DataFlow
 
 from MethodAccess println, MethodAccess throwableAccess, Method throwableMethod
 where
   println.getTarget().hasQualifiedName("java.lang.System.out") and
   println.getTarget().hasName("println") and
   throwableAccess.getTarget().hasName("getMessage") and
   throwableAccess.getAnAccessPath().getBase().getType().getASupertype*().(isClass() and hasQualifiedName("java.lang.Throwable")) and
   throwableMethod = throwableAccess.getTarget().getALocalMethod() and
   throwableMethod.hasName("getMessage") and
   throwableAccess.getAnAccessPath().getTarget().getASingleElement() = throwableMethod.getAnExpression() and
   exists(MethodAccess methodAccess |
     methodAccess.getAnArgument() = throwableAccess.getAnAccessPath().getBase() and
     methodAccess.getTarget().hasName("printStackTrace")
   )
 select println, "Possible use of System.out.println(e.getMessage()): " + println.toString() + " in " + println.getMethod().getLocation().toString()
 