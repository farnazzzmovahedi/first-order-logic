% Adjacency rule to check if two positions are adjacent
adjacent((X1, Y1), (X2, Y2)) :-
    grid_size(MaxRows, MaxCols),
    (
        (X2 is X1 + 1, Y2 = Y1, X2 < MaxRows);  % Down
        (X2 is X1 - 1, Y2 = Y1, X2 >= 0);      % Up
        (X2 = X1, Y2 is Y1 + 1, Y2 < MaxCols); % Right
        (X2 = X1, Y2 is Y1 - 1, Y2 >= 0)       % Left
    ).

% Check if a position is a valid tile (not a rock)
can_move((X, Y)) :-
    tile(X, Y),
    \+ rock(X, Y).

% Helper: Determine Action for Move
action_for_move((X1, Y1), (X2, Y2), Action) :-
    (
        X2 is X1 + 1, Y2 = Y1 -> Action = "down";
        X2 is X1 - 1, Y2 = Y1 -> Action = "up";
        X2 = X1, Y2 is Y1 + 1 -> Action = "right";
        X2 = X1, Y2 is Y1 - 1 -> Action = "left"
    ).

% BFS to find the shortest path from Start to Target, returning Actions
bfs(Start, Target, Actions) :-
    bfs([[Start, []]], Target, [], Actions).

% Base Case: Target Found
bfs([[Target, ActionPath] | _], Target, _, ActionPath) :-
    writeln(['Found path to target:', ActionPath]).

% Recursive Case: Expand Paths
bfs([CurrentPath | OtherPaths], Target, Visited, Result) :-
    CurrentPath = [CurrentPos, CurrentActions],
    writeln(['Exploring from:', CurrentPos]),
    findall(
        [NextPos, [NextAction | CurrentActions]],
        (
            adjacent(CurrentPos, NextPos),
            action_for_move(CurrentPos, NextPos, NextAction),
            can_move(NextPos),
            \+ member(NextPos, Visited)
        ),
        NewPaths
    ),
    writeln(['Next Actions:', NewPaths]),
    append(OtherPaths, NewPaths, AllPaths),
    bfs(AllPaths, Target, [CurrentPos | Visited], Result).

% Visit all pigs by moving from one pig to another, collecting Actions
visit_all_pigs_graph(_, [], []) :-
    writeln('All pigs visited!').  % If no pigs left to visit
visit_all_pigs_graph(Start, [NextPig | RemainingPigs], Actions) :-
    bfs(Start, NextPig, SubActions),  % Find actions to the next pig
    writeln(['Actions to pig:', SubActions]),
    visit_all_pigs_graph(NextPig, RemainingPigs, RemainingActions),  % Continue with remaining pigs
    append(SubActions, RemainingActions, Actions).

% Helper to start the pig-visiting process
solve :-
    bird(BirdX, BirdY),
    findall((PigX, PigY), pig(PigX, PigY), Pigs),
    writeln(['Pigs to visit:', Pigs]),
    visit_all_pigs_graph((BirdX, BirdY), Pigs, Actions),
    writeln(['Final Actions:', Actions]).

% Define the grid size
grid_size(8, 8).

% Bird position
bird(0, 0).

% Pig positions
pig(2, 0).
pig(4, 0).
pig(7, 0).
pig(7, 4).
pig(7, 7).

% Rock positions
rock(1, 1).
rock(1, 2).
rock(1, 3).
rock(1, 4).
rock(1, 5).
rock(1, 6).
rock(1, 7).
rock(4, 1).
rock(5, 1).
rock(6, 1).
rock(6, 2).
rock(6, 3).
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
tile(1, 0).
tile(2, 0).
tile(2, 1).
tile(2, 2).
tile(2, 3).
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
tile(3, 6).
tile(3, 7).
tile(4, 0).
tile(4, 2).
tile(4, 3).
tile(4, 4).
tile(4, 5).
tile(4, 6).
tile(4, 7).
tile(5, 0).
tile(5, 2).
tile(5, 3).
tile(5, 4).
tile(5, 5).
tile(5, 6).
tile(5, 7).
tile(6, 0).
tile(6, 7).
tile(7, 0).
tile(7, 1).
tile(7, 2).
tile(7, 3).
tile(7, 4).
tile(7, 5).
tile(7, 6).
tile(7, 7).