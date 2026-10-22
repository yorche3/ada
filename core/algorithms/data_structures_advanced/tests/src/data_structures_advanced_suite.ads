with AUnit.Test_Suites; use AUnit.Test_Suites;

--  Tres suites anidadas, una por abstracción de la especificación; dentro de
--  cada una, un caso de prueba por operación del contrato.
package Data_Structures_Advanced_Suite is
   function Suite return Access_Test_Suite;
end Data_Structures_Advanced_Suite;
