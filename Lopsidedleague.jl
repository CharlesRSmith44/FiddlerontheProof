## Lopsided League computation
## Written by Charlie Smith

# Just two leagues 
N = 2 # number of leagues 
T = 5 # number of teams per league 
probs = rand(N,T)

function ind_higher(probs)
    if minimum(probs[1,:]) .> maximum(probs[2,:])
        return 1
    else
        return 0
    end 
end

function compute_prob(n,N,T)
    sum = 0 
    for i = 1:n
        probs = rand(N,T)
        sum = sum + ind_higher(probs)
    end
    return sum 
end 

n = 1e8 #number of times one league dominates the other 
share = compute_prob(n, N, T)/n
print(share) #approximately 0.003955

## Extra Credit 
N = 6 # number of leagues 
T = 5 # number of teams per league 

function ind_any_higher(probs)
    mins = zeros(N)
    maxs = zeros(N)
    for i = 1:N
        mins[i] = minimum(probs[i,:])
        maxs[i] = maximum(probs[i,:])
    end
    if minimum(maxs) < maximum(mins)
        return 1
    else
        return 0
    end 
end

function compute_prob_any(n,N,T)
    sum = 0 
    for i = 1:n
        probs = rand(N,T)
        sum = sum + ind_any_higher(probs)
    end
    return sum 
end 


n = 1e8 #number of times one league dominates the other 
share = compute_prob_any(n, N, T)/n
print(share) # approximately 0.08625

### More general example 
N = 6 # number of leagues 
T = 5 # number of teams per league 

matches = 162*ones(N*T,N*T) # number of games between each time 
using LinearAlgebra
matches[diagind(matches)] .= 0.0 #making teams not face themselves 
total_games = transpose(sum(matches,dims=1))

# removing lower diagonal elements so we don't have repeat games 
for i = 1:N*T
    for j = 1:N*T
        if i > j 
            matches[i,j] = 0.0
        end
    end
end



function prob_win(x,y)
    return x/(x+y)
end

function det_wins(wins, matches,strength, i,j)
    if matches[i,j] == 0.0
        
    else 
        for l = 1:matches[i,j]
            draw = rand(1)
            wins[i,j] = wins[i,j] + first(prob_win(strength[i],strength[j]) .>= draw) 
            wins[j,i] = wins[j,i] + first(prob_win(strength[j],strength[i]) .> draw) 
        end
    end 
    return wins 
end

function play_games(N,T,strength,matches) 
    wins = zeros(N*T,N*T)
    for i = 1:N*T
        for j = 1:N*T
            wins = det_wins(wins, matches, strength, i, j)
        end
    end
    return wins
end


num = 0 
num_iters = 1e6
for i = 1:num_iters
    strength = rand(N*T) .+ 0.75
    total_wins = play_games(N,T,strength,matches)
    total_wins = sum(total_wins,dims=2)
    win_pct = total_wins./total_games 
    by_league = reshape(win_pct, N, T)
    num = num + ind_any_higher(by_league)
end 

pct = num/num_iters