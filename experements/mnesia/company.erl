-module(company).
-export([reset_schema/0, create_tables/0, insert_emp/3, all_employees/0]).
-include_lib("stdlib/include/qlc.hrl").
-include("company.hrl").

% Example erl session:
% erl -name kitty -mnesia dir '"databases/Mnesia.Company"'
% c(company).
% rr("company.hrl").
% company:reset_schema().
% company:create_tables().
% company:insert_emp(
%   #employee{
%     emp_no = 244717,
%     name = "Colin Campbell-McPherson",
%     salary = 53000,
%     sex = male,
%     phone = 8493,
%     room_no = 109
%   },
%   cits,
%   ["Telecommunications Form", "Flow Docs"]
% ).

reset_schema() ->
  mnesia:stop(),
  mnesia:delete_schema( [node()] ),
  mnesia:create_schema( [node()] ),
  mnesia:start().

create_tables() ->
  mnesia:create_table( employee, [
    {disc_copies, [node()]},
    {attributes, record_info(fields, employee)}
  ]),

  mnesia:create_table( dept, [
    {disc_copies, [node()]},
    {attributes, record_info(fields, dept)}
  ]),

  mnesia:create_table( project, [
    {disc_copies, [node()]},
    {attributes, record_info(fields, project)}
  ]),

  mnesia:create_table( manager, [
    {disc_copies, [node()]},
    {type, bag}, 
    {attributes, record_info(fields, manager)}
  ]),

  mnesia:create_table( at_dep, [
    {disc_copies, [node()]},
    {attributes, record_info(fields, at_dep)}
  ]),

  mnesia:create_table( in_proj, [
    {disc_copies, [node()]},
    {type, bag}, 
    {attributes, record_info(fields, in_proj)}
  ]).

insert_emp(Emp, DeptId, ProjNames) ->
  Ename = Emp#employee.name,
  Fun = fun() ->
    mnesia:write(Emp),
    AtDep = #at_dep{emp = Ename, dept_id = DeptId},
    mnesia:write(AtDep),
    mk_projs(Ename, ProjNames)
  end,
  mnesia:transaction(Fun).

mk_projs(Ename, [ProjName|Tail]) ->
  mnesia:write(#in_proj{emp = Ename, proj_name = ProjName}),
  mk_projs(Ename, Tail);
mk_projs(_, []) -> ok.

all_employees() ->
  F = fun() -> qlc:e(qlc:q([X || X <- mnesia:table(employee)])) end,
  {atomic, Employees} = mnesia:transaction(F),
  Employees.

