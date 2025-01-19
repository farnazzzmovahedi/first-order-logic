adjacent((X1, Y1), (X2, Y2)) :-
    grid_size(MaxRows, MaxCols),
    (
        (X2 is X1 + 1, Y2 = Y1, X2 < MaxRows);
        (X2 is X1 - 1, Y2 = Y1, X2 >= 0);
        (X2 = X1, Y2 is Y1 + 1, Y2 < MaxCols);
        (X2 = X1, Y2 is Y1 - 1, Y2 >= 0)
    ).

can_move((X, Y)) :-
    tile(X, Y),
    \+ rock(X, Y).

action_for_move((X1, Y1), (X2, Y2), Action) :-
    (
        X2 is X1 + 1, Y2 = Y1 -> Action = 1;
        X2 is X1 - 1, Y2 = Y1 -> Action = 0;
        X2 = X1, Y2 is Y1 + 1 -> Action = 3;
        X2 = X1, Y2 is Y1 - 1 -> Action = 2
    ).

path_to_actions([], []).
path_to_actions([_], []).
path_to_actions([Node1, Node2 | Rest], [Action | Actions]) :-
    action_for_move(Node1, Node2, Action),
    path_to_actions([Node2 | Rest], Actions).

bfs(Start, Target, Actions) :-
    bfs([[Start]], Target, [], Path),
    reverse(Path, ReversedPath),
    path_to_actions(ReversedPath, Actions).

bfs([[Target | Path] | _], Target, _, [Target | Path]) :-
    writeln(['Found path to target:', [Target | Path]]).

bfs([CurrentPath | OtherPaths], Target, Visited, Result) :-
    CurrentPath = [CurrentPos | _],
    writeln(['Exploring from:', CurrentPos]),
    findall([NextPos | CurrentPath], (
        adjacent(CurrentPos, NextPos),
        can_move(NextPos),
        \+ member(NextPos, Visited)
    ), NewPaths),
    writeln(['Next Positions:', NewPaths]),
    append(OtherPaths, NewPaths, AllPaths),
    bfs(AllPaths, Target, [CurrentPos | Visited], Result).

visit_all_pigs_graph(Current, UnvisitedPigs, FinalActions) :- 
    ( UnvisitedPigs = [] ->
        writeln('All pigs visited!'),
        FinalActions = []
    ; find_nearest_pig(Current, UnvisitedPigs, NearestPig, ActionsToPig),
      writeln(['Actions to pig:', ActionsToPig]),
      delete(UnvisitedPigs, NearestPig, RemainingPigs),
      visit_all_pigs_graph(NearestPig, RemainingPigs, RemainingActions),
      append(ActionsToPig, RemainingActions, FinalActions)
    ).

find_nearest_pig(Current, Pigs, NearestPig, Actions) :-
    findall(Cost-Pig-Actions, (
        member(Pig, Pigs),
        bfs(Current, Pig, Actions),
        length(Actions, Cost)
    ), CostsPigsActions),
    sort(CostsPigsActions, [MinCost-NearestPig-Actions | _]),
    writeln(['Nearest pig:', NearestPig, 'with cost:', MinCost]).

solve_to_python(FinalActions) :-
    bird(BirdX, BirdY),
    findall((PigX, PigY), pig(PigX, PigY), Pigs),
    visit_all_pigs_graph((BirdX, BirdY), Pigs, FinalActions).

% Define the grid size
grid_size(8, 8).

% Bird position
bird(0, 0).

% Pig positions
pig(0, 4).
pig(2, 5).
pig(3, 7).
pig(4, 0).
pig(7, 0).
pig(7, 4).

% Rock positions
rock(1, 0).
rock(1, 2).
rock(1, 3).
rock(1, 5).
rock(2, 3).
rock(3, 6).
rock(4, 1).
rock(4, 3).
rock(4, 6).
rock(5, 1).
rock(6, 1).
rock(6, 2).
rock(6, 4).
rock(6, 5).
rock(6, 6).

% Tile positions (valid positions to move)
tile(0, 1).
tile(0, 2).
tile(0, 3).
tile(0, 4).
tile(0, 5).
tile(0, 6).
tile(0, 7).
tile(1, 1).
tile(1, 4).
tile(1, 6).
tile(1, 7).
tile(2, 0).
tile(2, 1).
tile(2, 2).
tile(2, 4).
tile(2, 5).
tile(2, 6).
tile(2, 7).
tile(3, 0).
tile(3, 1).
tile(3, 2).
tile(3, 3).
tile(3, 4).
tile(3, 5).
tile(3, 7).
tile(4, 0).
tile(4, 2).
tile(4, 4).
tile(4, 5).
tile(4, 7).
tile(5, 0).
tile(5, 2).
tile(5, 3).
tile(5, 4).
tile(5, 5).
tile(5, 6).
tile(5, 7).
tile(6, 0).
tile(6, 3).
tile(6, 7).
tile(7, 0).
tile(7, 1).
tile(7, 2).
tile(7, 3).
tile(7, 4).
tile(7, 5).
tile(7, 6).
tile(7, 7).

