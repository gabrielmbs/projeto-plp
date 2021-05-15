:- module(personController, [registerCustomer/0, registerEmployee/0, showEmployees/0, showCustomers/0]).

:- use_module('../persistence/db.pl').
:- use_module('./util/utils.pl').
:- use_module('../util/show.pl').

existsCustomer(CustomerID) :-
  db:customer(CustomerID, _, _, _, _).

existsEmployee(EmployeeID) :-
  db:employee(EmployeeID, _, _, _, _).

existsSellerByID(EmployeeID) :-
  db:employee(EmployeeID, _, _, _, "vendedor").

existsOwner :-
  db:employee(_, _, _, _, "dono").

existsOwnerByID(OwnerID) :-
  db:employee(OwnerID, _, _, _, "dono").





registerCustomer :- 
  db:nextId(ID),
  utils:input("CPF: ", Ssn),
  (db:employee(_, Ssn, Name, Age, _), \+db:customer(_, Ssn, _, _, _),format('Olá, ~w~n', [Name]);
  (db:customer(_, Ssn, _, _, _), writeln("Já existe um cliente cadastrado com o CPF informado."),wait, registerCustomer);
  registerPerson(Name, Age),utils:input("Digite seu endereço: ", Address)),
  db:assertz(customer(ID, Ssn, Name, Age, Address)),
  db:writeCustomer,
  clear,
  writeln("Cliente cadastrado com sucesso!\n"),
  show:showCustomer(ID, Ssn, Name, Age, Address),
  utils:wait.

registerEmployee :- 
  db:nextId(ID),
  registerPerson(Ssn, Name, Age),
  writeln("\n(1) Confeitero"),
  writeln("(2) Vendedor"),
  utils:inputNumber("\nCargo: ", Number),
  (Number =:= 1 -> Role = "confeitero" ; Role = "vendedor"),
  db:assertz(employee(ID, Ssn, Name, Age, Role)),
  clear,
  db:writeEmployee,
  writeln("Funcionário cadastrado com sucesso!\n"),
  show:showEmployee(ID, Ssn, Name, Age, Role),
  utils:wait.

registerOwner :-
  writeln("Não existe dono!"),
  utils:input("\nDeseja cadastrar um dono? [s/n]: ", Op),
  Op =:= "s",
  db:nextId(ID),
  registerPerson(Ssn, Name, Age),
  db:assertz(employee(ID, Ssn, Name, Age, "dono")),
  clear,
  db:writeEmployee,
  writeln("Dono cadastrado com sucesso!\n"),
  show:showEmployee(ID, Ssn, Name, Age, "dono"),
  utils:wait;
  !.

registerPerson(Name, Age) :-
  utils:input("Nome: ", Name),
  utils:inputNumber("Idade: ", Age).

showEmployees :-
  clear,
  writeln("Funcionários\n"),
  forall(db:employee(EmployeeID, Ssn, Name, Age, Role),
         show:showEmployee(EmployeeID, Ssn, Name, Age, Role)),
  wait.

showCustomers :-
  clear,
  writeln("Clientes\n"),
  forall(db:customer(CustomerID, Ssn, Name, Age, Role),
         show:showCustomer(CustomerID, Ssn, Name, Age, Role)),
  wait.